

/* ***************************************************************
 * Security Rule
 * ************************************************************ */
 
resource "digitalocean_firewall" "this" {
  name = "var.name"

  droplet_ids = [ var.instance_id ]
  
  dynamic "inbound_rule" { 
    for_each = var.ingress_ports
    content {
      port_range            = inbound_rule.value[0]
      protocol              = inbound_rule.value[1]
      source_addresses      = ["0.0.0.0/0", "::/0"]
    }
  }
  
  inbound_rule {
      protocol              = "tcp"
      port_range            = "1-1024"
      source_addresses      = ["10.0.0.0/8", "2002:1:2::/48"]
  }

  outbound_rule {
      protocol              = "tcp"
      port_range            = "1-1024"
      destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
      protocol              = "icmp"
      destination_addresses = ["0.0.0.0/0", "::/0"]
  }
  
  outbound_rule {
    protocol              = "udp"
    port_range            = "1-1024"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }
}



