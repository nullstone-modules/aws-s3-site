resource "aws_cloudfront_origin_access_identity" "this" {
  comment = "${data.ns_workspace.this.hyphenated_name} Managed by Terraform"
}
