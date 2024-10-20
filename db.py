import mysql.connector
from mysql.connector import Error
import os
from functools import wraps


# Database connections
def get_db_connection():
    try:
                
        connection = mysql.connector.connect(
        host=os.getenv('MYSQL_HOST', 'localhost'),
        port=int(os.getenv('MYSQL_PORT', 3306)),  # Note: convert port to int
        database=os.getenv('MYSQL_DATABASE'),
        user=os.getenv('MYSQL_USER'),
        password=os.getenv('MYSQL_PASSWORD')
    )
        if connection.is_connected():
            return connection
    except Error as e:
        print(f"Error connecting to MariaDB: {e}")
        return None
    except FileNotFoundError:
        print("config.json file not found.")
        return None
    

def atomic_transaction(f):
    @wraps(f)
    def decorated_function(*args, **kwargs):
        conn = get_db_connection()
        if not conn:
            raise RuntimeError("Failed to get a database connection")
        
        cursor = None
        try:
            cursor = conn.cursor()
            conn.start_transaction()  # Start transaction

            result = f(conn, cursor, *args, **kwargs)  # Call the decorated function

            conn.commit()  # Commit transaction if everything is okay
            return result
        except Error as e:
            conn.rollback()  # Rollback transaction on failure
            raise RuntimeError(f"Transaction failed: {e}")
        finally:
            if cursor:
                cursor.close()
            if conn:
                conn.close()
    return decorated_function
