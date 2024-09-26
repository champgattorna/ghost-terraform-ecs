#           ██████  ██    ██ ████████ ██████  ██    ██ ████████ ███████           
#          ██    ██ ██    ██    ██    ██   ██ ██    ██    ██    ██                
#█████     ██    ██ ██    ██    ██    ██████  ██    ██    ██    ███████     █████ 
#          ██    ██ ██    ██    ██    ██      ██    ██    ██         ██           
#           ██████   ██████     ██    ██       ██████     ██    ███████           
                                                    
# Written by Christian Hamp                                                   
# Datum: 24.09.2024
                                                                                
# Output EFS Security Group
output "efs_sg" {
  value = aws_security_group.alasco_efs_sg.id
}

# Output EFS DNS
output "efs_dns" {
  value = aws_efs_file_system.alasco_efs.dns_name
}

# Output EFS ID
output "efs_id" {
  value = aws_efs_file_system.alasco_efs.id
}