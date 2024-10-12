from flask import Flask, render_template
# TO DO
# from flask_login import login_required

app = Flask(__name__)

### THERE WILL BE 3 TYPES OF USERS:
# 1. Administrator (admin) - will be able to manage clinics, doctors and patients. Super user. It won´t be able to see clinical data
# 2. Doctor - will be able to see the patients that have been assigned to them and their respective clinical data
# 3. Secretary - will be able to manage patients

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/register') 
def register():
    return render_template('register.html')

@app.route('/login')
def login():
    return render_template('login.html')

@app.route('/dashboard')
# TO DO @login_required
# this is where the doctors will be able to see the patients that have been assigned to them
def dashboard():
    return render_template('dashboard.html')

@app.route('/anamnesis')
# TO DO @login_required
# this is where the doctors will be able to perform the anamnesis of the patients
def anamnesis():
    return render_template('anamnesis.html')

@app.route('/schedule')
# TO DO @login_required
# this is where the secretaries and admin will be able to see the schedule of the doctors for the day
# and mark the patients as arrived
def schedule():
    return render_template('schedule.html')

@app.route('/patient_management')
# TO DO @login_required
# dashboard for admin and secretary to manage patients and make appointments
def patient_management():
    return render_template('patient_management.html')

@app.route('/doctor_management')
# TO DO @login_required
# dashboard for admin to manage doctors
def doctor_management():
    return render_template('doctor_management.html')

@app.route('/clinic_management')
# TO DO @login_required
# dashboard for the admin to manage clinics
def clinic_management():
    return render_template('clinic_management.html')





if __name__ == '__main__':
    app.run(debug=True)

