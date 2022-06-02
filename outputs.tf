output "region" {
  value       = data.aws_region.this.name
  description = "string ||| The region where the S3 bucket resides."
}

output "bucket_arn" {
  value       = aws_s3_bucket.this.arn
  description = "string ||| The ARN of the created S3 bucket."
}

output "bucket_name" {
  value       = aws_s3_bucket.this.bucket
  description = "string ||| The name of the created S3 bucket."
}

output "deployer" {
  value = {
    name       = aws_iam_user.deployer.name
    access_key = aws_iam_access_key.deployer.id
    secret_key = aws_iam_access_key.deployer.secret
  }

  description = "object({ name: string, access_key: string, secret_key: string }) ||| An AWS User with explicit privilege to deploy to the S3 bucket."

  sensitive = true
}

output "cdn_ids" {
  value = [for cdn in try(local.capabilities.cdns, []) : cdn["id"]]
}

locals {
  // Private and public URLs are shown in the Nullstone UI
  // Typically, they are created through capabilities attached to the application
  // If this module has URLs, add them here as list(string) 
  additional_private_urls = []
  additional_public_urls  = []
}

output "private_urls" {
  value       = concat([for url in try(local.capabilities.private_urls, []) : url["url"]], local.additional_private_urls)
  description = "list(string) ||| A list of URLs only accessible inside the network"
}

output "public_urls" {
  value       = concat([for url in try(local.capabilities.public_urls, []) : url["url"]], local.additional_public_urls)
  description = "list(string) ||| A list of URLs accessible to the public"
}
