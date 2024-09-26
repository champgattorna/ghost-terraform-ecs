#          ██    ██ ██████   ██████           
#          ██    ██ ██   ██ ██                
#█████     ██    ██ ██████  ██          █████ 
#           ██  ██  ██      ██                
#            ████   ██       ██████           
                                                    
# Written by Christian Hamp                                                   
# Datum: 24.09.2024

# Fetch available availability zones
data "aws_availability_zones" "available" {}

# Create VPC
resource "aws_vpc" "alasco_vpc" {
  cidr_block = var.cidr_block
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "${var.name}-vpc"
  }
}

# Create Public Subnets
resource "aws_subnet" "public" {
  count = length(var.public_subnets)

  vpc_id                  = aws_vpc.alasco_vpc.id
  cidr_block              = var.public_subnets[count.index]
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.name}-public-subnet-${count.index}"
  }
}

# Create Internet Gateway
resource "aws_internet_gateway" "alasco_igw" {
  vpc_id = aws_vpc.alasco_vpc.id

  tags = {
    Name = "${var.name}-igw"
  }
}

# Create Route Table for Public Subnets
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.alasco_vpc.id

  tags = {
    Name = "${var.name}-public-rt"
  }
}

# Create Route to Internet
resource "aws_route" "internet_access" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.alasco_igw.id
}

# Associate Route Table with Public Subnets
resource "aws_route_table_association" "public_subnets" {
  count          = length(aws_subnet.public)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_vpc_endpoint" "efs" {
  vpc_id            = aws_vpc.alasco_vpc.id
  service_name      = "com.amazonaws.${var.region}.elasticfilesystem"
  vpc_endpoint_type = "Interface"
  subnet_ids        = var.subnet_ids
  security_group_ids = [var.security_group_id]
}