variable "env_name" {
  type = string
}

variable "project_name" {
  type = string
}

variable "region" {
  type = string
}

variable "infra_email" {
  type = string
}

variable "app_email" {
  type = string
}

variable "sec_email" {
  type = string
}

variable "mon_override_tags" {
  type    = map(string)
  default = {}
}

variable "react_tg_arn_suffix" {
  type = string
}

variable "react_alb_arn_suffix" {
  type = string
}

variable "node_alb_arn_suffix" {
  type = string
}

variable "node_tg_arn_suffix" {
  type = string
}

variable "python_alb_arn_suffix" {
  type = string
}

variable "python_tg_arn_suffix" {
  type = string
}

variable "react_service_name" {
  type = string
}

variable "node_service_name" {
  type = string
}

variable "python_service_name" {
  type = string
}

variable "ecs_cluster_name" {
  type = string
}

variable "rds_db_identifier" {
  type = string
}

variable "cdn_domain_name" {
  type = string
}

variable "env_web_domain" {
  type = string
}

variable "env_api_domain" {
  type = string
}

variable "env_core_domain" {
  type = string
}