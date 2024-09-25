#          ███    ███  █████  ██ ███    ██           
#          ████  ████ ██   ██ ██ ████   ██           
#█████     ██ ████ ██ ███████ ██ ██ ██  ██     █████ 
#          ██  ██  ██ ██   ██ ██ ██  ██ ██           
#          ██      ██ ██   ██ ██ ██   ████           
                                                    
# Written by Christian Hamp                                                   
# Datum: 24.09.2024

# Fetch available availability zones
data "aws_availability_zones" "available" {}

# VPC Module
module "vpc" {
  source = "./modules/vpc"

  name                = var.name
  cidr_block          = var.vpc_cidr_block
  public_subnets      = var.public_subnet_cidrs
  availability_zones  = data.aws_availability_zones.available.names
}

# ECS Cluster Module
module "ecs_cluster" {
  source = "./modules/ecs_cluster"

  name                    = var.name
  vpc_id                  = module.vpc.vpc_id
  subnet_ids              = module.vpc.public_subnet_ids
  instance_type           = var.instance_type
  desired_capacity        = var.ecs_desired_capacity
  min_size                = var.ecs_min_size
  max_size                = var.ecs_max_size
  key_name                = var.key_name
  capacity_provider_name  = module.autoscaling.capacity_provider_name
}

# ALB Module
module "alb" {
  source = "./modules/alb"

  name       = var.name
  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.public_subnet_ids
}

# ECS Service Module
module "ecs_service" {
  source = "./modules/ecs_service"

  name                    = var.name
  cluster_id              = module.ecs_cluster.cluster_id
  subnet_ids              = module.vpc.public_subnet_ids
  security_group_id       = module.ecs_cluster.security_group_id
  desired_count           = var.ecs_service_desired_count
  image                   = var.image
  target_group_arn        = module.alb.target_group_arn
  capacity_provider_name  = module.autoscaling.capacity_provider_name
}

# Autoscaling Module
module "autoscaling" {
  source = "./modules/autoscaling"

  subnets            = module.vpc.public_subnet_ids
  ecs_sg             = module.ecs_cluster.security_group_id
  launch_template_id = module.ecs_cluster.launch_template_id
  target_group_arn   = module.alb.target_group_arn
}

# Output the ALB DNS name
output "alb_dns_name" {
  value = module.alb.alb_dns_name
}
