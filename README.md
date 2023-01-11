# aws-s3-site

Launch infrastructure for a static site hosted by AWS S3 Bucket.

## Deploys

When using the Nullstone CLI or auto-build/deploy functionality, 
Nullstone pushes the static assets to the S3 Bucket during the "push" phase of deployment.

If necessary, Nullstone reconfigures a CDN to serve the new assets. 
Then, Nullstone performs invalidation on the CDN so that the new assets are properly served to users.  

This module supports [Versioned](#versioned-assets) and [Unversioned](#unversioned-assets) Assets.
By default, Versioned Assets is configured.

### Versioned Assets

When storing assets in the S3 Bucket, Versioned Assets stores each version of assets in a separate subdirectory in the S3 Bucket.
During deployment, Nullstone reconfigures the CDN to serve assets from the `<version>` S3 subdirectory.

Versioned Assets enables rollback functionality for static site apps and guarantees that assets are not overwritten in the S3 Bucket.
However, this does not allow serving of assets from multiple deployments.

### Unversioned Assets

When storing assets in the S3 Bucket, Unversioned Assets stores all assets in the root directory of the S3 Bucket.

This disables rollback functionality in Nullstone, but enables serving assets that are uploaded in separate deployments.
