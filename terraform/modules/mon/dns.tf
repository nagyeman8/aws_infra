resource "aws_route53_health_check" "react_health_check" {
  fqdn              = var.env_web_domain
  port              = 443
  type              = "HTTPS"
  resource_path     = "/"
  request_interval  = 30
  failure_threshold = 3
}

resource "aws_route53_health_check" "node_health_check" {
  fqdn              = var.env_api_domain
  port              = 443
  type              = "HTTPS"
  resource_path     = "/v1/health"
  request_interval  = 30
  failure_threshold = 3
}

resource "aws_route53_health_check" "python_health_check" {
  fqdn              = var.env_core_domain
  port              = 443
  type              = "HTTPS"
  resource_path     = "/health"
  request_interval  = 30
  failure_threshold = 3
}