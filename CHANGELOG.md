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
