variable "terratowns_endpoint" {
 description = "endpoint for TerraTowns api"
 type = string
}

variable "terratowns_access_token" {
 description = "access token for TerraTowns api"
 type = string
}

variable "teacherseat_user_uuid" {
  description = "The UUID for the user" 
  type = string
}

variable "frontier" {
  type = object({
    public_path = string
    content_version = number
  })
}

variable "okcomputer" {
  type = object({
    public_path = string
    content_version = number
  })
}