output "ecs_execution_role_arn" {
  value       = module.iam.fargate_task_role_arn
  description = "ecs execution role arn"
}


output "waf_shield_role" {
  value       = module.iam.waf_shield_role
  description = "waf shield role"
}


output "ecsTaskExecutionRole" {
  value       = module.iam.ecsTaskExecutionRole
  description = "ecs Task Execution Role"
}


output "ecsTaskRole" {
  value       = module.iam.ecsTaskRole
  description = "ecs Task Role"
}

