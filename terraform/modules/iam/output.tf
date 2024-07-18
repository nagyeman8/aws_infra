output "fargate_task_role_arn" {
  value = aws_iam_role.fargate_task_role.arn
}

output "waf_shield_role" {
  value = aws_iam_role.waf-shield-role.arn
}

output "ecsTaskExecutionRole" {
  value = aws_iam_role.ecsTaskExecutionRole.arn
}

output "ecsTaskRole" {
  value = aws_iam_role.ecsTaskRole.arn
}