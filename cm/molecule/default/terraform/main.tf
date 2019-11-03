locals {
  platforms = "${yamldecode(file("../molecule.yml"))["platforms"]}"
  domain    = "ansible.local"
}

provider "digitalocean" {
}

/* ***************************************************************
 * Instance with an security group
 * ************************************************************ */

resource "digitalocean_droplet" "this" {
  count               = length(local.platforms)
  
  image               = local.platforms[count.index].image
  name                = local.platforms[count.index].name
  region              = local.platforms[count.index].region
  size                = local.platforms[count.index].size
  private_networking  = local.platforms[count.index].private_networking
  ssh_keys            = [ digitalocean_ssh_key.ansible.id ]
}

/* ***************************************************************
 * DNS Records
 * ************************************************************ */

/*   CURRENTLY NO NEED fOR DNS

resource "digitalocean_record" "A" {
  count  = length(digitalocean_droplet.this)
  
  domain = local.domain
  type   = "A"
  name   = digitalocean_droplet.this[count.index].name
  value  = digitalocean_droplet.this[count.index].ipv4_address
  ttl    = 60
}

resource "digitalocean_record" "AAAA" {
  count  = length(digitalocean_droplet.this)
  
  domain = local.domain
  type   = "AAAA"
  name   = digitalocean_droplet.this[count.index].name
  value  = digitalocean_droplet.this[count.index].ipv6_address
  ttl    = 60
}

*/

resource "local_file" "foo" {
  count  = length(digitalocean_droplet.this)
 
  content  = <<-EOT
  ansible_ssh_host: ${digitalocean_droplet.this[count.index].ipv4_address}
  ansible_ssh_port: 22422
  ansible_ssh_user: ${local.platforms[count.index].ssh_user}
  ansible_python_interpreter: /opt/bin/python
  EOT  
  filename = "${path.module}/host_vars/${digitalocean_droplet.this[count.index].name}.yml"
}

/* ***************************************************************
 * SSH Key
 * ************************************************************ */

resource "digitalocean_ssh_key" "ansible" {
  name   = "ansible-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCmdXGpnPzxx3Z1XRjSPxSxB+Oob6gGMcqGEmxeR9ly3hlzUI5yTrgLOSwwLvOCaT17ePKdObXBKt49TH1NX2kzNNwY7VBILxvGchRh/9rJvwCmJENOaI5ibZoPL/+bhF1YEK1V3Sgy8NfJUa1/ZgMDUQDz8WpqoTNJReq3B6+UyeB2sbGQVRDVEdnWhkICpl6eWNBDJNgBTXxS8chOZi526U9tFr1veZtOYvMlDhFiJp5z1dr7zR+PJL6KHm41WYDVW2YG922Le4uUdKnA9eCEX+AiRUiK1qydENpPs60WI+quLdNRh7MQbaI5RZ5Pjl8jFK1PZuzjrFp9gjj+jQn5A5lATRIE1T/kFGfycsx+wexCcPjykFWRAfgNngh/8JQ8PGaKh5J608zQCpUXkbu5+3c2jrRRDQlQx9GJwCVYSh7CN6KUXl8kOurcvVEJaB26ih8Nx18/YFvR7SszhUAk5z1Z5junungebOs/LJErb8ge3UgdoyR+osp7bqbDzcGcgN0c5o4wSZoQoEjGIFamaF4SL9btzlLBl+E9WIopnV1NZFVtwttRsnTQ3Oztb3hKknYikoDqxaepYZwQwRMjdeS9lKipmglb5l+snsMg8EA3d7rU8fHa3MmVUdSLUff+Tlh257yoTFnAH0ko7oUNOe+/TIJZuAat8Vs3FoRK5w=="
}
