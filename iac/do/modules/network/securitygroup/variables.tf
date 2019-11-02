variable "name"           { }
variable "instance_id"    { }

# Security
variable "egress_all"     { default = false }
variable "egress_cidr"    { default = [ ] }
variable "ingress_ports"  { default = [ ] }
variable "ingress_sg"     { default = [ ] }
variable "ingress_cidr"   { default = [ ] }

# not needed here
variable "vpc_id"         { default = [ ] }