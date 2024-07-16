resource "aws_db_instance" "database" {
  db_name                      = var.db_name
  vpc_security_group_ids       = [aws_security_group.luster_rds_sg.id]
  identifier                   = "${local.name_prefix}-rds-instance"
  allocated_storage            = var.pg_allocated_storage
  max_allocated_storage        = var.pg_max_allocated_storage
  db_subnet_group_name         = aws_db_subnet_group.rds_subnet_group.name
  storage_type                 = var.pg_storage_type
  engine                       = var.pg_engine
  engine_version               = var.pg_engine_version
  instance_class               = var.pg_instance_class
  username                     = aws_ssm_parameter.name_parameter_pg.value
  password                     = aws_ssm_parameter.password_parameter_pg.value
  parameter_group_name         = aws_db_parameter_group.parameter_grp.name
  deletion_protection          = var.pg_deletion_protection
  backup_retention_period      = var.pg_backup_retention_period
  storage_encrypted            = var.pg_storage_encrypted
  performance_insights_enabled = var.pg_performance_insights_enabled
  option_group_name            = var.pg_option_group_name
  apply_immediately            = var.pg_apply_immediately
  skip_final_snapshot          = var.pg_skip_final_snapshot
  publicly_accessible          = true

  tags = merge(local.default_tags, var.inf_override_tags, { Name = "${var.project_name}-${var.env_name}-rds-instance" })

  depends_on = [aws_db_subnet_group.rds_subnet_group]

  lifecycle {
    ignore_changes = [
      tags["CreatedOnDate"]
    ]
  }
}

resource "aws_db_parameter_group" "parameter_grp" {
  name   = join("-", [local.name_prefix, "rds-db", "pg"])
  family = var.db_parameter_group_fam
}
