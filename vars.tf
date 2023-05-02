variable "domain" {
  type        = string
  description = "domain site is deployed at, used for DNS"
}

// Region

variable "region" {
  type        = string
  description = "AWS region"
}

variable "zone1" {
  type        = string
  description = "AvailabilityZone 1"
}

variable "zone2" {
  type        = string
  description = "AvailabilityZone 2"
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

variable "wp1_ip" {
  type        = string
  description = "Private IP for the first WP instance (needs to be in subnet1)"
  default     = "10.0.21.11"
}

variable "wp2_ip" {
  type        = string
  description = "Private IP for the second WP instance (needs to be in subnet2)"
  default     = "10.0.42.11"
}

// Instances

variable "instance-type" {
  type        = string
  description = "EC2 instance type for the wp servers"
}

