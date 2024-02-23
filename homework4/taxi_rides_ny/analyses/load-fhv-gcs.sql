CREATE OR REPLACE EXTERNAL TABLE `qwiklabs-gcp-01-8f42f7c0126c.trips_data_all.fhv_tripdata`
OPTIONS (
  format = 'parquet',
  uris = ['gs://dbt-taxi-ny/fhv/fhv_tripdata_2019-*.parquet']
);

CREATE OR REPLACE TABLE `qwiklabs-gcp-01-8f42f7c0126c.trips_data_all.fhv_tripdata` AS
SELECT
    *
FROM
    `qwiklabs-gcp-01-8f42f7c0126c.trips_data_all.fhv_external_tripdata`;