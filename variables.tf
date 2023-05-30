variable "region" {
  type = string
  description = "Region of aws"
  default = "us-west-1"
}

variable "access-key" {
  type = string
  description = "My Access Key ID"
}

variable "secret-key" {
  type = string
  description = "My Secret Access Key"
}

####################################################################
# VPC
####################################################################

variable "state" {
  type = string
  description = "Environment for project"
}

####################################################################
# RDS
####################################################################

variable "db-name" {
  description = "RDS database name"
}

variable "username" {
  description = "RDS database username"
  sensitive   = true
}

variable "password" {
  description = "RDS database password"
  sensitive   = true
}

variable "instance-class" {
  description = "RDS instance class"
  default = "db.t2.micro"
}

variable "allocated-storage" {
  description = "RDS allocated storage (in GB)"
  default = "5"
}
variable "publicly-accessible" {
  description = "RDS publicly accessible"
  default     = false
}

####################################################################
# EC2
####################################################################

variable "instance-type" {
  type = string
  description = "Instance type of the EC2"
}