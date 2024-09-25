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

# EC2 instance type
variable "instance_type" {
  description = "EC2 instance type for ECS instances"
  type        = string
}

# Key pair name for SSH access
variable "key_name" {
  description = "Key pair name for SSH access"
  type        = string
  default     = null
}

# Desired capacity of ECS instances
variable "desired_capacity" {
  description = "Desired capacity of ECS instances"
  type        = number
}

# Minimum number of ECS instances
variable "min_size" {
  description = "Minimum number of ECS instances"
  type        = number
}

# Maximum number of ECS instances
variable "max_size" {
  description = "Maximum number of ECS instances"
  type        = number
}

# Capacity Provider name
variable "capacity_provider_name" {
  description = "Name of the ECS capacity provider"
  type        = string
}
