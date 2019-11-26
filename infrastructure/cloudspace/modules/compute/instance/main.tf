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
}

resource "local_file" "foo" {
    content  = <<-EOT
      ansible_ssh_host: ${digitalocean_droplet.this.ipv4_address}
      EOT
    filename = "${path.root}/inventory/host_vars/${var.name}.yml"
}

module "dns_consul" {
   source     = "../../network/dns_entry"
   zone       = var.subnet.domain
   record     = var.name
   typ        = "A"
   values     = [ digitalocean_droplet.this.ipv4_address ] 
} 

module "dns_consul_aaaa" { 
   source     = "../../network/dns_entry"
   zone       = var.subnet.domain
   record     = var.name
   typ        = "AAAA"
   values     = [ digitalocean_droplet.this.ipv6_address ] 
}