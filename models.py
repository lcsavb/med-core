from flask_login import UserMixin
from db import get_db_connection
from mysql.connector import Error

class User(UserMixin):
    def __init__(self, id, username, is_admin, is_doctor, password_hash, created_at):
        self.id = id
        self.username = username
        self.is_admin = is_admin
        self.is_doctor = is_doctor
        self.password_hash = password_hash
        self.created_at = created_at

    def get_id(self):
        return self.username  # Return username

def get_user_by_username(username):
    connection = get_db_connection()
    if not connection:
        return None
    try:
        cursor = connection.cursor(dictionary=True)
        cursor.execute("SELECT * FROM users WHERE username = %s", (username,))
        user_data = cursor.fetchone()
        if user_data:
            user = User(
                id=user_data['id'],
                username=user_data['username'],
                is_admin=user_data['is_admin'],
                is_doctor=user_data['is_doctor'],
                password_hash=user_data['password_hash'],
                created_at=user_data['created_at'],
            )
            return user
    except Error as e:
        print(f"Error fetching user by username: {e}")
    finally:
        cursor.close()
        connection.close()
    return None
