from flask_restful import Resource
from sqlalchemy import text
from db import engine

class PatientsResource(Resource):
    def get(self, clinic_id):
        # Securely query the database to get all patients for the specified clinic
        query = text("SELECT * FROM patients WHERE clinic_id = :clinic_id")
        with engine.connect() as connection:
            result = connection.execute(query, {"clinic_id": clinic_id})
            patients = [dict(row) for row in result]
        return {"patients": patients}, 200

class PatientsByDoctorsResource(Resource):
    def get(self, clinic_id, doctor_id):
        # Securely query the database to get all patients for the specified doctor and clinic
        query = text("""
            SELECT p.* FROM patients p
            JOIN appointments a ON p.id = a.patient_id
            JOIN schedules s ON a.schedule_id = s.id
            WHERE s.doctor_id = :doctor_id AND p.clinic_id = :clinic_id
        """)
        with engine.connect() as connection:
            result = connection.execute(query, {"doctor_id": doctor_id, "clinic_id": clinic_id})
            patients = [dict(row) for row in result]
        return {"patients": patients}, 200
