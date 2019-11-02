/* ***************************************************************
 * Network
 * ************************************************************ */

module "subnet" {
   source = "../modules/network/public_subnet"

   name   = var.name
   avz    = var.region
}

/* ***************************************************************
 * Instances
 * ************************************************************ */

module "consul" {
  source  = "./consul"
  
  name    = "${var.name}-consul"
  domain  = var.domain
  subnet  = module.subnet
  
  ssh_key = var.ssh_key
}
