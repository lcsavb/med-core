import random
import threading
import logging

from flask import Blueprint
from mysql.connector import Error
from werkzeug.security import check_password_hash


from db import engine
from sqlalchemy.exc import SQLAlchemyError
from sqlalchemy.sql import text

models_bp = Blueprint('models', __name__)


class User:
    def __init__(self, id, username, email, created_at, is_admin=False, roles=None):
        self.id = id
        self.username = username
        self.email = email
        self.created_at = created_at
        self.is_admin = is_admin
        self.roles = roles if roles else []  # A list of roles assigned to the user, e.g., ["doctor"]

    def get_id(self):
        return self.username  # Return username

    def has_role(self, role_name):
        """Check if the user has a specific role."""
        return role_name in self.roles

    def is_doctor(self):
        return "doctor" in self.roles

    def is_admin(self):
        return self.is_admin

    def set_verification_code(self):
        """Generate a 6-digit code and set expiry time."""
        self.verification_code = random.randint(100000, 999999)
        
         # Schedule deletion of the code after 5 minutes
        threading.Timer(300, self.delete_verification_code).start()

    def delete_verification_code(self):
        """Delete the verification code and expiry."""
        self.verification_code = None

    def __repr__(self):
        return f'<User {self.username}>'
        
def construct_user(user_data):
    """Construct a User object from a dictionary of user data."""
    user_id = user_data['id']
    roles = get_roles_by_user_id(user_id)  # This can use database flags to decide roles
    is_admin = user_data.get('is_admin', False)

    return User(
        id=user_id,
        username=user_data['username'],
        email=user_data["email"],
        created_at=user_data['created_at'],
        is_admin=is_admin,
        roles=roles
    )



    