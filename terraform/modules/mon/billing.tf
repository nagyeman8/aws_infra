resource "aws_sns_topic" "billing_topic" {
  name = join("-", [local.name_prefix, "Billing-Topic"])
}


resource "aws_sns_topic_subscription" "billing_subscription" {
  topic_arn = aws_sns_topic.billing_topic.arn
  protocol  = "email"
  endpoint  = var.infra_email
}


resource "aws_cloudwatch_metric_alarm" "overall_billing_alarm" {
  alarm_name                = join("-", [local.name_prefix, "Overall-Billing-Alarm"])
  comparison_operator       = "GreaterThanThreshold"
  evaluation_periods        = "1"
  metric_name               = "EstimatedCharges"
  namespace                 = "AWS/Billing"
  period                    = "21600"
  statistic                 = "Maximum"
  threshold                 = "100" # Overall threshold
  alarm_description         = "Alarm when overall AWS billing exceeds $100"
  actions_enabled           = true
  alarm_actions             = [aws_sns_topic.billing_topic.arn]
  ok_actions                = [aws_sns_topic.billing_topic.arn]
  insufficient_data_actions = [aws_sns_topic.billing_topic.arn]

  dimensions = {
    Currency = "USD"
  }

  tags = merge(local.default_tags, var.mon_override_tags, { Name = "${var.project_name}-${var.env_name}-Overall-Billing-Alarm" })
  lifecycle {
    ignore_changes = [
      tags["CreatedOnDate"]
    ]
  }
}

resource "aws_cloudwatch_metric_alarm" "ecs_billing_alarm" {
  alarm_name                = join("-", [local.name_prefix, "ECS-Billing-Alarm"])
  comparison_operator       = "GreaterThanThreshold"
  evaluation_periods        = "1"
  metric_name               = "EstimatedCharges"
  namespace                 = "AWS/Billing"
  period                    = "21600"
  statistic                 = "Maximum"
  threshold                 = "20" # ECS threshold
  alarm_description         = "Alarm when ECS billing exceeds $20"
  actions_enabled           = true
  alarm_actions             = [aws_sns_topic.billing_topic.arn]
  ok_actions                = [aws_sns_topic.billing_topic.arn]
  insufficient_data_actions = [aws_sns_topic.billing_topic.arn]

  dimensions = {
    Currency = "USD"
    Service  = "AmazonECS"
  }
}

resource "aws_cloudwatch_metric_alarm" "ecr_billing_alarm" {
  alarm_name                = join("-", [local.name_prefix, "ECR-Billing-Alarm"])
  comparison_operator       = "GreaterThanThreshold"
  evaluation_periods        = "1"
  metric_name               = "EstimatedCharges"
  namespace                 = "AWS/Billing"
  period                    = "21600"
  statistic                 = "Maximum"
  threshold                 = "10" # ECR threshold
  alarm_description         = "Alarm when ECR billing exceeds $10"
  actions_enabled           = true
  alarm_actions             = [aws_sns_topic.billing_topic.arn]
  ok_actions                = [aws_sns_topic.billing_topic.arn]
  insufficient_data_actions = [aws_sns_topic.billing_topic.arn]

  dimensions = {
    Currency = "USD"
    Service  = "AmazonECR"
  }
}

resource "aws_cloudwatch_metric_alarm" "dns_billing_alarm" {
  alarm_name                = join("-", [local.name_prefix, "DNS-Billing-Alarm"])
  comparison_operator       = "GreaterThanThreshold"
  evaluation_periods        = "1"
  metric_name               = "EstimatedCharges"
  namespace                 = "AWS/Billing"
  period                    = "21600"
  statistic                 = "Maximum"
  threshold                 = "5" # DNS threshold
  alarm_description         = "Alarm when DNS billing exceeds $5"
  actions_enabled           = true
  alarm_actions             = [aws_sns_topic.billing_topic.arn]
  ok_actions                = [aws_sns_topic.billing_topic.arn]
  insufficient_data_actions = [aws_sns_topic.billing_topic.arn]

  dimensions = {
    Currency = "USD"
    Service  = "AmazonRoute53"
  }
}

resource "aws_cloudwatch_metric_alarm" "certificate_billing_alarm" {
  alarm_name                = join("-", [local.name_prefix, "Certificate-Billing-Alarm"])
  comparison_operator       = "GreaterThanThreshold"
  evaluation_periods        = "1"
  metric_name               = "EstimatedCharges"
  namespace                 = "AWS/Billing"
  period                    = "21600"
  statistic                 = "Maximum"
  threshold                 = "5" # Certificate threshold
  alarm_description         = "Alarm when Certificate billing exceeds $5"
  actions_enabled           = true
  alarm_actions             = [aws_sns_topic.billing_topic.arn]
  ok_actions                = [aws_sns_topic.billing_topic.arn]
  insufficient_data_actions = [aws_sns_topic.billing_topic.arn]

  dimensions = {
    Currency = "USD"
    Service  = "AWSCertificateManager"
  }
}

resource "aws_cloudwatch_metric_alarm" "alb_billing_alarm" {
  alarm_name                = join("-", [local.name_prefix, "ALB-Billing-Alarm"])
  comparison_operator       = "GreaterThanThreshold"
  evaluation_periods        = "1"
  metric_name               = "EstimatedCharges"
  namespace                 = "AWS/Billing"
  period                    = "21600"
  statistic                 = "Maximum"
  threshold                 = "15" # ALB threshold
  alarm_description         = "Alarm when ALB billing exceeds $15"
  actions_enabled           = true
  alarm_actions             = [aws_sns_topic.billing_topic.arn]
  ok_actions                = [aws_sns_topic.billing_topic.arn]
  insufficient_data_actions = [aws_sns_topic.billing_topic.arn]

  dimensions = {
    Currency = "USD"
    Service  = "AmazonElasticLoadBalancing"
  }
}

output "sns_topic_arn" {
  value = aws_sns_topic.billing_topic.arn
}
