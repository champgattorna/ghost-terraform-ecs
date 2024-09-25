#           █████  ███████  ██████            
#          ██   ██ ██      ██                 
#█████     ███████ ███████ ██   ███     █████ 
#          ██   ██      ██ ██    ██           
#          ██   ██ ███████  ██████            
                                             
# Written by Christian Hamp                                                   
# Datum: 24.09.2024                                            

# Auto Scaling Group for ECS Instances
resource "aws_autoscaling_group" "ecs_asg" {
  desired_capacity     = 1
  max_size             = 3
  min_size             = 1
  protect_from_scale_in = true
  vpc_zone_identifier  = var.subnets
  launch_template {
    id      = var.launch_template_id
    version = "$Latest"
  }

  instance_refresh {
    strategy = "Rolling"

    preferences {
      min_healthy_percentage = 90
    }

    triggers = ["launch_template"] # Triggers refresh when the launch template changes
  }

  lifecycle {
    ignore_changes = [desired_capacity]
  }

  health_check_type         = "EC2"
  health_check_grace_period = 300

  target_group_arns = [var.target_group_arn]

#  scaling_policies {
#    cpu_scaling_policy = {
#      adjustment_type         = "ChangeInCapacity"
#      scaling_adjustment      = 1
#      cooldown                = 300
#    }
#  }
}

# Create ECS Capacity Provider
resource "aws_ecs_capacity_provider" "alasco_capacity_provider" {
  name = "alasco-task-capacity-provider"

  auto_scaling_group_provider {
    auto_scaling_group_arn         = aws_autoscaling_group.ecs_asg.arn
    managed_termination_protection = "ENABLED"

    managed_scaling {
      status                    = "ENABLED"
      target_capacity           = 80
      minimum_scaling_step_size = 1
      maximum_scaling_step_size = 100
    }
  }
}

# Scaling Policy to add instances when CPU > 70%
#resource "aws_autoscaling_policy" "scale_out_policy" {
#  name                   = "alasco-task-scale-out"
#  scaling_adjustment      = 1
#  adjustment_type         = "ChangeInCapacity"
#  cooldown                = 300
#  autoscaling_group_name  = aws_autoscaling_group.ecs_asg.name
#  estimated_instance_warmup = 180

#  metric_aggregation_type = "Average"
#  policy_type             = "StepScaling"
#}

# Scaling Policy to remove instances when CPU < 30%
#resource "aws_autoscaling_policy" "scale_in_policy" {
#  name                   = "alasco-task-scale-in"
#  scaling_adjustment      = -1
#  adjustment_type         = "ChangeInCapacity"
#  cooldown                = 300
#  autoscaling_group_name  = aws_autoscaling_group.ecs_asg.name
#  estimated_instance_warmup = 180

#  metric_aggregation_type = "Average"
#  policy_type             = "SimpleScaling"
#}
