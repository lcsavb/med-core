from flask import Blueprint
from flask_login import UserMixin
from mysql.connector import Error
from werkzeug.security import check_password_hash
import random
import threading



models_bp = Blueprint('models', __name__)


class User(UserMixin):
    def __init__(self, id, username, email, is_admin, is_doctor, created_at):
        self.id = id
        self.username = username
        self.email = email
        self.is_admin = is_admin
        self.is_doctor = is_doctor
        self.created_at = created_at
        self.verification_code = None

    def get_id(self):
        return self.username  # Return username

    def set_verification_code(self):
        """Generate a 6-digit code and set expiry time."""
        self.verification_code = random.randint(100000, 999999)
        
         # Schedule deletion of the code after 5 minutes
        threading.Timer(300, self.delete_verification_code).start()

    def delete_verification_code(self):
        """Delete the verification code and expiry."""
        self.verification_code = None
        
def construct_user(user_data):
    """Construct a User object from a dictionary of user data."""
    return User(
        id=user_data['id'],
        username=user_data['username'],
        email = user_data["email"],
        is_admin=user_data['is_admin'],
        is_doctor=user_data['is_doctor'],
        created_at=user_data['created_at']
    )

    