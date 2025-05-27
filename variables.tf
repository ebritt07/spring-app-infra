variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-2"
}

variable "org_name" {
  description = "org name, prepended for things like S3 bucket names"
  type        = string
  default     = "ebritt07-org"
}

variable "bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
  default     = "${var.org_name}-default-bucket"
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