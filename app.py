from flask import Flask, render_template, redirect, url_for, session, request, flash
from flask_login import login_required, LoginManager
from flask_migrate import Migrate
from flask_sqlalchemy import SQLAlchemy
from sqlalchemy import text
from datetime import timedelta
from models import db, User, HealthcareProfessional
from auth import auth_bp
import json

with open('config.json', 'r') as f:
    config = json.load(f)

local_db_uri = config['database_uri']
print(local_db_uri)

app = Flask(__name__)
app.config['DEBUG'] = True
app.config['SQLALCHEMY_DATABASE_URI'] = local_db_uri
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
app.config['REMEMBER_COOKIE_DURATION'] = timedelta(days=7)
app.secret_key = 'mysecretkey'

# Initialize extensions
db.init_app(app)
migrate = Migrate(app, db)

login_manager = LoginManager()
login_manager.init_app(app)
login_manager.login_view = 'auth.login'

@login_manager.user_loader
def load_user(user_id):
    return User.query.get(int(user_id))

# Register blueprints
app.register_blueprint(auth_bp, url_prefix='/auth')

# Sample data for appointments
appointments = [
    {'time': '10:00 AM', 'patient_name': 'John Doe', 'arrived': False, 'id': 1},
    {'time': '11:00 AM', 'patient_name': 'Jane Smith', 'arrived': False, 'id': 2}
]

# Routes
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
    # Find the appointment by ID and mark it as arrived
    for appointment in appointments:
        if appointment['id'] == appointment_id:
            appointment['arrived'] = True
            break
    return redirect(url_for('dashboard'))

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
@login_required
def test_db():
    try:
        db.session.execute(text('SELECT 1'))
        return 'Database connection successful!', 200
    except Exception as e:
        return f'Error connecting to the database: {str(e)}', 500

@app.route('/login')
def login():
    return render_template('auth/login.html')

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)