#          ███████  ██████ ███████           
#          ██      ██      ██                
#█████     █████   ██      ███████     █████ 
#          ██      ██           ██           
#          ███████  ██████ ███████           
                                                                                       
# Written by Christian Hamp                                                   
# Datum: 24.09.2024

# Create ECS Cluster
resource "aws_ecs_cluster" "alasco_ecs_cluster" {
  name = "${var.name}-cluster"

  #capacity_providers = [var.capacity_provider_name]

  #default_capacity_provider_strategy {
  #  capacity_provider = var.capacity_provider_name
  #  weight            = 1
  #  base              = 0
  #}
}

# IAM Role for ECS Instances
resource "aws_iam_role" "ecs_instance_role" {
  name = "${var.name}-ecs-instance-role"

  assume_role_policy = data.aws_iam_policy_document.ecs_instance_role_assume_role_policy.json
}

# IAM Policy Document for ECS Instances
data "aws_iam_policy_document" "ecs_instance_role_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

# Attach Policy to IAM Role
resource "aws_iam_role_policy_attachment" "ecs_instance_role_policy" {
  role       = aws_iam_role.ecs_instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

# IAM Instance Profile
resource "aws_iam_instance_profile" "ecs_instance_profile" {
  name = "${var.name}-ecs-instance-profile"
  role = aws_iam_role.ecs_instance_role.name
}

# Security Group for ECS Instances
resource "aws_security_group" "alasco_sg" {
  name        = "${var.name}-ecs-instances-sg"
  description = "Security group for ECS instances"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Adjust as needed
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

# Fetch the latest ECS-optimized AMI
data "aws_ami" "ecs_ami" {
  filter {
    name   = "name"
    values = ["amzn2-ami-ecs-hvm-*-x86_64-ebs"]
  }

  owners      = ["amazon"]
  most_recent = true
}

# Launch Template for ECS Instances
resource "aws_launch_template" "ecs" {
  name_prefix   = "${var.name}-ecs-launch-template-"
  image_id      = data.aws_ami.ecs_ami.id
  instance_type = var.instance_type

  iam_instance_profile {
    name = aws_iam_instance_profile.ecs_instance_profile.name
  }

  key_name = var.key_name

  network_interfaces {
    security_groups = [aws_security_group.alasco_sg.id]
  }

  # Embed user data
  user_data = base64encode(<<-EOF
    #!/bin/bash
    echo "ECS_CLUSTER=${var.name}-cluster" >> /etc/ecs/ecs.config
    systemctl restart ecs
    systemctl enable --now ecs
  EOF
  )

  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size = 30
    }
  }

  tags = {
    Name = "${var.name}-ecs-instance"
  }
}

# Auto Scaling Group for ECS Instances
resource "aws_autoscaling_group" "alasco_asg" {
  name                      = "${var.name}-ecs-asg"
  max_size                  = var.max_size
  min_size                  = var.min_size
  desired_capacity          = var.desired_capacity
  vpc_zone_identifier       = var.subnet_ids
  launch_template {
    id      = aws_launch_template.ecs.id
    version = "$Latest"
  }
  health_check_type         = "EC2"
  health_check_grace_period = 300

  tag {
    key                 = "Name"
    value               = "${var.name}-ecs-instance"
    propagate_at_launch = true
  }
}
