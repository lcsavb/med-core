from sqlalchemy.exc import IntegrityError
from sqlalchemy.exc import SQLAlchemyError

from flask import jsonify, make_response
import logging
from error_messages import ErrorMessages  # Import from the new file

class ErrorHandler:
    """
    A class to handle and validate errors, including type conversions and database errors.
    """

    @staticmethod
    def handle_error(error):
        """
        Handles various types of errors and returns appropriate responses.

        :param error: The error to handle (either IntegrityError or generic Exception)
        :return: A response with the appropriate error message and status code.
        """
        if isinstance(error, IntegrityError):
            # Handle database integrity errors, e.g., duplicate entry
            error_message, status_code = ErrorHandler.handle_integrity_error(error)
        elif isinstance(error, SQLAlchemyError):
            error_message, status_code = ErrorHandler.handle_sql_error(error)
            
        else:
            # Handle unexpected or generic exceptions
            error_message, status_code = ErrorHandler.handle_unexpected_error(error)
        
        return make_response(jsonify({'message': error_message}), status_code)
    
    @staticmethod
    def handle_sql_error(error):
        """
        Handles any SQLAlchemy errors, including integrity errors, connection errors, etc.

        :param error: The SQLAlchemy error object.
        :return: A tuple containing the error message and the HTTP status code.
        """
        logging.error(f"SQLAlchemyError: {error}")
        
        # For all other SQLAlchemy errors, return a generic error message
        logging.error("A general SQLAlchemy error occurred")
        return ErrorMessages.SQL_ERROR, 500

    @staticmethod
    def handle_integrity_error(error):
        """
        Handles database integrity errors such as duplicate entries.

        :param error: The IntegrityError exception object.
        :return: A tuple containing the error message and the HTTP status code.
        """
        logging.error(f"IntegrityError: {error}")
        if error.orig.args[0] == 1062:  # MySQL duplicate entry error code
            logging.error("Duplicated entry detected")
            return ErrorMessages.DUPLICATE_ENTRY, 400
        return ErrorMessages.INTEGRITY_ERROR, 500

    @staticmethod
    def handle_unexpected_error(error):
        """
        Handles unexpected errors.

        :param error: The exception object.
        :return: A tuple containing the error message and the HTTP status code.
        """
        logging.error(f"Unexpected error: {error}")
        return ErrorMessages.UNEXPECTED_ERROR, 500

    @staticmethod
    def validate_conversion(value, target_type):
        """
        Validates if a value can be converted to the specified target type.
        Raises an error if conversion is not possible.
        
        :param value: The value to convert.
        :param target_type: The target type to validate conversion to.
        :return: The converted value if successful.
        :raises ValueError: If the conversion is not possible.
        """
        try:
            # Perform conversion based on the target type
            if target_type == str:
                return str(value)
            elif target_type == int:
                return int(value)
            elif target_type == float:
                return float(value)
            elif target_type == bool:
                if isinstance(value, str):  # Handle string "true"/"false" for boolean
                    return value.lower() in ["true", "1", "yes"]
                return bool(value)
            elif target_type == list:
                if isinstance(value, str):
                    return value.split(",")  # Example: Convert CSV strings to a list
                return list(value)
            elif target_type == dict:
                if isinstance(value, str):
                    import json
                    return json.loads(value)  # Convert JSON strings to dict
                return dict(value)
            else:
                raise ValueError(f"Unsupported target type: {target_type}")
        except (ValueError, TypeError, json.JSONDecodeError):
            raise ValueError(ErrorMessages.INVALID_CONVERSION.format(type(value).__name__, target_type.__name__))









