from datetime import datetime
import hashlib
import simplejson as json

from flask import request, Response
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
        care_link_id = request.args.get("care_link_id")
        if not care_link_id:
            return Response(json.dumps({"error": "Care Link ID is required."}), status=400, mimetype='application/json')
        
        query = """
                SELECT * FROM medical_records
                WHERE care_link_id = :care_link_id
                """
        try:
            with engine.connect() as conn:
                result = conn.execute(text(query), care_link_id=care_link_id)
                records = [dict(row) for row in result]
            return Response(json.dumps({"records": records}, default=str), status=200, mimetype='application/json')
        except Exception as e:
            return Response(json.dumps({"error": f"Failed to retrieve records: {str(e)}"}), status=500, mimetype='application/json')



    
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

        # Prepare the data for insertion
        input_data.setdefault("appointment_id", None)  # Default to NULL if not provided
        input_data.setdefault("pdf_file", None)       # Default to NULL if not provided

        # Ensure pdf_file is a string or None
        if isinstance(input_data["pdf_file"], dict):
            input_data["pdf_file"] = None

        hash_input = f"{input_data['care_link_id']}_{datetime.now().isoformat()}"
        input_data["hash"] = hashlib.sha256(hash_input.encode()).hexdigest()

        print("=====================================================================================================")
        print(input_data)
        print("=====================================================================================================")

        # SQL query for inserting a record into medical_records
        query = """
                INSERT INTO medical_records (anamnesis, evolution, care_link_id,
                                             appointment_id, diagnosis, pdf_file, hash)
                VALUES (:anamnesis, :evolution, :care_link_id,
                        :appointment_id, :diagnosis, :pdf_file, :hash)
                """

        try:
            # Insert the data into the database
            with engine.connect() as conn:
                conn.execute(text(query), **input_data)
            return {"message": "Record inserted successfully"}, 201
        except Exception as e:
            return {"error": f"Failed to insert medical record: {str(e)}"}, 500