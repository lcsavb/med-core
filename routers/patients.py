import logging
import simplejson as json
import random

from marshmallow import Schema, fields, ValidationError, post_load
from flask_restful import Resource
from flask import request, Response
from sqlalchemy import text
from sqlalchemy.exc import SQLAlchemyError
from datetime import date, datetime

from db import engine
from helper_functions import create_care_link


class PatientsResource(Resource):
    def get(self):
        clinic_id = request.args.get("clinic_id")
        doctor_id = request.args.get("doctor_id")

        if not clinic_id:
            return {"message": "Clinic ID is required"}, 400

        try:
            # Base query for patients linked to the specified clinic
            query = """
                SELECT patients.*
                FROM patients
                JOIN care_link AS cl ON patients.id = cl.patient_id
                WHERE cl.clinic_id = :clinic_id
            """
            params = {"clinic_id": clinic_id}

            if doctor_id:
                # Add doctor_id condition if provided
                query += " AND cl.doctor_id = :doctor_id"
                params["doctor_id"] = doctor_id

            with engine.connect() as connection:
                result = connection.execute(text(query), params)
                patients = [dict(row) for row in result]  # Convert rows to dictionaries

            # Return the patients list as a JSON response
                return Response(json.dumps({"patients": patients}, default=str), mimetype='application/json')

        
        except Exception as e:
            return {"message": f"An error occurred: {str(e)}"}, 500


    

    def post(self):
        patient_data = request.get_json()

        clinic_id = patient_data.get("clinic_id")
        doctor_id = patient_data.get("doctor_id")
        
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
                result = connection.execute(insert_query, **patient_data)
                patient_id = result.lastrowid  # Retrieve the last inserted patient ID

                # generate a random care_link id


                ### THAT IS A WORKAROUND, SINCE I WAS NOT ABLE TO CHANGE THE CARE_LINK ID TO AUTO INCREMENT
                care_link_id = random.randint(100000, 999999)

                create_care_link(care_link_id, doctor_id, clinic_id, patient_id)

            return {"message": "Patient created successfully"}, 201
        except SQLAlchemyError as e:
            logging.error(f"Error creating patient: {e}")
            return {"message": "Error creating patient"}, 500
        
    @staticmethod
    def serialize_row(row):
        """
        Serialize a database row to make it JSON serializable.
        Converts DATE and DATETIME objects to ISO 8601 strings.
        """
        for key, value in row.items():
            if isinstance(value, (date, datetime)):
                row[key] = value.isoformat()
        return row

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