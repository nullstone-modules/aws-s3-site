variable "env_vars_filename" {
  type    = string
  default = "env.json"

  description = <<EOF
The name of the configuration file that will store environment variables.
This should only be changed if the default 'env.json' collides with existing content.
EOF
}

variable "enable_versioned_assets" {
  type        = bool
  description = "Enable/Disable serving assets from versioned S3 subdirectories"
  default     = true
}

variable "revalidate_html_pages" {
  type    = bool
  default = true

  description = <<EOF
When true, HTML files are served with Cache-Control: no-cache so browsers revalidate on each
load. Hashed assets remain long-cached. Recommended for SPA deployments to prevent stale-HTML /
missing-chunk failures after deploy.
EOF
}

locals {
  artifacts_key_template = var.enable_versioned_assets ? "{{app-version}}/" : ""
}
