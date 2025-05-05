provider "aws" {
  region = var.aws_region
}

# Assign existing VPC 
data "aws_vpc" "existing" {
  filter {
    name   = "tag:Name"
    values = ["terraform-vpc"]
  }
}

# Subnet baru dibuat di VPC yang sudah ada
resource "aws_subnet" "example_subnet" {
  vpc_id                  = data.aws_vpc.existing.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = true

  tags = {
    Name = "example-subnet"
  }
}

# Assign existing security group 
resource "aws_instance" "example" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = var.key_name
  subnet_id              = aws_subnet.example_subnet.id
  vpc_security_group_ids = ["sg-06d0fddd431f3e114"]

  tags = {
    Name = var.instance_name
  }
}

# Output
output "instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.example.public_ip
}

output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.example.id
}

output "subnet_id" {
  description = "ID of the subnet"
  value       = aws_subnet.example_subnet.id
}

output "vpc_id" {
  description = "ID of the VPC"
  value       = data.aws_vpc.existing.id
}

data "aws_availability_zones" "available" {}
