from datetime import datetime

from flask import request
from flask_restful import Resource
from marshmallow import ValidationError, Schema, fields
from sqlalchemy import text

from db import engine

class MedicalRecordQuerySchema(Schema):
    clinicId = fields.Int(required=True, 
                          error_messages={"required": "Clinic ID is required."})
    patientId = fields.Int(required=True, 
                           error_messages={"required": "Patient ID is required."})
    doctorId = fields.Int(required=False)

    
class MedicalRecordResource(Resource):
    def get(self):
        schema = MedicalRecordQuerySchema()

        try:
            args = schema.load(request.args)
        except ValidationError as err:
            return {"errors": err.messages}, 400
        
        clinic_id = args['clinicId']
        patient_id = args['patientId']
        doctor_id = args.get('doctorId')

        medical_record_list = []

        medical_record_list = self.retrieve(clinic_id, 
                                            patient_id, 
                                            doctor_id=doctor_id
                                            )
        
        return {"medical_record_list": medical_record_list}, 200
    
    def retrieve(self, clinic_id, patient_id, **kwargs):

        doctor_id = kwargs.get('doctor_id')

        query = """SELECT mr.*
                FROM medical_records mr
                JOIN care_link cl ON mr.care_link_id = cl.id
                WHERE cl.clinic_id = :clinic_id
                  AND cl.patient_id = :patient_id"""
        
        if doctor_id:
            query += " AND cl.doctor_id = :doctor_id;"
       
        
        with engine.connect() as connection:
            result = connection.execute(text(query), clinic_id=clinic_id, patient_id=patient_id, doctor_id=doctor_id)
            records = [dict(row) for row in result]

            # Convert datetime objects to strings
            for record in records:
                record['record_date'] = record['record_date'].strftime('%Y-%m-%d')
                record['created_at'] = record['created_at'].strftime('%Y-%m-%d %H:%M:%S')
            return records
                
        
        return "No records found", 404
    
    def post(self):
        pass

    def put(self, **kwargs):

        fields_to_update = ['anamnesis', 'evolution', 'doctor_id', 'clinic_id', 
                            'appointment_id', 'patient_id', 'diagnosis', 'prescription']
        update_data = {field: kwargs.get(field) for field in fields_to_update}

        query = """INSERT INTO medical_records (anamnesis, evolution, doctor_id, clinic_id,
                                                appointment_id, patient_id, diagnosis, prescription
                                                VALUES (:anamnesis, :evolution, :doctor_id, :clinic_id,
                                                :appointment_id, :patient_id, :diagnosis, :prescription)"""
        
        with engine.connect() as conn:
            conn.execute(text(query), **update_data)

        return "Record updated successfully", 200      