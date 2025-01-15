from datetime import datetime
import hashlib

from flask import request, jsonify
from flask_restful import Resource
from marshmallow import ValidationError, Schema, fields
from sqlalchemy import text


from db import engine

class MedicalRecordInsertSchema(Schema):
    care_link_id = fields.Int(required=True, 
                              error_messages={"required": "Care Link ID is required."})
    anamnesis = fields.Str(required=False)
    evolution = fields.Str(required=False)
    appointment_id = fields.Int(required=False, allow_none=True)
    diagnosis = fields.Str(required=False)
    # TO DO PRESCRIPTION AND PDF
    pdf_file = fields.Str(required=False, allow_none=True)


    
class MedicalRecordResource(Resource):
    def get(self):
        pass
    
    def put(self):
        pass

    def post(self):
        # Parse the JSON input data
        try:
            input_data = request.get_json()
            if input_data is None:
                return {"error": "Invalid JSON or no data provided."}, 400
        except Exception as e:
            return {"error": f"Failed to parse JSON: {str(e)}"}, 400

        # Create schema instance
        schema = MedicalRecordInsertSchema()

        try:
            # Validate the input data
            validated_data = schema.load(input_data)
            validated_data.setdefault("appointment_id", None)  # Default to NULL if not provided
            validated_data.setdefault("pdf_file", None)       # Default to NULL if not provided

            hash_input = f"{validated_data['care_link_id']}_{datetime.now().isoformat()}"
            validated_data["hash"] = hashlib.sha256(hash_input.encode()).hexdigest()
        except ValidationError as err:
            # Return validation errors if any
            return{"errors": err.messages}, 400
        
        print(validated_data)
        

        # SQL query for inserting a record into medical_records
        # TO DO APPOINTMENT ID
        query = """
                INSERT INTO medical_records (anamnesis, evolution, care_link_id,
                                             appointment_id, diagnosis, pdf_file, hash)
                VALUES (:anamnesis, :evolution, :care_link_id,
                        :appointment_id, :diagnosis, :pdf_file, :hash)
                """

        # Insert the validated data into the database
        with engine.connect() as conn:
            conn.execute(text(query), **validated_data)

        return {"message": "Record inserted successfully"}, 200