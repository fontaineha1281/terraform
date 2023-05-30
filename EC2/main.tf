data "aws_ami" "amazon-linux-2" {
  owners = ["amazon"]
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

####################################################################
# Key pair
####################################################################

# Creates a PEM (and OpenSSH) formatted private key.
resource "tls_private_key" "aime-rsa-4096-ec2" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Create local file save credentials
resource "local_file" "aime-tf-key-pair-ec2" {
  content  = tls_private_key.aime-rsa-4096-ec2.private_key_pem
  filename = "tfkey.pem"
}

# Create key pair
resource "aws_key_pair" "aime-ec2-kp" {
  key_name   = "aime-ec2"
  public_key = tls_private_key.aime-rsa-4096-ec2.public_key_openssh
}

####################################################################
# EC2 backend
####################################################################

# Create ec2
resource "aws_instance" "aime-ec2-backend" {
  ami                    = data.aws_ami.amazon-linux-2.id
  instance_type          = var.instance-type
  key_name               = aws_key_pair.aime-ec2-kp.key_name
  subnet_id              = var.private-subnet-id-01
  vpc_security_group_ids = [var.ec2-sg-id]
  associate_public_ip_address = true

  tags = {
    Name = "aime-ec2"
  }

  lifecycle {
    create_before_destroy = true
  }
}

####################################################################
# Bastion host
####################################################################