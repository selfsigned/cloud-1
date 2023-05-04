#  _    ___
# | |  | _ )
# | |__| _ \
# |____|___/

resource "aws_security_group" "lb_sg" {
  description = "Application Load Balancer security group"
  vpc_id      = aws_vpc.vpc.id
}

resource "aws_security_group_rule" "public_http_in" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.lb_sg.id
}

resource "aws_security_group_rule" "public_https_in" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.lb_sg.id
}

resource "aws_security_group_rule" "public_http_out" {
  type              = "egress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.lb_sg.id
}

resource "aws_security_group_rule" "public_https_out" {
  type              = "egress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.lb_sg.id
}

#  ___ ___ ___
# | __/ __|_  )
# | _| (__ / /
# |___\___/___|

resource "aws_security_group" "wp_sg" {
  description = "Wordpress app security group"
  vpc_id      = aws_vpc.vpc.id
}

resource "aws_security_group_rule" "elb_http_in" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.lb_sg.id
  security_group_id        = aws_security_group.wp_sg.id
}

resource "aws_security_group_rule" "elb_http_out" {
  type                     = "egress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.lb_sg.id
  security_group_id        = aws_security_group.wp_sg.id
}

// Needed for SSM
resource "aws_security_group_rule" "https_out" {
  type              = "egress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"] // Could be restricted to proper endpoints
  security_group_id = aws_security_group.wp_sg.id
}

// DANGEROUS
resource "aws_security_group_rule" "debug_out" {
  type              = "egress"
  from_port         = 0
  to_port           = 65535
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.wp_sg.id
}
// DANGEROUS
resource "aws_security_group_rule" "debug_int" {
  type              = "ingress"
  from_port         = 0
  to_port           = 65535
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.wp_sg.id
}
