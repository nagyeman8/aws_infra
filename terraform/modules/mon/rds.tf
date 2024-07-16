resource "aws_sns_topic" "{$project_name}_rds_alerts" {
  name = "rds-alerts-topic"
}


resource "aws_cloudwatch_metric_alarm" "cpu_utilization_alarm" {
  alarm_name          = join("-", [local.name_prefix, "RDS-CPU-Utilization-Alarm"])
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 3
  metric_name         = "CPUUtilization"
  namespace           = "AWS/RDS"
  period              = 300 # 5 minutes
  statistic           = "Average"
  threshold           = 80 # 80% threshold, adjust as needed
  alarm_description   = "Alarm for RDS CPU Utilization exceeding 80%"
  actions_enabled     = true
  alarm_actions       = [aws_sns_topic.rds_alerts.arn] # Replace with your SNS topic ARN

  dimensions = {
    DBInstanceIdentifier = var.rds_db_identifier # Replace with your DB InstanceIdentifier
  }

  tags = merge(local.default_tags, var.mon_override_tags, { Name = "${var.project_name}-${var.env_name}-RDS-CPU-Utilization-Alarm" })
  lifecycle {
    ignore_changes = [
      tags["CreatedOnDate"]
    ]
  }
}


resource "aws_cloudwatch_metric_alarm" "memory_utilization_alarm" {
  alarm_name          = join("-", [local.name_prefix, "RDS-Memory-Utilization-Alarm"])
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 3
  metric_name         = "FreeableMemory"
  namespace           = "AWS/RDS"
  period              = 300 # 5 minutes
  statistic           = "Average"
  threshold           = 10 # 10% threshold, adjust as needed
  alarm_description   = "Alarm for RDS Memory Utilization falling below 10%"
  actions_enabled     = true
  alarm_actions       = [aws_sns_topic.rds_alerts.arn] # Replace with your SNS topic ARN

  dimensions = {
    DBInstanceIdentifier = var.rds_db_identifier # Replace with your DB InstanceIdentifier
  }

  tags = merge(local.default_tags, var.mon_override_tags, { Name = "${var.project_name}-${var.env_name}-RDS-Memory-Utilization-Alarm" })
  lifecycle {
    ignore_changes = [
      tags["CreatedOnDate"]
    ]
  }
}


resource "aws_cloudwatch_metric_alarm" "connection_failures_alarm" {
  alarm_name          = join("-", [local.name_prefix, "RDS-Connection-Failures-Alarm"])
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = "DatabaseConnections"
  namespace           = "AWS/RDS"
  period              = 60 # 1 minute
  statistic           = "Sum"
  threshold           = 10 # Adjust as needed
  alarm_description   = "Alarm for RDS Connection Failures exceeding 10 connections"
  actions_enabled     = true
  alarm_actions       = [aws_sns_topic.rds_alerts.arn] # Replace with your SNS topic ARN

  dimensions = {
    DBInstanceIdentifier = var.rds_db_identifier # Replace with your DB InstanceIdentifier
  }

  tags = merge(local.default_tags, var.mon_override_tags, { Name = "${var.project_name}-${var.env_name}-RDS-Connection-Failures-Alarm" })
  lifecycle {
    ignore_changes = [
      tags["CreatedOnDate"]
    ]
  }
}


resource "aws_cloudwatch_metric_alarm" "connection_timeout_alarm" {
  alarm_name          = join("-", [local.name_prefix, "RDS-Connection-Timeout-Alarm"])
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 3
  metric_name         = "DatabaseConnections"
  namespace           = "AWS/RDS"
  period              = 300 # 5 minutes
  statistic           = "Sum"
  threshold           = 15 # Adjust as needed
  alarm_description   = "Alarm for RDS Connection Timeout exceeding 15 connections"
  actions_enabled     = true
  alarm_actions       = [aws_sns_topic.rds_alerts.arn] # Replace with your SNS topic ARN

  dimensions = {
    DBInstanceIdentifier = var.rds_db_identifier # Replace with your DB InstanceIdentifier
  }

  tags = merge(local.default_tags, var.mon_override_tags, { Name = "${var.project_name}-${var.env_name}-RDS-Connection-Timeout-Alarm" })
  lifecycle {
    ignore_changes = [
      tags["CreatedOnDate"]
    ]
  }
}


resource "aws_cloudwatch_metric_alarm" "storage_alarm" {
  alarm_name          = join("-", [local.name_prefix, "RDS-Storage-Alarm"])
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = 3
  metric_name         = "FreeStorageSpace"
  namespace           = "AWS/RDS"
  period              = 3600 # 1 hour
  statistic           = "Minimum"
  threshold           = 20 * 1024 * 1024 * 1024 # 20GB, adjust as needed
  alarm_description   = "Alarm for RDS Storage falling below 20GB"
  actions_enabled     = true
  alarm_actions       = [aws_sns_topic.rds_alerts.arn] # Replace with your SNS topic ARN

  dimensions = {
    DBInstanceIdentifier = var.rds_db_identifier
  }

  tags = merge(local.default_tags, var.mon_override_tags, { Name = "${var.project_name}-${var.env_name}-RDS-Storage-Alarm" })
  lifecycle {
    ignore_changes = [
      tags["CreatedOnDate"]
    ]
  }
}
