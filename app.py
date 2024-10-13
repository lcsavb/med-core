from flask import Flask, render_template, redirect, url_for, session, request
# TO DO
# from flask_login import login_required

app = Flask(__name__)

app.secret_key = 'mysecretkey'

### THERE WILL BE 3 TYPES OF USERS:
# 1. Administrator (admin) - will be able to manage clinics, doctors and patients. Super user. It won´t be able to see clinical data
# 2. Doctor - will be able to see the patients that have been assigned to them and their respective clinical data
# 3. Secretary - will be able to manage patients

@app.route('/')
def index():
    if not session.get('logged_in'):
        return redirect(url_for('login'))
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


@app.route('/dashboard')
def dashboard():
    if not session.get('logged_in') or session.get('role') != 'doctor':
        return redirect(url_for('login'))
    # Get the selected date from the query parameters
    selected_date = request.args.get('appointment_date', 'No date selected')
    # Sample appointments data
    appointments = [
        {'time': '09:00 AM', 'patient_name': 'John Doe', 'arrived': False, 'id': 1},
        {'time': '10:00 AM', 'patient_name': 'Jane Smith', 'arrived': True, 'id': 2},
        {'time': '11:00 AM', 'patient_name': 'Alice Johnson', 'arrived': False, 'id': 3},
    ]
    # Render the dashboard template with the selected date and appointments
    return render_template('doctor/dashboard.html', selected_date=selected_date, appointments=appointments)


@app.route('/mark_arrived/<int:appointment_id>', methods=['POST'])
def mark_arrived(appointment_id):
    # Logic to mark the appointment as arrived
    print(f"Marking appointment {appointment_id} as arrived")
    # Redirect back to the dashboard
    return redirect(url_for('dashboard'))

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



@app.route('/about')
def about():
    return render_template('about.html')


@app.route('/schedule')
# TO DO @login_required
# this is where the secretaries and admin will be able to see the schedule of the doctors for the day
# and mark the patients as arrived
def schedule():
    if not session.get('logged_in') or session.get('role') not in ['admin', 'secretary']:
        return redirect(url_for('login'))
    
    # Fetch patient data (this is a placeholder, replace with actual data fetching logic)
    appointments = [
        {'id': 1, 'time': '09:00 AM', 'patient_name': 'John Doe', 'patient_id': 1, 'arrived': False},
        {'id': 2, 'time': '10:00 AM', 'patient_name': 'Jane Smith', 'patient_id': 2, 'arrived': True},
        {'id': 3, 'time': '11:00 AM', 'patient_name': 'Alice Johnson', 'patient_id': 3, 'arrived': False},
    ]
    
    patients = {
        1: {'ausweiss_number': '123456789', 'photo': 'path/to/photo1.jpg', 'phone': '(123) 456-7890', 'address': '123 Main St, Anytown, USA'},
        2: {'ausweiss_number': '987654321', 'photo': 'path/to/photo2.jpg', 'phone': '(987) 654-3210', 'address': '456 Elm St, Othertown, USA'},
        3: {'ausweiss_number': '456789123', 'photo': 'path/to/photo3.jpg', 'phone': '(456) 789-1234', 'address': '789 Oak St, Sometown, USA'},
    }
    
    return render_template('secretary/schedule.html', appointments=appointments, patients=patients)
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

