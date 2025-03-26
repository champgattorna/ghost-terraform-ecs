#           ██████  ██    ██ ████████ ██████  ██    ██ ████████ ███████           
#          ██    ██ ██    ██    ██    ██   ██ ██    ██    ██    ██                
#█████     ██    ██ ██    ██    ██    ██████  ██    ██    ██    ███████     █████ 
#          ██    ██ ██    ██    ██    ██      ██    ██    ██         ██           
#           ██████   ██████     ██    ██       ██████     ██    ███████           
                                                                                 
# Written by Christian Hamp                                                   
# Datum: 24.09.2024                                                                              

# Output VPC ID
output "vpc_id" {
  value = aws_vpc.ghost_vpc.id
}

# Output Public Subnet IDs
output "public_subnet_ids" {
  value = aws_subnet.public[*].id
}
