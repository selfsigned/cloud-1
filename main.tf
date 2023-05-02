terraform {
  required_version = ">= 1.4.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
    dns = {
      source  = "hashicorp/dns"
      version = "~> 3.3"
    }
  }
  backend "s3" {
    # variables not supported in backend
    bucket = "usanga3k-terraform"
    key    = "cloud-1.tfstate"
    region = "eu-west-3" # Paris
  }
}

provider "aws" {
  region = var.region
}
