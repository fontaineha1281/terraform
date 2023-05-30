locals {
  block = var.state == "staging" ? 0 : 1
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
    Name = "aime-${var.state}-vpc"
  }
}

####################################################################
# Internet Gateway
####################################################################

# Create internet gateway
resource "aws_internet_gateway" "aime-ig" {
  vpc_id = aws_vpc.aime-vpc.id

  tags = {
    Name = "aime-${var.state}-internet-gateway"
  }
}

####################################################################
# NAT Gateway
####################################################################

# Create elastic IP
resource "aws_eip" "aime-eip" {

  tags = {
    Name = "aime-${var.state}-eip"
  }
}

# create NAT gateway
resource "aws_nat_gateway" "aime-nat-gateway" {
  subnet_id     = aws_subnet.aime-public-subnet-01.id
  allocation_id = aws_eip.aime-eip.id

  tags = {
    Name = "aime-${var.state}-nat-gateway"
  }
}

####################################################################
# Public Subnet
####################################################################

# Create public subnets
resource "aws_subnet" "aime-public-subnet-01" {
  map_public_ip_on_launch = true

  cidr_block        = format("10.%d.%d.0/24", local.block, 1)
  availability_zone = data.aws_availability_zones.available-zones.names[1 % length(data.aws_availability_zones.available-zones.names)]
  vpc_id            = aws_vpc.aime-vpc.id

  tags = {
    Name = "aime-${var.state}-public-subnet-01"
  }
}

resource "aws_subnet" "aime-public-subnet-02" {
  map_public_ip_on_launch = true

  cidr_block        = format("10.%d.%d.0/24", local.block, 2)
  availability_zone = data.aws_availability_zones.available-zones.names[2 % length(data.aws_availability_zones.available-zones.names)]
  vpc_id            = aws_vpc.aime-vpc.id

  tags = {
    Name = "aime-${var.state}-public-subnet-02"
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
    Name = "aime-${var.state}-public-route-table"
  }
}

locals {
  list_public_subnet_id = [aws_subnet.aime-public-subnet-01.id, aws_subnet.aime-public-subnet-02.id]
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
  cidr_block        = format("10.%d.%d.0/24", local.block, 10)
  availability_zone = data.aws_availability_zones.available-zones.names[1 % length(data.aws_availability_zones.available-zones.names)]
  vpc_id            = aws_vpc.aime-vpc.id

  tags = {
    Name = "aime-${var.state}-private-subnet-01"
  }
}

# Create route tables for private subnets
resource "aws_route_table" "aime-private-rtb" {
  vpc_id = aws_vpc.aime-vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.aime-nat-gateway.id
  }

  tags = {
    Name = "aime-${var.state}-private-route-table"
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
# Database Subnet
####################################################################
resource "aws_subnet" "aime-database-subnet-01" {
  cidr_block        = format("10.%d.%d.0/24", local.block, 13)
  availability_zone = data.aws_availability_zones.available-zones.names[1 % length(data.aws_availability_zones.available-zones.names)]
  vpc_id            = aws_vpc.aime-vpc.id

  tags = {
    Name = "aime-${var.state}-database-subnet-01"
  }
}

resource "aws_subnet" "aime-database-subnet-02" {
  cidr_block        = format("10.%d.%d.0/24", local.block, 14)
  availability_zone = data.aws_availability_zones.available-zones.names[2 % length(data.aws_availability_zones.available-zones.names)]
  vpc_id            = aws_vpc.aime-vpc.id

  tags = {
    Name = "aime-${var.state}-database-subnet-02"
  }
}
####################################################################
# Security group for ALB
####################################################################

# Create sg for ALB
resource "aws_security_group" "aime-alb-sg" {
  name_prefix = "aime-alb"
  description = "Security group for ALB"
  vpc_id      = aws_vpc.aime-vpc.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "aime-${var.state}-alb-sg"
  }
}

resource "aws_security_group_rule" "aime-ingress-alb-traffic" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.aime-alb-sg.id
}

resource "aws_security_group_rule" "aime-egress-alb-traffic" {
  description = "ALB outbound traffic from backend EC2"
  type                     = "egress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  security_group_id        = aws_security_group.aime-alb-sg.id
  source_security_group_id = aws_security_group.aime-backend-ec2-sg.id
}

####################################################################
# Security group for backend EC2
####################################################################

# Create sg for EC2
resource "aws_security_group" "aime-backend-ec2-sg" {
  name_prefix = "aime-backend-ec2"
  description = "Security group for EC2"
  vpc_id      = aws_vpc.aime-vpc.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "aime-${var.state}-ec2-sg"
  }
}

resource "aws_security_group_rule" "aime-ingress-backend-ec2-traffic-from-alb" {
  description = "Backend ec2 inbound traffic from ALB"
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  security_group_id        = aws_security_group.aime-backend-ec2-sg.id
  source_security_group_id = aws_security_group.aime-alb-sg.id
}

####################################################################
# Security group for RDS
####################################################################

# Create sg for RDS
resource "aws_security_group" "aime-rds-sg" {
  name_prefix = "aime-rds"
  description = "Security group for RDS"
  vpc_id      = aws_vpc.aime-vpc.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "aime-${var.state}-rds-sg"
  }
}

resource "aws_security_group_rule" "aime-ingress-rds-traffic-from-ec2" {
  description = " RDS inbound traffic from backend EC2"
  type              = "ingress"
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
  security_group_id = aws_security_group.aime-rds-sg.id
  source_security_group_id = aws_security_group.aime-backend-ec2-sg.id
}