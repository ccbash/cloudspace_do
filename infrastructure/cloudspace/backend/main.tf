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
  
  name          = keys( var.hosts )[0]
  image         = values( var.hosts )[0]["image"]
  instance_type = values( var.hosts )[0]["instance_type"]
  ssh_key       = var.ssh_key
  subnet        = module.subnet
  ingress_ports = [ [22, "tcp"] ]
}