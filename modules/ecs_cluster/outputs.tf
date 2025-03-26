#           ██████  ██    ██ ████████ ██████  ██    ██ ████████ ███████           
#          ██    ██ ██    ██    ██    ██   ██ ██    ██    ██    ██                
#█████     ██    ██ ██    ██    ██    ██████  ██    ██    ██    ███████     █████ 
#          ██    ██ ██    ██    ██    ██      ██    ██    ██         ██           
#           ██████   ██████     ██    ██       ██████     ██    ███████           
                                                    
# Written by Christian Hamp                                                   
# Datum: 24.09.2024
                                                                                
# Output ECS Cluster ID
output "cluster_id" {
  value = aws_ecs_cluster.ghost_ecs_cluster.id
}

# Output Auto Scaling Group Name
output "asg_name" {
  value = aws_autoscaling_group.ghost_asg.name
}

# Output Security Group ID
output "security_group_id" {
  value = aws_security_group.ghost_sg.id
}

# Output for the Capacity Provider Name
output "capacity_provider_name" {
  value = aws_ecs_capacity_provider.ghost_capacity_providers.name
}
