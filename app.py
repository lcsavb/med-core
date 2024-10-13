from flask import Flask, render_template, redirect, url_for, session, request
# TO DO
# from flask_login import login_required

app = Flask(__name__)
app.secret_key = 'your_secret_key'

### THERE WILL BE 3 TYPES OF USERS:
# 1. Administrator (admin) - will be able to manage clinics, doctors and patients. Super user. It won´t be able to see clinical data
# 2. Doctor - will be able to see the patients that have been assigned to them and their respective clinical data
# 3. Secretary - will be able to manage patients

@app.route('/')
def index():
    print("Accessing index route")
    print(f"Session state: {session}")
    if not session.get('logged_in'):
        print("User not logged in, redirecting to login page")
        return redirect(url_for('login'))
    print("User logged in, rendering index.html")
    return render_template('index.html')

@app.route('/login', methods=['GET', 'POST'])
def login():
    print("Accessing login route")
    if request.method == 'POST':
        print("Login form submitted")
        # Simulate login
        session['logged_in'] = True
        session['role'] = request.form.get('role')  # Simulate role assignment
        role = session['role']
        print(f"User role: {role}")
        if role == 'admin':
            return redirect(url_for('clinic_management'))
        elif role == 'doctor':
            return redirect(url_for('dashboard'))
        elif role == 'secretary':
            return redirect(url_for('schedule'))
        else:
            return redirect(url_for('index'))
    return render_template('auth/login.html')


@app.route('/logout')
def logout():
    session.pop('logged_in', None)
    session.pop('role', None)
    return redirect(url_for('login'))

@app.route('/register', methods=['GET', 'POST'])
def register():
    if request.method == 'POST':
        # Handle registration logic here
        return redirect(url_for('login'))
    return render_template('auth/register.html')


@app.route('/dashboard')
# TO DO @login_required
# this is where the doctors will be able to see the patients that have been assigned to them
def dashboard():
    if not session.get('logged_in') or session.get('role') != 'doctor':
        return redirect(url_for('login'))
    return render_template('doctor/dashboard.html')

@app.route('/about')
def about():
    return render_template('about.html')

@app.route('/anamnesis')
# TO DO @login_required
# this is where the doctors will be able to perform the anamnesis of the patients
def anamnesis():
    if not session.get('logged_in') or session.get('role') != 'doctor':
        return redirect(url_for('login'))
    return render_template('doctor/anamnesis.html')

@app.route('/schedule')
# TO DO @login_required
# this is where the secretaries and admin will be able to see the schedule of the doctors for the day
# and mark the patients as arrived
def schedule():
    if not session.get('logged_in') or session.get('role') not in ['admin', 'secretary']:
        return redirect(url_for('login'))
    return render_template('schedule.html')

@app.route('/patient_management')
# TO DO @login_required
# dashboard for admin and secretary to manage patients and make appointments
def patient_management():
    if not session.get('logged_in') or session.get('role') not in ['admin', 'secretary']:
        return redirect(url_for('login'))
    return render_template('admin/patient_management.html')

@app.route('/doctor_management')
# TO DO @login_required
# dashboard for admin to manage doctors
def doctor_management():
    if not session.get('logged_in') or session.get('role') != 'admin':
        return redirect(url_for('login'))
    return render_template('admin/doctor_management.html')

@app.route('/clinic_management')
# TO DO @login_required
# dashboard for the admin to manage clinics
def clinic_management():
    if not session.get('logged_in') or session.get('role') != 'admin':
        return redirect(url_for('login'))
    return render_template('admin/clinic_management.html')

@app.route('/contact')
def contact():
    return render_template('contact.html')




if __name__ == '__main__':
    app.run(debug=True)

