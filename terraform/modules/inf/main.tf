locals {
  name_prefix       = join("-", [var.project_name, var.env_name])
  public_cidr_block = "0.0.0.0/0"

  default_tags = {
    CreatedOnDate = timestamp()
    env_name      = var.env_name
    project_name  = var.project_name
    CreatedBy     = "Terraform"
  }
}