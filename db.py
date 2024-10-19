import mysql.connector
from mysql.connector import Error
import os


# Database connection
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