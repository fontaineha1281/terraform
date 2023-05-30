terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }

  backend "s3" {
    bucket = "aime-terraform-state"
    key    = "staging/terraform.tfstate"
    region = "us-west-1"
  }
}

# Configure the AWS Provider
provider "aws" {
  region     = var.region
  access_key = var.access-key
  secret_key = var.secret-key
}

locals {
  block = var.state == "staging" ? 0 : 1
  state = var.state == "staging" ? "staging" : "production"
}

module "vpc" {
  source = "./VPC"
  state  = local.state
}

module "rds" {
  source              = "./RDS"
  region              = var.region
  state               = var.state
  db-name             = var.db-name
  username            = var.username
  password            = var.password
  instance-class      = var.instance-class
  allocated-storage   = var.allocated-storage
  publicly-accessible = var.publicly-accessible

  vpc-id                 = module.vpc.vpc-id
  database-subnet-ids-01 = module.vpc.database-subnet-ids-01
  database-subnet-ids-02 = module.vpc.database-subnet-ids-02
  rds-sg-id              = module.vpc.rds-sg-id

}

module "ec2" {
  source = "./EC2"
  instance-type = var.instance-type
  vpc-id = module.vpc.vpc-id
  private-subnet-id-01 = module.vpc.private-subnet-ids-01
  ec2-sg-id = module.vpc.ec2-sg-id
}

module "elb" {
  source = "./ELB"
  vpc-id = module.vpc.vpc-id
  public-subnet-id-01 = module.vpc.public-subnet-ids-01
  public-subnet-id-02 = module.vpc.public-subnet-ids-02
  alb-sg-id = module.vpc.alb-sg-id
  ec2-backend-id = module.ec2.ec2-backend-id
}