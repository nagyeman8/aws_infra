# CREATES REACT SERVICE ALERTS
resource "aws_sns_topic" "react_alerts" {
  name = "react-alerts-topic"
}


# CPU Utilization Alarm
resource "aws_cloudwatch_metric_alarm" "react_service_cpu_alarm" {
  alarm_name          = join("-", [local.name_prefix, "ReactServiceCPUAlarm"])
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = 300
  statistic           = "Average"
  threshold           = 80
  actions_enabled     = true
  alarm_description   = "Alarm when CPU exceeds 80% for the React service"
  alarm_actions       = [aws_sns_topic.react_alerts.arn] # Specify your SNS topic ARN for notifications
  dimensions = {
    ServiceName = var.react_service_name
    ClusterName = var.ecs_cluster_name
  }
}


# Memory Utilization Alarm
resource "aws_cloudwatch_metric_alarm" "react_service_memory_alarm" {
  alarm_name          = join("-", [local.name_prefix, "ReactServiceMemoryAlarm"])
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "MemoryUtilization"
  namespace           = "AWS/ECS"
  period              = 300
  statistic           = "Average"
  threshold           = 80
  actions_enabled     = true
  alarm_description   = "Alarm when Memory exceeds 80% for the React service"
  alarm_actions       = [aws_sns_topic.react_alerts.arn] # Specify your SNS topic ARN for notifications
  dimensions = {
    ServiceName = var.react_service_name
    ClusterName = var.ecs_cluster_name
  }
}


# Response Time Alarm (Assuming you are using custom metrics)
resource "aws_cloudwatch_metric_alarm" "react_service_response_time_alarm" {
  alarm_name          = join("-", [local.name_prefix, "ReactServiceResponseTimeAlarm"])
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "ResponseTime"  # Replace with the actual metric name
  namespace           = "AWS/ECS" # Replace with the namespace where the metric is published
  period              = 300
  statistic           = "Average" # Choose the appropriate statistic based on how the metric is collected
  threshold           = 500       # Set the threshold for response time (in milliseconds)
  actions_enabled     = true
  alarm_description   = "Alarm when response time exceeds 500ms for the React service"
  alarm_actions       = [aws_sns_topic.react_alerts.arn] # Specify your SNS topic ARN for notifications
  dimensions = {
    ServiceName = var.react_service_name
    ClusterName = var.ecs_cluster_name
  }
}


# Request Failures Alarm (Assuming you are using custom metrics)
resource "aws_cloudwatch_metric_alarm" "react_service_request_failures_alarm" {
  alarm_name          = join("-", [local.name_prefix, "ReactServiceRequestFailuresAlarm"])
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "RequestFailures" # Replace with the actual metric name
  namespace           = "AWS/ECS"   # Replace with the namespace where the metric is published
  period              = 300
  statistic           = "Sum" # Choose the appropriate statistic based on how the metric is collected
  threshold           = 10    # Set the threshold for request failures
  actions_enabled     = true
  alarm_description   = "Alarm when request failures exceed 10 for the React service"
  alarm_actions       = [aws_sns_topic.react_alerts.arn] # Specify your SNS topic ARN for notifications
  dimensions = {
    ServiceName = var.react_service_name
    ClusterName = var.ecs_cluster_name
  }
}


# Connection Timeout Alarm (Assuming you are using custom metrics)
resource "aws_cloudwatch_metric_alarm" "react_service_connection_timeout_alarm" {
  alarm_name          = join("-", [local.name_prefix, "ReactServiceConnectionTimeoutAlarm"])
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "ConnectionTimeout" # Replace with the actual metric name
  namespace           = "AWS/ECS"     # Replace with the namespace where the metric is published
  period              = 300
  statistic           = "Sum" # Choose the appropriate statistic based on how the metric is collected
  threshold           = 5     # Set the threshold for connection timeouts
  actions_enabled     = true
  alarm_description   = "Alarm when connection timeouts exceed 5 for the React service"
  alarm_actions       = [aws_sns_topic.react_alerts.arn] # Specify your SNS topic ARN for notifications
  dimensions = {
    ServiceName = var.react_service_name
    ClusterName = var.ecs_cluster_name
  }
}


# Health Check Status Alarm (Assuming you are using custom metrics)
resource "aws_cloudwatch_metric_alarm" "react_service_health_check_alarm" {
  alarm_name          = join("-", [local.name_prefix, "ReactServiceHealthCheckAlarm"])
  comparison_operator = "LessThanThreshold" # Assuming health check status 0 indicates healthy
  evaluation_periods  = 1
  metric_name         = "HealthCheckStatus" # Replace with the actual health check metric name
  namespace           = "AWS/ECS"     # Replace with the namespace where the health check metric is published
  period              = 60
  statistic           = "Minimum" # Choose the appropriate statistic based on how the metric is collected
  threshold           = 1         # Set the threshold for unhealthy status (e.g., 1 for unhealthy, 0 for healthy)
  actions_enabled     = true
  alarm_description   = "Alarm when health check status indicates the React service is unhealthy"
  alarm_actions       = [aws_sns_topic.react_alerts.arn] # Specify your SNS topic ARN for notifications
  dimensions = {
    ServiceName = var.react_service_name
    ClusterName = var.ecs_cluster_name
  }
}



# NODE SERVICE ALERTS
resource "aws_sns_topic" "node_alerts" {
  name = "node-alerts-topic"
}


# CPU Utilization Alarm
resource "aws_cloudwatch_metric_alarm" "node_service_cpu_alarm" {
  alarm_name          = join("-", [local.name_prefix, "NodeServiceCPUAlarm"])
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = 300
  statistic           = "Average"
  threshold           = 80
  actions_enabled     = true
  alarm_description   = "Alarm when CPU exceeds 80% for the Node service"
  alarm_actions       = [aws_sns_topic.node_alerts.arn] # Specify your SNS topic ARN for notifications
  dimensions = {
    ServiceName = var.node_service_name
    ClusterName = var.ecs_cluster_name
  }
}

# Memory Utilization Alarm
resource "aws_cloudwatch_metric_alarm" "node_service_memory_alarm" {
  alarm_name          = join("-", [local.name_prefix, "NodeServiceMemoryAlarm"])
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "MemoryUtilization"
  namespace           = "AWS/ECS"
  period              = 300
  statistic           = "Average"
  threshold           = 80
  actions_enabled     = true
  alarm_description   = "Alarm when Memory exceeds 80% for the Node service"
  alarm_actions       = [aws_sns_topic.node_alerts.arn] # Specify your SNS topic ARN for notifications
  dimensions = {
    ServiceName = var.node_service_name
    ClusterName = var.ecs_cluster_name
  }
}


# Response Time Alarm (Assuming you are using custom metrics)
resource "aws_cloudwatch_metric_alarm" "node_service_response_time_alarm" {
  alarm_name          = join("-", [local.name_prefix, "NodeServiceResponseTimeAlarm"])
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "ResponseTime"  # Replace with the actual metric name
  namespace           = "AWS/ECS" # Replace with the namespace where the metric is published
  period              = 300
  statistic           = "Average" # Choose the appropriate statistic based on how the metric is collected
  threshold           = 500       # Set the threshold for response time (in milliseconds)
  actions_enabled     = true
  alarm_description   = "Alarm when response time exceeds 500ms for the Node service"
  alarm_actions       = [aws_sns_topic.node_alerts.arn] # Specify your SNS topic ARN for notifications
  dimensions = {
    ServiceName = var.node_service_name
    ClusterName = var.ecs_cluster_name
  }
}


# Request Failures Alarm (Assuming you are using custom metrics)
resource "aws_cloudwatch_metric_alarm" "node_service_request_failures_alarm" {
  alarm_name          = join("-", [local.name_prefix, "NodeServiceRequestFailuresAlarm"])
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "RequestFailures" # Replace with the actual metric name
  namespace           = "AWS/ECS"   # Replace with the namespace where the metric is published
  period              = 300
  statistic           = "Sum" # Choose the appropriate statistic based on how the metric is collected
  threshold           = 10    # Set the threshold for request failures
  actions_enabled     = true
  alarm_description   = "Alarm when request failures exceed 10 for the Node service"
  alarm_actions       = [aws_sns_topic.node_alerts.arn] # Specify your SNS topic ARN for notifications
  dimensions = {
    ServiceName = var.node_service_name
    ClusterName = var.ecs_cluster_name
  }
}


# Connection Timeout Alarm (Assuming you are using custom metrics)
resource "aws_cloudwatch_metric_alarm" "node_service_connection_timeout_alarm" {
  alarm_name          = join("-", [local.name_prefix, "NodeServiceConnectionTimeoutAlarm"])
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "ConnectionTimeout" # Replace with the actual metric name
  namespace           = "AWS/ECS"     # Replace with the namespace where the metric is published
  period              = 300
  statistic           = "Sum" # Choose the appropriate statistic based on how the metric is collected
  threshold           = 5     # Set the threshold for connection timeouts
  actions_enabled     = true
  alarm_description   = "Alarm when connection timeouts exceed 5 for the Node service"
  alarm_actions       = [aws_sns_topic.node_alerts.arn] # Specify your SNS topic ARN for notifications
  dimensions = {
    ServiceName = var.node_service_name
    ClusterName = var.ecs_cluster_name
  }
}

# Health Check Status Alarm (Assuming you are using custom metrics)
resource "aws_cloudwatch_metric_alarm" "node_service_health_check_alarm" {
  alarm_name          = join("-", [local.name_prefix, "NodeServiceHealthCheckAlarm"])
  comparison_operator = "LessThanThreshold" # Assuming health check status 0 indicates healthy
  evaluation_periods  = 1
  metric_name         = "HealthCheckStatus" # Replace with the actual health check metric name
  namespace           = "AWS/ECS"     # Replace with the namespace where the health check metric is published
  period              = 60
  statistic           = "Minimum" # Choose the appropriate statistic based on how the metric is collected
  threshold           = 1         # Set the threshold for unhealthy status (e.g., 1 for unhealthy, 0 for healthy)
  actions_enabled     = true
  alarm_description   = "Alarm when health check status indicates the Node service is unhealthy"
  alarm_actions       = [aws_sns_topic.node_alerts.arn] # Specify your SNS topic ARN for notifications
  dimensions = {
    ServiceName = var.node_service_name
    ClusterName = var.ecs_cluster_name
  }
}



# PYTHON SERVICE ALERTS
resource "aws_sns_topic" "python_alerts" {
  name = "python-alerts-topic"
}


# CPU Utilization Alarm
resource "aws_cloudwatch_metric_alarm" "python_service_cpu_alarm" {
  alarm_name          = join("-", [local.name_prefix, "PythonServiceCPUAlarm"])
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = 300
  statistic           = "Average"
  threshold           = 80
  actions_enabled     = true
  alarm_description   = "Alarm when CPU exceeds 80% for the Python service"
  alarm_actions       = [aws_sns_topic.python_alerts.arn] # Specify your SNS topic ARN for notifications
  dimensions = {
    ServiceName = var.python_service_name
    ClusterName = var.ecs_cluster_name
  }
}


# Memory Utilization Alarm
resource "aws_cloudwatch_metric_alarm" "python_service_memory_alarm" {
  alarm_name          = join("-", [local.name_prefix, "PythonServiceMemoryAlarm"])
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "MemoryUtilization"
  namespace           = "AWS/ECS"
  period              = 300
  statistic           = "Average"
  threshold           = 80
  actions_enabled     = true
  alarm_description   = "Alarm when Memory exceeds 80% for the Python service"
  alarm_actions       = [aws_sns_topic.python_alerts.arn] # Specify your SNS topic ARN for notifications
  dimensions = {
    ServiceName = var.python_service_name
    ClusterName = var.ecs_cluster_name
  }
}


# Response Time Alarm (Assuming you are using custom metrics)
resource "aws_cloudwatch_metric_alarm" "python_service_response_time_alarm" {
  alarm_name          = join("-", [local.name_prefix, "PythonServiceResponseTimeAlarm"])
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "ResponseTime"  # Replace with the actual metric name
  namespace           = "AWS/ECS" # Replace with the namespace where the metric is published
  period              = 300
  statistic           = "Average" # Choose the appropriate statistic based on how the metric is collected
  threshold           = 500       # Set the threshold for response time (in milliseconds)
  actions_enabled     = true
  alarm_description   = "Alarm when response time exceeds 500ms for the Python service"
  alarm_actions       = [aws_sns_topic.python_alerts.arn] # Specify your SNS topic ARN for notifications
  dimensions = {
    ServiceName = var.python_service_name
    ClusterName = var.ecs_cluster_name
  }
}


# Request Failures Alarm (Assuming you are using custom metrics)
resource "aws_cloudwatch_metric_alarm" "python_service_request_failures_alarm" {
  alarm_name          = join("-", [local.name_prefix, "PythonServiceRequestFailuresAlarm"])
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "RequestFailures" # Replace with the actual metric name
  namespace           = "AWS/ECS"   # Replace with the namespace where the metric is published
  period              = 300
  statistic           = "Sum" # Choose the appropriate statistic based on how the metric is collected
  threshold           = 10    # Set the threshold for request failures
  actions_enabled     = true
  alarm_description   = "Alarm when request failures exceed 10 for the Python service"
  alarm_actions       = [aws_sns_topic.python_alerts.arn] # Specify your SNS topic ARN for notifications
  dimensions = {
    ServiceName = var.python_service_name
    ClusterName = var.ecs_cluster_name
  }
}


# Connection Timeout Alarm (Assuming you are using custom metrics)
resource "aws_cloudwatch_metric_alarm" "python_service_connection_timeout_alarm" {
  alarm_name          = join("-", [local.name_prefix, "PythonServiceConnectionTimeoutAlarm"])
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "ConnectionTimeout" # Replace with the actual metric name
  namespace           = "AWS/ECS"     # Replace with the namespace where the metric is published
  period              = 300
  statistic           = "Sum" # Choose the appropriate statistic based on how the metric is collected
  threshold           = 5     # Set the threshold for connection timeouts
  actions_enabled     = true
  alarm_description   = "Alarm when connection timeouts exceed 5 for the Python service"
  alarm_actions       = [aws_sns_topic.python_alerts.arn] # Specify your SNS topic ARN for notifications
  dimensions = {
    ServiceName = var.python_service_name
    ClusterName = var.ecs_cluster_name
  }
}


# Health Check Status Alarm (Assuming you are using custom metrics)
resource "aws_cloudwatch_metric_alarm" "python_service_health_check_alarm" {
  alarm_name          = join("-", [local.name_prefix, "PythonServiceHealthCheckAlarm"])
  comparison_operator = "LessThanThreshold" # Assuming health check status 0 indicates healthy
  evaluation_periods  = 1
  metric_name         = "HealthCheckStatus" # Replace with the actual health check metric name
  namespace           = "AWS/ECS"     # Replace with the namespace where the health check metric is published
  period              = 60
  statistic           = "Minimum" # Choose the appropriate statistic based on how the metric is collected
  threshold           = 1         # Set the threshold for unhealthy status (e.g., 1 for unhealthy, 0 for healthy)
  actions_enabled     = true
  alarm_description   = "Alarm when health check status indicates the Python service is unhealthy"
  alarm_actions       = [aws_sns_topic.python_alerts.arn] # Specify your SNS topic ARN for notifications
  dimensions = {
    ServiceName = var.python_service_name
    ClusterName = var.ecs_cluster_name
  }
}

