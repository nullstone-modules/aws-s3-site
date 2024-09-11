variable "env_vars" {
  type        = map(string)
  default     = {}
  description = <<EOF
The environment variables to inject into the service.
These are typically used to configure a service per environment.
It is dangerous to put sensitive information in this variable because they are not protected and could be unintentionally exposed.
EOF
}

locals {
  standard_env_vars = tomap({
    NULLSTONE_STACK         = data.ns_workspace.this.stack_name
    NULLSTONE_APP           = data.ns_workspace.this.block_name
    NULLSTONE_ENV           = data.ns_workspace.this.env_name
    NULLSTONE_VERSION       = data.ns_app_env.this.version
    NULLSTONE_COMMIT_SHA    = data.ns_app_env.this.commit_sha
    NULLSTONE_PUBLIC_HOSTS  = join(",", local.public_hosts)
    NULLSTONE_PRIVATE_HOSTS = join(",", local.private_hosts)
  })

  input_env_vars = merge(local.standard_env_vars, local.cap_env_vars, var.env_vars)
}

data "ns_env_variables" "this" {
  input_env_variables = local.input_env_vars
  input_secrets       = {}
}

locals {
  all_env_vars = data.ns_env_variables.this.env_variables
}

resource "aws_s3_object" "env_file" {
  bucket       = aws_s3_bucket.this.bucket
  key          = var.env_vars_filename
  content      = jsonencode(local.all_env_vars)
  content_type = "application/json"
}

resource "null_resource" "env_file_invalidation" {
  for_each = local.cdn_ids

  triggers = {
    file_version = aws_s3_object.env_file.etag
  }
  provisioner "local-exec" {
    command = "aws cloudfront create-invalidation --distribution-id '${each.value}' --paths '/${var.env_vars_filename}'"
  }
}
