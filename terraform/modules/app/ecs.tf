# Define CloudWatch Log Groups
resource "aws_cloudwatch_log_group" "ecs_react_log_group" {
  name              = "react-web-logs"
  retention_in_days = 30
}


resource "aws_cloudwatch_log_group" "ecs_node_log_group" {
  name              = "node-api-logs"
  retention_in_days = 30
}


resource "aws_cloudwatch_log_group" "ecs_python_log_group" {
  name              = "python-core-logs"
  retention_in_days = 30
}


resource "aws_cloudwatch_log_group" "api" {
  name              = "api"
  retention_in_days = 30
}


resource "aws_cloudwatch_log_group" "apiint" {
  name              = "apiint"
  retention_in_days = 30
}


# ECS Task Definitions
resource "aws_ecs_task_definition" "react_task" {
  family                   = join("-", [local.name_prefix, "react-task"])
  execution_role_arn       = var.ecsTaskExecutionRole
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "1024"
  memory                   = "3072"
  task_role_arn            = var.ecsTaskRole

  container_definitions = jsonencode([
    {
      name      = "react-container"
      image     = "${aws_ecr_repository.ui-ecr.repository_url}:latest"
      essential = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
          protocol      = "tcp"
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.ecs_react_log_group.name
          "awslogs-region"        = var.region
          "awslogs-stream-prefix" = "react-container"
        }
      },
      mountPoints = [
        {
          sourceVolume  = "data-volume"
          containerPath = "/app/data"
          readOnly      = false
        }
      ]
    }
  ])

  volume {
    name = "data-volume"
  }

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }

  tags = merge(local.default_tags, var.app_override_tags, { Name = "${var.project_name}-${var.env_name}-react-task" })

  lifecycle {
    ignore_changes = [
      tags["CreatedOnDate"]
    ]
  }
}


resource "aws_ecs_task_definition" "node_task" {
  family                   = join("-", [local.name_prefix, "node-task"])
  execution_role_arn       = var.ecsTaskExecutionRole
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "1024"
  memory                   = "3072"
  task_role_arn            = var.ecsTaskRole

  container_definitions = jsonencode([
    {
      name      = "node-container"
      image     = "${aws_ecr_repository.node-ecr.repository_url}:latest"
      essential = true
      portMappings = [
        {
          containerPort = 3000
          hostPort      = 3000
          protocol      = "tcp"
        }
      ],
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.ecs_node_log_group.name
          "awslogs-region"        = var.region
          "awslogs-stream-prefix" = "node-container"
        }
      }
    }
  ])

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }

  tags = merge(local.default_tags, var.app_override_tags, { Name = "${var.project_name}-${var.env_name}-node-task" })

  lifecycle {
    ignore_changes = [
      tags["CreatedOnDate"]
    ]
  }
}


resource "aws_ecs_task_definition" "python_task" {
  family                   = join("-", [local.name_prefix, "python-task"])
  execution_role_arn       = var.ecsTaskExecutionRole
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "1024"
  memory                   = "3072"
  task_role_arn            = var.ecsTaskRole

  container_definitions = jsonencode([
    {
      name      = "python-container"
      image     = "${aws_ecr_repository.pyapi-ecr.repository_url}:latest"
      essential = true
      portMappings = [
        {
          containerPort = 8080
          hostPort      = 8080
          protocol      = "tcp"
        }
      ],
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.ecs_python_log_group.name
          "awslogs-region"        = var.region
          "awslogs-stream-prefix" = "python-container"
        }
      },
      mountPoints = [
        {
          sourceVolume  = "data-volume"
          containerPath = "/app/data"
          readOnly      = true
        }
      ]
    }
  ])

  volume {
    name = "data-volume"
  }

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }

  tags = merge(local.default_tags, var.app_override_tags, { Name = "${var.project_name}-${var.env_name}-python-task" })

  lifecycle {
    ignore_changes = [
      tags["CreatedOnDate"]
    ]
  }
}


# ECS Services
resource "aws_ecs_service" "react_service" {
  name            = join("-", [local.name_prefix, "react-service"])
  cluster         = var.ecs_cluster_arn
  task_definition = aws_ecs_task_definition.react_task.arn
  launch_type     = "FARGATE"
  desired_count   = 2

  network_configuration {
    subnets          = [var.react_subnet1_id, var.react_subnet2_id]
    security_groups  = [var.react_sg_id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.react_tg.arn
    container_name   = "react-container"
    container_port   = 80
  }

  depends_on = [aws_lb_target_group.react_tg]
}

resource "aws_ecs_service" "node_service" {
  name            = join("-", [local.name_prefix, "node-service"])
  cluster         = var.ecs_cluster_arn
  task_definition = aws_ecs_task_definition.node_task.arn
  launch_type     = "FARGATE"
  desired_count   = 2

  network_configuration {
    subnets          = [var.node_subnet1_id, var.node_subnet2_id]
    security_groups  = [var.node_sg_id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.node_tg.arn
    container_name   = "node-container"
    container_port   = 3000
  }

  depends_on = [aws_lb_target_group.node_to_python_tg]
}


resource "aws_ecs_service" "python_service" {
  name            = join("-", [local.name_prefix, "python-service"])
  cluster         = var.ecs_cluster_arn
  task_definition = aws_ecs_task_definition.python_task.arn
  launch_type     = "FARGATE"
  desired_count   = 2

  network_configuration {
    subnets          = [var.python_subnet1_id, var.python_subnet2_id]
    security_groups  = [var.python_sg_id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.python_tg.arn
    container_name   = "python-container"
    container_port   = 8080
  }

  depends_on = [aws_lb_target_group.node_to_python_tg]
}


# Auto Scaling Targets and Policies
# React Service
resource "aws_appautoscaling_target" "react_service_scaling_target" {
  max_capacity       = 10
  min_capacity       = 2
  resource_id        = "service/${var.ecs_cluster_name}/${aws_ecs_service.react_service.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "react_service_cpu_policy" {
  name               = "react-service-cpu-policy"
  resource_id        = aws_appautoscaling_target.react_service_scaling_target.resource_id
  scalable_dimension = aws_appautoscaling_target.react_service_scaling_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.react_service_scaling_target.service_namespace
  policy_type        = "TargetTrackingScaling"

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }

    target_value       = 80.0
    scale_in_cooldown  = 60
    scale_out_cooldown = 60
  }
}


resource "aws_appautoscaling_policy" "react_service_memory_policy" {
  name               = "react-service-memory-policy"
  resource_id        = aws_appautoscaling_target.react_service_scaling_target.resource_id
  scalable_dimension = aws_appautoscaling_target.react_service_scaling_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.react_service_scaling_target.service_namespace
  policy_type        = "TargetTrackingScaling"

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageMemoryUtilization"
    }

    target_value       = 80.0
    scale_in_cooldown  = 60
    scale_out_cooldown = 60
  }
}


# Node Service
resource "aws_appautoscaling_target" "node_service_scaling_target" {
  max_capacity       = 10
  min_capacity       = 2
  resource_id        = "service/${var.ecs_cluster_name}/${aws_ecs_service.node_service.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}


resource "aws_appautoscaling_policy" "node_service_cpu_policy" {
  name               = "node-service-cpu-policy"
  resource_id        = aws_appautoscaling_target.node_service_scaling_target.resource_id
  scalable_dimension = aws_appautoscaling_target.node_service_scaling_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.node_service_scaling_target.service_namespace
  policy_type        = "TargetTrackingScaling"

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }

    target_value       = 80.0
    scale_in_cooldown  = 60
    scale_out_cooldown = 60
  }
}


resource "aws_appautoscaling_policy" "node_service_memory_policy" {
  name               = "node-service-memory-policy"
  resource_id        = aws_appautoscaling_target.node_service_scaling_target.resource_id
  scalable_dimension = aws_appautoscaling_target.node_service_scaling_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.node_service_scaling_target.service_namespace
  policy_type        = "TargetTrackingScaling"

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageMemoryUtilization"
    }

    target_value       = 80.0
    scale_in_cooldown  = 60
    scale_out_cooldown = 60
  }
}


# Python Service
resource "aws_appautoscaling_target" "python_service_scaling_target" {
  max_capacity       = 10
  min_capacity       = 2
  resource_id        = "service/${var.ecs_cluster_name}/${aws_ecs_service.python_service.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}


resource "aws_appautoscaling_policy" "python_service_cpu_policy" {
  name               = "python-service-cpu-policy"
  resource_id        = aws_appautoscaling_target.python_service_scaling_target.resource_id
  scalable_dimension = aws_appautoscaling_target.python_service_scaling_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.python_service_scaling_target.service_namespace
  policy_type        = "TargetTrackingScaling"

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }

    target_value       = 80.0
    scale_in_cooldown  = 60
    scale_out_cooldown = 60
  }
}


resource "aws_appautoscaling_policy" "python_service_memory_policy" {
  name               = "python-service-memory-policy"
  resource_id        = aws_appautoscaling_target.python_service_scaling_target.resource_id
  scalable_dimension = aws_appautoscaling_target.python_service_scaling_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.python_service_scaling_target.service_namespace
  policy_type        = "TargetTrackingScaling"

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageMemoryUtilization"
    }

    target_value       = 80.0
    scale_in_cooldown  = 60
    scale_out_cooldown = 60
  }
}


# Monitoring and Tracing
resource "aws_xray_sampling_rule" "xray" {
  rule_name      = join("-", [local.name_prefix, "xray"])
  priority       = 9999
  fixed_rate     = 0.05
  reservoir_size = 1
  resource_arn   = "*"
  service_name   = "*"
  service_type   = "*"
  host           = "*"
  http_method    = "*"
  url_path       = "*"
  version        = 1

  tags = merge(local.default_tags, var.app_override_tags, { Name = "${var.project_name}-${var.env_name}-xray-sampling-rule" })

  lifecycle {
    ignore_changes = [
      tags["CreatedOnDate"]
    ]
  }
}