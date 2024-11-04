import os
from sqlalchemy import create_engine, text


engine = create_engine(
    f"mysql+pymysql://{os.getenv('MYSQL_USER')}:{os.getenv('MYSQL_PASSWORD')}@"
    f"{os.getenv('MYSQL_HOST', 'localhost')}:{os.getenv('MYSQL_PORT', 3306)}/"
    f"{os.getenv('MYSQL_DATABASE')}",
    pool_size=5,         # Pool size (same as before)
    max_overflow=10,     # Additional connections if the pool is full
    pool_timeout=30,     # Time to wait for a connection before raising an error
    pool_recycle=3600    # Recycle connections after 1 hour to avoid stale connections
)

def query(base_query, **params):
    """
    Executes an SQL query with the provided parameters.
    
    :param base_query: The base SQL query string with placeholders.
    :param params: Dictionary of parameters for the SQL query.
    :return: List of dictionaries representing the query result rows.
    """
    try:
        # Execute the query directly
        with engine.connect() as connection:
            query_text = text(base_query)
            result = connection.execute(query_text, params)

        # Return the result as a list of dictionaries
        return [dict(row) for row in result]

    except Exception as e:
        # Log any errors and return an empty list
        print("Error executing query:", e)
        return []


    


