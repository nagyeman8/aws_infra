# Creates Repository and Lifecycle_policy for UI
resource "aws_ecr_repository" "ui-ecr" {
  name                 = join("-", [local.name_prefix, "ui-ecr"])
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
  tags = merge(local.default_tags, var.app_override_tags, { Name = "${var.project_name}-${var.env_name}-ui-ecr" })

  lifecycle {
    ignore_changes = [
      tags["CreatedOnDate"]
    ]
  }
}


resource "aws_ecr_lifecycle_policy" "ui-ecr" {
  repository = aws_ecr_repository.ui-ecr.name

  policy = jsonencode({
    rules = [{
      rulePriority = 1
      description  = "keep last 10 images"
      action = {
        type = "expire"
      }
      selection = {
        tagStatus   = "any"
        countType   = "imageCountMoreThan"
        countNumber = 10
      }
    }]
  })
}



# Creates Repository and Lifecycle_policy for PYAPI
resource "aws_ecr_repository" "pyapi-ecr" {
  name                 = join("-", [local.name_prefix, "pyapi-ecr"])
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
  tags = merge(local.default_tags, var.app_override_tags, { Name = "${var.project_name}-${var.env_name}-pyapi-ecr" })

  lifecycle {
    ignore_changes = [
      tags["CreatedOnDate"]
    ]
  }
}


resource "aws_ecr_lifecycle_policy" "pyapi-ecr" {
  repository = aws_ecr_repository.pyapi-ecr.name

  policy = jsonencode({
    rules = [{
      rulePriority = 1
      description  = "keep last 10 images"
      action = {
        type = "expire"
      }
      selection = {
        tagStatus   = "any"
        countType   = "imageCountMoreThan"
        countNumber = 10
      }
    }]
  })
}



# Creates Repository and Lifecycle_policy for NODE
resource "aws_ecr_repository" "node-ecr" {
  name                 = join("-", [local.name_prefix, "node-ecr"])
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
  tags = merge(local.default_tags, var.app_override_tags, { Name = "${var.project_name}-${var.env_name}-node-ecr" })

  lifecycle {
    ignore_changes = [
      tags["CreatedOnDate"]
    ]
  }
}


resource "aws_ecr_lifecycle_policy" "node-ecr" {
  repository = aws_ecr_repository.node-ecr.name

  policy = jsonencode({
    rules = [{
      rulePriority = 1
      description  = "keep last 10 images"
      action = {
        type = "expire"
      }
      selection = {
        tagStatus   = "any"
        countType   = "imageCountMoreThan"
        countNumber = 10
      }
    }]
  })
}
