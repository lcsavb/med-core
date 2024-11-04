from datetime import datetime

from marshmallow import ValidationError, Schema, fields
from flask import request
from flask_restful import Resource

from db import query

class AppointmentQuerySchema(Schema):
    clinicId = fields.Int(required=True, 
                          error_messages={"required": "Clinic ID is required."})
    doctorId = fields.Int(required=True, 
                          error_messages={"required": "Doctor ID is required."})
    patientId = fields.Int(required=False)
    date = fields.Date(required=True, 
                       format='%Y-%m-%d', 
                       error_messages={"required": "Date is required in YYYY-MM-DD format."})

from flask import request
from flask_restful import Resource
from datetime import datetime
from db import query  # Ensure this imports the modified query function

class AppointmentsResource(Resource):
    def get(self):
        # Define the expected query parameters
        clinic_id = 1
        healthcare_professional_id = 4
        appointment_date = '2024-10-31'

        # Retrieve appointments based on hardcoded criteria
        appointments = self.retrieve(
            clinic_id=clinic_id,
            healthcare_professional_id=healthcare_professional_id,
            appointment_date=datetime.strptime(appointment_date, '%Y-%m-%d').date()
        )

        # Convert datetime fields for JSON serialization
        for appointment in appointments:
            if isinstance(appointment['appointment_date'], datetime):
                appointment['appointment_date'] = appointment['appointment_date'].strftime('%Y-%m-%d %H:%M:%S')

        return {"appointments": appointments}, 200

    def retrieve(self, clinic_id, healthcare_professional_id, appointment_date):
        # Define the standard query
        base_query = """
            SELECT id, patient_id, schedule_id, medical_records_id, appointment_date, clinic_id, healthcare_professional_id
            FROM appointments
            WHERE clinic_id = :clinic_id
              AND healthcare_professional_id = :healthcare_professional_id
              AND DATE(appointment_date) = :appointment_date
            ORDER BY appointment_date
        """

        # Format parameters and execute the query
        params = {
            "clinic_id": clinic_id,
            "healthcare_professional_id": healthcare_professional_id,
            "appointment_date": appointment_date.strftime('%Y-%m-%d')
        }

        return query(base_query, **params)
