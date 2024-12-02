import logging
from datetime import datetime

from marshmallow import Schema, fields, ValidationError, post_load
from flask import request
from flask_restful import Resource
from sqlalchemy import text

from db import engine

class ClinicsSchema(Schema):
    name = fields.Str(required=True)
    address = fields.Str(required=True)
    address_number = fields.Str(required=True)
    address_complement = fields.Str(required=False)
    zip = fields.Str(required=True)
    city = fields.Str(required=True)
    state = fields.Str(required=True)
    country = fields.Str(required=True)
    phone = fields.Str(required=True)
    email = fields.Str(required=True)
    website = fields.Str(required=False)
    clinic_type = fields.Str(required=True)
    user_id = fields.Int(required=True)
    created_at = fields.DateTime(required=True) 

    @post_load
    def make_clinic(self, data, **kwargs):
        return data
    


class ClinicsResource(Resource):
    def get(self, clinic_id):
        # Query the database to get the clinic by its ID
        with engine.connect() as conn:
            result = conn.execute(f"SELECT * FROM clinics WHERE id = {clinic_id}")
            clinic = result.fetchone()
            if clinic:
                return dict(clinic), 200
            else:
                return {"message": "Clinic not found"}, 404
            
    def post(self):
        clinic_schema = ClinicsSchema()

        try:
            clinic_data = clinic_schema.load(request.get_json())
        except ValidationError as e:
            return {"message": e.messages}, 400

        insert_query = text("""
                INSERT INTO clinics (
                    name, address, address_number, address_complement, zip, city, state, country,
                    phone, email, website, clinic_type, user_id, created_at
                ) VALUES (
                    :name, :address, :address_number, :address_complement, :zip, :city, :state, :country,
                    :phone, :email, :website, :clinic_type, :user_id, :created_at
                )
                """)

        try:
            with engine.connect() as connection:
                connection.execute(insert_query, **clinic_data)
            return {"message": "Clinic created successfully"}, 201
        except Exception as e:
            logging.error(f"Error creating clinic: {e}")
            return {"message": "Error creating clinic"}, 500
    