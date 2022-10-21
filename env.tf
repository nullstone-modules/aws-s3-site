locals {
  standard_env_vars = tomap({
    NULLSTONE_ENV        = local.env_name
    NULLSTONE_VERSION    = data.ns_app_env.this.version
    NULLSTONE_COMMIT_SHA = data.ns_app_env.this.commit_sha
  })
  cap_env_vars = {for kv in try(local.capabilities.env, []) : kv.name => kv.value}
  env_vars     = merge(local.standard_env_vars, var.service_env_vars, local.cap_env_vars)
}

resource "aws_s3_bucket_object" "env_file" {
  bucket       = aws_s3_bucket.this.bucket
  key          = var.env_vars_filename
  content      = jsonencode(local.env_vars)
  content_type = "application/json"
}
