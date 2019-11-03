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

module "instance" {
  source = "../../modules/compute/instance"
  
  name           = var.name
  image          = "coreos-stable"
  instance_type  = "s-1vcpu-1gb"  
  ssh_key        = var.ssh_key
  subnet         = var.subnet
  ingress_ports  = [ [22, "tcp"], [ 8500, "tcp" ], [ 8200, "tcp" ], [ 80, "tcp"], [ 8080, "tcp"], [ 443, "tcp"]  ]
}

module "dns_consul" {
   source     = "../../../modules/dns_entry"
   zone       = var.domain
   record     = "@"
   typ        = "A"
   values     = [module.control.public_ip] 
} 

module "dns_consul_aaaa" { 
   source     = "../../../modules/dns_entry"
   zone       = var.domain
   record     = "@"
   typ        = "AAAA"
   values     = module.control.ipv6 
}