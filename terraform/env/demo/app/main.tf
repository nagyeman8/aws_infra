locals {
  project_name      = ""
  env_name          = "demo"
  region            = ""
  cdn_domain_name   = "assets.demo.${project_name}.ai"
  app_override_tags = {}
  env_domain        = "demo.${project_name}.ai"
  env_web_domain    = "app.demo.${project_name}.ai"
  env_api_domain    = "api.demo.${project_name}.ai"
  env_core_domain   = "core.demo.${project_name}.ai"
}


# Fetch values from the remote iam state file
data "terraform_remote_state" "remote-iam" {
  backend = "s3"
  config = {
    bucket = "bucket_name"
    key    = "bucket_key"
    region = "region"
  }
}


# Fetch values from the remote inf state file
data "terraform_remote_state" "remote-inf" {
  backend = "s3"
  config = {
    bucket = "bucket_name"
    key    = "bucket_key"
    region = "region"
  }
}


module "app" {
  source                        = "../../../modules/app"
  env_name                      = local.env_name
  region                        = local.region
  project_name                  = local.project_name
  app_override_tags             = local.app_override_tags
  cdn_domain_name               = local.cdn_domain_name
  env_domain                    = local.env_domain
  env_web_domain                = local.env_web_domain
  env_api_domain                = local.env_api_domain
  env_core_domain               = local.env_core_domain
  ecs_cluster_arn        = data.terraform_remote_state.remote-inf.outputs.ecs_cluster_arn
  ecs_cluster_name       = data.terraform_remote_state.remote-inf.outputs.ecs_cluster_name
  public_subnet1_id      = data.terraform_remote_state.remote-inf.outputs.public_subnet1_id
  public_subnet2_id      = data.terraform_remote_state.remote-inf.outputs.public_subnet2_id
  private_subnet1_id     = data.terraform_remote_state.remote-inf.outputs.private_subnet1_id
  private_subnet2_id     = data.terraform_remote_state.remote-inf.outputs.private_subnet2_id
  react_subnet1_id       = data.terraform_remote_state.remote-inf.outputs.react_subnet1_id
  node_subnet1_id        = data.terraform_remote_state.remote-inf.outputs.node_subnet1_id
  python_subnet1_id      = data.terraform_remote_state.remote-inf.outputs.python_subnet1_id
  react_subnet2_id       = data.terraform_remote_state.remote-inf.outputs.react_subnet2_id
  node_subnet2_id        = data.terraform_remote_state.remote-inf.outputs.node_subnet2_id
  python_subnet2_id      = data.terraform_remote_state.remote-inf.outputs.python_subnet2_id
  react_sg_id            = data.terraform_remote_state.remote-inf.outputs.react_sg_id
  node_sg_id             = data.terraform_remote_state.remote-inf.outputs.node_sg_id
  python_sg_id           = data.terraform_remote_state.remote-inf.outputs.python_sg_id
  ecs_sg_id              = data.terraform_remote_state.remote-inf.outputs.ecs_sg_id
  rds_sg_id              = data.terraform_remote_state.remote-inf.outputs.rds_sg_id
  rds_subnet1_id         = data.terraform_remote_state.remote-inf.outputs.rds_subnet1_id
  rds_subnet2_id         = data.terraform_remote_state.remote-inf.outputs.rds_subnet2_id
  rds_subnet_group_id    = data.terraform_remote_state.remote-inf.outputs.rds_subnet_group_id
  vpc_id                 = data.terraform_remote_state.remote-inf.outputs.vpc_id
  waf_shield_role        = data.terraform_remote_state.remote-iam.outputs.waf_shield_role
  ecs_execution_role_arn = data.terraform_remote_state.remote-iam.outputs.ecs_execution_role_arn
  ecsTaskExecutionRole   = data.terraform_remote_state.remote-iam.outputs.ecsTaskExecutionRole
  ecsTaskRole            = data.terraform_remote_state.remote-iam.outputs.ecsTaskRole
  assets_cdn_s3_rdn      = data.terraform_remote_state.remote-inf.outputs.assets_cdn_s3_rdn
  assets_cdn_s3_id       = data.terraform_remote_state.remote-inf.outputs.assets_cdn_s3_id
}


terraform {
  backend "s3" {
    bucket = "bucket_name"
    key    = "bucket_key"
    region = "region"
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