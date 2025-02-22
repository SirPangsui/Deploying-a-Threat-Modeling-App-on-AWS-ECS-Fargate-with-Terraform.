
# Create a Route 53 record for the root domain (e.g., camerinfoline.info)
resource "aws_route53_record" "root" {
  # Use the variable for Hosted Zone ID
  zone_id = var.hosted_zone_id
  name    = var.domain_name  # Use the provided domain name
  type    = "A"  # Type of DNS record, A for alias
  
  alias {
    name                   = aws_lb.app_alb.dns_name  # ALB DNS name
    zone_id                = aws_lb.app_alb.zone_id   # ALB Hosted Zone ID
    evaluate_target_health = true  # Evaluate the health of the target
  }
}

# Create a Route 53 record for the www subdomain (e.g., www.camerinfoline.info)
resource "aws_route53_record" "www" {
  # Use the variable for Hosted Zone ID
  zone_id = var.hosted_zone_id
  name    = "www.${var.domain_name}"  # Use the provided domain name with the "www" subdomain
  type    = "A"  # Type of DNS record, A for alias
  
  alias {
    name                   = aws_lb.app_alb.dns_name  # ALB DNS name
    zone_id                = aws_lb.app_alb.zone_id   # ALB Hosted Zone ID
    evaluate_target_health = true  # Evaluate the health of the target
  }
}
