import logging
import simplejson as json
import random
import os
from werkzeug.utils import secure_filename

from marshmallow import Schema, fields, ValidationError, post_load
from flask_restful import Resource
from flask import request, Response, current_app as app
from sqlalchemy import text
from sqlalchemy.exc import SQLAlchemyError
from datetime import date, datetime

from db import engine
from helper_functions import create_care_link

def allowed_file(filename):
    return '.' in filename and filename.rsplit('.', 1)[1].lower() in app.config['ALLOWED_EXTENSIONS']

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
        # Check if the request is JSON or multipart/form-data
        if request.content_type.startswith('application/json'):
            patient_data = request.get_json()
        elif request.content_type.startswith('multipart/form-data'):
            patient_data = request.form.to_dict()
            file = request.files.get('picture')
            if file and allowed_file(file.filename):
                filename = secure_filename(file.filename)
                file.save(os.path.join(app.config['UPLOAD_FOLDER'], filename))
                patient_data['picture'] = filename
            else:
                patient_data['picture'] = None
        else:
            return {"error": "Unsupported Content-Type"}, 400

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


                ### THAT IS A WORKAROUND, SINCE I WAS NOT ABLE TO CHANGE THE CARE_LINK ID T
                care_link_id = random.randint(1, 2147483647)  # Suitable for a 32-bit integer ID

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
    

class PatientByIdResource(Resource):
    def get(self, patient_id):
        try:
            # Query to get the patient by ID
            query = """
                SELECT *
                FROM patients
                WHERE id = :patient_id
            """
            params = {"patient_id": patient_id}

            with engine.connect() as connection:
                result = connection.execute(text(query), params)
                patient = result.fetchone()

            if patient:
                return {"patient": self.serialize_row(dict(patient))}, 200
            else:
                return {"message": "Patient not found"}, 404
        except SQLAlchemyError as e:
            logging.error(f"Error retrieving patient: {e}")
            return {"message": "Error retrieving patient"}, 500

    @staticmethod
    def serialize_row(row):
        """
        Serialize a database row to make it JSON serializable.
        Converts DATE, DATETIME, and BYTES objects to ISO 8601 strings or decoded strings.
        """
        for key, value in row.items():
            if isinstance(value, (date, datetime)):
                row[key] = value.isoformat()
            elif isinstance(value, bytes):
                row[key] = value.decode('utf-8')
        return row
    
    def put(self, patient_id):
        patient_data = request.get_json()
        update_query = text(
            """
            UPDATE patients
            SET first_name = :first_name, last_name = :last_name, picture = :picture, date_of_birth = :date_of_birth,
                gender = :gender, address = :address, address_number = :address_number, address_complement = :address_complement,
                zip = :zip, phone = :phone, email = :email, status = :status, emergency_contact_name = :emergency_contact_name,
                emergency_contact_phone = :emergency_contact_phone, nationality = :nationality, language = :language,
                insurance_provider = :insurance_provider, insurance_policy_number = :insurance_policy_number, updated_at = :updated_at
            WHERE id = :patient_id
            """
        )
        patient_data["patient_id"] = patient_id
        patient_data["updated_at"] = datetime.utcnow()
        try:
            with engine.connect() as connection:
                result = connection.execute(update_query, **patient_data)
            if result.rowcount == 0:
                return {"message": "Patient not found"}, 404
            return {"message": "Patient updated successfully"}, 200
        except SQLAlchemyError as e:
            logging.error(f"Error updating patient: {e}")
            return {"message": "Error updating patient"}, 500


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
        

class CareLinkResource(Resource):
    def get(self):
        doctor_id = request.args.get("doctor_id")
        clinic_id = request.args.get("clinic_id")
        patient_id = request.args.get("patient_id")
        print("=====================================================================================================")
        print(doctor_id, clinic_id, patient_id)
        print("=====================================================================================================")

        if not doctor_id or not clinic_id or not patient_id:
            return {"message": "doctor_id, clinic_id, and patient_id are required"}, 400

        query = text("""
            SELECT * FROM care_link
            WHERE doctor_id = :doctor_id AND clinic_id = :clinic_id AND patient_id = :patient_id
        """)
        params = {
            "doctor_id": doctor_id,
            "clinic_id": clinic_id,
            "patient_id": patient_id
        }

        try:
            with engine.connect() as connection:
                result = connection.execute(query, params)
                care_link = result.fetchone()
                print(care_link)

            if care_link:
                return care_link["id"], 200
            else:
                return {"message": "Care link not found"}, 404
        except SQLAlchemyError as e:
            return {"message": f"Error retrieving care link: {str(e)}"}, 500

