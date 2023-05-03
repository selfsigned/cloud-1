packer {
    required_plugins {
        amazon = {
            version = ">= 1.2.5"
            source  = "github.com/hashicorp/amazon"
        }
    }
}

// vars

variable "region" {
    type        = string
    description = "AWS region"
    default     = "eu-west-3"
}

variable "instance-type" {
    type        = string
    description = "builder/source instance type"
    default     = "t3.micro"
}

// source

source "amazon-ebs" "debian" {
    ami_name        = "cloud-1"
    region          = var.region
    instance_type   = var.instance-type

    source_ami_filter {
        filters = {
            name                = "debian-11-amd64-*"
            root-device-type    = "ebs"
            virtualization-type = "hvm"
        }
        most_recent = true
        owners      = ["136693071363"]
    }
    ssh_username = "admin"
}

build {
    name    = "cloud-1"
    sources = [ "source.amazon-ebs.debian" ]

    provisioner "shell" {
      environment_vars = []
      inline = [
        "echo Installing ansible",
        "sleep 5",
        "sudo apt-get update",
        "sudo apt-get install -y ansible",
        "echo Installing Amazon SSM",
        "sleep 5",
        "mkdir /tmp/ssm",
        "cd /tmp/ssm",
        "wget https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/debian_amd64/amazon-ssm-agent.deb",
        "sudo dpkg -i amazon-ssm-agent.deb",
      ]
    }
}
