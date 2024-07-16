resource "aws_sns_topic" "container_insights_alerts" {
  name = "container-insights-alerts-topic"
}

resource "aws_cloudwatch_event_rule" "ecs_task_state_change" {
  name        = "Projectname-ECSTaskStateChange"
  description = "Rule to capture ECS Task State Change events"
  event_pattern = jsonencode({
    "source" : ["aws.ecs"],
    "detail-type" : ["ECS Task State Change"],
    "detail" : {
      "group" : ["${var.ecs_cluster_name}"]
    }
  })
}

resource "aws_cloudwatch_event_target" "sns_target" {
  rule      = aws_cloudwatch_event_rule.ecs_task_state_change.name
  target_id = "ECSStateChangeEventTarget"
  arn       = aws_sns_topic.container_insights_alerts.arn # Specify your SNS topic ARN
}
