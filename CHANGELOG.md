# 0.16.0 (Sep 30, 2026)
* Upgraded `nullstone-io/ns` provider to `~> 0.13.0`.
* Replaced `ns_env_variables` with the layered `ns_env_values` and `ns_env_platform_data` data sources to aggregate environment variables.
* Emitted the `env` platform data record, including the source of each variable.
* Upgraded capability scaffolding to emit `capability` on capability outputs and `cap_prefixes`.

# 0.15.0 (Sep 29, 2026)
* Fixed unhashed well-known files being cached as `immutable` when `revalidate_html_pages` is enabled.
  `*.xml`, `*.txt`, `*.json`, `*.webmanifest`, and `favicon.*` are now served with `Cache-Control: no-cache` alongside `*.html`.
* Added `extra_revalidate_globs` variable to revalidate additional unhashed files (e.g. `og-image.svg`).

# 0.14.1 (Jul 06, 2026)
* Added `AllowSSLRequestsOnly` statement to the bucket policy to deny non-HTTPS traffic.

# 0.14.0 (Jun 19, 2026)
* Upgraded `nullstone-io/ns` provider to `~> 0.11.0`.
* Used `aws_tags` from `data.ns_workspace` to tag all resources via provider `default_tags`.

# 0.13.1 (May 20, 2026)
* Added `revalidate_html_pages` variable and `cache_control_rules` output. 
   When enabled, the deployer serves HTML with `Cache-Control: no-cache` and hashed assets as long-cached/immutable, preventing stale-HTML / missing-chunk failures after deploy.

# 0.13.0 (May 07, 2026)
* Switched to OpenTofu.
* Migrated app scaffold to open-source module.

# 0.12.1 (Mar 05, 2026)
* Upgrade to latest ns terraform provider to improve env var interpolation

# 0.12.0 (Nov 11, 2025)
* Added support for reading logs in Nullstone.
* Added support for displaying metrics in Nullstone.
* Optimized aggregation of capabilities.

# 0.11.0 (Sep 22, 2025)
* Upgrade terraform providers.

# 0.10.4 (Oct 01, 2024)
* Fixed and restored cloudfront distribution invalidation.

# 0.10.3 (Sep 19, 2024)
* Disable cloudfront distribution invalidation since it's causing Terraform errors.

# 0.10.2 (Sep 16, 2024)
* Added CDN invalidation to the env file when env vars change.

# 0.10.1 (Aug 29, 2023)
* Added creation delay to ensure IAM propagates before deploying.
* Fixed initial launch issue where an attached CDN redirects to the S3 bucket URL.

# 0.10.0 (Aug 08, 2023)
* Added Bridgecrew scanning.
* Updated `README.md`.
* Fixed compliance issues.

# 0.9.0 (Apr 25, 2023)
* Drop `service_` prefix from variables.

# 0.8.8 (Apr 24, 2023)
* Set s3 bucket ownership default to fix errors when setting ACL
