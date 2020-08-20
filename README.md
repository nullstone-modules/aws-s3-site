# block-aws-s3-site

Nullstone Block standing up a static site on S3 in AWS.

## Inputs

- `owner_id: string` - Stack Owner ID
- `stack_name: string` - Stack Name
- `block_name: string` - Block Name
- `parent_blocks: {subdomain: string}` - Parent Blocks (subdomain refers to block with Route53 hosted zone)
- `env: string` - Environment Name
- `backend_conn_str: string` - Connection string for postgres backend

- `enable_www: bool` - (Default: true) Enable/Disable creating www.<subdomain> DNS record 
in addition to <subdomain> DNS record for site hosted on CDN
- `enable_404page: bool` - (Default: false) Enable/Disable custom 404 page within s3 bucket. If enabled, bucket must contain 404.html.

## Outputs

