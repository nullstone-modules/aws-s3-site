output "bucket_arn" {
  value = aws_s3_bucket.this.arn
}

output "bucket_name" {
  value = aws_s3_bucket.this.bucket
}

output "cdn_arn" {
  value = aws_cloudfront_distribution.this.arn
}

output "cdn_domain" {
  value = aws_cloudfront_distribution.this.domain_name
}
