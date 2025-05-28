variable "bucket_name" {
  type = string
}

variable "lambda_arns" {
  description = "List of Lambda function ARNs to allow invocation from S3"
  type        = map(string)
}