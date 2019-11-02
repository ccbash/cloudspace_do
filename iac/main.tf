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

variable "name"   { default = "do" }
variable "domain" { default = "ccbash.de" }
variable "region" { default = "FRA1" }
variable "cidr"   { default = "10.1.0.0/16" }

/* ***************************************************************
 * Provider
 * ************************************************************ */

provider "digitalocean" {
}


/* ***************************************************************
 * AWS Infra
 * ************************************************************ */
 
module "zone_dns" {
   source      = "./modules/dns_zone"
   zone        = "${var.name}.${var.domain}"
} 

module "cloud_space" {
  source     = "./do"
  
  name       = var.name
  domain     = module.zone_dns.zone
  region     = var.region
}
