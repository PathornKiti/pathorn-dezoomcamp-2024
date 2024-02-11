import os
import logging

import airflow
from airflow import DAG
#from airflow.utils.dates import days_ago
from airflow.operators.bash_operator import BashOperator
from airflow.operators.python import PythonOperator


from google.cloud import storage
from airflow.providers.google.cloud.operators.bigquery import BigQueryCreateExternalTableOperator
import pyarrow.parquet as pq

from operators import download_green_taxi_data,upload_to_gcs

#Getting the PROJECT_ID & GCP_GCS_BUCKET declared in 'docker-compose.yaml'
PROJECT_ID = os.environ.get("GCP_PROJECT_ID")
BUCKET = os.environ.get("GCP_GCS_BUCKET")


# Download url
base_url="https://d37ci6vzurychx.cloudfront.net/trip-data/green_tripdata_2022-{:02d}.parquet"
# Path to local home from "Dockerfile"
path_to_local_home = os.environ.get("AIRFLOW_HOME", "/opt/airflow/")


default_args = {
    "owner": "airflow",
    "start_date": airflow.utils.dates.days_ago(1),
    "depends_on_past": False,
    "retries": 1,
}

# DAG section

with DAG(
    dag_id="data_ingestion_gcs_dag",
    schedule_interval="@daily",
    default_args=default_args,
    catchup=False,
    max_active_runs=1,
    tags=['dtc-de'],
) as dag:

    download_operator_task = PythonOperator(
    task_id='download_green_taxi_data_task',
    python_callable=download_green_taxi_data,
    op_kwargs={'save_path': path_to_local_home}, 
    )   

    upload_operator_task = PythonOperator(
        task_id="local_to_gcs_task",
        python_callable=upload_to_gcs,
        op_kwargs={
            "bucket_name": BUCKET,
            "folder_path": path_to_local_home,
        },
    )



    download_operator_task >> upload_operator_task 