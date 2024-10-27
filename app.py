import logging
import os

from flask import Flask, jsonify
from flask_restful import Api
from flask_login import LoginManager
from flask_limiter.errors import RateLimitExceeded


from auth import LoginResource, RegisterResource, LogoutResource, StatusResource, get_user_by_username
from logging_config import configure_logging
from rate_limit import limiter


configure_logging()

app = Flask(__name__)
api = Api(app)

# Rate limiter initialization and configuration to prevent abuse and brute force attacks
limiter.init_app(app)

# Error handler for rate limit exceeded
@app.errorhandler(RateLimitExceeded)
def rate_limit_handler(e):
    return jsonify({'message': 'Rate limit exceeded. Please try again later.'}), 429

# Secret key for session management
app.secret_key = os.environ.get("SECRET_KEY", "default-secret-key")

# Resources
api.add_resource(LoginResource, '/auth/login')
api.add_resource(RegisterResource, '/auth/register')
api.add_resource(LogoutResource, '/auth/logout')
api.add_resource(StatusResource, '/auth/status')


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
