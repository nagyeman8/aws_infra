# WAF IP Set
resource "aws_wafv2_ip_set" "ip_set" {
  name               = join("-", [local.name_prefix, "ip-set"])
  description        = "IP Set for application"
  scope              = "REGIONAL"
  ip_address_version = "IPV4"

  addresses = [
    # Add IP addresses or ranges here, for example:
    "10.50.0.0/16",
  ]

  tags = merge(local.default_tags, var.app_override_tags, { Name = "${var.project_name}-${var.env_name}-ip-set" })

  lifecycle {
    ignore_changes = [
      tags["CreatedOnDate"]
    ]
  }
}


# WAF Rule Group
resource "aws_wafv2_rule_group" "rule_group" {
  name     = join("-", [local.name_prefix, "rule-group"])
  scope    = "REGIONAL"
  capacity = 100

  rule {
    name     = "IPBlacklistRule"
    priority = 1

    statement {
      ip_set_reference_statement {
        arn = aws_wafv2_ip_set.ip_set.arn
      }
    }

    action {
      block {}
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "IPBlacklistRule"
      sampled_requests_enabled   = true
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = join("-", [local.name_prefix, "rule-group"])
    sampled_requests_enabled   = true
  }
}


# WAF Web ACL
resource "aws_wafv2_web_acl" "web_acl" {
  name  = join("-", [local.name_prefix, "web-acl"])
  scope = "REGIONAL"
  default_action {
    allow {}
  }

  rule {
    name     = "RuleGroup"
    priority = 1

    override_action {
      none {}
    }

    statement {
      rule_group_reference_statement {
        arn = aws_wafv2_rule_group.rule_group.arn
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "RuleGroup"
      sampled_requests_enabled   = true
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = join("-", [local.name_prefix, "web-acl"])
    sampled_requests_enabled   = true
  }

  tags = merge(local.default_tags, var.app_override_tags, { Name = "${var.project_name}-${var.env_name}-web-acl" })

  lifecycle {
    ignore_changes = [
      tags["CreatedOnDate"]
    ]
  }
}


# WAF Association with Load Balancers
resource "aws_wafv2_web_acl_association" "react_waf_association" {
  resource_arn = aws_lb.react_alb.arn
  web_acl_arn  = aws_wafv2_web_acl.web_acl.arn
}

resource "aws_wafv2_web_acl_association" "node_waf_association" {
  resource_arn = aws_lb.node_alb.arn
  web_acl_arn  = aws_wafv2_web_acl.web_acl.arn
}

resource "aws_wafv2_web_acl_association" "python_waf_association" {
  resource_arn = aws_lb.python_alb.arn
  web_acl_arn  = aws_wafv2_web_acl.web_acl.arn
}
