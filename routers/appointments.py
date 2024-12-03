from datetime import datetime, timedelta

from marshmallow import ValidationError, Schema, fields, post_dump
from flask import request
from flask_restful import Resource
from sqlalchemy import text  # Import text for raw SQL queries
from db import engine

class AppointmentQuerySchema(Schema):
    clinicId = fields.Int(required=True, 
                          error_messages={"required": "Clinic ID is required."})
    doctorId = fields.Int(required=False, 
                          error_messages={"required": "Doctor ID is required."})
    patientId = fields.Int(required=True)
    date = fields.Date(required=False, 
                       format='%Y-%m-%d', 
                       error_messages={"required": "Date is required in YYYY-MM-DD format."})
    
    

class AppointmentsResource(Resource):
    def get(self):
        # Validate and extract query parameters using the schema
        schema = AppointmentQuerySchema()
        try:
            kwargs = schema.load(request.args)
        except ValidationError as err:
            return {"errors": err.messages}, 400  # Return validation errors if any

        # Retrieve appointments based on parameters from the API request
        appointments = self.retrieve(**kwargs)


        return {"appointments": appointments}, 200

    def retrieve(self, **kwargs):
        # Prepare the query and parameters
        base_query, query_filters = self._prepare_query(**kwargs)

        # Execute the query
        records = self._execute_query(base_query, query_filters)

        # Convert the datetime objects to strings
        return self._transform_records(records)

    def _prepare_query(self, **kwargs):
        """
        Prepares the SQL query and parameters based on the input arguments.
        """
        clinic_id = kwargs.get('clinicId')
        doctor_id = kwargs.get('doctorId')
        patient_id = kwargs.get('patientId')
        appointment_date = kwargs.get('date')

        # Base query
        query = """
            SELECT clinic_id, doctor_id, patient_id, patient_first_name, patient_last_name, appointment_date
            FROM appointment_search
            WHERE clinic_id = :clinic_id
              AND patient_id = :patient_id
        """

        # Query filters
        filters = {
            "clinic_id": clinic_id,
            "patient_id": patient_id,
        }

        # Add optional filters
        if doctor_id:
            query += " AND doctor_id = :doctor_id"
            filters["doctor_id"] = doctor_id
        if appointment_date:
            query += " AND DATE(appointment_date) = :appointment_date"
            filters["appointment_date"] = appointment_date

        # Final query ordering
        query += " ORDER BY appointment_date"

        return query, filters

    def _execute_query(self, query, filters):
        """
        Executes the SQL query with the provided parameters.
        """
        with engine.connect() as connection:
            result = connection.execute(text(query), filters)
            return [dict(row) for row in result]

    def _transform_records(self, records):
        """
        Transforms the query results into the desired format.
        """
        for record in records:
            if isinstance(record.get('appointment_date'), datetime):
                record['appointment_date'] = record['appointment_date'].isoformat()
        return records
