
##### USER DEFINED FUNCTIONS#######################
import psycopg2
import pandas as pd


## READ SQL TABLE TO PANDAS DF
def read_table_into_dataframe(table_name):
    

    # Establish connection parameters-- In this case for my AMBA database
    dbname = 'AMBA'
    user = 'postgres'
    password = 'Ferm1987'
    host = 'localhost'  # By default, localhost
    port = '5432'  # By default, 5432
    try:
        # Connect to the PostgreSQL database
        conn = psycopg2.connect(
            dbname=dbname,
            user=user,
            password=password,
            host=host,
            port=port
        )

        # Create a cursor object
        cursor = conn.cursor()

        # Execute a query to select data from the specified table
        query = f"SELECT * FROM {table_name};"
        cursor.execute(query)
        
        # Fetch all rows from the result set
        rows = cursor.fetchall()
        
        # Get the column names from the cursor description
        column_names = [desc[0] for desc in cursor.description]
        
        # Create a DataFrame from the fetched data and column names
        df = pd.DataFrame(rows, columns=column_names)

        return df

    except psycopg2.Error as e:
        print("Error connecting to PostgreSQL:", e)
        return None

    finally:
        # Close the cursor and connection
        if 'cursor' in locals() and cursor is not None:
            cursor.close()
        if 'conn' in locals() and conn is not None:
            conn.close()


