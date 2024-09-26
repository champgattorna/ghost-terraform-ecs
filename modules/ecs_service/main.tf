#          ███████ ███████ ██████  ██    ██ ██  ██████ ███████           
#          ██      ██      ██   ██ ██    ██ ██ ██      ██                
#█████     ███████ █████   ██████  ██    ██ ██ ██      █████       █████ 
#               ██ ██      ██   ██  ██  ██  ██ ██      ██                
#          ███████ ███████ ██   ██   ████   ██  ██████ ███████           
                                                                        
# Written by Christian Hamp                                                   
# Datum: 24.09.2024

# Task execution role
resource "aws_iam_role" "ecs_task_execution_role" {
  name = "${var.name}-ecs-task-execution-role"

  assume_role_policy = data.aws_iam_policy_document.ecs_task_execution_role_assume_role_policy.json
}

# Assume Role Policy Document
data "aws_iam_policy_document" "ecs_task_execution_role_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

# Policy for Cloudwatch Logs
resource "aws_iam_policy" "alasco_ecs_task_execution_logging" {
  name        = "${var.name}-ecs-task-execution-logging"
  description = "Allows ECS tasks to create log streams and put log events"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = [
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Resource = "arn:aws:logs:*:*:log-group:/ecs/*"
      }
    ]
  })
}

# Attach execution policies to role
resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# Attach logging policies to role
resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_logging" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = aws_iam_policy.alasco_ecs_task_execution_logging.arn
}


# Create Cloudwatch Log Group
resource "aws_cloudwatch_log_group" "alasco_ecs_task_log_group" {
  name              = "/ecs/${var.name}-logs"
  retention_in_days = 7
}

# Task Definition
resource "aws_ecs_task_definition" "alasco_taskdef" {
  family                   = "${var.name}-task"
  network_mode             = "bridge"
  requires_compatibilities = ["EC2"]
  runtime_platform  {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  container_definitions = <<TASK_DEFINITION
  [
  {
    "cpu": 256,
    "memory": 512,
    "environment": [
      {"name": "NODE_ENV", "value": "development"}
    ],
    "essential": true,
    "image": "ghost:latest",
    "name": "ghost",
    "portMappings": [
      {
        "containerPort": 2368,
        "hostPort": 0
      }
    ],
    "mountPoints": [
      {
        "sourceVolume": "efs",
        "containerPath": "/var/lib/ghost/content"
      }
    ],  
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-group": "/ecs/alasco-task-logs",
        "awslogs-region": "us-east-2",
        "awslogs-stream-prefix": "alasco-task"
      }
    }
  }
]
  TASK_DEFINITION
  volume {
    name = "efs"
    efs_volume_configuration {
      file_system_id = var.efs_id
      root_directory = "/"
    }
  }
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

