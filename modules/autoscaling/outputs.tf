#           ██████  ██    ██ ████████ ██████  ██    ██ ████████ ███████           
#          ██    ██ ██    ██    ██    ██   ██ ██    ██    ██    ██                
#█████     ██    ██ ██    ██    ██    ██████  ██    ██    ██    ███████     █████ 
#          ██    ██ ██    ██    ██    ██      ██    ██    ██         ██           
#           ██████   ██████     ██    ██       ██████     ██    ███████           
                                                    
# Written by Christian Hamp                                                   
# Datum: 24.09.2024
                                                                                
output "asg_name" {
  description = "Auto Scaling Group name for ECS instances"
  value       = aws_autoscaling_group.ecs_asg.name
}

output "capacity_provider_name" {
  value = aws_ecs_capacity_provider.alasco_capacity_provider.name
}
