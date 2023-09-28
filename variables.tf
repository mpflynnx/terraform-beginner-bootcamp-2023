variable "user_uuid" {
  type        = string
  description = "The UUID for the user"

  validation {
    condition     = can(regex("^\\w{8}-\\w{4}-\\w{4}-\\w{4}-\\w{12}$", var.user_uuid))
    error_message = "Invalid UUID format. Please provide a valid UUID."
  }
}