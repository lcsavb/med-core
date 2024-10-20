from mysql.connector import Error
from functools import wraps
from flask import logging
import mysql.connector.pooling
import os


pool = mysql.connector.pooling.MySQLConnectionPool(
    pool_name="mypool",
    pool_size=5,
    pool_reset_session=True,
    host=os.getenv('MYSQL_HOST', 'localhost'),
    port=int(os.getenv('MYSQL_PORT', 3306)),
    database=os.getenv('MYSQL_DATABASE'),
    user=os.getenv('MYSQL_USER'),
    password=os.getenv('MYSQL_PASSWORD')
)

# Database connections
def get_db_connection():
    """Get a connection from the connection pool."""
    try:
        connection = pool.get_connection()  # Retrieve a connection from the pool
        return connection
    except mysql.connector.Error as e:
        logging.error(f"Error getting connection from pool: {e}")
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
