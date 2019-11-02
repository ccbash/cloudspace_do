/* ***************************************************************
 * Network
 * ************************************************************ */

module "subnet" {
   source   = "../modules/network/private_subnet"

   name     = var.name
   avz      = var.region
}

/* ***************************************************************
 * Instances
 * ************************************************************ */

module "docker_host1" {
  source  = "./docker_host"
  
  name    = "${var.name}.docker"
  domain  = var.domain
  subnet  = module.subnet
  ssh_key = var.ssh_key
  servicediscovery = var.servicediscovery
}