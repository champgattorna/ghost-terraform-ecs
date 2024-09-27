#           █████  ██      ██████            
#          ██   ██ ██      ██   ██           
#█████     ███████ ██      ██████      █████ 
#          ██   ██ ██      ██   ██           
#          ██   ██ ███████ ██████            
                                            
# Written by Christian Hamp                                                   
# Datum: 24.09.2024

# Security Group for ALB
resource "aws_security_group" "alasco_alb_sg" {
  name        = "${var.name}-alb-sg"
  description = "Security group for ALB"
  vpc_id      = var.vpc_id

  # Access to HTTP from Load Balancer
  ingress {
    from_port   = 80
    to_port     = 80
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
    Name = "${var.name}-alb-sg"
  }
}

# Create ALB
resource "aws_lb" "alasco_alb" {
  name               = "${var.name}-alb"
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alasco_alb_sg.id]
  subnets            = var.subnet_ids

  tags = {
    Name = "${var.name}-alb"
  }
}

# Create Target Group
resource "aws_lb_target_group" "alasco_tg" {
  name        = "${var.name}-target-group"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "instance"

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200-399"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = {
    Name = "${var.name}-target-group"
  }
}

# Create Listener
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.alasco_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alasco_tg.arn
  }
}
