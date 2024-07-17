output "react_alb_arn_suffix" {
  value = aws_lb.react_alb.arn_suffix
}

output "react_tg_arn_suffix" {
  value = aws_lb_target_group.react_tg.arn_suffix
}

output "node_alb_arn_suffix" {
  value = aws_lb.node_alb.arn_suffix
}

output "node_tg_arn_suffix" {
  value = aws_lb_target_group.node_tg.arn_suffix
}

output "python_alb_arn_suffix" {
  value = aws_lb.python_alb.arn_suffix
}

output "python_tg_arn_suffix" {
  value = aws_lb_target_group.python_tg.arn_suffix
}

output "react_service_name" {
  value = aws_ecs_service.react_service.name
}

output "node_service_name" {
  value = aws_ecs_service.node_service.name
}

output "python_service_name" {
  value = aws_ecs_service.python_service.name
}



