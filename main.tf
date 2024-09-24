provider "aws" {
  region = "us-east-1"
}

# VPC Definition
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.0"
  name = "alasco-ghost-vpc"
  cidr = "10.0.0.0/16"
  public_subnets  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets = ["10.0.3.0/24", "10.0.4.0/24"]
}

# ECS Cluster
resource "aws_ecs_cluster" "alasco-ghost_cluster" {
  name = "alasco-ghost-ec2-cluster"
}

# Launch Configuration for EC2
resource "aws_launch_configuration" "alasco-ecs_instance" {
  image_id      = data.aws_ami.amazon_linux.id
  instance_type = "t2.micro"
  user_data     = <<EOF
#!/bin/bash
echo ECS_CLUSTER=${aws_ecs_cluster.alasco-ghost_cluster.name} >> /etc/ecs/ecs.config
EOF
}

# Auto Scaling Group for EC2 instances
resource "aws_autoscaling_group" "alasco-ecs_asg" {
  launch_configuration = aws_launch_configuration.ecs_instance.id
  min_size = 1
  max_size = 2
  desired_capacity = 1
  vpc_zone_identifier = module.vpc.public_subnets
}

# Application Load Balancer
resource "aws_lb" "alasco-ghost_alb" {
  load_balancer_type = "application"
  subnets            = module.vpc.public_subnets
}

# ECS Service
resource "aws_ecs_service" "alasco-ghost_ecs_service" {
  name = "ghost-service"
  cluster = aws_ecs_cluster.alasco-ghost_cluster.id
  task_definition = aws_ecs_task_definition.alasco-ghost_task_def.arn
  desired_count = 1
  launch_type = "EC2"
}

# ALB Listener
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.alasco-ghost_alb.arn
  port = 80
  protocol = "HTTP"
  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.alasco-ghost_tg.arn
  }
}
