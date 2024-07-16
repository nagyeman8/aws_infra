variable "project_name" {
  type = string
}

variable "env_name" {
  type = string
}

variable "region" {
  type = string
}

variable "controller_port" {
  type = string
}

variable "inf_override_tags" {
  type    = map(string)
  default = {}
}

variable "vpc_cidr" {
  type = string
}

variable "account_id" {
  type = string
}

variable "db_name" {
  type = string
}

variable "controller_task_role_arn" {
  type        = string
  description = "A custom task role to use for the ECS controller (optional)"
  default     = null
}

variable "ecs_execution_role_arn" {
  type        = string
  description = "A custom execution role to use as the ecs exection role (optional)"
  default     = null
}

variable "pg_allocated_storage" {
  type = string
}

variable "pg_max_allocated_storage" {
  type = string
}

variable "pg_storage_type" {
  type = string
}

variable "pg_engine" {
  type = string
}

variable "pg_engine_version" {
  type = string
}

variable "pg_instance_class" {
  type = string
}

variable "pg_deletion_protection" {
  type = string
}

variable "pg_backup_retention_period" {
  type = string
}

variable "pg_storage_encrypted" {
  type = string
}

variable "pg_performance_insights_enabled" {
  type = string
}

variable "pg_option_group_name" {
  type = string
}

variable "pg_apply_immediately" {
  type = string
}

variable "pg_skip_final_snapshot" {
  type = string
}

variable "db_parameter_group_fam" {
  type = string
}

variable "initial_password" {
  type = string
}

variable "ecs_execution_role_arn" {
  type = string
}

variable "vpn_ip" {
  type = string
}