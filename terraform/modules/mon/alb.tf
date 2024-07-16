# Data Source for Caller Identity
data "aws_caller_identity" "current" {}


# CREATES SNS TOPIC and SUBSCRIPTION for ALB alerts
resource "aws_sns_topic" "alb_alerts" {
  name = "alb-alerts-topic"
}


resource "aws_sns_topic_subscription" "email_subscription" {
  topic_arn = aws_sns_topic.alb_alerts.arn
  protocol  = "email"
  endpoint  = var.infra_email
}



# CREATES SNS TOPIC and SUBSCRIPTION for SECURITY ALERTS
resource "aws_sns_topic" "security_alerts" {
  name = "security-alerts-topic"
}


resource "aws_sns_topic_subscription" "security_email_subscription" {
  topic_arn = aws_sns_topic.security_alerts.arn
  protocol  = "email"
  endpoint  = var.sec_email
}



# CREATES CLOUDWATCH ALARMS for REACT ALB
resource "aws_cloudwatch_metric_alarm" "react_alb_high_latency" {
  alarm_name          = join("-", [local.name_prefix, "ReactALBHighLatency"])
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "Latency"
  namespace           = "AWS/ApplicationELB"
  period              = 60
  statistic           = "Average"
  threshold           = 0.5
  alarm_description   = "This metric monitors high latency for React ALB"
  dimensions = {
    LoadBalancer = var.react_alb_arn_suffix
  }
  alarm_actions = [aws_sns_topic.alb_alerts.arn]
}


resource "aws_cloudwatch_metric_alarm" "react_alb_unhealthy_hosts" {
  alarm_name          = join("-", [local.name_prefix, "ReactALBUnhealthyHosts"])
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "UnHealthyHostCount"
  namespace           = "AWS/ApplicationELB"
  period              = 60
  statistic           = "Average"
  threshold           = 1
  alarm_description   = "This metric monitors unhealthy hosts for React ALB"
  dimensions = {
    TargetGroup  = var.react_tg_arn_suffix,
    LoadBalancer = var.react_alb_arn_suffix
  }
  alarm_actions = [aws_sns_topic.alb_alerts.arn]
}


resource "aws_cloudwatch_metric_alarm" "react_alb_high_request_count" {
  alarm_name          = join("-", [local.name_prefix, "ReactALBHighRequestCount"])
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "RequestCount"
  namespace           = "AWS/ApplicationELB"
  period              = 60
  statistic           = "Sum"
  threshold           = 1000
  alarm_description   = "This metric monitors high request count for React ALB"
  dimensions = {
    LoadBalancer = var.react_alb_arn_suffix
  }
  alarm_actions = [aws_sns_topic.alb_alerts.arn]
}



# CREATES CLOUDWATCH ALARMS for NODE ALB
resource "aws_cloudwatch_metric_alarm" "node_alb_high_latency" {
  alarm_name          = join("-", [local.name_prefix, "NodeALBHighLatency"])
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "Latency"
  namespace           = "AWS/ApplicationELB"
  period              = 60
  statistic           = "Average"
  threshold           = 0.5
  alarm_description   = "This metric monitors high latency for Node ALB"
  dimensions = {
    LoadBalancer = var.node_alb_arn_suffix
  }
  alarm_actions = [aws_sns_topic.alb_alerts.arn]
}


resource "aws_cloudwatch_metric_alarm" "node_alb_unhealthy_hosts" {
  alarm_name          = join("-", [local.name_prefix, "NodeALBUnhealthyHosts"])
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "UnHealthyHostCount"
  namespace           = "AWS/ApplicationELB"
  period              = 60
  statistic           = "Average"
  threshold           = 1
  alarm_description   = "This metric monitors unhealthy hosts for Node ALB"
  dimensions = {
    TargetGroup  = var.node_tg_arn_suffix,
    LoadBalancer = var.node_alb_arn_suffix
  }
  alarm_actions = [aws_sns_topic.alb_alerts.arn]
}


resource "aws_cloudwatch_metric_alarm" "node_alb_high_request_count" {
  alarm_name          = join("-", [local.name_prefix, "NodeALBHighRequestCount"])
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "RequestCount"
  namespace           = "AWS/ApplicationELB"
  period              = 60
  statistic           = "Sum"
  threshold           = 1000
  alarm_description   = "This metric monitors high request count for Node ALB"
  dimensions = {
    LoadBalancer = var.node_alb_arn_suffix
  }
  alarm_actions = [aws_sns_topic.alb_alerts.arn]
}



# CREATES CLOUDWATCH ALARMS for PYTHON ALB
resource "aws_cloudwatch_metric_alarm" "python_alb_high_latency" {
  alarm_name          = join("-", [local.name_prefix, "PythonALBHighLatency"])
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "Latency"
  namespace           = "AWS/ApplicationELB"
  period              = 60
  statistic           = "Average"
  threshold           = 0.5
  alarm_description   = "This metric monitors high latency for Python ALB"
  dimensions = {
    LoadBalancer = var.python_alb_arn_suffix
  }
  alarm_actions = [aws_sns_topic.alb_alerts.arn]
}


resource "aws_cloudwatch_metric_alarm" "python_alb_unhealthy_hosts" {
  alarm_name          = join("-", [local.name_prefix, "PythonALBUnhealthyHosts"])
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "UnHealthyHostCount"
  namespace           = "AWS/ApplicationELB"
  period              = 60
  statistic           = "Average"
  threshold           = 1
  alarm_description   = "This metric monitors unhealthy hosts for Python ALB"
  dimensions = {
    TargetGroup  = var.python_tg_arn_suffix,
    LoadBalancer = var.python_alb_arn_suffix
  }
  alarm_actions = [aws_sns_topic.alb_alerts.arn]
}


resource "aws_cloudwatch_metric_alarm" "python_alb_high_request_count" {
  alarm_name          = join("-", [local.name_prefix, "PythonALBHighRequestCount"])
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "RequestCount"
  namespace           = "AWS/ApplicationELB"
  period              = 60
  statistic           = "Sum"
  threshold           = 1000
  alarm_description   = "This metric monitors high request count for Python ALB"
  dimensions = {
    LoadBalancer = var.python_alb_arn_suffix
  }
  alarm_actions = [aws_sns_topic.alb_alerts.arn]
}



# CREATES CLOUDTRAIL to MONITOR SECURITY GROUP CHANGES
resource "aws_cloudtrail" "main" {
  name                          = join("-", [local.name_prefix, "security-audit-trail"])
  s3_bucket_name                = aws_s3_bucket.trail_bucket.id
  include_global_service_events = true
  is_multi_region_trail         = true
  enable_logging                = true

  event_selector {
    read_write_type           = "All"
    include_management_events = true

    data_resource {
      type   = "AWS::S3::Object"
      values = ["arn:aws:s3:::${aws_s3_bucket.trail_bucket.id}/"]
    }
  }

  tags = merge(local.default_tags, { Name = join("-", [local.name_prefix, "security-audit-trail"]) })
}



# CREATES S3 BUCKET for CLOUDTRAIL
resource "aws_s3_bucket" "trail_bucket" {
  bucket = join("-", [local.name_prefix, "security-audit-trail"])

  tags = merge(local.default_tags, var.mon_override_tags, { Name = "${var.project_name}-${var.env_name}-cdn-stg" })
  lifecycle {
    ignore_changes = [
      tags["CreatedOnDate"]
    ]
  }
}



# S3 BUCKET POLICY for CLOUDTRAIL
resource "aws_s3_bucket_policy" "cloudtrail_policy" {
  bucket = aws_s3_bucket.trail_bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "cloudtrail.amazonaws.com"
        }
        Action   = "s3:GetBucketAcl"
        Resource = aws_s3_bucket.trail_bucket.arn
      },
      {
        Effect = "Allow"
        Principal = {
          Service = "cloudtrail.amazonaws.com"
        }
        Action   = "s3:PutObject"
        Resource = "${aws_s3_bucket.trail_bucket.arn}/AWSLogs/${data.aws_caller_identity.current.account_id}/*"
        Condition = {
          StringEquals = {
            "s3:x-amz-acl" = "bucket-owner-full-control"
          }
        }
      }
    ]
  })
}



# CLOUDWATCH LOGS METRIC FILTER and ALARM for SECURITY GROUP CHANGES
resource "aws_cloudwatch_log_group" "trail_log_group" {
  name = join("-", [local.name_prefix, "cloudtrail-security"])
}


resource "aws_cloudwatch_log_metric_filter" "security_group_changes" {
  name           = join("-", [local.name_prefix, "SecurityGroupChanges"])
  log_group_name = aws_cloudwatch_log_group.trail_log_group.name
  pattern        = "{ ($.eventName = AuthorizeSecurityGroupIngress) || ($.eventName = RevokeSecurityGroupIngress) || ($.eventName = AuthorizeSecurityGroupEgress) || ($.eventName = RevokeSecurityGroupEgress) }"

  metric_transformation {
    name      = join("-", [local.name_prefix, "SecurityGroupChanges"])
    namespace = join("-", [local.name_prefix, "Security"])
    value     = "1"
  }
}


resource "aws_cloudwatch_metric_alarm" "security_group_changes_alarm" {
  alarm_name          = join("-", [local.name_prefix, "SecurityGroupChangesAlarm"])
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = join("-", [local.name_prefix, "SecurityGroupChanges"])
  namespace           = join("-", [local.name_prefix, "Security"])
  period              = 60
  statistic           = "Sum"
  threshold           = 1
  alarm_description   = "This alarm triggers when there are security group changes"
  alarm_actions       = [aws_sns_topic.security_alerts.arn]
}