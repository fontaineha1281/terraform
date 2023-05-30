variable "region" {
  description = "AWS region"
  default = ""
}

variable "access_key" {
  type = string
  description = "My Access Key ID"
}

variable "secret_key" {
  type = string
  description = "My Secret Access Key"
}

####################################################################
# VPC
####################################################################

variable "state" {
  type = string
  description = "Environment for project"
  default = "staging"
}


####################################################################
# RDS
####################################################################

variable "db_name" {
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

variable "instance_class" {
  description = "RDS instance class"
  default = "db.t2.micro"
}

variable "allocated_storage" {
  description = "RDS allocated storage (in GB)"
  default = "5"
}
variable "publicly_accessible" {
  description = "RDS publicly accessible"
  default     = false
}
