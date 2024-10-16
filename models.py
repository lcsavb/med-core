from flask_sqlalchemy import SQLAlchemy
from flask_login import UserMixin
from datetime import datetime

db = SQLAlchemy()

class User(db.Model, UserMixin):
    __tablename__ = 'users'
    id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String(50), nullable=False, unique=True)
    # User role will always be admin
    is_admin = db.Column(db.Boolean, nullable=False, default=True)
    # this is a one to one relationship, as a user (admin) can sometimes be a healthcare professional
    healthcare_professional = db.relationship('HealthcareProfessional', backref='user', uselist=False)
    is_doctor = db.Column(db.Boolean, nullable=False, default=False)
    password_hash = db.Column(db.String(255), nullable=False)
    created_at = db.Column(db.DateTime, default=datetime.utcnow)
    clinics = db.relationship('Clinic', backref='admin', lazy=True)

class Clinic(db.Model):
    __tablename__ = 'clinics'
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(100), nullable=False)
    address = db.Column(db.Text, nullable=False)
    zip = db.Column(db.String(20), nullable=False)
    phone = db.Column(db.String(20), nullable=False)
    admin_user_id = db.Column(db.Integer, db.ForeignKey('users.id'), nullable=False)
    created_at = db.Column(db.DateTime, default=datetime.utcnow)

    front_desk_users = db.relationship('FrontDeskUser', backref='clinic', lazy=True)
    employment_links = db.relationship('EmploymentLink', backref='clinic', lazy=True)
    schedules = db.relationship('Schedule', backref='clinic', lazy=True)

class FrontDeskUser(db.Model, UserMixin):
    __tablename__ = 'front_desk_users'
    id = db.Column(db.Integer, primary_key=True)
    is_admin = db.Column(db.Boolean, nullable=False, default=False)
    clinic_id = db.Column(db.Integer, db.ForeignKey('clinics.id'), nullable=False)
    email = db.Column(db.String(255), nullable=False)
    created_at = db.Column(db.DateTime, default=datetime.utcnow)

class HealthcareProfessional(db.Model, UserMixin):
    __tablename__ = 'healthcare_professionals'
    id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.Integer, db.ForeignKey('users.id'), nullable=False)
    # User role can be a doctor and admin, doctor can never be dropped
    is_doctor = db.Column(db.Boolean, nullable=False, default=True)
    is_admin = db.Column(db.Boolean, nullable=False, default=False)
    profession = db.Column(db.String(50), nullable=False)
    specialty = db.Column(db.String(100), nullable=True)
    council_number = db.Column(db.String(50), nullable=False)
    email = db.Column(db.String(255), nullable=False)
    phone = db.Column(db.String(20), nullable=True)
    address = db.Column(db.String(255), nullable=True)
    created_at = db.Column(db.DateTime, default=datetime.utcnow)

    care_links = db.relationship('CareLink', backref='doctor', lazy=True)
    employment_links = db.relationship('EmploymentLink', backref='doctor', lazy=True)
    schedules = db.relationship('Schedule', backref='doctor', lazy=True)

class Patient(db.Model):
    __tablename__ = 'patients'
    id = db.Column(db.Integer, primary_key=True)
    first_name = db.Column(db.String(50), nullable=False)
    last_name = db.Column(db.String(50), nullable=False)
    picture = db.Column(db.LargeBinary)
    date_of_birth = db.Column(db.Date, nullable=False)
    gender = db.Column(db.String(10), nullable=False)
    address = db.Column(db.Text, nullable=False)
    phone = db.Column(db.String(20), nullable=False)
    email = db.Column(db.String(100), nullable=False)
    created_at = db.Column(db.DateTime, default=datetime.utcnow)

    care_links = db.relationship('CareLink', backref='patient', lazy=True)
    appointments = db.relationship('Appointment', backref='patient', lazy=True)
    medical_records = db.relationship('MedicalRecord', backref='patient', lazy=True)

class CareLink(db.Model):
    __tablename__ = 'care_link'
    id = db.Column(db.Integer, primary_key=True)
    doctor_id = db.Column(db.Integer, db.ForeignKey('healthcare_professionals.id'), nullable=False)
    patient_id = db.Column(db.Integer, db.ForeignKey('patients.id'), nullable=False)
    assigned_at = db.Column(db.DateTime, default=datetime.utcnow)

class EmploymentLink(db.Model):
    __tablename__ = 'employment_link'
    id = db.Column(db.Integer, primary_key=True)
    clinic_id = db.Column(db.Integer, db.ForeignKey('clinics.id'), nullable=False)
    doctor_id = db.Column(db.Integer, db.ForeignKey('healthcare_professionals.id'), nullable=False)
    created_at = db.Column(db.DateTime, default=datetime.utcnow)

class Schedule(db.Model):
    __tablename__ = 'schedules'
    id = db.Column(db.Integer, primary_key=True)
    doctor_id = db.Column(db.Integer, db.ForeignKey('healthcare_professionals.id'), nullable=False)
    clinic_id = db.Column(db.Integer, db.ForeignKey('clinics.id'), nullable=False)
    front_desk_users_id = db.Column(db.Integer, db.ForeignKey('front_desk_users.id'), nullable=True)
    available_from = db.Column(db.Time, nullable=False)
    available_to = db.Column(db.Time, nullable=False)
    appointment_interval = db.Column(db.String(50), nullable=False)

class Appointment(db.Model):
    __tablename__ = 'appointments'
    id = db.Column(db.Integer, primary_key=True)
    patient_id = db.Column(db.Integer, db.ForeignKey('patients.id'), nullable=False)
    schedule_id = db.Column(db.Integer, db.ForeignKey('schedules.id'), nullable=False)
    medical_records_id = db.Column(db.Integer, db.ForeignKey('medical_records.id'), nullable=True)
    appointment_time = db.Column(db.DateTime, nullable=False)

class MedicalRecord(db.Model):
    __tablename__ = 'medical_records'
    id = db.Column(db.Integer, primary_key=True)
    patient_id = db.Column(db.Integer, db.ForeignKey('patients.id'), nullable=False)
    record_date = db.Column(db.DateTime, default=datetime.utcnow)
    diagnosis = db.Column(db.Text, nullable=False)
    anamnesis = db.Column(db.Text, nullable=False)
    evolution = db.Column(db.Text, nullable=False)
    pdf_file = db.Column(db.LargeBinary)
    created_at = db.Column(db.DateTime, default=datetime.utcnow)
