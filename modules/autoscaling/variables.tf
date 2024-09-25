#          ██    ██  █████  ██████            
#          ██    ██ ██   ██ ██   ██           
#█████     ██    ██ ███████ ██████      █████ 
#           ██  ██  ██   ██ ██   ██           
#            ████   ██   ██ ██   ██           
                                             
# Written by Christian Hamp                                                   
# Datum: 24.09.2024                                             

variable "instance_type" {
  description = "Instance type for the ECS EC2 instances"
  type        = string
  default     = "t2.micro"  # Free-tier eligible instance
}

variable "subnets" {
  description = "Private subnets for ECS instances"
  type        = list(string)
}

variable "ecs_sg" {
  description = "Security group for ECS instances"
  type        = string
}

variable "target_group_arn" {
  description = "ARN of the ALB Target Group"
  type        = string
}

variable "key_name" {
  description = "EC2 Key pair for SSH access"
  type        = string
  default     = null
}

variable "launch_template_id" {
  description = "ID of the launch template to use for the Auto Scaling Group"
  type        = string
}