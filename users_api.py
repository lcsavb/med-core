from flask import jsonify, Blueprint, request

from sqlalchemy import text
from db import engine 
from email_validator import validate_email, EmailNotValidError 

from rate_limit import limiter

users_bp = Blueprint('users', __name__)


# Helper functions
def query_username(username):
    if not username:
        return False
    with engine.connect() as connection:
        query = text("SELECT 1 FROM users WHERE username = :username LIMIT 1")
        result = connection.execute(query, {"username": username}).fetchone()
        return result is not None

def query_email(email):
    if not email:
        return False
    with engine.connect() as connection:
        query = text("SELECT 1 FROM users WHERE email = :email LIMIT 1")
        result = connection.execute(query, {"email": email}).fetchone()
        return result is not None


# Endpoint to check username availability
@users_bp.route('/check_username', methods=['POST'])
@limiter.limit("5 per 10 seconds; 10 per minute; 20 per hour")  # Adjust the limit as needed
def check_username():
    username = request.json.get('username')
    if not username:
        return jsonify({'message': 'Username must be provided.'}), 400

    if query_username(username):
        return jsonify({'available': False, 'message': 'Username is not available.'}), 200
    else:
        return jsonify({'available': True, 'message': 'Username is available.'}), 200

# Endpoint to check email availability
@users_bp.route('/check_email', methods=['POST'])
@limiter.limit("5 per 10 seconds; 10 per minute; 20 per hour")  # Adjust the limit as needed
def check_email():
    try:
        valid = validate_email(request.json.get('email'))
        email = valid.email
    except EmailNotValidError as e:
        return jsonify({'message': 'Invalid email format.'}), 400

    if query_email(email):
        return jsonify({'available': False, 'message': 'Email is not available.'}), 200
    else:
        return jsonify({'available': True, 'message': 'Email is available.'}), 200
    
   
