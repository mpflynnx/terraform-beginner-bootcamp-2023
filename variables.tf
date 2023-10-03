variable "user_uuid" {
  description = "The UUID for the user" 
  type = string
}

variable "bucket_name" {
  description = "The name of the S3 bucket"
  type = string
}

variable "index_html_path" {
  description = "The file path for index.html"
  type        = string
}

variable "error_html_path" {
  description = "The file path for error.html"
  type        = string
}