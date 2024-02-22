CREATE OR REPLACE EXTERNAL TABLE `qwiklabs-gcp-04-210a8bc07b32.trips_data_all.fhv_tripdata`
OPTIONS (
  format = 'parquet',
  uris = ['gs://dbt-taxi-ny/fhv/fhv_tripdata_2019-*.parquet']
);