/* ***************************************************************
 * Output
 * ************************************************************ */

output "id"         { value = digitalocean_droplet.this.id }
output "urn"        { value = digitalocean_droplet.this.urn }
output "private_ip" { value = digitalocean_droplet.this.ipv4_address_private }
output "public_ip"  { value = digitalocean_droplet.this.ipv4_address }
output "ipv6"       { value = [ digitalocean_droplet.this.ipv6_address ] }
