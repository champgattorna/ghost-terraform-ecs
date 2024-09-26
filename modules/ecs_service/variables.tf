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

# ECS cluster ID
variable "cluster_id" {
  description = "ECS cluster ID"
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

# Desired number of tasks
variable "desired_count" {
  description = "Desired number of tasks"
  type        = number
}

# Docker image to use
variable "image" {
  description = "Docker image to use"
  type        = string
}

# ARN of the target group to attach
variable "target_group_arn" {
  description = "ARN of the target group to attach"
  type        = string
}

# Capacity Provider Name
variable "capacity_provider_name" {
  description = "Name of the ECS capacity provider"
  type        = string
}

# Execution role ARN
variable "execution_role_arn" {
  description = "ARN of the IAM role that grants permissions for ECS tasks to make AWS API calls"
  type        = string
}

# Task role ARN
variable "task_role_arn" {
  description = "ARN of the IAM role that grants permissions to the containers in the task"
  type        = string
  default     = null
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

# EFS ID
variable "efs_id" {
  description = "EFS ID"
  type        = string
}