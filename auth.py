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
from pymysql.err import IntegrityError
from sqlalchemy.exc import SQLAlchemyError
from sqlalchemy.sql import text
from werkzeug.security import check_password_hash, generate_password_hash

from db import engine
from models import construct_user

SECRET_KEY = "your-secret-key"


class LoginResource(Resource):
    def post(self):
        start_time = time.time()

        username = request.json.get('username')
        password = request.json.get('password')

        # Measure time to get request data
        request_time = time.time()
        print(f"Time to get request data: {request_time - start_time:.4f} seconds")

        # Authenticate the user
        auth_start_time = time.time()
        user = authenticate_user(username, password)
        auth_end_time = time.time()
        print(f"Time to authenticate user: {auth_end_time - auth_start_time:.4f} seconds")

        if user:
            # Set a verification code
            verification_start_time = time.time()
            user.set_verification_code()
            verification_end_time = time.time()
            print(f"Time to set verification code: {verification_end_time - verification_start_time:.4f} seconds")

            # Hash the verification code
            verification_code_hash = generate_password_hash(str(user.verification_code))
            verification_code_hash = str(verification_code_hash)

            # Create a temporary token with the username and hashed code
            temporary_token = create_access_token(
                identity={
                    "username": user.username,
                    "verification_code_hash": verification_code_hash
                },
                expires_delta=timedelta(minutes=5)  # Token expires in 10 minutes
            )

            # Send the verification code via email in a separate thread
            email_thread = threading.Thread(target=send_verification_email, args=(user.email, user.verification_code))
            email_thread.start()

            print(f'Email sent to {user.email} with verification code: {user.verification_code}')

            end_time = time.time()
            print(f"Total time for LoginResource.post: {end_time - start_time:.4f} seconds")

            return make_response(jsonify({'temporary_token': temporary_token, 'message': 'Verification code sent!'}), 200)
        else:
            end_time = time.time()
            print(f"Total time for LoginResource.post (failed): {end_time - start_time:.4f} seconds")
            return make_response(jsonify({'message': 'Invalid username or password'}), 401)
        

class Verify2FAResource(Resource):
    @jwt_required()  # This decorator validates the JWT token
    def post(self):
        # Retrieve the entered verification code from the request
        entered_code = request.json.get('verification_code')

        # Decode the temporary token and get the user identity data
        decoded_token = get_jwt_identity()
        username = decoded_token.get("username")
        verification_code_hash = decoded_token.get("verification_code_hash")

        # Check the entered code against the hash
        if check_password_hash(verification_code_hash, str(entered_code)):
            # If successful, generate a new access token
            access_token = create_access_token(identity={"username": username, "role":"oi"})
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

        try:
            save_user_in_db(username, password_hash, email, name, phone, is_doctor)
            return make_response(jsonify({'message': 'User registered successfully!'}), 201)

        except IntegrityError as e:
            if e.orig.args[0] == 1062:  # MySQL duplicate entry error code
                logging.error("Duplicated username detected")
                return make_response(jsonify({'message': 'Username already taken!'}), 400)
            logging.error(f"IntegrityError: {e}")
            return make_response(jsonify({'message': 'An integrity error occurred.'}), 500)

        except Exception as e:
            logging.error(f"Error registering user: {e}")
            return make_response(jsonify({'message': 'Error registering user.'}), 500)


class StatusResource(Resource):
    @jwt_required()
    def get(self):
        # Get the current user's identity from the JWT token
        current_identity = get_jwt_identity()
        print(current_identity)

        # Assuming current_identity is a dictionary containing user information
        username = current_identity.get("username")

        if username:
            return make_response(jsonify({'authenticated': True, 'username': username}), 200)
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
            INSERT INTO users (username, name, password_hash, email, phone, user_roles, created_at)
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
    try:
        with engine.connect() as conn:  # Use engine.connect() to get a connection
            query = text("SELECT * FROM users WHERE username = :username")
            result = conn.execute(query, {'username': username})
            user_data = result.fetchone()  # Fetch one result
            
            if user_data and check_password_hash(user_data['password_hash'], password):
                return construct_user(user_data)
    except SQLAlchemyError as e:  # Catch SQLAlchemy-specific exceptions
        logging.error(f"Error during user authentication: {e}")
        raise  # Re-raise the exception after logging it access_token = create_access_token(identity={"username": user


def get_user_by_username(username):
    """Get a user by their username."""
    try:
        with engine.connect() as conn:  # Use engine.connect() to get a connection
            query = text("SELECT * FROM users WHERE username = :username")
            result = conn.execute(query, {'username': username})
            user_data = result.fetchone()  # Fetch one result
            
            if user_data:
                return construct_user(user_data)
    except SQLAlchemyError as e:  # Catch SQLAlchemy-specific exceptions
        logging.error(f"Error getting user by username: {e}")
        raise  # Re-raise the exception after logging it
