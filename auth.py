from flask import Blueprint, render_template, request, jsonify, logging
import jwt
import datetime
from werkzeug.security import generate_password_hash, check_password_hash
from db import engine
from sqlalchemy.exc import SQLAlchemyError
from sqlalchemy.sql import text
from models import construct_user
from functools import wraps
import smtplib
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart


auth_bp = Blueprint('auth', __name__)

SECRET_KEY = "your-secret-key"

# Token generation function
def generate_token(username):
    token = jwt.encode(
        {
            'username': username,
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

        if not token:
            return jsonify({'message': 'Token is missing!'}), 403

        try:
            # Ensure token is in "Bearer <token>" format
            if not token.startswith("Bearer "):
                return jsonify({'message': 'Invalid token format!'}), 403

            # Split the Bearer token
            token = token.split(" ")[1]
            print("Token after split:", token)  # Log the extracted token

            # Decode the JWT token
            data = jwt.decode(token, SECRET_KEY, algorithms=['HS256'])
            print("Decoded token data:", data)  # Log the decoded data
            
            # Get user from decoded token
            current_user = get_user_by_username(data['username'])
        except jwt.ExpiredSignatureError:
            print("Token expired!")  # Log if the token is expired
            return jsonify({'message': 'Token has expired!'}), 403
        except jwt.InvalidTokenError:
            print("Invalid token!")  # Log if the token is invalid
            return jsonify({'message': 'Token is invalid!'}), 403
        except Exception as e:
            print(f"An error occurred: {e}")  # Log any other errors
            return jsonify({'message': 'Token is invalid!'}), 403

        # Pass the current_user to the wrapped function
        return f(current_user, *args, **kwargs)
    
    return decorated_function



@auth_bp.route('/login', methods=['POST'])
def login():
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
        
        return jsonify({'token': token, 'message': 'Login successful!'}), 200
    else:
        return jsonify({'message': 'Invalid username or password'}), 401

    
    
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




# Register route for SPA
@auth_bp.route('/register', methods=['POST'])
def register():
    username = request.json.get('username')
    password = request.json.get('password')
    email = request.json.get('email')  

    # Hash the password
    password_hash = generate_password_hash(password)

    # Check if the username already exists
    existing_user = get_user_by_username(username)
    if existing_user:
        return jsonify({'message': 'Username already taken!'}), 400

    try:
        save_user_in_db(username, password_hash, email) 
        return jsonify({'message': 'User registered successfully!'}), 201
    except RuntimeError as e:
        return jsonify({'message': f'Error registering user: {e}'}), 500

# Save user function remains the same

def save_user_in_db(username, password_hash, email=None):
    """Insert a new user into the database using vanilla SQL and transaction handling."""
    try:
        with engine.begin() as conn:  # engine.begin() handles transaction management
            query = text("""
                INSERT INTO users (username, password_hash, email, is_admin, is_doctor, created_at)
                VALUES (:username, :password_hash, :email, :is_admin, :is_doctor, NOW())
            """)
            conn.execute(query, {
                'username': username,
                'password_hash': password_hash,
                'email': email, 
                'is_admin': False,
                'is_doctor': False
            })
    except SQLAlchemyError as e:
        logging.error(f"Transaction failed: {e}")
        raise RuntimeError(f"Transaction failed: {e}")


# Authenticate user function remains the same
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

# Get user function remains the same
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

@auth_bp.route('/status', methods=['GET'])
@token_required
def check_auth_status(current_user):
      
    # Return the authenticated status along with the username
    return jsonify({'authenticated': True, 'username': current_user.username}), 200

    
@auth_bp.route('/protected')
@token_required
def protected_route(current_user):
    return jsonify({'message': f'Hello, {current_user.username}!'}), 200



# Logout route (optional if not using token storage)
@auth_bp.route('/logout', methods=['POST'])
def logout():
    # No session to clear, tokens are stateless, just remove token from client-side
    return jsonify({'message': 'Logged out successfully.'}), 200