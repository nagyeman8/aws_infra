resource "aws_resourcegroups_group" "ecs_app_insights" {
  name = join("-", [local.name_prefix, "ecs-app-insights"])

  resource_query {
    query = jsonencode({
      ResourceTypeFilters = ["AWS::AllSupported"],
      TagFilters          = [{ Key = "env", Values = ["INT"] }]
    })
  }

  tags = merge(local.default_tags, var.mon_override_tags, { Name = "${var.project_name}-${var.env_name}-application-insights" })

  lifecycle {
    ignore_changes = [
      tags["CreatedOnDate"]
    ]
  }
}

resource "aws_applicationinsights_application" "app_insights" {
  resource_group_name = aws_resourcegroups_group.ecs_app_insights.name
  auto_config_enabled = true
  auto_create         = true

  tags = merge(local.default_tags, var.mon_override_tags, { Name = "${var.project_name}-${var.env_name}-app-insights" })

  lifecycle {
    ignore_changes = [
      tags["CreatedOnDate"]
    ]
  }
}
