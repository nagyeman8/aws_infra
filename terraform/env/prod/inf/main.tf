locals {
  project_name                    = ""
  env_name                        = "prod"
  db_name                         = ""
  vpc_cidr                        = ""
  region                          = ""
  controller_port                 = "3000"
  account_id                      = ""
  controller_task_role_arn        = ""
  pg_allocated_storage            = "30"
  pg_max_allocated_storage        = "100"
  pg_storage_type                 = "gp2"
  pg_engine                       = "postgres"
  pg_engine_version               = "16.2"
  pg_instance_class               = "db.t3.small"
  pg_backup_retention_period      = "30"
  pg_deletion_protection          = "true"
  pg_storage_encrypted            = "true"
  pg_performance_insights_enabled = "true"
  pg_option_group_name            = ""
  pg_apply_immediately            = "true"
  pg_skip_final_snapshot          = "true"
  db_parameter_group_fam          = "postgres16"
  inf_override_tags               = {}
  vpn_ip                          = ""

}


# Fetch values from the remote state file
data "terraform_remote_state" "remote-iam" {
  backend = "s3"
  config = {
    bucket = "bucket_name"
    key    = "bucket_key"
    region = ""
  }
}


module "inf" {
  source                          = "../../../modules/inf"
  controller_port                 = local.controller_port
  env_name                        = local.env_name
  region                          = local.region
  project_name                    = local.project_name
  vpc_cidr                        = local.vpc_cidr
  account_id                      = local.account_id
  inf_override_tags               = local.inf_override_tags
  controller_task_role_arn        = local.controller_task_role_arn
  pg_allocated_storage            = local.pg_allocated_storage
  pg_max_allocated_storage        = local.pg_max_allocated_storage
  pg_storage_type                 = local.pg_storage_type
  pg_engine                       = local.pg_engine
  pg_engine_version               = local.pg_engine_version
  pg_instance_class               = local.pg_instance_class
  pg_backup_retention_period      = local.pg_backup_retention_period
  pg_deletion_protection          = local.pg_deletion_protection
  pg_storage_encrypted            = local.pg_storage_encrypted
  pg_performance_insights_enabled = local.pg_performance_insights_enabled
  pg_option_group_name            = local.pg_option_group_name
  pg_apply_immediately            = local.pg_apply_immediately
  pg_skip_final_snapshot          = local.pg_skip_final_snapshot
  db_parameter_group_fam          = local.db_parameter_group_fam
  initial_password                = ""
  db_name                         = local.db_name
  ecs_execution_role_arn          = data.terraform_remote_state.remote-iam.outputs.ecs_execution_role_arn
  vpn_ip                          = local.vpn_ip
}


terraform {
  backend "s3" {
    bucket = "bucket_name"
    key    = "bucket_key"
    region = ""
  }
}


terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "=5.46.0"
    }
    null = {
      source  = "hashicorp/null"
      version = ">= 3.0.0"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.0.0"
    }
  }
}


provider "aws" {
  region = local.region
}