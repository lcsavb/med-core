from flask import Flask, render_template, redirect, url_for, session, request, flash
from flask_login import login_required, LoginManager
from mysql.connector import Error
from datetime import timedelta
from auth import auth_bp
from db import get_db_connection
from models import User, get_user_by_username

app = Flask(__name__)
app.config['DEBUG'] = True
app.config['REMEMBER_COOKIE_DURATION'] = timedelta(days=7)

# Blueprints
app.register_blueprint(auth_bp, url_prefix='/auth')

# Login Manager
login_manager = LoginManager()
login_manager.login_view = 'auth.login'
login_manager.init_app(app)

# Define the user loader function
@login_manager.user_loader
def load_user(username):
    user = get_user_by_username(username)
    return user



@app.route('/')
def index():
    return render_template('index.html')

@app.route('/about')
def about():
    return render_template('about.html')

@app.route('/contact')
def contact():
    return render_template('contact.html')

@app.route('/dashboard')
@login_required
def dashboard():
    return render_template('/doctor/dashboard.html', appointments=appointments)

@app.route('/mark_arrived/<int:appointment_id>', methods=['POST'])
@login_required
def mark_arrived(appointment_id):
    pass    

@app.route('/clinic_management')
def clinic_management():
    return render_template('./admin/clinic_management.html', clinics=clinics)

@app.route('/doctor_management')
def doctor_management():
    return render_template('./admin/doctor_management.html', doctors=doctors)

@app.route('/patient_management')
def patient_management():
    return render_template('./admin/patient_management.html', patients=patients)


@app.route('/test-db')
def test_db():
    connection = get_db_connection()
    if connection:
        try:
            cursor = connection.cursor()
            cursor.execute('SELECT 1')
            return 'Database connection successful!', 200
        except Error as e:
            return f'Error executing query: {e}', 500
        finally:
            cursor.close()
            connection.close()
    else:
        return 'Failed to connect to the database.', 500


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)