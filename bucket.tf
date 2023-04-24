resource "aws_s3_bucket" "this" {
  bucket        = local.resource_name
  tags          = local.tags
  force_destroy = true
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
