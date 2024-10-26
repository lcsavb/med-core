from flask_limiter import Limiter
from flask_limiter.util import get_remote_address

# Initialize the Limiter without passing the app immediately
limiter = Limiter(key_func=get_remote_address, default_limits=[])

# Optionally, define custom rate limiters for different scopes or uses
def limit_by_ip(limit):
    return limiter.shared_limit(limit, scope_func=get_remote_address)

# If you need to limit by user ID or other identifiers, you can define additional functions
def limit_by_user(limit):
    from flask import g
    def user_identifier():
        return getattr(g, 'user_id', get_remote_address())
    return limiter.shared_limit(limit, scope_func=user_identifier)
