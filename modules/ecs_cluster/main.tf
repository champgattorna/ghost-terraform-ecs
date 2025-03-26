#          ███████  ██████ ███████           
#          ██      ██      ██                
#█████     █████   ██      ███████     █████ 
#          ██      ██           ██           
#          ███████  ██████ ███████           
                                                                                       
# Written by Christian Hamp                                                   
# Datum: 24.09.2024

# Create ECS Cluster
resource "aws_ecs_cluster" "ghost_ecs_cluster" {
  name      = "ghost-ecs-cluster"
}

# Fetch the latest ECS-optimized AMI
data "aws_ami" "ecs_ami" {
  filter {
    name   = "name"
    values = ["amzn2-ami-ecs-hvm-*-x86_64-ebs"]
  }

  owners      = ["amazon"]
  most_recent = true
}

# Create Launch Template for ECS EC2 Instances
resource "aws_launch_template" "ghost_ecs_launch_template" {
  name_prefix   = "${var.name}-ecs-launch-template"
  image_id      = data.aws_ami.ecs_ami.id 
  instance_type = var.instance_type
  
  network_interfaces {
    security_groups = [aws_security_group.ghost_sg.id]
  }

  key_name = var.key_name

  iam_instance_profile {
    arn = aws_iam_instance_profile.profile.arn
  }

  # Instance Storage
  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size = 30
      volume_type = "gp2"
    }
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
        Name = "${var.name}-ecs-instance"
    }
  }
  
  # User data script for bootstrapping EC2 instance to ECS cluster
  user_data = filebase64("${path.module}/user_data.tpl")
}


# IAM Role for ECS task execution
resource "aws_iam_role" "ecs_task_execution_role" {
  name                = "ecs-cluster-assoc"
  assume_role_policy  = data.aws_iam_policy_document.assume_policy.json
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role",
    "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy",
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  ]
}

# Instance profile for role
resource "aws_iam_instance_profile" "profile" {
  name = "ghost-ecs-cluster-profile"
  role = aws_iam_role.ecs_task_execution_role.name
}

# Policy Document to assume
data "aws_iam_policy_document" "assume_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      identifiers = ["ecs-tasks.amazonaws.com", "ec2.amazonaws.com"]
      type = "Service"
    }
  }
}

# Auto Scaling group, performs refresh on launch template change to ensure changes execute
resource "aws_autoscaling_group" "ghost_asg" {
  name                 = "${var.name}-ecs-asg"
  desired_capacity     = var.desired_capacity
  min_size             = var.min_size
  protect_from_scale_in = true
  max_size             = var.max_size
  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 90
    }
    triggers = ["launch_template"]
  }
  launch_template {
    id      = aws_launch_template.ghost_ecs_launch_template.id
    version = "$Latest"
  }
  vpc_zone_identifier = var.subnet_ids
}

# Capacity provider to attach to ECS cluster
resource "aws_ecs_capacity_provider" "ghost_capacity_providers" {
  name = "ghost-ecs-asg"

  auto_scaling_group_provider {
    auto_scaling_group_arn         = aws_autoscaling_group.ghost_asg.arn
    managed_termination_protection = "DISABLED"
    managed_draining               = "DISABLED"

    managed_scaling {
      instance_warmup_period    = 300
      maximum_scaling_step_size = 10000
      minimum_scaling_step_size = 1
      status                    = "DISABLED"
      target_capacity           = 100
    }
  }
}

# Attachment of capacity provider to ECS cluster
resource "aws_ecs_cluster_capacity_providers" "ghost_cluster_capacity_providers" {
  cluster_name       = aws_ecs_cluster.ghost_ecs_cluster.name
  capacity_providers = [aws_ecs_capacity_provider.ghost_capacity_providers.name]
}

# Security Group for ECS Instances
resource "aws_security_group" "ghost_sg" {
  name        = "${var.name}-ecs-instances-sg"
  description = "Security group for ECS instances"
  vpc_id      = var.vpc_id

  # All TCP. Improvement to be made with more time...
  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.name}-ecs-instances-sg"
  }
}
