output "home_frontier_hosting_s3_bucket_name" {
  description = "S3 bucket name"
  value = module.home_frontier_hosting.bucket_name
}

output "home_frontier_hosting_s3_website_endpoint" {
  description = "S3 Static Website hosting endpoint"
  value = module.home_frontier_hosting.website_endpoint
}

output "home_frontier_hosting_cloudfront_url" {
  description = "CloudFront Distribution domain name"
  value = module.home_frontier_hosting.domain_name
}

output "home_okcomputer_hosting_s3_bucket_name" {
  description = "S3 bucket name"
  value = module.home_okcomputer_hosting.bucket_name
}

output "home_okcomputer_hosting_s3_website_endpoint" {
  description = "S3 Static Website hosting endpoint"
  value = module.home_okcomputer_hosting.website_endpoint
}

output "home_okcomputer_hosting_cloudfront_url" {
  description = "CloudFront Distribution domain name"
  value = module.home_okcomputer_hosting.domain_name
}