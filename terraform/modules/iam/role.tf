
data "aws_iam_policy_document" "fargate_task_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}


data "aws_iam_policy_document" "ecs_secret_policy" {
  statement {
    effect = "Allow"
    actions = [
      "ecr:BatchCheckLayerAvailability",
      "ecr:BatchGetImage",
      "ecr:GetDownloadUrlForLayer",
      "ecr:GetAuthorizationToken",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = ["*"
    ]
  }
}


resource "aws_iam_role" "fargate_task_role" {
  name               = join("-", [local.name_prefix, "fargate-task-role"])
  assume_role_policy = data.aws_iam_policy_document.fargate_task_policy.json

  tags = merge(local.default_tags, var.iam_override_tags, { Name = "${var.project_name}-${var.env_name}-fargate-task-role" })

  lifecycle {
    ignore_changes = [
      tags["CreatedOnDate"]
    ]
  }
}


resource "aws_iam_policy" "secret_policy" {
  name   = join("-", [local.name_prefix, "fargate-task-policy"])
  policy = data.aws_iam_policy_document.ecs_secret_policy.json

  tags = merge(local.default_tags, var.iam_override_tags, { Name = "${var.project_name}-${var.env_name}-fargate-task-policy" })

  lifecycle {
    ignore_changes = [
      tags["CreatedOnDate"]
    ]
  }
}


resource "aws_iam_role_policy_attachment" "task_attachment" {
  role       = aws_iam_role.fargate_task_role.name
  policy_arn = aws_iam_policy.secret_policy.arn
}


resource "aws_iam_role" "waf-shield-role" {
  name = join("-", [local.name_prefix, "waf-shield-role"])
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "shield.amazonaws.com"
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })
}


resource "aws_iam_role" "ecr_ecs_role" {
  name = join("-", [local.name_prefix, "ecr-ecs-role"])

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = [
            "ecs-tasks.amazonaws.com",
            "ecr.amazonaws.com"
          ]
        }
      }
    ]
  })

  tags = merge(local.default_tags, var.iam_override_tags, { Name = "${var.project_name}-${var.env_name}-ecr-ecs-role" })

  lifecycle {
    ignore_changes = [
      tags["CreatedOnDate"]
    ]
  }
}


resource "aws_iam_policy" "ecr_policy" {
  name        = join("-", [local.name_prefix, "ECRPolicy"])
  description = "Policy for ECR access"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "ecr:BatchCheckLayerAvailability",
          "ecr:PutImage",
          "ecr:InitiateLayerUpload",
          "ecr:UploadLayerPart",
          "ecr:CompleteLayerUpload",
          "ecr:DescribeRepositories",
          "ecr:GetRepositoryPolicy",
          "ecr:ListImages",
          "ecr:DeleteRepository",
          "ecr:BatchDeleteImage",
          "ecr:SetRepositoryPolicy",
          "ecr:DeleteRepositoryPolicy"
        ],
        Resource = "*"
      }
    ]
  })
}


resource "aws_iam_role_policy_attachment" "attach_ecr_policy" {
  role       = aws_iam_role.ecr_ecs_role.name
  policy_arn = aws_iam_policy.ecr_policy.arn
}