/* ***************************************************************
 * Provison - get an Ami and template 
 * ************************************************************ */

module "securitygroup" {
  source = "../../network/securitygroup"
  
  name           = var.name
  instance_id    = digitalocean_droplet.this.id
  ingress_ports  = var.ingress_ports
}

/* ***************************************************************
 * EC2 Instance Def
 * ************************************************************ */

resource "digitalocean_droplet" "this" {
  image               = var.image
  name                = var.name
  region              = var.subnet.region
  size                = var.instance_type
  ipv6                = var.subnet.ipv6_enabled
  private_networking  = true
  ssh_keys            = [ var.ssh_key.id ]
  user_data           = var.user_data
}

