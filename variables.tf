variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-2"
}

variable "bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
  default     = "ebritt07-default-bucket-name"
}

variable "zip_path" {
  description = "path to store lambda zip files"
  type        = string
  default     = "zip_artifact"
}

variable "s3_logger_lambda_name" {
  description = "Name of the S3 logger Lambda function"
  type        = string
  default     = "s3_logger"
}