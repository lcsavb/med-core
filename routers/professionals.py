from flask_restful import Resource
from sqlalchemy import text
from db import engine

class ProfessionalsResource(Resource):
    def get(self, clinic_id):
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
                return dict(professional), 200
            else:
                return {"message": "Professional not found"}, 404