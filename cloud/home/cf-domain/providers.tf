terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "3.15.0"
    }
    sops = {
      source  = "carlpett/sops"
      version = "0.7.1"
    }
  }
}

provider "sops" {}

provider "cloudflare" {
  email     = data.sops_file.cloudflare.data["cloudflare.email"]
  api_token = data.sops_file.cloudflare.data["cloudflare.api_key"]
}
