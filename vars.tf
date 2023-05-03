variable "domain" {
  type        = string
  description = "domain site is deployed at, used for DNS"
}

// Region

variable "region" {
  type        = string
  description = "AWS region"
  default     = "eu-west-3"
}

variable "zone1" {
  type        = string
  description = "AvailabilityZone 1"
  default     = "eu-west-3"
}

variable "zone2" {
  type        = string
  description = "AvailabilityZone 2"
  default     = "eu-west-3c"
}

// Network

variable "vpc_cidr" {
  type        = string
  description = "CIDR for the VPC"
  default     = "10.0.0.0/16"
}

variable "subnet1" {
  type        = string
  description = "CIDR for the first subnet"
  default     = "10.0.21.0/24"
}

variable "subnet2" {
  type        = string
  description = "CIDR for the second subnet"
  default     = "10.0.42.0/24"
}

// Instances

variable "instance-type" {
  type        = string
  description = "EC2 instance type for the wp servers"
  default     = "t3.micro"
}

