// This file is replaced by code-generation using 'capabilities.tf.tmpl'
// This file helps app module creators define a contract for what types of capability outputs are supported.
locals {
  capabilities = {
    // origin_access_identities refer to the origin identities that are attached to the cdns
    // They are granted access to read contents from the S3 Bucket
    origin_access_identities = [
      {
        iam_arn = ""
      }
    ]

    // cdns refer to attached Cloudfront Distribution Networks
    // They are used to serve the static content inside the S3 Bucket
    cdns = [
      {
        id = ""
      }
    ]

    // private_urls follows a wonky syntax so that we can send all capability outputs into the merge module
    // Terraform requires that all members be of type list(map(any))
    // They will be flattened into list(string) when we output from this module
    private_urls = [
      {
        url = ""
      }
    ]

    // public_urls follows a wonky syntax so that we can send all capability outputs into the merge module
    // Terraform requires that all members be of type list(map(any))
    // They will be flattened into list(string) when we output from this module
    public_urls = [
      {
        url = ""
      }
    ]
  }
}
