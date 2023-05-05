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

variable "subnet1_private" {
  type        = string
  description = "CIDR for the first private subnet"
  default     = "10.0.22.0/24"
}

variable "subnet2" {
  type        = string
  description = "CIDR for the second subnet"
  default     = "10.0.42.0/24"
}

variable "subnet2_private" {
  type        = string
  description = "CIDR for the second private subnet"
  default     = "10.0.43.0/24"
}

// Instances

variable "instance-type" {
  type        = string
  description = "EC2 instance type for the wp servers"
  default     = "t3.micro"
}

// Databasae
// Would actually use a random password and use AWS secret storage in the real world

variable "db-user" {
  type        = string
  description = "RDS DB user"
}

variable "db-password" {
  type        = string
  description = "RDS DB password"
}

// Wordpress

variable "reverse-proxy-port" {
  type        = number
  description = "APP reverse proxy endpoint port"
  default     = 8080
}

variable "wp-health-check" {
  type        = string
  description = "Wordpress health check path"
  default     = "/wp-admin/images/wordpress-logo.svg"
}

variable "pubkey" {
  type        = string
  description = "SSH pubkey"
}

// Wordpress cloud-init

variable "db-name" {
  type        = string
  description = "Wordpress database name"
}

variable "wp-user" {
  type        = string
  description = "Wordpress administrator username"
}

variable "wp-password" {
  type        = string
  description = "Wordpress administrator password"
}

variable "wp-email" {
  type        = string
  description = "Wordpress administrator email"
}
