locals {
  project_name = ""
  env_name     = "prod"
  region       = ""
}


module "iam" {
  source       = "../../../modules/iam"
  env_name     = local.env_name
  region       = local.region
  project_name = local.project_name
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