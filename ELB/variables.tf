variable "vpc-id" {
  type = any
  description = "ID of VPC"
}

variable "public-subnet-id-01" {
  type = any
  description = "ID of public subnet"
}

variable "alb-sg-id" {
  type = any
  description = "ID of ALB security group"
}

variable "ec2-id" {
  type = any
  description = "ID of ec2"
}
