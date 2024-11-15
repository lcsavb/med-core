import logging
import os

from flask import Flask, jsonify
from flask_restful import Api
from flask_limiter.errors import RateLimitExceeded
from flask_jwt_extended import JWTManager, create_access_token, get_jwt_identity, jwt_required


from auth import LoginResource, RegisterResource, LogoutResource, StatusResource, ProtectedResource, Verify2FAResource
from routers.clinics import ClinicsResource
from routers.clinics import ClinicsResource
from routers.professionals import ProfessionalsResource, ProfessionalByIdResource
from routers.patients import PatientsResource, PatientsByDoctorsResource
from routers.schedules import DoctorScheduleResource
from routers.appointments import AppointmentsResource
from logging_config import configure_logging
from rate_limit import limiter


configure_logging()

def create_app():
    # Flask application initialization
    app = Flask(__name__)
    api = Api(app)
    app.config["JWT_SECRET_KEY"] = os.environ.get("JWT_SECRET_KEY")  # Change this!
    app.config["SECRET_KEY"] = os.environ.get("SECRET_KEY")  # Change this!
    jwt = JWTManager(app)

    # Resources
    api.add_resource(LoginResource, '/auth/login')
    api.add_resource(RegisterResource, '/auth/register')
    api.add_resource(LogoutResource, '/auth/logout')
    api.add_resource(StatusResource, '/auth/status')
    api.add_resource(ProtectedResource, '/auth/protected')
    api.add_resource(Verify2FAResource, '/auth/verify-2fa')
    api.add_resource(ClinicsResource, '/api/clinics/<int:clinic_id>')
    api.add_resource(ProfessionalsResource, '/api/clinics/<int:clinic_id>/doctors')
    api.add_resource(ProfessionalByIdResource, '/api/clinics/<int:clinic_id>/doctors/<int:healthcare_professional_id>')
    api.add_resource(PatientsResource, '/api/clinics/<int:clinic_id>/patients')
    api.add_resource(PatientsByDoctorsResource, '/api/clinics/<int:clinic_id>/doctors/<int:healthcare_professional_id>/patients')
    api.add_resource(DoctorScheduleResource, '/api/clinics/<int:clinic_id>/doctors/<int:healthcare_professional_id>/schedules')
    api.add_resource(AppointmentsResource, '/api/appointments/')

    return app

app = create_app()

# Rate limiter initialization and configuration to prevent abuse and brute force attacks
limiter.init_app(app)

# Error handler for rate limit exceeded
@app.errorhandler(RateLimitExceeded)
def rate_limit_handler(e):
    return jsonify({'message': 'Rate limit exceeded. Please try again later.'}), 429

# Secret key for session management
app.secret_key = os.environ.get("SECRET_KEY", "default-secret-key")



if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True, use_reloader=True)
