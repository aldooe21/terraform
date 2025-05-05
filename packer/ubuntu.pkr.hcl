packer {
  required_plugins {
    amazon = {
      version = ">= 1.0.0"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

variable "version" {
  type    = string
  default = "1.0.0"
}

source "amazon-ebs" "example" {
  region         = "ap-southeast-2"
  source_ami     = "ami-08fa7bfa5c215f85f"  # Sesuaikan dengan AMI yang Anda gunakan
  instance_type  = "t2.micro"
  ssh_username   = "ec2-user"
  ami_name       = "packer-example-{{timestamp}}_v${var.version}"
}

build {
  hcp_packer_registry {
    bucket_name = "learn-packer-ubuntu"
    description = <<EOT
This image was created using Packer and is targeted for deployment in the ap-southeast-2 region.
    EOT
    bucket_labels = {
      "owner"          = "platform-team"
      "os"             = "Ubuntu",
      "ubuntu-version" = "20.04",
    }

    build_labels = {
      "build-time"   = timestamp()
      "build-source" = basename(path.cwd)
    }
  }
  sources = [
    "source.amazon-ebs.example"
  ]
}