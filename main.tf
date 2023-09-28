resource "random_string" "bucket_name" {
  length  = 32
  special = false
  upper = false
}

resource "aws_s3_bucket" "example" {
  bucket = random_string.bucket_name.result
  tags = {
    UserUuid = var.user_uuid
  }
  
}
