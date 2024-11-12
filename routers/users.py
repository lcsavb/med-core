from flask_restful import Resource
from flask import request, jsonify
from sqlalchemy.sql import text
from db import engine
from models import User

class UserResource(Resource):
    def get(self):
        """This method returns the roles of a specific user."""
        user_id = request.args.get('id')
        if not user_id:
            return jsonify({"error": "User ID is required"}), 400

        query = text("SELECT roles FROM users WHERE id = :id")
        result = engine.execute(query, {"id": user_id})
        user_data = result.fetchone()

        if not user_data:
            return jsonify({"error": "User not found"}), 404

        roles_json = user_data[0]
        roles = roles_json.split(",") if roles_json else []

        return jsonify({"roles": roles})

    def put(self):
        """This method updates the roles of a specific user."""
        user_id = request.args.get('id')
        if not user_id:
            return jsonify({"error": "User ID is required"}), 400

        data = request.get_json()
        if not data or "roles" not in data:
            return jsonify({"error": "Roles data is required"}), 400

        roles = data["roles"]
        if not isinstance(roles, list):
            return jsonify({"error": "Roles must be a list"}), 400

        roles_json = ",".join(roles)
        query = text("UPDATE users SET roles = :roles WHERE id = :id")
        engine.execute(query, {"roles": roles_json, "id": user_id})

        return jsonify({"message": "User roles updated successfully"})