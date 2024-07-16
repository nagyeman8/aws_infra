resource "aws_ecs_cluster" "ecs-cluster" {
  name = join("-", [local.name_prefix, "ecs-cluster"])

  tags = merge(local.default_tags, var.inf_override_tags, { Name = "${var.project_name}-${var.env_name}-ecs-cluster" })

  lifecycle {
    ignore_changes = [
      tags["CreatedOnDate"]
    ]
  }
}