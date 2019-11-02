
/* ***************************************************************
 * Infrastructur Net
 * ************************************************************ */

module "infra" {
   source = "./infra"
   
   name       = "infra"
   domain     = var.domain
   region     = var.region
   
   ssh_key    = digitalocean_ssh_key.ansible
}


/* ***************************************************************
 * Compute Cluster (public)
 * ************************************************************ */

module "common_compute" {
   source = "./common_compute"
   
   name       = "common"
   domain     = var.domain
   region     = var.region

   ssh_key    = digitalocean_ssh_key.ansible
   servicediscovery = module.infra.servicediscovery
}


/* ***************************************************************
 * Global
 * ************************************************************ */

resource "digitalocean_ssh_key" "ansible" {
  name   = "ansible-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCgY5XkmYMhA6Ma2rvVhTqWx9VCf79ymNvCIXu63RyyHOv/XkxCJB5XkxUo4NfyeA+R9/RyPhDCUxrzQkyfpOxTv945+zpkYYzeF8OxO+l7lYbex99VYcVHPyoIiGZyvpDV8Yrs8A3ppnA3OQUqxSgzx1nuHuzHAC69a/yyZmYrcW7246b1LFB91tSYRjSAmUii8fQ+LgCVPrvXeldaaEd/WkWJSgHaZ/EylZ5zm1Nw+4cAjHnj/FLgPd24CNTQwzxcAf1sX2vw2NPyCl4mWietVZxNBcQi49fv1LN5InnFqWdNsA9N4Gj9YmumEnUNEE/Vg5STRijPdE+jScaKdwWhT9MGcZu21MsIrMRhzO9OffGylyRP0fuYfSRIF0i7pg2mK51kBWb21+E56aU+L3FafPcR5xUC5Laq6ahpcxllAdOriFbdSHHZmuOM+3jvRcqN10lmbjwvB6QFSkj78JiO0UKLLCniyZu/TYwAq13XQ2NwRqXhFu8HYfufjIPppLz27BIE1tqCrNnytruduOKs0ZBCPkbqYsI+XurdCYfCw3iYv1Z3Si6r/0OjbfsVxSpodaaqoPqslJNLelHbXctVKm53BYPMZm8Zyp+IYsUNzpwjQeCpgsN3oiTDJNhTxnAUtSpWlaYnDrF4qFgVZf9oq6ax85l554MgrRdbejPIXw=="
}


