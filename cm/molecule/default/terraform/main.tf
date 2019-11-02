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
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEApk1XztH8SL+Y6LyU9q502oZOku7VyrYLQinzvWInICzMwQ8rReuGhgABMDuIZv++adSS1sz1OFo9o3nvzNYepIi38St7wzoFQDO6TQiL3qnO+//JHCZJ09FeJ6Ig685lrItCIGmYAH2L2FLLwYkrng79uZxgwEWkHSD4svqqpVfccFwVv/4gAHN79ay8npm8YgDfujB3ZZR202hWzo1UfajqEoSOf8ygzNrkiMCYbtQENgQyoyAi+ZkPGAD3KUVNCMZGfAvem0WXcuVrz2XaIDIjDvDWkVRP6b6weYtXwH/8PXMBJWpNyaNtZjR5dIdHPjqTraUmqar0cqxU3F9nHw== rsa-key-ansible-201910"
}
