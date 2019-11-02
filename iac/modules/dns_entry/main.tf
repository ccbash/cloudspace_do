
# api key for nsone

variable "zone"     { }
variable "typ"      { default = "A" }
variable "record"   { } 
variable "ttl"      { default = 600 } 
variable "values"   { type = list(string) }

resource "digitalocean_record" "this" {
  domain = var.zone
  type   = var.typ
  name   = var.record
  value  = var.values[0]
  ttl    = var.ttl
}