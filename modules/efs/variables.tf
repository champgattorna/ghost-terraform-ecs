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

# List of subnet IDs
variable "subnet_ids" {
  description = "List of subnet IDs"
  type        = list(string)
}

# Security Group ID for ECS tasks
variable "security_group_id" {
  description = "Security Group ID for ECS tasks"
  type        = string
}

# AWS Region
variable "region" {
  description = "AWS region"
  type        = string
}

# VPC ID
variable "vpc_id" {
  description = "VPC ID"
  type        = string
}