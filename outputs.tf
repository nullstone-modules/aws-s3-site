output "region" {
  value       = local.region
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
  value       = local.artifacts_key_template
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

output "env_vars_filename" {
  value       = var.env_vars_filename
  description = "string ||| The name of the S3 Object that contains a json-encoded configuration file with environment variables."
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

output "log_provider" {
  value       = "cloudwatch"
  description = "string ||| 'cloudwatch'"
}

output "log_group_name" {
  value       = module.logs.name
  description = "string ||| The name of the Cloudwatch Log Group where logs are stored."
}

output "log_reader" {
  value       = module.logs.reader
  description = "object({ name: string, access_key: string, secret_key: string }) ||| An AWS User with explicit privilege to read logs from Cloudwatch."
  sensitive   = true
}

output "metrics_provider" {
  value       = "cloudwatch"
  description = "string ||| 'cloudwatch'"
}

output "metrics_reader" {
  value       = module.logs.reader
  description = "object({ name: string, access_key: string, secret_key: string }) ||| An AWS User with explicit privilege to read metrics from Cloudwatch."
  sensitive   = true
}

output "metrics_mappings" {
  value = local.metrics_mappings
}
