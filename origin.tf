resource "aws_cloudfront_origin_access_identity" "this" {
  comment = "${local.full_name} Managed by Terraform"
}
