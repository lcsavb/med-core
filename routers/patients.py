import logging

from flask_restful import Resource
from flask import request
from sqlalchemy import text
from sqlalchemy.exc import SQLAlchemyError
from db import engine

class PatientsResource(Resource):
    def get(self, clinic_id):
        # Securely query the database to get all patients for the specified clinic
        query = text("SELECT * FROM patients WHERE clinic_id = :clinic_id")
        with engine.connect() as connection:
            result = connection.execute(query, {"clinic_id": clinic_id})
            patients = [dict(row) for row in result]
        return {"patients": patients}, 200
    

    def post(self):
        patient_data = request.get_json()


        insert_query = text(
            """
            INSERT INTO patients (
                first_name, last_name, picture, date_of_birth, gender, address, address_number,
                address_complement, zip, phone, email, status, emergency_contact_name,
                emergency_contact_phone, nationality, language, insurance_provider,
                insurance_policy_number, created_at, updated_at
            ) VALUES (
                :first_name, :last_name, :picture, :date_of_birth, :gender, :address, :address_number,
                :address_complement, :zip, :phone, :email, :status, :emergency_contact_name,
                :emergency_contact_phone, :nationality, :language, :insurance_provider,
                :insurance_policy_number, :created_at, :updated_at
            )
            """
        )

        try:
            with engine.connect() as connection:
                connection.execute(insert_query, **patient_data)
            return {"message": "Patient created successfully"}, 201
        except SQLAlchemyError as e:
            logging.error(f"Error creating patient: {e}")
            return {"message": "Error creating patient"}, 500

class PatientsByDoctorsResource(Resource):
    # def get(self, clinic_id, doctor_id):
    #     # Securely query the database to get all patients for the specified doctor and clinic
    #     query = text("""
    #         SELECT p.* FROM patients p
    #         JOIN appointments a ON p.id = a.patient_id
    #         JOIN schedules s ON a.schedule_id = s.id
    #         WHERE s.doctor_id = :doctor_id AND p.clinic_id = :clinic_id
    #     """)
    #     with engine.connect() as connection:
    #         result = connection.execute(query, {"doctor_id": doctor_id, "clinic_id": clinic_id})
    #         patients = [dict(row) for row in result]
    #     return {"patients": patients}, 200

    def get(self):
        pass
    
    def post(self):
        patient_data = request.get_json()


        insert_query = text(
            """
            INSERT INTO patients (
                first_name, last_name, picture, date_of_birth, gender, address, address_number,
                address_complement, zip, phone, email, status, emergency_contact_name,
                emergency_contact_phone, nationality, language, insurance_provider,
                insurance_policy_number, created_at, updated_at
            ) VALUES (
                :first_name, :last_name, :picture, :date_of_birth, :gender, :address, :address_number,
                :address_complement, :zip, :phone, :email, :status, :emergency_contact_name,
                :emergency_contact_phone, :nationality, :language, :insurance_provider,
                :insurance_policy_number, :created_at, :updated_at
            )
            """
        )

        try:
            with engine.connect() as connection:
                connection.execute(insert_query, **patient_data)
            return {"message": "Patient created successfully"}, 201
        except SQLAlchemyError as e:
            logging.error(f"Error creating patient: {e}")
            return {"message": "Error creating patient"}, 500