terraform {
  cloud {
    organization = "mpflynnx"
    workspaces {
      name = "terra-house-1"
    }
   }
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

module "home_frontier_hosting" {
  source = "./modules/terrahome_aws"
  teacherseat_user_uuid = var.teacherseat_user_uuid
  public_path = var.frontier.public_path
  content_version = var.frontier.content_version
}

resource "terratowns_home" "home_frontier" {
  name = "Why play Frontier: Elite II in 2023!"
  description = <<DESCRIPTION
Frontier: Elite II is a space trading and combat simulator 
video game written by David Braben and published by GameTek 
and Konami in October 1993 and released on the Amiga, Atari 
ST and DOS.
DESCRIPTION
  domain_name = module.home_frontier_hosting.domain_name
  # mock server credentials
  # domain_name = "sdfsdfsgsg32423.cloudfront_url"
  town = "gamers-grotto"
  content_version = var.frontier.content_version
}

module "home_okcomputer_hosting" {
  source = "./modules/terrahome_aws"
  teacherseat_user_uuid = var.teacherseat_user_uuid
  public_path = var.okcomputer.public_path
  content_version = var.okcomputer.content_version
}

resource "terratowns_home" "home_okcomputer" {
  name = "Why is the Radiohead album, OK Computer still rated as one of the greatest albums?"
  description = <<DESCRIPTION
Radiohead's OK Computer, released in 1997, is still rated 
as one of the greatest albums of all time for many reasons. 
DESCRIPTION
  domain_name = module.home_okcomputer_hosting.domain_name
  # mock server credentials
  # domain_name = "sdfsdfsgsg32423.cloudfront_url"
  town = "melomaniac-mansion"
  content_version = var.okcomputer.content_version
}