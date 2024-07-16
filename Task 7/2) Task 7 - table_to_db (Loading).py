# In this file, I am going to create table and insert data using the same columns and values present in transformed_data CSV file
# ------------------------------------------

# Importing required libraries
import psycopg2
from psycopg2 import sql
from psycopg2.extras import execute_values
import pandas as pd


# Loading data
transformed_data = pd.read_csv("transformed_data.csv")


# DB Credientials
hostname = ""
port_id = 
database = ""
username = ""
pwd = ""

conn = None
cur = None
table_name = "orderdetails"
columns = transformed_data.columns
datatype = transformed_data.dtypes

# Map transformed_data dtypes to PostgreSQL data types
dtype_mapping = {
    'int64': 'INTEGER',
    'float64': 'FLOAT',
    'object': 'TEXT',
    'datetime64[ns]': 'TIMESTAMP',
    'bool': 'BOOLEAN'
}

try:
    conn = psycopg2.connect(host = hostname,
                           dbname = database,
                           user = username,
                           password = pwd,
                           port = port_id)

    cur = conn.cursor()

    # Creating table in DB
    create_table_query = f"CREATE TABLE IF NOT EXISTS {table_name} ("
    for col, dtype in zip(columns, datatype):
        pg_type = dtype_mapping[str(dtype)]
        create_table_query += f"{col} {pg_type}, "
    create_table_query = create_table_query.rstrip(", ") + ");"

    cur.execute(create_table_query)

    # Inserting data into the table
    insert_query = sql.SQL(
        "INSERT INTO {table} ({fields}) VALUES %s").format(table=sql.Identifier(table_name),
                                                           fields=sql.SQL(', ').join(map(sql.Identifier, columns)))
    
    # Convert DataFrame to list of tuples
    data_tuples = [tuple(x) for x in transformed_data.to_numpy()]

    # Use psycopg2's execute_values to insert data
    execute_values(cur, insert_query.as_string(cur), data_tuples)

    conn.commit()

    print(f"Table {table_name} created and DataFrame loaded into PostgreSQL database.")


except Exception as error:
    print(error)


finally:
    if cur is not None:
        cur.close()
    
    if conn is not None:
        conn.close()