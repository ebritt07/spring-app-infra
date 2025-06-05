# # NAT Gateway and EIP for private subnet outbound internet access
# resource "aws_eip" "nat" {
# }

# resource "aws_nat_gateway" "nat" {
#   allocation_id = aws_eip.nat.id
#   subnet_id     = aws_subnet.public[0].id

#   tags = {
#     Name = "spring-app-nat"
#   }
# }
# ### VPC and Subnets
# data "aws_availability_zones" "available" {
# }

# resource "aws_vpc" "main" {
#   cidr_block = "10.0.0.0/16"
# }

# resource "aws_subnet" "private" {
#   count             = var.az_count
#   cidr_block = cidrsubnet(aws_vpc.main.cidr_block, 8, count.index)
#   availability_zone = data.aws_availability_zones.available.names[count.index]
#   vpc_id            = aws_vpc.main.id
# }

# resource "aws_subnet" "public" {
#   count                   = var.az_count
#   cidr_block = cidrsubnet(aws_vpc.main.cidr_block, 8, var.az_count + count.index)
#   availability_zone       = data.aws_availability_zones.available.names[count.index]
#   vpc_id                  = aws_vpc.main.id
#   map_public_ip_on_launch = true
# }

# # Internet Gateway for the public subnet
# resource "aws_internet_gateway" "gw" {
#   vpc_id = aws_vpc.main.id
# }

# # Route the public subnet traffic through the IGW
# resource "aws_route" "internet_access" {
#   route_table_id         = aws_vpc.main.main_route_table_id
#   destination_cidr_block = "0.0.0.0/0"
#   gateway_id             = aws_internet_gateway.gw.id
# }

# ### VPC Route Table
# resource "aws_route_table" "private" {
#   vpc_id = aws_vpc.main.id

#   tags = {
#     Name = "spring-app-private-rt"
#   }
# }

# # Route outbound traffic from private subnet through the NAT gateway
# resource "aws_route" "private_nat" {
#   route_table_id         = aws_route_table.private.id
#   destination_cidr_block = "0.0.0.0/0"
#   nat_gateway_id         = aws_nat_gateway.nat.id
# }

# resource "aws_route_table_association" "private" {
#   count          = var.az_count
#   subnet_id      = aws_subnet.private[count.index].id
#   route_table_id = aws_route_table.private.id
# }

# ### ALB
# resource "aws_alb" "main" {
#   name    = "spring-app-load-balancer"
#   subnets = aws_subnet.public.*.id
#   security_groups = [aws_security_group.lb.id]
# }

# resource "aws_alb_target_group" "app" {
#   name        = "spring-app-target-group"
#   port        = 80
#   protocol    = "HTTP"
#   vpc_id      = aws_vpc.main.id
#   target_type = "ip"

#   health_check {
#     healthy_threshold   = "3"
#     interval            = "30"
#     protocol            = "HTTP"
#     matcher             = "200"
#     timeout             = "3"
#     path                = var.health_check_path
#     unhealthy_threshold = "2"
#   }
# }

# resource "aws_alb_listener" "front_end" {
#   load_balancer_arn = aws_alb.main.id
#   port              = var.app_port
#   protocol          = "HTTP"

#   default_action {
#     target_group_arn = aws_alb_target_group.app.id
#     type             = "forward"
#   }
# }

# ### Security Groups
# resource "aws_security_group" "lb" {
#   name        = "spring-app-lb-sg"
#   description = "Allow HTTP traffic to the ALB"
#   vpc_id      = aws_vpc.main.id

#   ingress {
#     from_port = var.app_port
#     to_port   = var.app_port
#     protocol  = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
# }

# resource "aws_security_group" "ecs_task_sg" {
#   name        = "spring-app-ecs-task-sg"
#   description = "Allow traffic from ALB to ECS tasks"
#   vpc_id      = aws_vpc.main.id

#   ingress {
#     from_port = var.app_port
#     to_port   = var.app_port
#     protocol  = "tcp"
#     security_groups = [aws_security_group.lb.id]
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
# }

# ### ECS Cluster
# resource "aws_ecs_cluster" "main" {
#   name = "spring-app-cluster"
# }

# resource "aws_iam_role" "ecs_task_execution_role" {
#   name = "ecsTaskExecutionRole"

#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Action = "sts:AssumeRole"
#         Effect = "Allow"
#         Principal = {
#           Service = "ecs-tasks.amazonaws.com"
#         }
#       }
#     ]
#   })
# }
# resource "aws_iam_role_policy_attachment" "ecs_task_execution_policy" {
#   role       = aws_iam_role.ecs_task_execution_role.name
#   policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
# }

# resource "aws_ecs_task_definition" "spring_app" {
#   family                   = "spring-app-task"
#   requires_compatibilities = ["FARGATE"]
#   network_mode             = "awsvpc"
#   cpu                      = var.fargate_cpu
#   memory                   = var.fargate_memory
#   execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn

#   container_definitions = jsonencode([
#     {
#       name  = "spring-app-container"
#       image = "${var.aws_account_id}.dkr.ecr.${var.region}.amazonaws.com/${var.spring_app_ecr_repo}:${var.spring_app_version}"
#       portMappings = [
#         {
#           containerPort = var.app_port
#           protocol      = "tcp"
#         }
#       ]
#     }
#   ])
# }
# resource "aws_ecs_service" "spring_app" {
#   name            = "spring-app-service"
#   cluster         = aws_ecs_cluster.main.id
#   task_definition = aws_ecs_task_definition.spring_app.arn
#   desired_count   = var.app_count
#   launch_type     = "FARGATE"

#   network_configuration {
#     subnets          = aws_subnet.private.*.id
#     security_groups = [aws_security_group.ecs_task_sg.id]
#     assign_public_ip = false
#   }

#   load_balancer {
#     target_group_arn = aws_alb_target_group.app.arn
#     container_name   = "spring-app-container"
#     container_port   = var.app_port
#   }

#   depends_on = [aws_iam_role.ecs_task_execution_role, aws_iam_role_policy_attachment.ecs_task_execution_policy]
# }