locals {
  block = var.state == "staging" ? 0 : 1
  env = var.state == "staging" ? "staging" : "production"
}

data "aws_availability_zones" "available-zones" {}

####################################################################
# VPC
####################################################################

# Create vpc
resource "aws_vpc" "aime-vpc" {
  cidr_block           = format("10.%d.0.0/20", local.block)
  enable_dns_hostnames = true
  tags = {
    Name = "aime-${local.env}-vpc"
  }
}

####################################################################
# Internet Gateway
####################################################################

# Create internet gateway
resource "aws_internet_gateway" "aime-ig" {
  vpc_id = aws_vpc.aime-vpc.id

  tags = {
    Name = "aime-${local.env}-internet-gateway"
  }
}

####################################################################
# NAT Gateway
####################################################################

# Create elastic IP
resource "aws_eip" "aime-eip" {

  tags = {
    Name = "aime-${local.env}-eip"
  }
}

# create NAT gateway
resource "aws_nat_gateway" "aime-nat-gateway" {
  subnet_id = aws_subnet.aime-public-subnet-01.id
  allocation_id = aws_eip.aime-eip.id

  tags = {
    Name = "aime-${local.env}-nat-gateway"
  }
}

####################################################################
# Public Subnet
####################################################################

# Create public subnets
resource "aws_subnet" "aime-public-subnet-01" {
  map_public_ip_on_launch = true

  cidr_block = format("10.%d.%d.0/24", local.block, 1)
  availability_zone =  data.aws_availability_zones.available-zones.names[1 % length(data.aws_availability_zones.available-zones.names)]
  vpc_id     = aws_vpc.aime-vpc.id

  tags = {
    Name = "aime-${local.env}-public-subnet-01"
  }
}

# Create route table for public subnets
resource "aws_route_table" "aime-public-rtb" {
  vpc_id = aws_vpc.aime-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.aime-ig.id
  }

  tags = {
    Name = "aime-${local.env}-public-route-table"
  }
}

locals {
  list_public_subnet_id = [aws_subnet.aime-public-subnet-01.id]
}

# Link the route table to the public subnet to allow instances in the subnet to access the Internet
resource "aws_route_table_association" "aime-public-rtb-association" {
  count = length(local.list_public_subnet_id)

  subnet_id      = local.list_public_subnet_id[count.index]
  route_table_id = aws_route_table.aime-public-rtb.id
}

####################################################################
# Private Subnet
####################################################################

# Create private subnets
resource "aws_subnet" "aime-private-subnet-01" {
  cidr_block = format("10.%d.%d.0/24", local.block, 2)
  availability_zone = data.aws_availability_zones.available-zones.names[1 % length(data.aws_availability_zones.available-zones.names)]
  vpc_id     = aws_vpc.aime-vpc.id

  tags = {
    Name = "aime-${local.env}-private-subnet-01"
  }
}

# Create route tables for private subnets
resource "aws_route_table" "aime-private-rtb" {
  vpc_id = aws_vpc.aime-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id  = aws_nat_gateway.aime-nat-gateway.id
  }

  tags = {
    Name = "aime-${local.env}-private-route-table"
  }
}

locals {
  list_private_subnet_id = [aws_subnet.aime-private-subnet-01.id]
}

# Link the route table to the private subnet to allow instances in the subnet to access the Internet
resource "aws_route_table_association" "aime-private-rtb-association" {
  count = length(local.list_private_subnet_id)

  subnet_id      = local.list_private_subnet_id[count.index]
  route_table_id = aws_route_table.aime-private-rtb.id
}

####################################################################
# Security group
####################################################################

# Create sg for RDS
resource "aws_security_group" "aime-dbs-sg" {
  name_prefix = "aime-lb"
  description = "Security group for RDS"
  vpc_id      = aws_vpc.aime-vpc.id

  ingress {
    from_port = 3306
    to_port   = 3306
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "aime-${local.env}-dbs-sg"
  }
}