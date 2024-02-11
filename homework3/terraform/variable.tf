variable "project" {
  description = "Project"
  default     = "xxxx"
}

variable "region" {
  description = "Region"
  #Update the below to your desired region
  default = "asia-southeast1-a"
}

variable "location" {
  description = "Project Location"
  #Update the below to your desired location
  default = "ASIA-SOUTHEAST1"
}

variable "gcs_bucket_name" {
  description = "My Storage Bucket Name"
  #Update the below to a unique bucket name
  default = "terraform-taxi-green-ny-2022-bucket"
}

variable "gcs_storage_class" {
  description = "Bucket Storage Class"
  default     = "STANDARD"
}

variable "credentials" {
  description = "My Credentials"
  default     = "xxxx"
}

variable "bq_dataset_name" {
  description = "My BigQuery Dataset Name"
  default     = "taxi_ny_green_2022"
}
