variable "project_name" {
  type = string
}

variable "env_name" {
  type = string
}

variable "region" {
  type = string
}

variable "env_domain" {
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


variable "app_override_tags" {
  type    = map(string)
  default = {}
}

variable "ecs_cluster_arn" {
  type = string
}

variable "ecs_cluster_name" {
  type = string
}

variable "public_subnet1_id" {
  type = string
}

variable "public_subnet2_id" {
  type = string
}

variable "private_subnet1_id" {
  type = string
}

variable "private_subnet2_id" {
  type = string
}

variable "ecs_sg_id" {
  type = string
}

variable "rds_sg_id" {
  type = string
}

variable "rds_subnet1_id" {
  type = string
}

variable "rds_subnet2_id" {
  type = string
}

variable "rds_subnet_group_id" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "cdn_domain_name" {
  type = string
}

variable "waf_shield_role" {
  type = string
}

variable "ecs_execution_role_arn" {
  type = string
}

variable "ecsTaskExecutionRole" {
  type = string
}

variable "ecsTaskRole" {
  type = string
}

variable "react_subnet1_id" {
  type = string
}

variable "node_subnet1_id" {
  type = string
}

variable "python_subnet1_id" {
  type = string
}

variable "react_subnet2_id" {
  type = string
}

variable "node_subnet2_id" {
  type = string
}

variable "python_subnet2_id" {
  type = string
}

variable "react_sg_id" {
  type = string
}

variable "node_sg_id" {
  type = string
}

variable "python_sg_id" {
  type = string
}

variable "assets_cdn_s3_rdn" {
  type = string
}

variable "assets_cdn_s3_id" {
  type = string
}