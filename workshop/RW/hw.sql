/* Question0*/
CREATE MATERIALIZED VIEW latest_dropoff_time AS
    WITH t AS (
        SELECT MAX(tpep_dropoff_datetime) AS latest_dropoff_time
        FROM trip_data
    )
    SELECT taxi_zone.Zone as taxi_zone, latest_dropoff_time
    FROM t,
            trip_data
    JOIN taxi_zone
        ON trip_data.DOLocationID = taxi_zone.location_id
    WHERE trip_data.tpep_dropoff_datetime = t.latest_dropoff_time;

/* Question1.1 Create MV:Create a materialized view to compute the average, min and max trip time between each taxi zone.

*/
CREATE MATERIALIZED VIEW trip_time_taxi_zone AS
    WITH t AS (
    SELECT 
        pulocationid,
        dolocationid,
        (tpep_dropoff_datetime - tpep_pickup_datetime) AS trip_time
    FROM 
        trip_data
)
    SELECT  
        taxi_zone_pu.Zone as pickup_taxi_zone, 
        taxi_zone_do.Zone as dropoff_taxi_zone,
        trip_time
    FROM t
    JOIN taxi_zone as taxi_zone_pu
        ON t.pulocationid = taxi_zone_pu.location_id
    JOIN taxi_zone as taxi_zone_do
        ON t.dolocationid = taxi_zone_do.location_id;

/* Question1.1 Answer*/
SELECT 
    pickup_taxi_zone, 
    dropoff_taxi_zone,
    AVG(trip_time) AS avg_trip_time,
    MAX(trip_time) AS max_trip_time,
    MIN(trip_time) AS min_trip_time
FROM 
    trip_time_taxi_zone
GROUP BY 
    pickup_taxi_zone, 
    dropoff_taxi_zone
ORDER BY 
    avg_trip_time DESC;


/* Question1.2 Create MV*/
CREATE MATERIALIZED VIEW trip_time_anomalies AS
WITH trip_stats AS (
    SELECT 
        pickup_taxi_zone,
        dropoff_taxi_zone,
        AVG(trip_time) AS avg_trip_time,
        MAX(trip_time) AS max_trip_time
    FROM 
        trip_time_taxi_zone
    GROUP BY 
        pickup_taxi_zone, 
        dropoff_taxi_zone
),
anomalies AS (
    SELECT 
        pickup_taxi_zone,
        dropoff_taxi_zone,
        avg_trip_time,
        max_trip_time,
        CASE 
            WHEN max_trip_time > avg_trip_time * 2 THEN 'High Anomaly'
            WHEN max_trip_time > avg_trip_time * 1.5 THEN 'Moderate Anomaly'
            ELSE 'No Anomaly' 
        END AS anomaly_type
    FROM 
        trip_stats
)
SELECT 
    pickup_taxi_zone,
    dropoff_taxi_zone,
    avg_trip_time,
    max_trip_time,
    anomaly_type
FROM 
    anomalies;


/* Question2 Create MV*/
SELECT 
    pickup_taxi_zone,
    dropoff_taxi_zone,
    COUNT(*) AS trip_count,
    AVG(trip_time) AS avg_trip_time
FROM 
    trip_time_taxi_zone
GROUP BY 
    pickup_taxi_zone,
    dropoff_taxi_zone
ORDER BY 
    avg_trip_time DESC;



/* Question3 Top3 Busiest*/
WITH latest_pickup_time AS (
    SELECT MAX(tpep_pickup_datetime) AS latest_time
    FROM trip_data
),
time_range AS (
    SELECT 
        latest_time - INTERVAL '17 hours' AS start_time,
        latest_time AS end_time
    FROM latest_pickup_time
),
pickup_counts AS (
    SELECT 
        t.pulocationid,
        COUNT(*) AS pickup_count
    FROM 
        trip_data t
    JOIN 
        taxi_zone tz ON t.pulocationid = tz.location_id
    WHERE 
        t.tpep_pickup_datetime BETWEEN (SELECT start_time FROM time_range) AND (SELECT end_time FROM time_range)
    GROUP BY 
        t.pulocationid
)
SELECT 
    tz.Zone,
    pc.pickup_count
FROM 
    pickup_counts pc
JOIN 
    taxi_zone tz ON pc.pulocationid = tz.location_id
ORDER BY 
    pc.pickup_count DESC;