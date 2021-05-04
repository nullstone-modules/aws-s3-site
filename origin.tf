resource "aws_cloudfront_origin_access_identity" "this" {
  comment = "${local.resource_name} Managed by Terraform"
}
