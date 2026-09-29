# S3 Static Site

This app module is used to create a static site hosted by an S3 Bucket.

Usually, an S3 Static Site has a Content Delivery Network (CDN) to serve content close to users.
Add a "CDN for S3 Site" capability to serve content publicly from this application module.

## Security & Compliance

Security scanning is graciously provided by [Bridgecrew](https://bridgecrew.io/).
Bridgecrew is the leading fully hosted, cloud-native solution providing continuous Terraform security and compliance.

![Infrastructure Security](https://www.bridgecrew.cloud/badges/github/nullstone-modules/aws-s3-site/general)
![CIS AWS V1.3](https://www.bridgecrew.cloud/badges/github/nullstone-modules/aws-s3-site/cis_aws_13)
![PCI-DSS V3.2](https://www.bridgecrew.cloud/badges/github/nullstone-modules/aws-s3-site/pci)
![NIST-800-53](https://www.bridgecrew.cloud/badges/github/nullstone-modules/aws-s3-site/nist)
![ISO27001](https://www.bridgecrew.cloud/badges/github/nullstone-modules/aws-s3-site/iso)
![SOC2](https://www.bridgecrew.cloud/badges/github/nullstone-modules/aws-s3-site/soc2)
![HIPAA](https://www.bridgecrew.cloud/badges/github/nullstone-modules/aws-s3-site/hipaa)

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

### HTML Revalidation

After a deploy, browsers that still hold a cached `index.html` may request asset URLs from the
previous version. If those assets have already rolled over, the page can fail to load with missing
JS/CSS chunks. This is especially common for single-page apps (SPAs).

The `revalidate_html_pages` variable (enabled by default) addresses this by differentiating cache
behavior between HTML entry points and hashed assets:

* **HTML files** are served with `Cache-Control: no-cache`, so browsers revalidate them on every
  load. New HTML is picked up immediately, enabling instant rollouts.
* **Unhashed well-known files** (`*.xml`, `*.txt`, `*.json`, `*.webmanifest`, `favicon.*`) are also served
  with `Cache-Control: no-cache`. Files like `sitemap.xml`, `robots.txt`, and `manifest.json` keep the
  same name across deploys, so they must not be cached as immutable.
* **Hashed assets** (JS, CSS, images, etc.) are served with
  `Cache-Control: public, max-age=31536000, immutable`, so they are cached long-term. The filename
  hash is the cache bust, so a new version produces new filenames rather than overwriting cached ones.

Nullstone applies these headers while uploading objects during the "push" phase of deployment.
Files matching a revalidate glob get `no-cache`; everything else is treated as an immutable asset.

If the site publishes other files under stable names (e.g. `og-image.svg`, unhashed images), add them with `extra_revalidate_globs`.
Globs use Go `path.Match` syntax against the path relative to the site root (`*` does not cross `/`);
a leading `**/` matches the file name at any depth.

```yaml
vars:
  extra_revalidate_globs:
    - "og-image.svg" # a single file in the site root
    - "images/*.jpg" # files directly inside images/
    - "**/*.pdf"     # any depth
```

| Variable                 | Type           | Default | Description                                                                                          |
|--------------------------|----------------|---------|------------------------------------------------------------------------------------------------------|
| `revalidate_html_pages`  | `bool`         | `true`  | Serve HTML and unhashed well-known files with `no-cache` and hashed assets as `immutable`.           |
| `extra_revalidate_globs` | `list(string)` | `[]`    | Additional globs served with `no-cache`. No effect unless `revalidate_html_pages` is true.           |

Set `revalidate_html_pages = false` to disable this behavior and upload all objects without explicit `Cache-Control` headers.

> **Note:** A CDN in front of the site may still cache HTML according to its own cache policy. To
> get end-to-end revalidation, the attached CDN's cache behavior for HTML must honor the origin's
> `no-cache` directive.
