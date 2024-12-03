import pytest
from flask import Flask
from flask_restful import Api
from routers.anamnesis import MedicalRecordResource
from app import create_app

@pytest.fixture
def app():
    app = create_app()
    app.config['TESTING'] = True
    return app

@pytest.fixture
def client(app):
    return app.test_client()

# Define the test cases
test_cases = [
    {
        "description": "No results",
        "query_string": {"clinicId": 1, "patientId": 2},
        "mock_retrieve_return_value": [],
        "expected_status": 200,
        "expected_response": {"medical_record_list": []}
    },
    {
        "description": "With results",
        "query_string": {"clinicId": 1, "patientId": 2, "doctorId": 3},
        "mock_retrieve_return_value": [
            {
                "medical_record_id": i,
                "patient_id": 2,
                "record_date": f"2024-11-17 00:00:00",
                "diagnosis": f"Diagnosis {i}",
                "anamnesis": f"Anamnesis {i}",
                "evolution": f"Evolution {i}",
                "pdf_file": None,
                "clinic_id": 1
            }
            for i in range(1, 6)
        ],
        "expected_status": 200,
        "expected_response": {
            "medical_record_list": [
                {
                    "medical_record_id": i,
                    "patient_id": 2,
                    "record_date": f"2024-11-17 00:00:00",
                    "diagnosis": f"Diagnosis {i}",
                    "anamnesis": f"Anamnesis {i}",
                    "evolution": f"Evolution {i}",
                    "pdf_file": None,
                    "clinic_id": 1
                }
                for i in range(1, 6)
            ]
        }
    },
    {
        "description": "Validation error",
        "query_string": {"clinicId": 1},
        "expected_status": 400,
        "expected_response": {"errors": {"patientId": ["Patient ID is required."]}}
    },
    {
        "description": "Database error",
        "query_string": {"clinicId": 1, "patientId": 2},
        "mock_retrieve_side_effect": Exception("Database error"),
        "expected_status": 500,
        "expected_response": {"message": "Database error"}
    }
]

@pytest.mark.parametrize("case", test_cases, ids=[case["description"] for case in test_cases])
def test_medical_records(client, mocker, case):
    # Mock the retrieve method if needed
    if "mock_retrieve_return_value" in case:
        mocker.patch('routers.anamnesis.MedicalRecordResource.retrieve', return_value=case["mock_retrieve_return_value"])
    elif "mock_retrieve_side_effect" in case:
        mocker.patch('routers.anamnesis.MedicalRecordResource.retrieve', side_effect=case["mock_retrieve_side_effect"])

    # Send a GET request to the /medical_records endpoint with the query parameters
    response = client.get('/api/medical-records', query_string=case["query_string"])

    # Assert the response status code and data
    assert response.status_code == case["expected_status"]
    assert response.json == case["expected_response"]