variable "teacherseat_user_uuid" {
  description = "The UUID for the user"

  validation {
    condition     = can(regex("^\\w{8}-\\w{4}-\\w{4}-\\w{4}-\\w{12}$", var.teacherseat_user_uuid))
    error_message = "Invalid UUID format. Please provide a valid UUID."
  }
}

variable "public_path" {
  description = "The file path for the public directory"
  type        = string
}

variable "content_version" {
  description = "Content version number"
  type        = number
  default     = 1
  
  validation {
    condition     = var.content_version > 0 && can(var.content_version)
    error_message = "Content version must be a positive integer"
  }
}