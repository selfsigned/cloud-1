variable "domain" {
  type = string
}

// Region

variable "region" {
  type = string
}

variable "zone1" {
  description = "AvailabilityZone 1"
  type        = string
}

variable "zone2" {
  description = "AvailabilityZone 2"
  type        = string
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
