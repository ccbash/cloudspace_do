/* ***************************************************************
 * Output
 * ************************************************************ */

output "id"         { value = digitalocean_droplet.this.id }
output "urn"        { value = digitalocean_droplet.this.urn }
output "ipv4_private" { value = digitalocean_droplet.this.ipv4_address_private }
output "ipv4"  { value = digitalocean_droplet.this.ipv4_address }
output "ipv6"       { value = [ digitalocean_droplet.this.ipv6_address ] }
