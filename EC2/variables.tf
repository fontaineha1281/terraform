variable "vpc-id" {
  type = any
  description = "ID of VPC"
}

variable "private-subnet-id-01" {
  type = any
  description = "ID of private subnet"
}

variable "ec2-sg-id" {
  type = any
  description = "ID of EC2 security group"
}

variable "instance-type" {
  type = string
  description = "Instance type of the EC2"
}