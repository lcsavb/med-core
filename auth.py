from flask import Blueprint, render_template, request, jsonify, logging
import jwt
import datetime
from werkzeug.security import generate_password_hash, check_password_hash
from db import engine
from sqlalchemy.exc import SQLAlchemyError
from sqlalchemy.sql import text
from models import construct_user
from functools import wraps

SECRET_KEY = "your-secret-key"  # Store in environment variables for better security

auth_bp = Blueprint('auth', __name__)

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
        
        if not token:
            return jsonify({'message': 'Token is mdissing!'}), 403
        
        try:
            # Split the Bearer token
            token = token.split(" ")[1]  
            data = jwt.decode(token, SECRET_KEY, algorithms=['HS256'])
            current_user = get_user_by_username(data['username'])
        except jwt.ExpiredSignatureError:
            return jsonify({'message': 'Token has expired!'}), 403
        except jwt.InvalidTokenError:
            return jsonify({'message': 'Token is invalid!'}), 403
        except Exception as e:
            return jsonify({'message': 'Token is invalid!'}), 403
        
        return f(current_user, *args, **kwargs)
    return decorated_function

# Login route for SPA
@auth_bp.route('/login', methods=['POST'])
def login():
    username = request.json.get('username')
    password = request.json.get('password')

    # Authenticate the user and construct a User object if valid
    user = authenticate_user(username, password)
    if user:
        # Generate and return JWT token
        token = generate_token(user.username)
        return jsonify({'token': token, 'message': 'Login successful!'}), 200
    else:
        return jsonify({'message': 'Invalid username or password'}), 401

# Register route for SPA
@auth_bp.route('/register', methods=['POST'])
def register():
    username = request.json.get('username')
    password = request.json.get('password')

    # Hash the password
    password_hash = generate_password_hash(password)

    # Check if the username already exists
    existing_user = get_user_by_username(username)
    if existing_user:
        return jsonify({'message': 'Username already taken!'}), 400

    try:
        save_user_in_db(username, password_hash)  # This is now atomic
        return jsonify({'message': 'User registered successfully!'}), 201
    except RuntimeError as e:
        return jsonify({'message': f'Error registering user: {e}'}), 500

# Save user function remains the same
def save_user_in_db(username, password_hash):
    """Insert a new user into the database using vanilla SQL and transaction handling."""
    try:
        with engine.begin() as conn:  # engine.begin() handles transaction management
            query = text("""
                INSERT INTO users (username, password_hash, is_admin, is_doctor, created_at)
                VALUES (:username, :password_hash, :is_admin, :is_doctor, NOW())
            """)
            conn.execute(query, {
                'username': username,
                'password_hash': password_hash,
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
def check_auth_status():
    token = request.headers.get('Authorization')
    print("Request Headers:", request.headers)
    
    
    if not token:
        return jsonify({'authenticated': False, 'message': 'Token is missing!'}), 401
    
    try:
        token = token.split(" ")[1]  # Split the "Bearer <token>" format
        data = jwt.decode(token, SECRET_KEY, algorithms=['HS256'])
        current_user = get_user_by_username(data['username'])  # Fetch user from the DB

        return jsonify({'authenticated': True, 'username': current_user.username}), 200
    except jwt.ExpiredSignatureError:
        return jsonify({'authenticated': False, 'message': 'Token has expired!'}), 401
    except jwt.InvalidTokenError:
        return jsonify({'authenticated': False, 'message': 'Token is invalid!'}), 401
    except Exception:
        return jsonify({'authenticated': False, 'message': 'Invalid token!'}), 401



# Logout route (optional if not using token storage)
@auth_bp.route('/logout', methods=['POST'])
def logout():
    # No session to clear, tokens are stateless, just remove token from client-side
    return jsonify({'message': 'Logged out successfully.'}), 200
