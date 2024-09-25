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
  default     = "alasco-task"
}

# AWS region
variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-2"
}

# CIDR block for VPC
variable "vpc_cidr_block" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

# CIDR blocks for public subnets
variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

# EC2 instance type
variable "instance_type" {
  description = "EC2 instance type for ECS instances"
  type        = string
  default     = "t2.micro"
}

# Key pair name for EC2 instances
variable "key_name" {
  description = "Key pair name for EC2 instances"
  type        = string
  default     = null
}

# Desired capacity for ECS instances
variable "ecs_desired_capacity" {
  description = "Desired capacity for ECS instances"
  type        = number
  default     = 2
}

# Minimum number of ECS instances
variable "ecs_min_size" {
  description = "Minimum number of ECS instances"
  type        = number
  default     = 1
}

# Maximum number of ECS instances
variable "ecs_max_size" {
  description = "Maximum number of ECS instances"
  type        = number
  default     = 3
}

# Desired number of ECS tasks
variable "ecs_service_desired_count" {
  description = "Desired number of ECS tasks"
  type        = number
  default     = 2
}

# Docker image to deploy
variable "image" {
  description = "Docker image to deploy"
  type        = string
  default     = "ghost:latest"
}

# List of availability zones
variable "availability_zones" {
  description = "List of availability zones"
  type        = number
  default     = 2
}