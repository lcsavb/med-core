from flask_restful import Resource
from db import engine

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
    