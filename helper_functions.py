from sqlalchemy import text
from db import engine




def create_care_link(id, doctor_id, clinic_id, patient_id):
    query = text(
        """
        INSERT INTO care_link (id, doctor_id, clinic_id, patient_id)
        VALUES (:id, :doctor_id, :clinic_id, :patient_id)
        """
    )

    with engine.connect() as connection:
        connection.execute(query, id=id, doctor_id=doctor_id, clinic_id=clinic_id, patient_id=patient_id)
        return {"message": "Patient linked successfully"}, 201