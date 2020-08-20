variable "owner_id" {
  type = string
}

variable "stack_name" {
  type = string
}

variable "env" {
  type = string
}

variable "block_name" {
  type = string
}

variable "parent_blocks" {
  type = object({
    subdomain : string
  })
}

variable "backend_conn_str" {
  type = string
}


variable "enable_www" {
  type        = bool
  description = "Enable/Disable creating www.<subdomain> DNS record in addition to <subdomain> DNS record for hosted site"
  default     = true
}

variable "enable_404page" {
  type        = bool
  description = "Enable/Disable custom 404 page within s3 bucket. If enabled, must provide 404.html"
  default     = false
}


locals {
  full_name = "${var.stack_name}-${var.env}-${var.block_name}"
}
