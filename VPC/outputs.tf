output "vpc_id" {
  value = aws_vpc.aime-vpc.id
}

output "public_subnet_ids-01" {
  value = aws_subnet.aime-public-subnet-01.id
}

output "private_subnet_ids-01" {
  value = aws_subnet.aime-private-subnet-01.id
}

output "eip_public_ip" {
  value = aws_eip.aime-eip.public_ip
}

output "rds_sg_id" {
  value = aws_security_group.aime-dbs-sg.id
}