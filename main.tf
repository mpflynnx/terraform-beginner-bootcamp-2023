terraform {
  required_providers {
    terratowns = {
      source = "local.providers/local/terratowns"
      version = "1.0.0"
    }
  }
}

provider "terratowns" {
  endpoint = var.terratowns_endpoint
  user_uuid = var.teacherseat_user_uuid
  token = var.terratowns_access_token

  # Mock server credentials
  # user_uuid = "e328f4ab-b99f-421c-84c9-4c42c7dcea01"
  # token = "9b49b3fb-b8e9-483c-b703-97ba88eef8e0"
}

module "terrahome_aws" {
  source = "./modules/terrahome_aws"
  teacherseat_user_uuid = var.teacherseat_user_uuid
  index_html_path = var.index_html_path
  error_html_path = var.error_html_path
  content_version = var.content_version
  assets_path = var.assets_path
}

resource "terratowns_home" "home" {
  name = "Why play Frontier: Elite II in 2023!"
  description = <<DESCRIPTION
Frontier: Elite II is a space trading and combat simulator 
video game written by David Braben and published by GameTek 
and Konami in October 1993 and released on the Amiga, Atari 
ST and DOS. It is the first sequel to the seminal game Elite 
from 1984. The game retains the same principal component of Elite, 
namely open-ended gameplay, and adds realistic physics and an
accurately modelled galaxy.
DESCRIPTION
  domain_name = module.terrahome_aws.cloudfront_url
  # mock server credentials
  # domain_name = "sdfsdfsgsg32423.cloudfront_url"

  town = "missingo"
  content_version = 1
}
