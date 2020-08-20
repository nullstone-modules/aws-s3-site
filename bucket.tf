data "aws_iam_policy_document" "s3_policy" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["arn:aws:s3:::${local.full_name}/*"]

    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.this.iam_arn]
    }
  }

  statement {
    actions   = ["s3:ListBucket"]
    resources = ["arn:aws:s3:::${local.full_name}"]

    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.this.iam_arn]
    }
  }
}

resource "aws_s3_bucket" "this" {
  bucket = local.full_name
  acl    = "private"

  policy = data.aws_iam_policy_document.s3_policy.json

  website {
    index_document = "index.html"
    error_document = "404.html"
  }

  tags = {
    Stack = var.stack_name
    Env   = var.env
    Block = var.block_name
  }
}

resource "aws_route53_record" "this" {
  zone_id = data.terraform_remote_state.subdomain.outputs.subdomain_zone_id
  name    = ""
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.this.domain_name
    zone_id                = aws_cloudfront_distribution.this.hosted_zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "www" {
  count = var.enable_www ? 1 : 0

  zone_id = data.terraform_remote_state.subdomain.outputs.subdomain_zone_id
  name    = "www"
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.this.domain_name
    zone_id                = aws_cloudfront_distribution.this.hosted_zone_id
    evaluate_target_health = true
  }
}
