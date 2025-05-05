provider "aws" {
  region = var.aws_region
}

# Gunakan VPC yang sudah ada
data "aws_vpc" "existing" {
  filter {
    name   = "tag:Name"
    values = ["terraform-vpc"]
  }
}

# Ambil AZ dari region saat ini
data "aws_availability_zones" "available" {}

# Buat subnet di VPC tersebut
resource "aws_subnet" "example_subnet" {
  vpc_id                  = data.aws_vpc.existing.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = true

  tags = {
    Name = "example-subnet"
  }
}

# Instance menggunakan subnet dari VPC custom, dan SG yang sudah ada
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
