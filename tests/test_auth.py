import pytest
import os

from flask import Flask, jsonify
from flask_jwt_extended import JWTManager, create_access_token
from flask_restful import Api
from sqlalchemy.exc import IntegrityError

from app import create_app

@pytest.fixture
def app():
    os.environ['JWT_SECRET_KEY'] = 'your_jwt_secret_key'
    os.environ['SECRET_KEY'] = 'your_secret_key'
    app = create_app()
    app.config['TESTING'] = True
    return app

@pytest.fixture
def client(app):
    return app.test_client()

def test_verify_2fa_success(client, mocker):
    # Mock the get_jwt_identity function to return a valid user identity
    mocker.patch('auth.get_jwt_identity', return_value={
        "username": "testuser",
        "id": 1,
        "verification_code_hash": "$pbkdf2-sha256$29000$somehash"
    })

    # Mock the check_password_hash function to return True
    mocker.patch('auth.check_password_hash', return_value=True)

    # Mock the search_user_data function to return user data
    mocker.patch('auth.search_user_data', return_value={
        "id": 1,
        "name": "Test User",
        "roles": ["user"]
    })

    # Create a temporary token
    temporary_token = create_access_token(identity={
        "username": "testuser",
        "id": 1,
        "verification_code_hash": "$pbkdf2-sha256$29000$somehash"
    })

    # Send a POST request to the /verify-2fa endpoint with the temporary token and verification code
    response = client.post('/auth/verify-2fa', json={
        "verification_code": "123456"
    }, headers={
        "Authorization": f"Bearer {temporary_token}"
    })

    # Assert the response status code and message
    assert response.status_code == 200
    assert response.json['message'] == '2FA successful!'

def test_verify_2fa_invalid_code(client, mocker):
    # Mock the get_jwt_identity function to return a valid user identity
    mocker.patch('auth.get_jwt_identity', return_value={
        "username": "testuser",
        "id": 1,
        "verification_code_hash": "$pbkdf2-sha256$29000$somehash"
    })

    # Mock the check_password_hash function to return False
    mocker.patch('auth.check_password_hash', return_value=False)

    # Create a temporary token
    temporary_token = create_access_token(identity={
        "username": "testuser",
        "id": 1,
        "verification_code_hash": "$pbkdf2-sha256$29000$somehash"
    })

    # Send a POST request to the /verify-2fa endpoint with the temporary token and invalid verification code
    response = client.post('/auth/verify-2fa', json={
        "verification_code": "654321"
    }, headers={
        "Authorization": f"Bearer {temporary_token}"
    })

    # Assert the response status code and message
    assert response.status_code == 401
    assert response.json['message'] == 'Invalid verification code'

def test_register_success(client, mocker):
    # Mock the save_user_in_db function to simulate successful user registration
    mocker.patch('auth.save_user_in_db', return_value=None)
    # Send a POST request to the /register endpoint with valid user data
    response = client.post('/auth/register', json={
        "username": "newuser",
        "password": "password123",
        "email": "newuser@example.com",
        "name": "New User",
        "phone": "1234567890",
        "is_doctor": False
    })
    # Assert the response status code and message
    assert response.status_code == 201
    assert response.json['message'] == 'User registered successfully!'

def test_register_duplicate_username(client, mocker):
    # Mock the save_user_in_db function to raise an IntegrityError for duplicate username
    mocker.patch('auth.save_user_in_db', side_effect=IntegrityError(None, None, "1062"))
    # Send a POST request to the /register endpoint with a duplicate username
    response = client.post('/auth/register', json={
        "username": "existinguser",
        "password": "password123",
        "email": "existinguser@example.com",
        "name": "Existing User",
        "phone": "1234567890",
        "is_doctor": False
    })
    # Assert the response status code and message
    assert response.status_code == 400
    assert response.json['message'] == 'Username already taken!'

def test_register_integrity_error(client, mocker):
    # Mock the save_user_in_db function to raise a generic IntegrityError
    mocker.patch('auth.save_user_in_db', side_effect=IntegrityError(None, None, "Some integrity error"))
    # Send a POST request to the /register endpoint with valid user data
    response = client.post('/auth/register', json={
        "username": "newuser",
        "password": "password123",
        "email": "newuser@example.com",
        "name": "New User",
        "phone": "1234567890",
        "is_doctor": False
    })
    # Assert the response status code and message
    assert response.status_code == 500
    assert response.json['message'] == 'An integrity error occurred.'

def test_register_generic_error(client, mocker):
    # Mock the save_user_in_db function to raise a generic Exception
    mocker.patch('auth.save_user_in_db', side_effect=Exception("Some error"))
    # Send a POST request to the /register endpoint with valid user data
    response = client.post('/auth/register', json={
        "username": "newuser",
        "password": "password123",
        "email": "newuser@example.com",
        "name": "New User",
        "phone": "1234567890",
        "is_doctor": False
    })
    # Assert the response status code and message
    assert response.status_code == 500
    assert response.json['message'] == 'Error registering user.'