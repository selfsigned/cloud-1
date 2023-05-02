# __   _____  ___ 
# \ \ / / _ \/ __|
#  \ V /|  _/ (__ 
#   \_/ |_|  \___|

// VPC
resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr
}

resource "aws_subnet" "subnet1" {
  vpc_id            = aws_vpc.vpc.id
  availability_zone = var.zone1
  cidr_block        = var.subnet1
}

resource "aws_subnet" "subnet2" {
  vpc_id            = aws_vpc.vpc.id
  availability_zone = var.zone2
  cidr_block        = var.subnet2
}

// gateaway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
}
// route table
resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}
resource "aws_route_table_association" "rt1" {
  subnet_id      = aws_subnet.subnet1.id
  route_table_id = aws_route_table.rt.id
}
resource "aws_route_table_association" "rt2" {
  subnet_id      = aws_subnet.subnet2.id
  route_table_id = aws_route_table.rt.id
}

#  _    ___ 
# | |  | _ )
# | |__| _ \
# |____|___/

// ALB
resource "aws_lb" "lb" {
  internal           = false
  load_balancer_type = "application" // ALB, layer 3
  subnets            = [aws_subnet.subnet1.id, aws_subnet.subnet2.id]

  // TODO security group

  // TODO subnets in two AZ
}

// lb ip resource
data "dns_a_record_set" "lb_ip" {
  host = aws_lb.lb.dns_name
}


# resource "aws_lb_listener" "example" {
#   # ... other configuration ...
#   certificate_arn = aws_acm_certificate_validation.primary.certificate_arn
# }
