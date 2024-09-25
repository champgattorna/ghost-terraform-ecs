#          ██    ██  █████  ██████            
#          ██    ██ ██   ██ ██   ██           
#█████     ██    ██ ███████ ██████      █████ 
#           ██  ██  ██   ██ ██   ██           
#            ████   ██   ██ ██   ██           
                                             
# Written by Christian Hamp                                                   
# Datum: 24.09.2024                                             

# Name prefix for resources
variable "name" {
  description = "Name prefix for resources"
  type        = string
}

# VPC ID
variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

# List of subnet IDs
variable "subnet_ids" {
  description = "List of subnet IDs"
  type        = list(string)
}