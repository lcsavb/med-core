import random
import threading
import logging

from flask import Blueprint


models_bp = Blueprint('models', __name__)


class User:
    def __init__(self, id, username, email, created_at, roles=None):
        self.id = id
        self.username = username
        self.email = email
        self.created_at = created_at
        self.roles = roles if roles else []  # A list of roles assigned to the user, e.g., ["doctor"]

    def get_id(self):
        return self.username  # Return username

    def list_roles(self):
        return self.roles

    def is_doctor(self):
        return True if "doctor" in self.roles else False

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

    return User(
        id=user_id,
        username=user_data['username'],
        email=user_data["email"],
        created_at=user_data['created_at'],
        roles=user_data['user_roles'].split(",") if user_data['user_roles'] else []
    )



    