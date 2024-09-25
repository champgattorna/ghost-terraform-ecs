#          ██    ██  █████  ██████            
#          ██    ██ ██   ██ ██   ██           
#█████     ██    ██ ███████ ██████      █████ 
#           ██  ██  ██   ██ ██   ██           
#            ████   ██   ██ ██   ██           
                                             
# Written by Christian Hamp                                                   
# Datum: 24.09.2024                                             

# Name prefix for the resources
variable "name" {
  description = "Name prefix for the resources"
  type        = string
}

# CIDR block for the VPC
variable "cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
}

# List of public subnet CIDR blocks
variable "public_subnets" {
  description = "List of public subnet CIDR blocks"
  type        = list(string)
}

# List of availability zones
variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
}