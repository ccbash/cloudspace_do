/* ***************************************************************
 * Network
 * ************************************************************ */

module "subnet" {
   source   = "../modules/network/private_subnet"

   name     = var.name
   avz      = var.region
   domain   = var.domain
}

/* ***************************************************************
 * Instances
 * ************************************************************ */

module "docker1" {
  source = "../modules/compute/instance"
  
  name          = "docker1.${var.name}"
  image         = "coreos-stable"
  instance_type = "s-1vcpu-1gb"  
  ssh_key       = var.ssh_key
  subnet        = module.subnet
  ingress_ports = [ [22, "tcp"] ]
}