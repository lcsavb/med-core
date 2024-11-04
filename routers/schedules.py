from flask_restful import Resource
from db import engine

class DoctorScheduleResource(Resource):
    def get(self, clinic_id, doctor_id):
        # Query the database to get all schedules for the specified doctor and clinic
        with engine.connect() as connection:
            result = connection.execute(f"SELECT * FROM schedules WHERE doctor_id = {doctor_id} AND clinic_id = {clinic_id}")
            schedules = [dict(row) for row in result]
        return {"schedules": schedules}, 200