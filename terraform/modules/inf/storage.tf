resource "aws_s3_bucket" "assets_cdn_s3" {
  bucket = join("-", [local.name_prefix, "cdn-assets-s3-bucket"])

  tags = merge(local.default_tags, var.inf_override_tags, { Name = "${var.project_name}-${var.env_name}-cdn-stg" })
  lifecycle {
    ignore_changes = [
      tags["CreatedOnDate"]
    ]
  }
}


resource "aws_s3_bucket_website_configuration" "assets_cdn_s3" {
  bucket = aws_s3_bucket.assets_cdn_s3.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }

}


resource "aws_s3_bucket_public_access_block" "cdn_bucket_public_access_block" {
  bucket = aws_s3_bucket.assets_cdn_s3.bucket

  block_public_acls       = false # false can be replaced by "true"
  block_public_policy     = false # false can be replaced by "true"
  ignore_public_acls      = false # false can be replaced by "true"
  restrict_public_buckets = false # false can be replaced by "true"
}


resource "aws_s3_bucket_policy" "public_read_policy" {
  bucket = aws_s3_bucket.assets_cdn_s3.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect    = "Allow",
        Principal = "*",
        Action    = "s3:GetObject",
        Resource  = "${aws_s3_bucket.assets_cdn_s3.arn}/*"
      }
    ]
  })
}
