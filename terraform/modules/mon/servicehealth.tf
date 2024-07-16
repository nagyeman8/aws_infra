# Define SNS topic
resource "aws_sns_topic" "aws_service_health" {
  name = "${project_name}-aws-service-health"
}


# Creates CloudWatch Events rule for health events
resource "aws_cloudwatch_event_rule" "service_health_rule" {
  name        = "ServiceHealthRule"
  description = "Rule for AWS Service Health Events"
  event_pattern = jsonencode({
    "source" : ["aws.health"],
    "detail-type" : ["AWS Health Notification"],
    "detail" : {
      "eventTypeCategory" : ["issue"]
    }
  })
}


# Define CloudWatch Events target to trigger SNS topic
resource "aws_cloudwatch_event_target" "service_health_target" {
  rule = aws_cloudwatch_event_rule.service_health_rule.name
  arn  = aws_sns_topic.aws_service_health.arn
}


# Define CloudWatch Events rule for service maintenance events
resource "aws_cloudwatch_event_rule" "service_maintenance_rule" {
  name        = "ServiceMaintenanceRule"
  description = "Rule for AWS Service Maintenance Events"
  event_pattern = jsonencode({
    "source" : ["aws.health"],
    "detail-type" : ["AWS Health Notification"],
    "detail" : {
      "eventTypeCategory" : ["scheduledChange"],
      "eventTypeCode" : ["AWS Service Update"]
    }
  })
}


# Define CloudWatch Events target to trigger SNS topic for service maintenance events
resource "aws_cloudwatch_event_target" "service_maintenance_target" {
  rule = aws_cloudwatch_event_rule.service_maintenance_rule.name
  arn  = aws_sns_topic.aws_service_health.arn
}
