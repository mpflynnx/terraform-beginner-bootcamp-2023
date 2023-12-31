output "bucket_name" {
  description = "S3 bucket name"
  value = aws_s3_bucket.website_bucket.bucket
}

output "website_endpoint" {
  description = "S3 Static Website hosting endpoint"
  value = aws_s3_bucket_website_configuration.website_configuration.website_endpoint
}

output "domain_name" {
  description = "CloudFront Distribution domain name"
  value = aws_cloudfront_distribution.s3_distribution.domain_name
}
