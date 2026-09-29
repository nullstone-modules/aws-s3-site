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
Well-known files whose names are not content-hashed (`*.xml`, `*.txt`, `*.json`, `*.webmanifest`,
`favicon.*`) are revalidated as well. Use `extra_revalidate_globs` to revalidate additional files.
EOF
}

variable "extra_revalidate_globs" {
  type    = list(string)
  default = []

  validation {
    condition     = alltrue([for g in var.extra_revalidate_globs : g != "" && !strcontains(trimprefix(g, "**/"), "**")])
    error_message = "Each glob must be non-empty and may only use \"**\" as a leading \"**/\"."
  }

  description = <<EOF
Additional globs for files that are served with Cache-Control: no-cache instead of being cached as immutable.
Use this for files whose names are not content-hashed (e.g. `og-image.svg`, `images/*.jpg`).
Globs are matched against the file path relative to the site root using Go `path.Match` syntax (`*` does not cross `/`).
A leading `**/` matches the remainder against the file name at any depth (e.g. `**/*.svg`).
This has no effect unless `revalidate_html_pages` is true.
EOF
}

locals {
  // Files that are conventionally published under stable, unhashed names.
  // Caching these as immutable would let browsers and crawlers hold stale copies.
  default_revalidate_globs = [
    "**/*.html",
    "**/*.xml",
    "**/*.txt",
    "**/*.json",
    "**/*.webmanifest",
    "**/favicon.*",
  ]
  revalidate_globs = distinct(concat(local.default_revalidate_globs, var.extra_revalidate_globs))
}

locals {
  artifacts_key_template = var.enable_versioned_assets ? "{{app-version}}/" : ""
}
