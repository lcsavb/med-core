import datetime
import logging
import smtplib
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText
from functools import wraps

import jwt
from flask import request, jsonify, make_response
from flask_restful import Resource, Api
from pymysql.err import IntegrityError
from sqlalchemy.exc import SQLAlchemyError
from sqlalchemy.sql import text
from werkzeug.security import check_password_hash, generate_password_hash

from db import engine
from models import construct_user

SECRET_KEY = "your-secret-key"

# Token generation function
def generate_token(username, roles):
    token = jwt.encode(
        {
            'username': username,
            'roles': roles,
            'exp': datetime.datetime.utcnow() + datetime.timedelta(hours=24)  # Token expires in 24 hours
        },
        SECRET_KEY,
        algorithm='HS256'
    )
    return token

# Token verification decorator
def token_required(f):
    @wraps(f)
    def decorated_function(*args, **kwargs):
        token = request.headers.get('Authorization')

        # Log the token for debugging purposes
        print("Authorization Header:", token)

        # Check if the token is present
        if not token:
            return make_response(jsonify({'message': 'Token is missing!'}), 403)

        try:
            # Ensure token is in "Bearer <token>" format
            if not token.startswith("Bearer "):
                return make_response(jsonify({'message': 'Invalid token format!'}), 403)

            # Extract the token from the "Bearer <token>" format
            token = token.split(" ")[1]
            print("Token after split:", token)  # Log the extracted token
            
            # Decode the JWT token
            data = jwt.decode(token, SECRET_KEY, algorithms=['HS256'])
            print("Decoded token data:", data)  # Log the decoded data
            
            # Get user from decoded token
            current_user = get_user_by_username(data['username'])
            roles = data['roles']

            print(current_user.roles)
            
        except jwt.ExpiredSignatureError:
            print("Token expired!")  # Log if the token is expired
            return make_response(jsonify({'message': 'Token has expired!'}), 403)
        except jwt.InvalidTokenError:
            print("Invalid token!")  # Log if the token is invalid
            return make_response(jsonify({'message': 'Token is invalid!'}), 403)
        except Exception as e:
            print(f"An error occurred: {e}")  # Log any other errors
            return make_response(jsonify({'message': 'Token is invalid!'}), 403)
        
        # Pass the current_user to the wrapped function
        return f(current_user, *args, **kwargs)
    
    return decorated_function


# Flask-RESTful Resources
class LoginResource(Resource):
    def post(self):
        username = request.json.get('username')
        password = request.json.get('password')

        # Authenticate the user and construct a User object if valid
        user = authenticate_user(username, password)
        if user:
            token = generate_token(user.username)
            # Generate and set a verification code
            user.set_verification_code()
            
            # Send the verification code via email
            send_verification_email(user.email, user.verification_code)
            
            return make_response(jsonify({'token': token, 'message': 'Login successful!'}), 200)
        else:
            return make_response(jsonify({'message': 'Invalid username or password'}), 401)


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
    @token_required
    def get(current_user, *args, **kwargs):
        # Access the username of the current_user
        username = current_user.username 
        
        if username:
            return make_response(jsonify({'authenticated': True, 'username': username}), 200)
        else:
            return make_response(jsonify({'authenticated': False, 'message': 'User not authenticated'}), 403)


class ProtectedResource(Resource):
    @token_required
    def get(self, current_user):
        return make_response(jsonify({'message': repr(current_user)}), 200)


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
            INSERT INTO users (username, name, password_hash, email, phone, is_doctor, created_at)
            VALUES (:username, :name, :password_hash, :email, :phone, :is_doctor, NOW())
        """)
        conn.execute(query, {
            'username': username,
            'name': name,
            'password_hash': password_hash,
            'email': email,
            'is_doctor': is_doctor,
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
        raise  # Re-raise the exception after logging it


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
