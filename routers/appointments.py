from flask_restful import Resource
from db import engine

class DoctorAppointmentsResource(Resource):
    def get(self, clinic_id, doctor_id, schedule_id):
        # Query the database to get all appointments for the specified doctor, schedule, and clinic
        with engine.connect() as connection:
            result = connection.execute(f"""
                SELECT * FROM appointments
                WHERE schedule_id = {schedule_id} AND doctor_id = {doctor_id} AND clinic_id = {clinic_id}
            """)
            appointments = [dict(row) for row in result]
        return {"appointments": appointments}, 200