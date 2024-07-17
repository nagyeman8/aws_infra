# Creates REACT ACM Cert, Record, Validation and Zone
resource "aws_acm_certificate" "react_cert" {
  domain_name       = var.env_web_domain
  validation_method = "DNS"

  tags = merge(local.default_tags, var.app_override_tags, { Name = "${var.project_name}-${var.env_name}-web-cert" })

  lifecycle {
    create_before_destroy = true
    ignore_changes = [
      tags["CreatedOnDate"]
    ]
  }
}


resource "aws_route53_record" "react_cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.react_cert.domain_validation_options : dvo.domain_name => {
      name  = dvo.resource_record_name
      type  = dvo.resource_record_type
      value = dvo.resource_record_value
    }
  }

  zone_id = aws_route53_zone.zone.zone_id
  name    = each.value.name
  type    = each.value.type
  records = [each.value.value]
  ttl     = 60
}


resource "aws_acm_certificate_validation" "react_cert" {
  certificate_arn         = aws_acm_certificate.react_cert.arn
  validation_record_fqdns = [for record in aws_route53_record.react_cert_validation : record.fqdn]
}



# Creates NODE ACM Cert, Record, Validation and Zone
resource "aws_acm_certificate" "node_cert" {
  domain_name       = var.env_api_domain
  validation_method = "DNS"

  tags = merge(local.default_tags, var.app_override_tags, { Name = "${var.project_name}-${var.env_name}-api-cert" })

  lifecycle {
    create_before_destroy = true
    ignore_changes = [
      tags["CreatedOnDate"]
    ]
  }
}


resource "aws_route53_record" "node_cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.node_cert.domain_validation_options : dvo.domain_name => {
      name  = dvo.resource_record_name
      type  = dvo.resource_record_type
      value = dvo.resource_record_value
    }
  }

  zone_id = aws_route53_zone.zone.zone_id
  name    = each.value.name
  type    = each.value.type
  records = [each.value.value]
  ttl     = 60
}


resource "aws_acm_certificate_validation" "node_cert" {
  certificate_arn         = aws_acm_certificate.node_cert.arn
  validation_record_fqdns = [for record in aws_route53_record.node_cert_validation : record.fqdn]
}



# Creates PYTHON ACM Cert, Record, Validation and Zone
resource "aws_acm_certificate" "python_cert" {
  domain_name       = var.env_core_domain
  validation_method = "DNS"

  tags = merge(local.default_tags, var.app_override_tags, { Name = "${var.project_name}-${var.env_name}-api-cert" })

  lifecycle {
    create_before_destroy = true
    ignore_changes = [
      tags["CreatedOnDate"]
    ]
  }
}


resource "aws_route53_record" "python_cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.python_cert.domain_validation_options : dvo.domain_name => {
      name  = dvo.resource_record_name
      type  = dvo.resource_record_type
      value = dvo.resource_record_value
    }
  }

  zone_id = aws_route53_zone.zone.zone_id
  name    = each.value.name
  type    = each.value.type
  records = [each.value.value]
  ttl     = 60
}


resource "aws_acm_certificate_validation" "python_cert" {
  certificate_arn         = aws_acm_certificate.python_cert.arn
  validation_record_fqdns = [for record in aws_route53_record.python_cert_validation : record.fqdn]
}



# Creates ASSETS ACM Cert, Record, Validation and Zone
resource "aws_acm_certificate" "assets_cert" {
  domain_name       = var.cdn_domain_name
  validation_method = "DNS"

  tags = merge(local.default_tags, var.app_override_tags, { Name = "${var.project_name}-${var.env_name}-assets-cert" })

  lifecycle {
    create_before_destroy = true
    ignore_changes = [
      tags["CreatedOnDate"]
    ]
  }
}


resource "aws_route53_record" "assets_cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.assets_cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      type   = dvo.resource_record_type
      record = dvo.resource_record_value
    }
  }

  zone_id = aws_route53_zone.zone.zone_id
  name    = each.value.name
  type    = each.value.type
  ttl     = 300
  records = [each.value.record]
}


resource "aws_acm_certificate_validation" "assets_cert_validation" {
  certificate_arn         = aws_acm_certificate.assets_cert.arn
  validation_record_fqdns = [for record in aws_route53_record.assets_cert_validation : record.fqdn]
}