resource "aws_s3_bucket" "this" {
  bucket = local.resource_name
  acl    = "private"
  tags   = local.tags

  website {
    index_document = "index.html"
    error_document = "404.html"
  }
}

resource "aws_s3_bucket_policy" "this" {
  bucket = aws_s3_bucket.this.id
  policy = data.aws_iam_policy_document.s3_policy.json
}

data "aws_iam_policy_document" "s3_policy" {
  statement {
    sid       = "AllowOriginReadObject"
    actions   = ["s3:GetObject"]
    resources = ["arn:aws:s3:::${local.resource_name}/*"]

    principals {
      type        = "AWS"
      identifiers = local.oai_iam_arns
    }
  }

  statement {
    sid       = "AllowReadBucket"
    actions   = ["s3:ListBucket"]
    resources = ["arn:aws:s3:::${local.resource_name}"]

    principals {
      type = "AWS"
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
