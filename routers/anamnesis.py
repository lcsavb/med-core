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

        if doctor_id:
            view = "medical_records_by_clinic_doctor_and_patient"
            query = f"""
                    SELECT * FROM {view}
                    WHERE clinic_id = :clinic_id
                      AND patient_id = :patient_id
                      AND doctor_id = :doctor_id
                    """
        else:
            view = "medical_records_by_clinic_and_patient"
            query = f"""
                    SELECT * FROM {view}
                    WHERE clinic_id = :clinic_id
                      AND patient_id = :patient_id
                    """   
        
        
        with engine.connect() as connection:
            result = connection.execute(text(query), clinic_id=clinic_id, patient_id=patient_id, doctor_id=doctor_id)
            return [dict(row) for row in result]
        
        return "No records found", 404
    
    def post(self):
        pass

    def put(self):
        pass


        

