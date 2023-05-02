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
  security_groups    = [aws_security_group.lb_sg.id]
}

// target EC2 wp servers
resource "aws_lb_target_group" "wp" {
  port     = 80
  protocol = "HTTP"

  vpc_id = aws_vpc.vpc.id // TODO target EC2s
}

// send HTTPS traffic to EC2 wp servers
resource "aws_lb_listener" "wp" {
  load_balancer_arn = aws_lb.lb.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = aws_acm_certificate_validation.primary.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.wp.arn
  }
}

// redirect HTTP to HTTPS
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = 443
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}
