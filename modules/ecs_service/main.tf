#          ███████ ███████ ██████  ██    ██ ██  ██████ ███████           
#          ██      ██      ██   ██ ██    ██ ██ ██      ██                
#█████     ███████ █████   ██████  ██    ██ ██ ██      █████       █████ 
#               ██ ██      ██   ██  ██  ██  ██ ██      ██                
#          ███████ ███████ ██   ██   ████   ██  ██████ ███████           
                                                                        
# Written by Christian Hamp                                                   
# Datum: 24.09.2024                                                                  

# Task Definition
resource "aws_ecs_task_definition" "alasco_taskdef" {
  family                   = "${var.name}-task"
  network_mode             = "bridge"
  requires_compatibilities = ["EC2"]
  cpu                      = "256"
  memory                   = "512"

  container_definitions = jsonencode([
    {
      name      = "ghost"
      image     = var.image
      cpu       = 256
      memory    = 512
      essential = true
      portMappings = [
        {
          containerPort = 2368
          hostPort      = 0
          protocol      = "tcp"
        }
      ]
    }
  ])

  tags = {
    Name = "${var.name}-task-def"
  }
}

# ECS Service
resource "aws_ecs_service" "alasco_service" {
  name            = "${var.name}-service"
  cluster         = var.cluster_id
  task_definition = aws_ecs_task_definition.alasco_taskdef.arn
  desired_count   = var.desired_count
  launch_type     = "EC2"

  #capacity_provider_strategy {
  #  capacity_provider = var.capacity_provider_name
  #  weight            = 1
  #  base              = 0
  #}

  deployment_minimum_healthy_percent = 100
  deployment_maximum_percent         = 200

  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = "ghost"
    container_port   = 2368
  }

  depends_on = [aws_ecs_task_definition.alasco_taskdef]

  tags = {
    Name = "${var.name}-service"
  }
}
