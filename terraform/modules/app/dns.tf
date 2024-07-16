resource "aws_route53_zone" "zone" {
  name = var.env_domain

  tags = merge(local.default_tags, var.app_override_tags, { Name = "${var.project_name}-${var.env_name}-dns-zone" })

  lifecycle {
    ignore_changes = [
      tags["CreatedOnDate"]
    ]
  }
}

resource "aws_route53_record" "react_domain" {
  zone_id = aws_route53_zone.zone.zone_id
  name    = var.env_web_domain
  type    = "A"

  alias {
    name                   = aws_lb.react_alb.dns_name
    zone_id                = aws_lb.react_alb.zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "luster_node_domain" {
  zone_id = aws_route53_zone.zone.zone_id
  name    = var.env_api_domain
  type    = "A"

  alias {
    name                   = aws_lb.node_alb.dns_name
    zone_id                = aws_lb.node_alb.zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "python_domain" {
  zone_id = aws_route53_zone.zone.zone_id
  name    = var.env_core_domain
  type    = "A"

  alias {
    name                   = aws_lb.python_alb.dns_name
    zone_id                = aws_lb.python_alb.zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "assets_cdn" {
  zone_id = aws_route53_zone.zone.zone_id
  name    = var.cdn_domain_name
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.assets_cdn_distribution.domain_name
    zone_id                = aws_cloudfront_distribution.assets_cdn_distribution.hosted_zone_id
    evaluate_target_health = true
  }
}