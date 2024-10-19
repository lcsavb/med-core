from flask import Blueprint, render_template, request, redirect, url_for, flash
from flask_login import login_user, logout_user, login_required, LoginManager
from werkzeug.security import generate_password_hash, check_password_hash
from mysql.connector import Error
from db import get_db_connection
from models import User, get_user_by_username
from datetime import datetime

auth_bp = Blueprint('auth', __name__)

@auth_bp.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        username = request.form.get('username')
        password = request.form.get('password')

        # Get the user from the database
        user = get_user_by_username(username)
        if user and check_password_hash(user.password_hash, password):
            # Log the user in
            login_user(user, remember=True)
            flash('Login successful!', 'success')
            return redirect(url_for('index'))
        else:
            flash('Invalid username or password', 'danger')
    return render_template('auth/login.html')

@auth_bp.route('/register', methods=['GET', 'POST'])
def register():
    '''Register a new user and check if the username is already taken'''
    if request.method == 'POST':
        username = request.form.get('username')
        password = request.form.get('password')

        # Hash the password
        password_hash = generate_password_hash(password)

        # Check if username already exists
        existing_user = get_user_by_username(username)
        if existing_user:
            flash('Username already taken!', 'danger')
            return redirect(url_for('auth.register'))

        # Create and add the new user to the database
        try:
            connection = get_db_connection()
            cursor = connection.cursor()
            cursor.execute("""
                INSERT INTO users (username, password_hash, is_admin, is_doctor, created_at)
                VALUES (%s, %s, %s, %s, %s)
            """, (username, password_hash, False, False, datetime.utcnow()))
            connection.commit()
            cursor.close()
            connection.close()
        except Error as e:
            flash('Error registering user: ' + str(e), 'danger')
            return redirect(url_for('auth.register'))

        flash('User registered successfully!', 'success')
        return redirect(url_for('auth.login'))
    return render_template('auth/register.html')

@auth_bp.route('/logout')
@login_required
def logout():
    logout_user()
    flash('You have been logged out.', 'info')
    return redirect(url_for('auth.login'))
