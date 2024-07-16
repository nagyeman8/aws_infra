resource "aws_cloudfront_origin_access_identity" "origin_access_identity" {
  comment = "Assets CDN CloudFront Origin Access Identity"
}

resource "aws_cloudfront_distribution" "assets_cdn_distribution" {
  origin {
    domain_name = var.assets_cdn_s3_rdn
    origin_id   = "S3-my-bucket"

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "Assets CDN CloudFront Distribution"
  default_root_object = "index.html"

  default_cache_behavior {
    target_origin_id = "S3-my-bucket"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    compress               = true
    default_ttl            = 3600
    max_ttl                = 86400
    min_ttl                = 0
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn      = aws_acm_certificate.assets_cert.arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }

  aliases = [var.cdn_domain_name]

  tags = merge(local.default_tags, var.app_override_tags, { Name = "${var.project_name}-${var.env_name}-assets-cdn" })

  lifecycle {
    ignore_changes = [
      tags["CreatedOnDate"]
    ]
  }

}

output "cloudfront_distribution_domain_name" {
  value = aws_cloudfront_distribution.assets_cdn_distribution.domain_name
}