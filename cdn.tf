resource "aws_cloudfront_origin_access_identity" "this" {
  comment = "${local.full_name} Managed by Terraform"
}

resource "aws_cloudfront_distribution" "this" {
  origin {
    domain_name = "${aws_s3_bucket.this.id}.s3.amazonaws.com"
    origin_id   = "S3-${aws_s3_bucket.this.id}"

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.this.cloudfront_access_identity_path
    }
  }

  enabled             = true
  comment             = "Managed by Terraform"
  default_root_object = "index.html"

  aliases = compact([local.subdomain, local.alt_subdomain])

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "S3-${aws_s3_bucket.this.id}"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 86400
    max_ttl                = 31536000
  }

  price_class = "PriceClass_All"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn = aws_acm_certificate.this.arn
    ssl_support_method  = "sni-only"
  }

  dynamic "custom_error_response" {
    for_each = var.enable_404page ? ["404.html"] : []

    content {
      error_code            = "404"
      error_caching_min_ttl = "0"
      response_code         = "404"
      response_page_path    = custom_error_response.value
    }
  }
}
