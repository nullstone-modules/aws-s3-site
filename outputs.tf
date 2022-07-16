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

output "artifacts_bucket_name" {
  value       = aws_s3_bucket.this.bucket
  description = "string ||| The name of the created S3 bucket."
}

output "artifacts_key_template" {
  value       = "{{app-version}}/"
  description = "string ||| Template for s3 directory where files are placed."
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

output "private_urls" {
  value       = local.private_urls
  description = "list(string) ||| A list of URLs only accessible inside the network"
}

output "public_urls" {
  value       = local.public_urls
  description = "list(string) ||| A list of URLs accessible to the public"
}
