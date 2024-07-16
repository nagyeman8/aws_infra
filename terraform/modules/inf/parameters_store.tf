resource "aws_ssm_parameter" "nodeapi" {
  name  = "Backend-Env"
  type  = "SecureString"
  tier  = "Standard"
  value = "UNSET"

  tags = merge(local.default_tags, var.inf_override_tags)

  lifecycle {
    ignore_changes = [
      value,
      tags["CreatedOnDate"]
    ]
  }

}


resource "aws_ssm_parameter" "web" {
  name  = "Frontend-Env"
  type  = "SecureString"
  tier  = "Standard"
  value = "UNSET"

  tags = merge(local.default_tags, var.inf_override_tags)

  lifecycle {
    ignore_changes = [
      value,
      tags["CreatedOnDate"]
    ]
  }

}


resource "aws_ssm_parameter" "core" {
  name  = "Core-Env"
  type  = "SecureString"
  tier  = "Standard"
  value = "UNSET"

  tags = merge(local.default_tags, var.inf_override_tags)

  lifecycle {
    ignore_changes = [
      value,
      tags["CreatedOnDate"]
    ]
  }

}


resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}


resource "aws_ssm_parameter" "password_parameter_pg" {
  name  = join("-", [local.name_prefix, "rds-pg-password"])
  type  = "SecureString"
  value = var.initial_password != "" ? var.initial_password : random_password.password.result
}

resource "aws_ssm_parameter" "name_parameter_pg" {
  name  = join("-", [local.name_prefix, "rds-pg-username"])
  type  = "SecureString"
  value = "postgres"
}