# aws-s3-site

Nullstone App standing up a static site on S3 in AWS.

## Inputs

## Outputs

- `region` - The region of the created S3 bucket.
- `bucket_arn` - The ARN of the created S3 bucket.
- `bucket_name` - The name of the created S3 bucket.
- `deployer` - An AWS User with explicit privilege to deploy to the S3 bucket.
    - `name`       - Deployer username
    - `access_key` = Access Key ID
    - `secret_key` = Secret Access Key
- `private_urls` - A list of URLs accessible from the network
- `public_urls` - A list of URLs accessible from the internet 