variable "service_env_vars" {
  type        = map(string)
  default     = {}
  description = <<EOF
The environment variables to inject into the service.
These are typically used to configure a service per environment.
It is dangerous to put sensitive information in this variable because they are not protected and could be unintentionally exposed.
EOF
}

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
