#           ██████  ██    ██ ████████ ██████  ██    ██ ████████ ███████           
#          ██    ██ ██    ██    ██    ██   ██ ██    ██    ██    ██                
#█████     ██    ██ ██    ██    ██    ██████  ██    ██    ██    ███████     █████ 
#          ██    ██ ██    ██    ██    ██      ██    ██    ██         ██           
#           ██████   ██████     ██    ██       ██████     ██    ███████           
                                                    
# Written by Christian Hamp                                                   
# Datum: 24.09.2024
                                                                                
# Output ALB DNS Name
output "alb_dns_name" {
  value = aws_lb.alasco_alb.dns_name
}

# Output Target Group ARN
output "target_group_arn" {
  value = aws_lb_target_group.alasco_tg.arn
}

# Output Security Group ID
output "security_group_id" {
  value = aws_security_group.alasco_alb_sg.id
}