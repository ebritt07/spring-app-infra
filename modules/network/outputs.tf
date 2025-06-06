output "ecs_service_details" {
  value       = aws_ecs_service.spring_app
  description = "Full configuration of the ECS service"
}