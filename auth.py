from flask import Blueprint, render_template, request, redirect, url_for, flash
from flask_login import login_user, logout_user, login_required, LoginManager
from werkzeug.security import generate_password_hash, check_password_hash
from models import db, User

auth_bp = Blueprint('auth', __name__)


@auth_bp.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        username = request.form.get('username')
        password = request.form.get('password')

        # Query the user from the database
        user = User.query.filter_by(username=username).first()
        if user and check_password_hash(user.password_hash, password):
            # Log the user in
            login_user(user, remember=True)
            flash('Login successful!', 'success')
            
            # Ensure 'index' route exists in your app
            return redirect(url_for('index'))
        else:
            flash('Invalid username or password', 'danger')
    
    # Ensure you have the correct template structure
    return render_template('auth/login.html')


@auth_bp.route('/register', methods=['GET', 'POST'])
def register():
    '''Register a new user and check if the username is already taken'''
    if request.method == 'POST':
        username = request.form.get('username')
        password = request.form.get('password')
        
        # Hash the password
        password_hash = generate_password_hash(password)
        
        # Create and add the new user to the database
        try:
            new_user = User(username=username, password_hash=password_hash)
            db.session.add(new_user)
            db.session.commit()
        except:
            flash('Username already taken!', 'danger')
            return redirect(url_for('auth.register'))
        
        flash('User registered successfully!', 'success')
        
        # Redirect to the login route (ensure it is correctly prefixed)
        return redirect(url_for('auth.login'))
    
    return render_template('auth/register.html')


@auth_bp.route('/logout')
@login_required
def logout():
    logout_user()
    flash('You have been logged out.', 'info')
    
    # Redirect to the login route after logout
    return redirect(url_for('auth.login'))
