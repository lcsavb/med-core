import mysql.connector
from mysql.connector import Error
import json

# Database connection
def get_db_connection():
    try:
        # Load database configuration from config.json
        with open('config.json', 'r') as f:
            config = json.load(f)
        db_config = config['database']
        
        connection = mysql.connector.connect(
            host=db_config['host'],
            port=db_config['port'],
            database=db_config['database'],
            user=db_config['user'],
            password=db_config['password']
        )
        if connection.is_connected():
            return connection
    except Error as e:
        print(f"Error connecting to MariaDB: {e}")
        return None
    except FileNotFoundError:
        print("config.json file not found.")
        return None