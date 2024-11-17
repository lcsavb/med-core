import pytest
from datetime import timedelta

from flask import Flask, request
from flask_restful import Api
from unittest.mock import patch
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

def test_get_medical_records_no_results(client, mocker):
    # Mock the retrieve method to return an empty list
    mocker.patch('routers.anamnesis.MedicalRecordResource.retrieve', return_value=[])

    # Send a GET request to the /medical_records endpoint with valid query parameters
    response = client.get('/api/medical-records', query_string={
        "clinicId": 1,
        "patientId": 2
    })

    # Assert the response status code and data
    assert response.status_code == 200
    assert response.json == {"medical_record_list": []}

def test_get_medical_records_with_results(client, mocker):
    # Define a mock list of 10 medical records based on your schema
    mock_medical_records = [
        {
            "medical_record_id": i,
            "patient_id": 2,
            "record_date": f"2024-11-17 00:00:00",
            "diagnosis": f"Diagnosis {i}",
            "anamnesis": f"Anamnesis {i}",
            "evolution": f"Evolution {i}",
            "pdf_file": None,  # Assuming no file for simplicity
            "clinic_id": 1
        }
        for i in range(1, 11)  # Generate 10 records
    ]

    # Mock the retrieve method to return the mock records
    mocker.patch('routers.anamnesis.MedicalRecordResource.retrieve', return_value=mock_medical_records)

    # Send a GET request to the /medical_records endpoint with valid query parameters
    response = client.get('/api/medical-records', query_string={
        "clinicId": 1,
        "patientId": 2
    })

    # Assert the response status code and data
    assert response.status_code == 200
    assert response.json == {"medical_record_list": mock_medical_records}

def test_get_medical_records_database_error(client, mocker):
    # Mock the retrieve method to raise an exception
    mocker.patch('routers.anamnesis.MedicalRecordResource.retrieve', side_effect=Exception("Database error"))

    # Send a GET request to the /medical_records endpoint with valid query parameters
    response = client.get('/api/medical-records', query_string={
        "clinicId": 1,
        "patientId": 2
    })

    # Assert the response status code and error message
    assert response.status_code == 500
    assert response.json == {"message": "Database error"}

def test_get_medical_records_with_doctor_id(client, mocker):
    # Define a mock list of 5 medical records based on your schema
    mock_medical_records = [
        {
            "medical_record_id": i,
            "patient_id": 2,
            "record_date": f"2024-11-17 00:00:00",
            "diagnosis": f"Diagnosis {i}",
            "anamnesis": f"Anamnesis {i}",
            "evolution": f"Evolution {i}",
            "pdf_file": None,  # Assuming no file for simplicity
            "clinic_id": 1
        }
        for i in range(1, 6)  # Generate 5 records
    ]

    # Mock the retrieve method to return the mock records
    mocker.patch('routers.anamnesis.MedicalRecordResource.retrieve', return_value=mock_medical_records)

    # Send a GET request to the /medical_records endpoint with valid query parameters
    response = client.get('/api/medical-records', query_string={
        "clinicId": 1,
        "patientId": 2,
        "doctorId": 3
    })

    # Assert the response status code and data
    assert response.status_code == 200
    assert response.json == {"medical_record_list": mock_medical_records}

def test_get_medical_records_validation_error(client):
    # Send a GET request to the /medical_records endpoint with missing required parameters
    response = client.get('/api/medical-records', query_string={
        "clinicId": 1
    })

    # Assert the response status code and error message
    assert response.status_code == 400
    assert "errors" in response.json
    assert "patientId" in response.json["errors"]