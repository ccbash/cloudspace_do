/* ***************************************************************
 * Variables
 * ************************************************************ */

variable "name"    { }
variable "domain"  { }
variable "region"  { }
variable "ssh_key" { }

variable "hosts"   { type = map() }