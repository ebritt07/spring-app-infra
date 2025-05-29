variable "region" {
  type        = string
  default     = "us-east-1"
}

variable "bucket_name" {
  type        = string
  default     = "default-bucket"
}

variable "zip_path" {
  description = "path to store lambda zip files"
  type        = string
  default     = "zip_artifacts"
}

variable "s3_logger_lambda_name" {
  type        = string
  default     = "s3_logger"
}

variable "spring_app_ecr_repo" {
  description = "GitHub repo name to store"
  type        = string
  default     = "ebritt07/spring-app"
}