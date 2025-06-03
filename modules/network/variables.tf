
## Network Variables
variable "az_count" {
    description = "Number of AZs to cover in a given region"
    default = 2
}

variable "region" {
    default     = "us-east-1"
}

## ECS Variables

variable "app_count" {
    description = "Number of docker containers to run"
    default = 2
}

variable "health_check_path" {
  default = "/ping"
}

variable "fargate_cpu" {
    description = "Fargate instance CPU units to provision (1 vCPU = 1024 CPU units)"
    default = 512
}

variable "fargate_memory" {
    description = "Fargate instance memory to provision (in MiB)"
    default = 1024
}

variable "app_port" {
    description = "Port spring app will listen on"
    default = 8445
}

variable "spring_app_ecr_repo" {
  type        = string
}

variable "spring_app_version" {
  type        = string
}