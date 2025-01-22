from sqlalchemy import text
from Sqlalchemy import engine



def create_care_link(doctor_id, clinic_id, patient_id):
    query = text(
        """
        INSERT INTO care_link (doctor_id, clinic_id, patient_id)
        VALUES (:doctor_id, :clinic_id, :patient_id)
        """
    )

    with engine.connect() as connection:
        connection.execute(query, doctor_id=doctor_id, clinic_id=clinic_id, patient_id=patient_id)
        return {"message": "Patient linked successfully"}, 201