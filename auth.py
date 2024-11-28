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

        # Save the user to the database, any error will be handled by the global error handler
        save_user_in_db(username, password_hash, email, name, phone, is_doctor)

        return make_response(jsonify({'message': 'User registered successfully!'}), 201)



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




class LogoutResource(Resource):
    def post(self):
        # No session to clear, tokens are stateless, just remove token from client-side
        return make_response(jsonify({'message': 'Logged out successfully.'}), 200)


# Utility Functions
def send_verification_email(recipient_email, code):
    """Send an email with the verification code to the user."""
    sender_email = "medcorelogin@gmail.com"
    sender_password = "qjba owmh dznj yiek"
    
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


# Authentication and User Management Functions
def save_user_in_db(username, password_hash, email, name, phone, is_doctor):
    """Insert a new user into the database using vanilla SQL and transaction handling."""
    with engine.begin() as conn:  # engine.begin() handles transaction management
        query = text("""
            INSERT INTO users (username, name, password_hash, email, phone, roles, created_at)
            VALUES (:username, :name, :password_hash, :email, :phone, :roles, NOW())
        """)
        conn.execute(query, {
            'username': username,
            'name': name,
            'password_hash': password_hash,
            'email': email,
            'roles': json.dumps(["doctor"] if is_doctor else []),  # Convert list to JSON string
            'phone': phone
        })


def authenticate_user(username, password):
    """Authenticate a user based on username and password."""
    with engine.connect() as conn:  # Use engine.connect() to get a connection
        query = text("SELECT * FROM users WHERE username = :username")
        result = conn.execute(query, {'username': username})
        user_data = result.fetchone()  # Fetch one result
        
        if user_data and check_password_hash(user_data['password_hash'], password):
            return construct_user(user_data)

def get_user_by_username(username):
    """Get a user by their username."""
    with engine.connect() as conn:  # Use engine.connect() to get a connection
        query = text("SELECT * FROM users WHERE username = :username")
        result = conn.execute(query, {'username': username})
        user_data = result.fetchone()  # Fetch one result
        
        if user_data:
            return construct_user(user_data)

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
       