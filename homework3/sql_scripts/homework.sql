CREATE OR REPLACE EXTERNAL TABLE `taxi_ny_green_2022.green_taxi_tripdata_external`
OPTIONS (
  format = 'PARQUET',
  uris = ['gs://terraform-taxi-green-ny-2022-bucket/*.parquet']
);


SELECT count(*) FROM `taxi_ny_green_2022.green_taxi_tripdata_external`;

CREATE OR REPLACE TABLE `taxi_ny_green_2022.green_taxi_tripdata_internal`
AS SELECT * FROM `taxi_ny_green_2022.green_taxi_tripdata_external`;

SELECT COUNT(DISTINCT PULocationID) AS distinct_PULocationIDs_external
FROM `taxi_ny_green_2022.green_taxi_tripdata_external`;

SELECT COUNT(DISTINCT PULocationID) AS distinct_PULocationIDs_regular
FROM `taxi_ny_green_2022.green_taxi_tripdata_internal`;

SELECT COUNT(*)
FROM `taxi_ny_green_2022.green_taxi_tripdata_external`
WHERE fare_amount = 0;

-- BQ does not support partitioned by multiple columns and partition only date column
CREATE OR REPLACE TABLE `taxi_ny_green_2022.green_taxi_tripdata_parby_lpep_clusby_pu`
PARTITION BY DATE(lpep_pickup_datetime)
CLUSTER BY PUlocationID AS (
  SELECT * FROM `taxi_ny_green_2022.green_taxi_tripdata_external`
);

SELECT DISTINCT PULocationID
FROM `taxi_ny_green_2022.green_taxi_tripdata_internal`
WHERE lpep_pickup_datetime >= TIMESTAMP('2022-06-01')
  AND lpep_pickup_datetime < TIMESTAMP('2022-07-01');


SELECT DISTINCT PULocationID
FROM `taxi_ny_green_2022.green_taxi_tripdata_parby_lpep_clusby_pu`
WHERE lpep_pickup_datetime >= TIMESTAMP('2022-06-01')
  AND lpep_pickup_datetime < TIMESTAMP('2022-07-01');