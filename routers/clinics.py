import logging
from datetime import datetime

from marshmallow import Schema, fields, ValidationError, post_load
from flask import request
from flask_restful import Resource
from sqlalchemy import text
from sqlalchemy.exc import SQLAlchemyError

from db import engine

# class ClinicsSchema(Schema):
#     name = fields.Str(required=True)
#     address = fields.Str(required=True)
#     address_number = fields.Str(required=True)
#     address_complement = fields.Str(required=False)
#     zip = fields.Str(required=True)
#     city = fields.Str(required=True)
#     state = fields.Str(required=True)
#     country = fields.Str(required=True)
#     phone = fields.Str(required=True)
#     email = fields.Str(required=True)
#     website = fields.Str(required=False)
#     clinic_type = fields.Str(required=False)
#     user_id = fields.Int(required=False)
#     created_at = fields.DateTime(required=True) 

#     @post_load
#     def make_clinic(self, data, **kwargs):
#         return data
    

class ClinicsResource(Resource):
    def get(self):
        # Get query parameters
        clinic_id = request.args.get("clinic_id")
        user_id = request.args.get("user_id")

        try:
            # Start the base query
            query = "SELECT * FROM clinics"
            params = {}

            # Dynamically build WHERE conditions
            conditions = []
            if clinic_id:
                conditions.append("id = :clinic_id")
                params["clinic_id"] = clinic_id
            if user_id:
                conditions.append("user_id = :user_id")
                params["user_id"] = user_id

            # Add conditions to query if any exist
            if conditions:
                query += " WHERE " + " AND ".join(conditions)

            # Execute the query
            with engine.connect() as conn:
                result = conn.execute(text(query), params)
                clinics = [dict(row) for row in result]

                # Convert datetime objects to strings
                for clinic in clinics:
                    for key, value in clinic.items():
                        if isinstance(value, datetime):
                            clinic[key] = value.isoformat()

                if clinics:
                    return {"clinics": clinics}, 200
                else:
                    return {"message": "No clinics found"}, 404
        except Exception as e:
            logging.error(f"Error retrieving clinics: {e}")
            return {"message": "An unexpected error occurred"}, 500

    def post(self):
        clinic_data = request.get_json()

        # Add created_at field to clinic_data
        clinic_data["created_at"] = datetime.utcnow()

        insert_query = text(
            """
            INSERT INTO clinics (
                name, address, address_number, address_complement, zip, city, state, country,
                phone, email, website, clinic_type, user_id, created_at
            ) VALUES (
                :name, :address, :address_number, :address_complement, :zip, :city, :state, :country,
                :phone, :email, :website, :clinic_type, :user_id, :created_at
            )
            """
        )

        try:
            with engine.connect() as connection:
                connection.execute(insert_query, **clinic_data)
            return {"message": "Clinic created successfully"}, 201
        except SQLAlchemyError as e:
            logging.error(f"Error creating clinic: {e}")
            return {"message": "Error creating clinic"}, 500