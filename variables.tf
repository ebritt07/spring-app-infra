variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-2"
}

variable "org_name" {
  description = "Organization name"
  type        = string
  default     = "ebritt07"
}

variable "bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
  default     = "ebritt07-default-bucket-name"
}

variable "zip_path" {
  description = "path to store lambda zip files"
  type        = string
  default     = "zip_artifacts"
}

variable "s3_logger_lambda_name" {
  description = "Name of the S3 logger Lambda function"
  type        = string
  default     = "s3_logger"
}