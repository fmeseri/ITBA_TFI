"""DOLAR API DAG- FMESERI"""
import json
from datetime import datetime
from time import sleep

import numpy as np
import pandas as pd
import requests
from airflow.models import DAG
from airflow.operators.email_operator import EmailOperator
from airflow.operators.python_operator import PythonOperator
from airflow.operators.postgres_operator import PostgresOperator
from symbol import parameters 


## --https://api.bluelytics.com.ar/v2/historical?day=2023-09-08
BASE_URL = 'https://api.bluelytics.com.ar/v2/historical?day='

CONNECTION_ID = 'postgres_workshop'
 # This is defined in Admin/Connections
SQL_TABLE = 'DolarHistorico'
SQL_CREATE = f"""
CREATE TABLE IF NOT EXISTS {SQL_TABLE} (
date TEXT,
ofAvg REAL,
ofSell REAL,
ofBuy REAL,
blueAvg REAL,
blueSell REAL,
blueBuy REAL,
UNIQUE(date)
)
"""
## --https://api.bluelytics.com.ar/v2/historical?day=2023-09-08
############# INSERT STATEMENT ###################
SQL_INSERT = f"""
INSERT INTO {SQL_TABLE} (
date,
ofAvg,
ofSell,
ofBuy,
blueAvg,
blueSell,
blueBuy
) VALUES ('{{ task_instance.xcom_pull(task_ids='get_dolar_data') }}')
"""
def _get_dolar_data( **context):
    date = f"{context['execution_date']:%Y-%m-%d}"  # read execution date from context
    end_point = (
        f"{BASE_URL}{date}"  ) ## --https://api.bluelytics.com.ar/v2/historical?day=2023-09-08
    print(f"Getting data from {end_point}...")
    r = requests.get(end_point)
    sleep(2)  # To avoid api limits
    data = json.loads(r.content)
    ##Iniciamos un dataframe con la fecha consultada
    d = {'date': [date]}
    df0= pd.DataFrame(data=d)
    ##Normalizamos el JSON de la respuesta del API into Dataframes
    df1= pd.DataFrame.from_dict(data['oficial'], orient='index').transpose()
    df2= pd.DataFrame.from_dict(data['blue'], orient='index').transpose()
     ## Renaming de columnas para fittear a la base de datos
    df1=df1.rename(columns={"value_avg": "ofAvg", "value_sell": "ofSell","value_buy":"ofBuy"})
    df2=df2.rename(columns={"value_avg": "blueAvg", "value_sell": "blueSell","value_buy":"blueBuy"})
    ## Joining la fecha 1x1 con  ambos 3x1  para tener un 7x1 con la fecha + 6 valores del día
    df3= pd.concat([df0, df1], axis=1, join='inner')
    df= pd.concat([df3, df2], axis=1, join='inner')
    ##Getting rid of numpy.float64 to int
    df=df.astype({'ofAvg': 'int','ofSell': 'int','ofBuy': 'int','blueAvg': 'int','blueSell': 'int','blueBuy': 'int'})
    lista=  tuple (df.loc[0, :].values.flatten().tolist())
    return lista
  
sql_insert="""INSERT INTO DolarHistorico (date,ofAvg,ofSell,ofBuy,blueAvg,blueSell,blueBuy)
     VALUES ('{{ task_instance.xcom_pull(task_ids='get_dolar_data') }}')"""
####-----------------------------------DAG ITSELF--------------------------------#######
default_args = {
    'owner': 'FM',
    'retries': 0,
    'start_date': datetime(2023, 8, 13),
    'email_on_failure': True,
    'email_on_retry': False,
    'email': ['fmeseri@gmail.com'],
}
with DAG('dolar_historico_V0', default_args=default_args, schedule_interval='0 12 * * *') as dag:
    create_table_if_not_exists = PostgresOperator(
        task_id='create_table_if_not_exists',
        sql=SQL_CREATE,
        postgres_conn_id=CONNECTION_ID,
    )
    get_dolar_data = PythonOperator(
        task_id='get_dolar_data',
        python_callable=_get_dolar_data,
        provide_context=True,
    )
    # INSERT USING SQL
    insert_into_postges = PostgresOperator(
        task_id='insert_into_postgres',
        sql= "INSERT INTO DolarHistorico (date,ofAvg,ofSell,ofBuy,blueAvg,blueSell,blueBuy) VALUES {{ task_instance.xcom_pull(task_ids='get_dolar_data') }}", 
        postgres_conn_id=CONNECTION_ID,
         autocommit=True,  # If the SQL query is an INSERT or similar operation
        provide_context=True,  # Allows access to the context
         )
    create_table_if_not_exists >> get_dolar_data >> insert_into_postges


