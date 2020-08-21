output "bucket_arn" {
  value = aws_s3_bucket.this.arn
}

output "bucket_name" {
  value = aws_s3_bucket.this.bucket
}

output "origin_domain_name" {
  value = aws_s3_bucket.this.bucket_domain_name
}

output "origin_id" {
  value = "S3-${aws_s3_bucket.this.id}"
}

output "origin_access_identity" {
  value = aws_cloudfront_origin_access_identity.this.cloudfront_access_identity_path
}
