locals {
  project_name      = ""
  env_name          = "dev"
  region            = ""
  infra_email       = ""
  app_email         = ""
  sec_email         = ""
  mon_override_tags = {}
  cdn_domain_name   = "assets.dev.${project_name}.ai"
  env_web_domain    = "app.dev.${project_name}.ai"
  env_api_domain    = "api.dev.${project_name}.ai"
  env_core_domain   = "core.dev.${project_name}.ai"
}


# Fetch values from the remote state file
data "terraform_remote_state" "remote-app" {
  backend = "s3"
  config = {
    bucket = "bucket_name"
    key    = "bucket_key"
    region = ""
  }
}


# Fetch values from the remote state file
data "terraform_remote_state" "remote-inf" {
  backend = "s3"
  config = {
    bucket = "bucket-name"
    key    = "bucket_key"
    region = ""
  }
}


module "mon" {
  source                       = "../../../modules/mon"
  env_name                     = local.env_name
  region                       = local.region
  project_name                 = local.project_name
  infra_email                  = local.infra_email
  app_email                    = local.app_email
  sec_email                    = local.sec_email
  mon_override_tags            = local.mon_override_tags
  cdn_domain_name              = local.cdn_domain_name
  env_web_domain               = local.env_web_domain
  env_api_domain               = local.env_api_domain
  env_core_domain              = local.env_core_domain
  react_tg_arn_suffix   = data.terraform_remote_state.remote-app.outputs.react_tg_arn_suffix
  react_alb_arn_suffix  = data.terraform_remote_state.remote-app.outputs.react_alb_arn_suffix
  node_alb_arn_suffix   = data.terraform_remote_state.remote-app.outputs.node_alb_arn_suffix
  node_tg_arn_suffix    = data.terraform_remote_state.remote-app.outputs.node_tg_arn_suffix
  python_alb_arn_suffix = data.terraform_remote_state.remote-app.outputs.python_alb_arn_suffix
  python_tg_arn_suffix  = data.terraform_remote_state.remote-app.outputs.python_tg_arn_suffix
  react_service_name    = data.terraform_remote_state.remote-app.outputs.react_service_name
  node_service_name     = data.terraform_remote_state.remote-app.outputs.node_service_name
  python_service_name   = data.terraform_remote_state.remote-app.outputs.python_service_name
  ecs_cluster_name      = data.terraform_remote_state.remote-inf.outputs.ecs_cluster_name
  rds_db_identifier     = data.terraform_remote_state.remote-inf.outputs.rds_db_identifier
}


terraform {
  backend "s3" {
    bucket = "lus-dev-tfm-stg"
    key    = "mon/lusmon.tfstate"
    region = "us-east-1"
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