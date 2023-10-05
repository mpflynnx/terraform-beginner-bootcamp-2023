output "s3_bucket_name" {
  description = "S3 bucket name"
  value = module.terrahouse_aws.bucket_name
}

output "s3_website_endpoint" {
  description = "S3 Static Website hosting endpoint"
  value = module.terrahouse_aws.website_endpoint
}

output "cloudfront_url" {
  description = "CloudFront Distribution domain name"
  value = module.terrahouse_aws.cloudfront_url
}