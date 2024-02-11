from google.cloud import storage
import requests
import os


def download_green_taxi_data(save_path):
    base_url = "https://d37ci6vzurychx.cloudfront.net/trip-data/green_tripdata_2022-{:02d}.parquet"
    for month in range(1, 13):
        url = base_url.format(month)
        filename = os.path.join(save_path, f"green_tripdata_2022_{month:02d}.parquet")
        response = requests.get(url)
        if response.status_code == 200:
            with open(filename, "wb") as file:
                file.write(response.content)
            print(f"Downloaded {filename}")
        else:
            print(f"Failed to download {filename}. Status code: {response.status_code}")


def upload_to_gcs(folder_path, bucket_name):

    storage.blob._MAX_MULTIPART_SIZE = 5 * 1024 * 1024  # 5 MB
    storage.blob._DEFAULT_CHUNKSIZE = 5 * 1024 * 1024  # 5 MB

    client = storage.Client()
    bucket = client.bucket(bucket_name)

    for file_name in os.listdir(folder_path):
        if file_name.endswith('.parquet'):
            blob = bucket.blob(file_name)
            blob.upload_from_filename(os.path.join(folder_path, file_name))
            print(f"Uploaded {file_name} to GCS")

