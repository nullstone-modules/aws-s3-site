data "ns_app_env" "this" {
  stack_id = data.ns_workspace.this.stack_id
  app_id   = data.ns_workspace.this.block_id
  env_id   = data.ns_workspace.this.env_id
}

locals {
  app_version = data.ns_app_env.this.version
}

locals {
  app_metadata = tomap({
    // Inject app metadata into capabilities here (e.g. security_group_name, role_name)
    s3_bucket_id           = aws_s3_bucket.this.id
    artifacts_key_template = local.artifacts_key_template
    // AWS recommends using the regional bucket domain name when creating CloudFront distribution origin
    // https://stackoverflow.com/questions/38735306/aws-cloudfront-redirecting-to-s3-bucket
    // This prevents issues where initial launch forces a redirect to the S3 bucket
    s3_domain_name = aws_s3_bucket.this.bucket_regional_domain_name
    log_group_name = module.logs.name
    log_group_arn  = module.logs.arn
  })
}
