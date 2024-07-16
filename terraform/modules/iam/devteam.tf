# Define the IAM Role
resource "aws_iam_role" "dev_team_role" {
  name               = join("-", [local.name_prefix, "dev-team"])
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}


# Define a custom policy for dev-team access to the specified services
resource "aws_iam_policy" "custom_dev_team_policy" {
  name        = join("-", [local.name_prefix, "dev-team-policy"])
  description = "Custom policy to provide read-only access to ECS, ECR, ALB, Route53, RDS, Parameter Store, VPC, CloudFront, and S3."
  policy      = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "ecs:Describe*",
          "ecs:List*",
          "ecr:Describe*",
          "ecr:Get*",
          "ecr:List*",
          "elasticloadbalancing:Describe*",
          "route53:Get*",
          "route53:List*",
          "rds:Describe*",
          "rds:List*",
          "ssm:GetParameter*",
          "ssm:DescribeParameters",
          "ssm:List*",
          "ec2:Describe*",
          "ec2:DescribeVpcs",
          "cloudfront:Get*",
          "cloudfront:List*",
          "s3:ListBucket",
          "s3:GetBucket*",
          "s3:GetObject",
          "s3:ListBucket",
          "s3:GetBucketPolicy"
        ],
        Resource = "*"
      }
    ]
  })
}


# Attach the custom policy to the IAM Role
resource "aws_iam_role_policy_attachment" "custom_dev_team_policy_attachment" {
  role       = aws_iam_role.dev_team_role.name
  policy_arn = aws_iam_policy.custom_dev_team_policy.arn
}
