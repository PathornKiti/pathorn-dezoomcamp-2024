import pyarrow as pa
import pyarrow.parquet as pq
import os
if 'data_exporter' not in globals():
    from mage_ai.data_preparation.decorators import data_exporter

os.environ['GOOGLE_APPLICATION_CREDENTIALS']="/home/src/xxx.json"

bucket_name= 'gg_demo_dialog'
project_id= 'datacafeplayground'
table_name= 'ny_taxi_green'
root_path= f'{bucket_name}/{table_name}'


@data_exporter
def export_data(data, *args, **kwargs):
    table=pa.Table.from_pandas(data)

    gcs=pa.fs.GcsFileSystem()

    pq.write_to_dataset(
        table,
        root_path=root_path,
        partition_cols=['lpep_pickup_date'],
        filesystem=gcs
    )
    # Specify your data exporting logic here


