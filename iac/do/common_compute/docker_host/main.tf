

data "template_file" "user_data" {
  template = file("${path.module}/templates/user-data.sh")

  vars = {
    datacenter   = var.servicediscovery.datacenter
    zone         = var.domain
    servicediscovery_ip = var.servicediscovery.private_ip
  }
}

/* ***************************************************************
 * Instance with an security group
 * ************************************************************ */


module "instance" {
  source = "../../modules/compute/instance"
  
  name           = var.name
  image          = "coreos-stable"
  instance_type  = "s-1vcpu-1gb"  
  user_data      = data.template_file.user_data.rendered
  ssh_key        = var.ssh_key
  subnet         = var.subnet
}


