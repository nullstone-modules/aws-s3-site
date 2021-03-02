# block-aws-s3-site

Nullstone Block standing up a static site on S3 in AWS.

## Inputs

## Outputs

- `bucket_arn` - The ARN of the created S3 bucket.
- `bucket_name` - The name of the created S3 bucket.
- `origin_domain_name` - The domain name for the created S3 bucket that can be used as an origin for CloudFront.
- `origin_id` - The ID of the created S3 bucket used as an origin.
- `origin_access_identity` - A prebuilt CloudFront origin access identity that is configured to work with the created S3 bucket.
- `deployer` - An AWS User with explicit privilege to deploy to the S3 bucket.
    - `name`       - Deployer username
    - `access_key` = Access Key ID
    - `secret_key` = Secret Access Key
