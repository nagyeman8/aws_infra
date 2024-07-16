output "react_alb_arn_suffix" {
  value       = module.app.react_alb_arn_suffix
  description = "react alb arn suffix"
}

output "react_tg_arn_suffix" {
  value       = module.app.react_tg_arn_suffix
  description = "react target group arn suffix"
}

output "node_alb_arn_suffix" {
  value       = module.app.node_alb_arn_suffix
  description = "node alb arn suffix"
}

output "node_tg_arn_suffix" {
  value       = module.app.node_tg_arn_suffix
  description = "node target group arn suffix"
}

output "python_alb_arn_suffix" {
  value       = module.app.python_alb_arn_suffix
  description = "python alb arn suffix"
}

output "python_tg_arn_suffix" {
  value       = module.app.python_tg_arn_suffix
  description = "python target group arn suffix"
}

output "react_service_name" {
  value       = module.app.react_service_name
  description = "react ecs service name"
}

output "node_service_name" {
  value       = module.app.node_service_name
  description = "node ecs service name"
}

output "python_service_name" {
  value       = module.app.python_service_name
  description = "python ecs service name"
}