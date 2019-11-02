
variable "zone"     {}
variable "ttl"      { default = 600 }

resource "digitalocean_domain" "this" {
  name       = var.zone
}

output "zone" { value = digitalocean_domain.this.id }