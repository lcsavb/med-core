import datetime
import time
import logging
import smtplib
import json
import threading

from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText
from functools import wraps
from datetime import timedelta

from flask import request, jsonify, make_response
from flask_restful import Resource, Api
from flask_jwt_extended import create_access_token, get_jwt_identity, jwt_required
from sqlalchemy.exc import IntegrityError
from sqlalchemy.exc import SQLAlchemyError
from sqlalchemy.sql import text
from werkzeug.security import check_password_hash, generate_password_hash

from db import engine
from models import construct_user
from errors import ErrorHandler
from error_messages import ErrorMessages  # Import from the new file
import random


SECRET_KEY = "your-secret-key"


class LoginResource(Resource):
    def post(self):
        username = request.json.get('username')
        password = request.json.get('password')

        # Authenticate the user
        user = authenticate_user(username, password)

        if user:
            # Set a verification code

            user.set_verification_code()

            # Hash the verification code
            verification_code_hash = generate_password_hash(user.verification_code)

            # Create a temporary token with the username and hashed code
            temporary_token = create_access_token(
                identity={
                    "username": user.username,
                    "id": user.id,
                    "verification_code_hash": verification_code_hash
                },
                expires_delta=timedelta(minutes=5)  # Token expires in 10 minutes
            )

            # Send the verification code via email in a separate thread
            email_thread = threading.Thread(target=send_verification_email, args=(user.email, user.verification_code))
            email_thread.start()

            print(f'Email sent to {user.email} with verification code: {user.verification_code}')


            return make_response(jsonify({'temporary_token': temporary_token, 'message': 'Verification code sent!'}), 200)
        else:
            return make_response(jsonify({'message': 'Invalid username or password'}), 401)
        

class Verify2FAResource(Resource):
    @jwt_required()  # This decorator validates the JWT token
    def post(self):
        # Retrieve the entered verification code from the request
        entered_code = request.json.get('verification_code')

        # Decode the temporary token and get the user identity data
        decoded_token = get_jwt_identity()
        username = decoded_token.get("username")
        id = decoded_token.get("id")
        user_data = search_user_data(id)
        verification_code_hash = decoded_token.get("verification_code_hash")

        # Check the entered code against the hash

        entered_code_str = ErrorHandler.validate_conversion(entered_code, str)

        if check_password_hash(verification_code_hash, entered_code_str):
            # If successful, generate a new access token
            access_token = create_access_token(identity=user_data)
            return make_response(jsonify({'access_token': access_token, 'message': '2FA successful!'}), 200)
        else:
            # If the code is incorrect, return an error
            return make_response(jsonify({'message': 'Invalid verification code'}), 401)


class VerifyAuthPasswordResetResource(Resource):
    @jwt_required()  # This decorator ensures the user is authenticated via JWT token
    def post(self):
        # Retrieve the entered verification code from the request
        entered_code = request.json.get('verification_code')

        # Decode the temporary token and get the user identity data
        decoded_token = get_jwt_identity()  # Decodes the JWT token to retrieve user data
        email = decoded_token.get("email")

        # Fetch the verification code hash from the JWT token (could be generated earlier in the password reset process)
        verification_code_hash = decoded_token.get("verification_code_hash")

        if not verification_code_hash:
            return make_response(jsonify({'message': 'No verification code hash found'}), 400)

        # Validate the entered code by comparing it to the hash
        entered_code_str = ErrorHandler.validate_conversion(entered_code, str)

        # If the entered code matches the hash, return success
        if check_password_hash(verification_code_hash, entered_code_str):
            return make_response(jsonify({'message': '2FA successful!'}), 200)

        # If the code does not match, return an error response
        return make_response(jsonify({'message': 'Invalid verification code'}), 401)



class RegisterResource(Resource):
    def post(self):
        username = request.json.get('username')
        password = request.json.get('password')
        email = request.json.get('email')
        name = request.json.get('name')
        phone = request.json.get('phone')
        is_doctor = request.json.get('is_doctor')  

        # Hash the password
        password_hash = generate_password_hash(password)

        try:
            # Save the user to the database
            user_id = save_user_in_db(username, password_hash, email, name, phone, is_doctor)
            print(user_id)
            
            # Save the clinic and get its ID
            clinic_id = save_clinic_in_db(user_id)  # Example data
            
            # Save the user as a healthcare professional if applicable
            
            save_user_healthcare_professionals(user_id, name, email, phone, clinic_id)

            return make_response(jsonify({'message': 'User registered successfully!'}), 201)
        except Exception as e:
            # Handle exceptions and return an appropriate error response
            return make_response(jsonify({'error': str(e)}), 500)



class StatusResource(Resource):
    @jwt_required()
    def get(self):
        # Get the current user's identity from the JWT token
        current_identity = get_jwt_identity()
        print(current_identity)

        # Assuming current_identity is a dictionary containing user information
        name = current_identity.get("name")

        if id:
            return make_response(jsonify({'authenticated': True, 'username': name}), 200)
        else:
            return make_response(jsonify({'authenticated': False, 'message': 'User not authenticated'}), 403)


class ProtectedResource(Resource):
    @jwt_required()
    def get(self):
        # Extract the identity from the token
        current_user = get_jwt_identity()

        # Access roles from the current_user dictionary
        roles = current_user.get("roles", "")
        type(roles)

        # Logic based on roles
        if "admin" in roles:
            return jsonify({"message": "Hello Admin! You have full access."})
        elif "doctor" in roles:
            return jsonify({"message": "Hello Doctor! You have restricted access."})
        else:
            return jsonify({"message": "Access denied! Insufficient role privileges."}), 403
        
class ForgotPasswordResource(Resource):
    def post(self):
        """Handle forgot password requests."""
        data = request.json  # Expecting JSON input with 'email'
        email = data.get('email')
        
        if not email:
            return make_response(jsonify({'error': 'Email is required'}), 400)

        # Check if the user exists in the database
        user_data = get_user_by_email(email)
        if not user_data:
            return make_response(jsonify({'error': 'Email does not exist'}), 404)

        # Generate a verification code (e.g., a 6-digit number)
        verification_code = f"{random.randint(100000, 999999)}"
        verification_code_hash = generate_password_hash(verification_code)

        try:
            temporary_token = create_access_token(
                identity={
                    "email": email,
                    "verification_code_hash": verification_code_hash
                },
                expires_delta=timedelta(minutes=5)
            )
        except Exception as e:
            return make_response(jsonify({"error": "Token creation failed", "details": str(e)}), 500)


        # Send the email in a separate thread
        email_thread = threading.Thread(target=send_verification_email, args=(email, verification_code))
        email_thread.start()

        return make_response(jsonify({
            'temporary_token': temporary_token,
            'message': 'Verification code sent!'
        }), 200)
class UpdatePasswordResource(Resource):
    @jwt_required()  # Ensure the request is authenticated with JWT token
    def post(self):
        try:
            # Get the JWT token and decode it
            decoded_token = get_jwt_identity()
            print(f"Decoded Token: {decoded_token}")

            # Extract email directly from the decoded token
            email = decoded_token.get("email")
            print(f"Email from token: {email}")

            # Ensure the email exists in the token
            if not email:
                return make_response(jsonify({'message': 'Email not found in token'}), 400)

            # Retrieve the new password from the request body
            new_password = request.json.get('new_password')
            print(f"New Password received: {new_password}")

            if not new_password:
                return make_response(jsonify({'message': 'New password is required'}), 400)

            # Hash the new password
            hashed_password = generate_password_hash(new_password)

            # Get the user from the database by email
            user = get_user_by_email(email)
            print(f"User found: {user}")

            if not user:
                return make_response(jsonify({'message': 'User not found'}), 404)

            # Update the user's password in the database
            update_user_password(email, hashed_password)

            # Respond with a success message
            return make_response(jsonify({'message': 'Password updated successfully'}), 200)

        except Exception as e:
            # Log and return the error
            print(f"Error occurred: {str(e)}")
            return make_response(jsonify({'message': 'Internal server error occurred', 'error': str(e)}), 500)






class LogoutResource(Resource):
    def post(self):
        # No session to clear, tokens are stateless, just remove token from client-side
        return make_response(jsonify({'message': 'Logged out successfully.'}), 200)
    
class ContactResource(Resource):
    def post(self):
        # Extract form data (name, email, message)
        sender_name = request.json.get('name')
        sender_email = request.json.get('email')
        message_content = request.json.get('message')

        # Validate the input
        if not sender_name or not sender_email or not message_content:
            return {'message': 'Missing required fields: name, email, message'}, 400

        # Send email asynchronously using a background thread
        email_thread = threading.Thread(target=send_contact_email, args=(sender_name, sender_email, message_content))
        email_thread.start()

        # Return a response indicating success
        return jsonify({'message': 'Your message has been sent successfully!'})


# Utility Functions
def send_verification_email(recipient_email, code):
    """Send an email with the verification code to the user."""
    sender_email = "medcorelogin@gmail.com"
    sender_password = "qprd vvhq rxqy xbbp"
    
    subject = "Your MedCore Login Verification Code"
    body = f"Your login verification code is: {code}. This code will expire in 5 minutes."
    
    # Create the email message
    msg = MIMEMultipart()
    msg['From'] = sender_email
    msg['To'] = recipient_email
    msg['Subject'] = subject
    msg.attach(MIMEText(body, 'plain'))

    # Set up the SMTP server
    try:
        server = smtplib.SMTP('smtp.gmail.com', 587)
        server.starttls()
        server.login(sender_email, sender_password)
        print(f"Logged in to SMTP server as {sender_email}")
        server.sendmail(sender_email, recipient_email, msg.as_string())
        server.quit()
        print(f"Verification email sent to {recipient_email}")
    except Exception as e:
        print("Error sending email:", e)
        
        
def send_contact_email(sender_name, sender_email, message_content):
    """Send an email with the contact form submission."""
    recipient_email = "medcorelogin@gmail.com"
    sender_email_address = "medcorelogin@gmail.com"  # You can replace this with the sender's email address if necessary
    sender_password = "qprd vvhq rxqy xbbp"  # Make sure this is a secure method of storing the password (like using environment variables or a secrets manager)
    
    subject = "New Contact Form Submission"
    body = f"""
    You have received a new message from the contact form:
    
    Name: {sender_name}
    Email: {sender_email}
    
    Message:
    {message_content}
    """
    
    # Create the email message
    msg = MIMEMultipart()
    msg['From'] = sender_email_address
    msg['To'] = recipient_email
    msg['Subject'] = subject
    msg.attach(MIMEText(body, 'plain'))

    # Set up the SMTP server
    try:
        server = smtplib.SMTP('smtp.gmail.com', 587)
        server.starttls()
        server.login(sender_email_address, sender_password)
        print(f"Logged in to SMTP server as {sender_email_address}")
        server.sendmail(sender_email_address, recipient_email, msg.as_string())
        server.quit()
        print(f"Contact email sent to {recipient_email}")
    except Exception as e:
        print("Error sending email:", e)


# Authentication and User Management Functions
def save_user_in_db(username, password_hash, email, name, phone, is_doctor):
    """Insert a new user into the database using vanilla SQL and transaction handling."""
    with engine.begin() as conn:  # engine.begin() handles transaction management
        query = text("""
            INSERT INTO users (username, name, password_hash, email, phone, roles, created_at)
            VALUES (:username, :name, :password_hash, :email, :phone, :roles, NOW())
        """)
        result = conn.execute(query, {
            'username': username,
            'name': name,
            'password_hash': password_hash,
            'email': email,
            'roles': json.dumps(["doctor"] if is_doctor else []),  # Convert list to JSON string
            'phone': phone
        })
        return result.lastrowid
    
def save_user_healthcare_professionals(user_id, name, email, phone, clinic_id):
    """
    Insert a new healthcare professional into the database.
    """
    with engine.begin() as conn:
        query = text("""
            INSERT INTO healthcare_professionals (
                id, profession, full_name, specialty, email, phone, address, 
                address_number, address_complement, created_at, clinic_id
            ) VALUES (
                :id, :profession, :full_name, :specialty, :email, :phone, :address, 
                :address_number, :address_complement, NOW(), :clinic_id
            )
        """)
        # Insert fake data for the required fields
        conn.execute(query, {
            'id': user_id,  # Use the same ID as the user
            'profession': 'Doctor',  # Assuming all are doctors for this example
            'full_name': name,
            'specialty': 'General Medicine',  # Example specialty
            'email': email,
            'phone': phone,
            'address': '123 Healthcare St.',  # Fake address
            'address_number': '1A',  # Fake address number
            'address_complement': 'Suite 100',  # Fake complement
            'clinic_id': clinic_id  # Use the clinic_id generated by save_clinics
        })
        
def save_clinic_in_db(user_id):
    """
    Generate random clinic data, insert a new clinic into the database, and return the generated clinic ID.
    """
    # Generate random clinic data
    clinic_data = {
        "name": f"Clinic {random.randint(1000, 9999)}",
        "address": f"Street {random.randint(1, 100)}",
        "address_number": str(random.randint(1, 999)),
        "address_complement": "Suite A",
        "zip": f"{random.randint(10000, 99999)}",
        "city": "Random City",
        "state": "RC",  # Random state code
        "country": "US",  # Random country code
        "phone": f"+1-{random.randint(100, 999)}-{random.randint(1000, 9999)}",
        "email": f"clinic{random.randint(1000, 9999)}@example.com",
        "website": "www.exampleclinic.com",
        "clinic_type": "Private",  # Default type
        "user_id": user_id  # Link clinic to the created user
    }
    
    # Insert the generated clinic data into the database
    with engine.begin() as conn:
        query = text("""
            INSERT INTO clinics (
                name, address, address_number, address_complement, zip, city, state, country, 
                phone, email, website, clinic_type, user_id, created_at
            ) VALUES (
                :name, :address, :address_number, :address_complement, :zip, :city, :state, :country,
                :phone, :email, :website, :clinic_type, :user_id, NOW()
            )
        """)
        result = conn.execute(query, clinic_data)
        return result.lastrowid  # Retrieve the auto-generated clinic ID



def authenticate_user(username, password):
    """Authenticate a user based on username and password."""
    with engine.connect() as conn:  # Use engine.connect() to get a connection
        query = text("SELECT * FROM users WHERE username = :username")
        result = conn.execute(query, {'username': username})
        user_data = result.fetchone()  # Fetch one result
        
        if user_data and check_password_hash(user_data['password_hash'], password):
            return construct_user(user_data)
        
def update_user_password(email, hashed_password):
    """Update the user's password in the database."""
    with engine.connect() as conn:
        # Start a transaction manually
        with conn.begin():
            query = text("UPDATE users SET password_hash = :password_hash WHERE email = :email")
            conn.execute(query, {'password_hash': hashed_password, 'email': email})

        
def get_user_by_username(username):
    """Get a user by their username."""
    with engine.connect() as conn:  # Use engine.connect() to get a connection
        query = text("SELECT * FROM users WHERE username = :username")
        result = conn.execute(query, {'username': username})
        user_data = result.fetchone()  # Fetch one result
        
        if user_data:
            return construct_user(user_data)
        
def get_user_by_email(email):
    """Get a user by their email."""
    with engine.connect() as conn:
        query = text("SELECT * FROM users WHERE email = :email")
        result = conn.execute(query, {'email': email})
        user_data = result.fetchone()  # Fetch one result
        return user_data

def search_user_data(user_id):
    """Get a user's role by their user ID searching the Database."""
    with engine.connect() as conn:  # Use engine.connect() to get a connection
        query = text("SELECT id, name, healthcare_professional_id, front_desk_user_id, roles FROM users WHERE id = :user_id")
        result = conn.execute(query, {'user_id': user_id})
        user_data = result.fetchone()  # Fetch one result

        if user_data:
            # Convert user_data to a dictionary with meaningful keys
            user_data_dict = {
                'id': user_data[0],
                'name': user_data[1],
                'healthcare_professional_id': user_data[2],
                'front_desk_user_id': user_data[3],
                'roles': json.loads(user_data[4])
            }
            return user_data_dict


def get_role():
    '''Extract user role from the token'''
    current_identity = get_jwt_identity()
    
    # Assuming current_identity is a dictionary containing user information
    
    return current_identity.get("role")
       