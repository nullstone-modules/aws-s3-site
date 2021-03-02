resource "random_string" "bucket_suffix" {
  length  = 5
  lower   = true
  upper   = false
  number  = false
  special = false
}

locals {
  bucket_name = "${data.ns_workspace.this.hyphenated_name}-${random_string.bucket_suffix.result}"
}

resource "aws_s3_bucket" "this" {
  bucket = local.bucket_name
  acl    = "private"

  policy = data.aws_iam_policy_document.s3_policy.json

  website {
    index_document = "index.html"
    error_document = "404.html"
  }

  tags = data.ns_workspace.this.tags
}

resource "aws_s3_bucket_policy" "this" {
  bucket = aws_s3_bucket.this.id
  policy = data.aws_iam_policy_document.s3_policy.json
}

data "aws_iam_policy_document" "s3_policy" {
  statement {
    sid       = "AllowOriginReadObject"
    actions   = ["s3:GetObject"]
    resources = ["arn:aws:s3:::${local.bucket_name}/*"]

    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.this.iam_arn]
    }
  }

  statement {
    sid       = "AllowReadBucket"
    actions   = ["s3:ListBucket"]
    resources = ["arn:aws:s3:::${local.bucket_name}"]

    principals {
      type = "AWS"
      identifiers = [
        aws_cloudfront_origin_access_identity.this.iam_arn,
        aws_iam_user.deployer.arn
      ]
    }
  }

  statement {
    sid = "AllowDeployerWrite"
    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:DeleteObject"
    ]
    resources = ["arn:aws:s3:::${local.bucket_name}/*"]

    principals {
      type        = "AWS"
      identifiers = [aws_iam_user.deployer.arn]
    }
  }
}
