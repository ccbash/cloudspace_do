

data "template_file" "user_data" {
  template = file("${path.module}/templates/user-data.sh")

  vars = {
    datacenter   = var.name
    zone         = var.domain
  }
}

/* ***************************************************************
 * Instance with an security group
 * ************************************************************ */


module "instance" {
  source = "../../modules/compute/instance"
  
  name           = var.name
  image          = "centos-7-x64"
  instance_type  = "s-1vcpu-1gb"  
  user_data      = data.template_file.user_data.rendered
  ssh_key        = var.ssh_key
  subnet         = var.subnet
  ingress_ports  = [ [22, "tcp"], [ 8500, "tcp" ], [ 8200, "tcp" ], [ 80, "tcp"], [ 8080, "tcp"] ]  
}

/* ***************************************************************
 * DNS Records
 * ************************************************************ */

module "dns_consul" {
   source     = "../../../modules/dns_entry"
   zone       = var.domain
   record     = "@"
   typ        = "A"
   values     = [module.instance.public_ip] 
} 

module "dns_consul_aaaa" { 
   source     = "../../../modules/dns_entry"
   zone       = var.domain
   record     = "@"
   typ        = "AAAA"
   values     = module.instance.ipv6 
}

module "dns_vault" {
   source     = "../../../modules/dns_entry"
   zone       = var.domain
   record     = "vault"
   typ        = "CNAME"
   values     = ["${var.domain}."] 
}
