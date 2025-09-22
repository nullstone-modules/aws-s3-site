resource "aws_s3_bucket" "this" {
  #bridgecrew:skip=CKV_AWS_18: "Ensure the S3 bucket has access logging enabled". Access Logs are configured on the CDN.
  #bridgecrew:skip=CKV_AWS_144: "Ensure that S3 bucket has cross-region replication enabled". CDNs can only serve out of us-east-1.
  #bridgecrew:skip=CKV_AWS_145: "Ensure that S3 buckets are encrypted with KMS by default". This bucket holds site assets which are not expected not to be sensitive in nature.
  bucket        = local.resource_name
  tags          = local.tags
  force_destroy = true
}

resource "aws_s3_bucket_lifecycle_configuration" "this" {
  bucket = aws_s3_bucket.this.id

  rule {
    id     = "AbortFailed"
    status = "Enabled"

    filter {}

    abort_incomplete_multipart_upload {
      days_after_initiation = 7
    }
  }
}

resource "aws_s3_bucket_notification" "this" {
  bucket      = aws_s3_bucket.this.id
  eventbridge = true
}

resource "aws_s3_bucket_public_access_block" "this" {
  bucket = aws_s3_bucket.this.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.this.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_ownership_controls" "default" {
  bucket = aws_s3_bucket.this.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "this" {
  depends_on = [aws_s3_bucket_ownership_controls.default]

  bucket = aws_s3_bucket.this.id
  acl    = "private"
}

resource "aws_s3_bucket_website_configuration" "this" {
  bucket = aws_s3_bucket.this.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "404.html"
  }
}

resource "aws_s3_bucket_policy" "this" {
  bucket = aws_s3_bucket.this.id
  policy = data.aws_iam_policy_document.s3_policy.json
}

data "aws_iam_policy_document" "s3_policy" {
  // Don't add the policy statement if we don't have any origin access identities
  // The IAM policy would be invalid with no principal identifiers
  dynamic "statement" {
    for_each = length(local.oai_iam_arns) > 0 ? [local.oai_iam_arns] : []

    content {
      sid       = "AllowOriginReadObject"
      actions   = ["s3:GetObject"]
      resources = ["arn:aws:s3:::${local.resource_name}/*"]

      principals {
        type        = "AWS"
        identifiers = statement.value
      }
    }
  }

  statement {
    sid       = "AllowReadBucket"
    actions   = ["s3:ListBucket"]
    resources = ["arn:aws:s3:::${local.resource_name}"]

    principals {
      type        = "AWS"
      identifiers = concat([aws_iam_user.deployer.arn], local.oai_iam_arns)
    }
  }

  statement {
    sid = "AllowDeployerWrite"
    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:DeleteObject"
    ]
    resources = ["arn:aws:s3:::${local.resource_name}/*"]

    principals {
      type        = "AWS"
      identifiers = [aws_iam_user.deployer.arn]
    }
  }
}
