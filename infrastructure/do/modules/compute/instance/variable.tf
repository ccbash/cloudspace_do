/* ***************************************************************
 * Input Variables
 * ************************************************************ */
 
variable "name"           { }
variable "instance_type"  { default = "t2.micro" }
variable "ssh_key"        { }
variable "subnet"         { type = map }
variable "user_data"      { default = "" }
variable "image"          { default = "" }
variable "image_owner"    { default = "amazon" }
variable "ingress_ports"  { default = [] }
variable "ansible_vars"   { default = {} }

variable "tags" {
  type        = map(string)
  default     = {}
}
variable "volume_tags" {
  type        = map(string)
  default     = {}
}
variable "root_block_device" {
  type        = list(map(string))
  default     = []
}
variable "ebs_block_device" {
  type        = list(map(string))
  default     = []
}
variable "ephemeral_block_device" {
  type        = list(map(string))
  default     = []
}

