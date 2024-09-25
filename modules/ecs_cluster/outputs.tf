#           ██████  ██    ██ ████████ ██████  ██    ██ ████████ ███████           
#          ██    ██ ██    ██    ██    ██   ██ ██    ██    ██    ██                
#█████     ██    ██ ██    ██    ██    ██████  ██    ██    ██    ███████     █████ 
#          ██    ██ ██    ██    ██    ██      ██    ██    ██         ██           
#           ██████   ██████     ██    ██       ██████     ██    ███████           
                                                    
# Written by Christian Hamp                                                   
# Datum: 24.09.2024
                                                                                
# Output ECS Cluster ID
output "cluster_id" {
  value = aws_ecs_cluster.alasco_ecs_cluster.id
}

# Output Auto Scaling Group Name
output "asg_name" {
  value = aws_autoscaling_group.alasco_asg.name
}

# Output Security Group ID
output "security_group_id" {
  value = aws_security_group.alasco_sg.id
}

# Output Launch Template ID
output "launch_template_id" {
  description = "ID of the ECS launch template"
  value       = aws_launch_template.ecs.id
}
