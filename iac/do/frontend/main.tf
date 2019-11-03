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

module "control" {
  source = "../modules/compute/instance"
  
  name           = "control.${var.name}"
  image          = "coreos-stable"
  instance_type  = "s-1vcpu-1gb"  
  ssh_key        = var.ssh_key
  subnet         = var.subnet
  ingress_ports  = [ [22, "tcp"], [ 80, "tcp"], [ 8080, "tcp"], [ 443, "tcp"]  ]
}

/* ***************************************************************
 * DNS Entries
 * ************************************************************ */

module "dns_control" {
   source     = "../modules/network/dns_entry"
   zone       = var.domain
   record     = "@"
   typ        = "A"
   values     = [module.control.ipv4] 
} 

module "dns_control_aaaa" { 
   source     = "../modules/network/dns_entry"
   zone       = var.domain
   record     = "@"
   typ        = "AAAA"
   values     = module.control.ipv6 
}