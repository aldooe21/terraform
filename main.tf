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

# Gunakan subnet yang sudah ada
data "aws_subnet" "existing_subnet" {
  id = "subnet-07a5355f2120f2ef5"  # subnet public yang ada
}

# Instance menggunakan subnet dan security group yang sudah ada
resource "aws_instance" "example" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = var.key_name
  subnet_id              = data.aws_subnet.existing_subnet.id
  vpc_security_group_ids = ["sg-06d0fddd431f3e114"]

  associate_public_ip_address = true  # jika subnet tidak map IP publik otomatis

  tags = {
    Name = var.instance_name
  }
}
