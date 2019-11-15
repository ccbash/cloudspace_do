
/* ***************************************************************
 * Infrastructur Net
 * ************************************************************ */

module "frontend" {
   source = "./frontend"
   
   name       = "fe"
   domain     = var.domain
   region     = var.region
   ssh_key    = digitalocean_ssh_key.ansible
}


/* ***************************************************************
 * Compute Cluster (public)
 * ************************************************************ */

module "backend" {
   source = "./backend"
   
   name       = "be"
   domain     = var.domain
   region     = var.region
   ssh_key    = digitalocean_ssh_key.ansible
}


/* ***************************************************************
 * Global
 * ************************************************************ */

resource "digitalocean_ssh_key" "ansible" {
  name   = "ansible-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCmdXGpnPzxx3Z1XRjSPxSxB+Oob6gGMcqGEmxeR9ly3hlzUI5yTrgLOSwwLvOCaT17ePKdObXBKt49TH1NX2kzNNwY7VBILxvGchRh/9rJvwCmJENOaI5ibZoPL/+bhF1YEK1V3Sgy8NfJUa1/ZgMDUQDz8WpqoTNJReq3B6+UyeB2sbGQVRDVEdnWhkICpl6eWNBDJNgBTXxS8chOZi526U9tFr1veZtOYvMlDhFiJp5z1dr7zR+PJL6KHm41WYDVW2YG922Le4uUdKnA9eCEX+AiRUiK1qydENpPs60WI+quLdNRh7MQbaI5RZ5Pjl8jFK1PZuzjrFp9gjj+jQn5A5lATRIE1T/kFGfycsx+wexCcPjykFWRAfgNngh/8JQ8PGaKh5J608zQCpUXkbu5+3c2jrRRDQlQx9GJwCVYSh7CN6KUXl8kOurcvVEJaB26ih8Nx18/YFvR7SszhUAk5z1Z5junungebOs/LJErb8ge3UgdoyR+osp7bqbDzcGcgN0c5o4wSZoQoEjGIFamaF4SL9btzlLBl+E9WIopnV1NZFVtwttRsnTQ3Oztb3hKknYikoDqxaepYZwQwRMjdeS9lKipmglb5l+snsMg8EA3d7rU8fHa3MmVUdSLUff+Tlh257yoTFnAH0ko7oUNOe+/TIJZuAat8Vs3FoRK5w=="
}


