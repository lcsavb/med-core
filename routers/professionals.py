from datetime import datetime

from flask_restful import Resource
from flask import jsonify, request
from sqlalchemy import text
from db import engine

class ProfessionalsResource(Resource):
    def get(self):

        clinic_id = request.args.get("clinic_id")
        if not clinic_id:
            return {"message": "Clinic ID is required"}, 400
        
        # Securely query the database to get all professionals for the specified clinic
        query = text("""
            SELECT hp.* FROM healthcare_professionals hp
            JOIN clinics c ON hp.clinic_id = c.id
            WHERE c.id = :clinic_id
        """)
        with engine.connect() as connection:
            result = connection.execute(query, {"clinic_id": clinic_id})
            professionals = [dict(row) for row in result]
        return {"professionals": professionals}, 200

class ProfessionalByIdResource(Resource):
    def get(self, clinic_id, healthcare_professional_id):
        # Securely query the database to get the professional by its ID and clinic ID
        query = text("""
            SELECT hp.* FROM healthcare_professionals hp
            JOIN clinics c ON hp.clinic_id = c.id
            WHERE c.id = :clinic_id AND hp.id = :healthcare_professional_id
        """)
        with engine.connect() as connection:
            result = connection.execute(query, {"clinic_id": clinic_id, "healthcare_professional_id": healthcare_professional_id})
            professional = result.fetchone()

            if professional:
                # This is necessary because the datetime object is not serializable
                # BUT IT IS NOT EFFICIENT, THE PLAN IS TO CREATE A VIEW IN THE DATABASE
                professional_dict = {column: (value.strftime("%Y-%m-%d %H:%M:%S") if isinstance(value, datetime) else value)
                                     for column, value in professional.items()}
                return professional_dict, 200
            else:
                return {"message": "Professional not found"}, 404
