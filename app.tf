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
    s3_domain_name         = aws_s3_bucket.this.bucket_domain_name
    s3_bucket_id           = aws_s3_bucket.this.id
    artifacts_key_template = local.artifacts_key_template
  })
}
