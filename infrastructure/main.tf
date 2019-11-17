/* ***************************************************************
 * Terraform Backend
 * ************************************************************ */

terraform {

  backend "s3" {
    bucket = "n8n"
    key    = "terraform.tfstate"
    region = "eu-west-1"
    endpoint = "https://fra1.digitaloceanspaces.com"
    skip_credentials_validation = true
    skip_metadata_api_check = true
  }
}

/* ***************************************************************
 * Variables
 * ************************************************************ */

locals {
  cloud  = "${yamldecode(file("inventory/inventory.yml"))["digitalocean"]}"
  domain = "ansible.local"
}

variable "name"   { default = "do" }
variable "domain" { default = "ccbash.de" }
variable "region" { default = "FRA1" }

/* ***************************************************************
 * Provider
 * ************************************************************ */

provider "digitalocean" {
}


/* ***************************************************************
 * cloudspace digitalocean
 * ************************************************************ */
 
module "zone_dns" {
  source = "./do/modules/network/dns_zone"

  zone   = "${local.cloud.vars.name}.${local.cloud.vars.domain}"
} 

module "cloudspace_do" {
  source = "./do"
  
  name   = local.cloud.vars.name
  domain = module.zone_dns.zone
  region = local.cloud.vars.region
  infra  = local.cloud.children 
}
