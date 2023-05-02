#  ___  _  _ ___ 
# |   \| \| / __|
# | |) | .` \__ \
# |___/|_|\_|___/

resource "aws_route53_zone" "primary" {
  name = var.domain
}

// record for our website to our load balancer
resource "aws_route53_record" "primary" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = var.domain
  type    = "A"
  ttl     = 60
  records = data.dns_a_record_set.lb_ip.addrs
}

#  ___ ___ _    
# / __/ __| |   
# \__ \__ \ |__ 
# |___/___/____|


// SSL certificate
resource "aws_acm_certificate" "cert" {
  domain_name       = var.domain
  validation_method = "DNS"
}

// SSL certificate DNS
resource "aws_route53_record" "cert_dns" {
  for_each = {
    for dvo in aws_acm_certificate.cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type

  zone_id = aws_route53_zone.primary.zone_id
}

// SSL certificate validation
resource "aws_acm_certificate_validation" "primary" {
  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = [for record in aws_route53_record.cert_dns : record.fqdn]
}
