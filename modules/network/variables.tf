variable "region" {
  type = string
}

variable "app_count" {
  description = "Number of docker containers to run"
  default     = 2
}

variable "fargate_cpu" {
  description = "Fargate instance CPU units to provision (1 vCPU = 1024 CPU units)"
  default     = 512
}

variable "fargate_memory" {
  description = "Fargate instance memory to provision (in MiB)"
  default     = 1024
}

variable "app_port" {
  description = "Port spring app will listen on"
  default     = 8445
}

variable "spring_app_ecr_repo" {
  type = string
}

variable "spring_app_version" {
  type = string
}

variable "aws_account_id" {
  type = string
}

variable "service_name" {
  type = string
}