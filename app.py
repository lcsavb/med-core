import logging
import os

from flask import Flask
from flask_login import LoginManager
from sqlalchemy import create_engine

from auth import auth_bp, get_user_by_username
from logging_config import configure_logging


configure_logging()

app = Flask(__name__)

# Secret key for session management
app.secret_key = os.environ.get("SECRET_KEY", "default-secret-key")

# Blueprints
app.register_blueprint(auth_bp, url_prefix='/auth')

# Login Manager
login_manager = LoginManager()
login_manager.login_view = 'auth.login'
login_manager.init_app(app)

# Define the user loader function
@login_manager.user_loader
def load_user(username):
    return get_user_by_username(username)


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True, use_reloader=True)
