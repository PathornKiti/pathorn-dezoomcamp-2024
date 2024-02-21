CREATE TABLE  `qwiklabs-gcp-00-120faed25f8b.trips_data_all.fhv_tripdata` as
SELECT * FROM `bigquery-public-data.new_york_taxi_trips.tlc_fhv_trips_2019`; 


ALTER TABLE `qwiklabs-gcp-00-120faed25f8b.trips_data_all.green_tripdata`
  RENAME COLUMN vendor_id TO VendorID;
ALTER TABLE `qwiklabs-gcp-00-120faed25f8b.trips_data_all.green_tripdata`
  RENAME COLUMN pickup_datetime TO lpep_pickup_datetime;
ALTER TABLE `qwiklabs-gcp-00-120faed25f8b.trips_data_all.green_tripdata`
  RENAME COLUMN dropoff_datetime TO lpep_dropoff_datetime;
ALTER TABLE `qwiklabs-gcp-00-120faed25f8b.trips_data_all.green_tripdata`
  RENAME COLUMN rate_code TO RatecodeID;
ALTER TABLE `qwiklabs-gcp-00-120faed25f8b.trips_data_all.green_tripdata`
  RENAME COLUMN imp_surcharge TO improvement_surcharge;
ALTER TABLE `qwiklabs-gcp-00-120faed25f8b.trips_data_all.green_tripdata`
  RENAME COLUMN pickup_location_id TO PULocationID;
ALTER TABLE `qwiklabs-gcp-00-120faed25f8b.trips_data_all.green_tripdata`
  RENAME COLUMN dropoff_location_id TO DOLocationID;