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

locals {
  artifacts_key_template = var.enable_versioned_assets ? "{{app-version}}/" : ""
}
