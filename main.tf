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
  security_group_id   = module.ecs_cluster.security_group_id
  cidr_block          = var.vpc_cidr_block
  public_subnets      = var.public_subnet_cidrs
  subnet_ids          = module.vpc.public_subnet_ids
  availability_zones  = data.aws_availability_zones.available.names
  region              = var.region
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
  capacity_provider_name  = module.ecs_cluster.capacity_provider_name
}

# ALB Module
module "alb" {
  source = "./modules/alb"

  name       = var.name
  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.public_subnet_ids
}

# EFS Module
module "efs" {
  source = "./modules/efs"

  name                    = var.name
  region                  = var.region
  subnet_ids              = module.vpc.public_subnet_ids
  security_group_id       = module.ecs_cluster.security_group_id
  vpc_id                  = module.vpc.vpc_id

}

# ECS Service Module
module "ecs_service" {
  source = "./modules/ecs_service"

  name                    = var.name
  cluster_id              = module.ecs_cluster.cluster_id
  vpc_id                  = module.vpc.vpc_id
  subnet_ids              = module.vpc.public_subnet_ids
  security_group_id       = module.ecs_cluster.security_group_id
  desired_count           = var.ecs_service_desired_count
  image                   = var.image
  target_group_arn        = module.alb.target_group_arn
  capacity_provider_name  = module.ecs_cluster.capacity_provider_name
  execution_role_arn      = module.ecs_service.ecs_task_execution_role_arn
  region                  = var.region
  efs_id                  = module.efs.efs_id
}

# Output the ALB DNS name
output "alb_dns_name" {
  value = module.alb.alb_dns_name
}
