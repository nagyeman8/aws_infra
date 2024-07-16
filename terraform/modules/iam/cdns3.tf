resource "aws_iam_policy" "s3_bucket_policy" {
  name        = "assets_cdn_s3_bucket_policy"
  description = "IAM policy for accessing the assets CDN S3 bucket"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "s3:CreateBucket",
          "s3:PutBucketPolicy",
          "s3:GetBucketPolicy",
          "s3:PutBucketPublicAccessBlock",
          "s3:PutBucketOwnershipControls",
          "s3:ListBucket",
          "s3:GetBucketLocation",
          "s3:DeleteBucketPolicy",
          "s3:DeleteBucket"
        ],
        Resource = "arn:aws:s3:::${project_name}-${var.env_name}-cdn-assets-s3-bucket"
      },
      {
        Effect = "Allow",
        Action = [
          "s3:PutObject",
          "s3:GetObject",
          "s3:DeleteObject"
        ],
        Resource = "arn:aws:s3:::${project_name}-${var.env_name}-cdn-assets-s3-bucket/*"
      }
    ]
  })
}


resource "aws_iam_role" "s3_bucket_role" {
  name = "assets_cdn_s3_bucket_role"

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


resource "aws_iam_role_policy_attachment" "s3_bucket_role_policy_attachment" {
  role       = aws_iam_role.s3_bucket_role.name
  policy_arn = aws_iam_policy.s3_bucket_policy.arn
}


resource "aws_iam_policy" "alb_route53_access" {
  name        = "Route53_ALB"
  description = "An example policy to manage Route53 and ALB"
  policy      = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "route53:ChangeResourceRecordSets",
                "route53:ListHostedZones",
                "route53:ListResourceRecordSets",
                "route53:GetHostedZone",
                "elasticloadbalancing:DescribeLoadBalancers",
                "elasticloadbalancing:DescribeLoadBalancerAttributes",
                "elasticloadbalancing:DescribeTags",
                "route53-recovery-control-config:CreateControlPanel",
                "route53-recovery-control-config:DescribeControlPanel",
                "route53-recovery-control-config:ListControlPanels",
                "route53-recovery-readiness:CreateRecoveryGroup",
                "route53-recovery-readiness:DescribeRecoveryGroup",
                "route53-recovery-readiness:ListRecoveryGroups"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

