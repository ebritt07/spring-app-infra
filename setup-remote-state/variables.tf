variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "org_name" {
  description = "org name, prepended for things like S3 bucket names"
  type        = string
  default     = "ebritt07-org"
}