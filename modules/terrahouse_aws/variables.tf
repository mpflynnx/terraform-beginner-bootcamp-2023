variable "user_uuid" {
  type        = string
  description = "The UUID for the user"

  validation {
    condition     = can(regex("^\\w{8}-\\w{4}-\\w{4}-\\w{4}-\\w{12}$", var.user_uuid))
    error_message = "Invalid UUID format. Please provide a valid UUID."
  }
}

variable "bucket_name" {
  description = "The name of the S3 bucket"
  type        = string

  validation {
    condition     = (
      length(var.bucket_name) >= 3 && length(var.bucket_name) <= 63 && 
      can(regex("^[a-z0-9][a-z0-9-.]*[a-z0-9]$", var.bucket_name))
    )
    error_message = "The bucket name must be between 3 and 63 characters, start and end with a lowercase letter or number, and can contain only lowercase letters, numbers, hyphens, and dots."
  }
}

variable "index_html_path" {
  description = "The file path for index.html"
  type        = string

  validation {
    condition     = fileexists(var.index_html_path)
    error_message = "File index.html does not exist."
  }
}

variable "error_html_path" {
  description = "The file path for error.html"
  type        = string

  validation {
    condition     = fileexists(var.error_html_path)
    error_message = "File error.html does not exist."
  }
}