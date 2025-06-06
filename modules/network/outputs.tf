output "ecs_task_public_ip" {
  value       = data.aws_network_interface.task_eni.public_ip
  description = "Public IP of the ECS Fargate task"
}