from datetime import datetime, timedelta

from marshmallow import ValidationError, Schema, fields, post_dump
from flask import request
from flask_restful import Resource
from sqlalchemy import create_engine, text  # Import text for raw SQL queries
from db import engine

class AppointmentQuerySchema(Schema):
    clinicId = fields.Int(required=True, 
                          error_messages={"required": "Clinic ID is required."})
    doctorId = fields.Int(required=True, 
                          error_messages={"required": "Doctor ID is required."})
    patientId = fields.Int(required=False)
    date = fields.Date(required=True, 
                       format='%Y-%m-%d', 
                       error_messages={"required": "Date is required in YYYY-MM-DD format."})
    
    

class AppointmentsResource(Resource):
    def get(self):
        # Validate and extract query parameters using the schema
        schema = AppointmentQuerySchema()
        try:
            args = schema.load(request.args)
        except ValidationError as err:
            return {"errors": err.messages}, 400  # Return validation errors if any

        # Retrieve parameters
        clinic_id = args['clinicId']
        doctor_id = args['doctorId']
        appointment_date = args['date'].strftime('%Y-%m-%d')  # Convert to string for SQL query

        # Retrieve appointments based on parameters from the API request
        appointments = self.retrieve(clinic_id, doctor_id, appointment_date)

        # Convert datetime fields for JSON serialization if needed

        # Convert datetime fields for JSON serialization
        # I have to improve that later 
        for appointment in appointments:
            # Convert timedelta to a time string in HH:MM format
            if isinstance(appointment['time'], timedelta):
                total_seconds = int(appointment['time'].total_seconds())
                hours, remainder = divmod(total_seconds, 3600)
                minutes, _ = divmod(remainder, 60)
                appointment['time'] = f"{hours:02}:{minutes:02}"  # Format as HH:MM

        return {"appointments": appointments}, 200

    def retrieve(self, clinic_id, doctor_id, appointment_date):
        # Define the SQL query using raw SQL
        base_query = """
        SELECT id, patient_id, schedule_id, medical_records_id, time, clinic_id, doctor_id,
               first_name, last_name, picture, gender, address, address_number,
               address_complement, zip, phone, email
        FROM vw_app2  -- Using the view
        WHERE clinic_id = :clinic_id
          AND doctor_id = :doctor_id
          AND day = :appointment_date  -- Filter using 'day'
        ORDER BY day  -- Ordering by 'day'
    """
    
        # Execute the query
        with engine.connect() as connection:
            result = connection.execute(text(base_query), {
                "clinic_id": clinic_id,
                "doctor_id": doctor_id,
                "appointment_date": appointment_date  # Ensure this matches the 'day' column
            })
    
            # Fetch all results
            appointments = [dict(row) for row in result]
    
        return appointments

