/* ***************************************************************
 * Output
 * ************************************************************ */

output "instance"   { value = module.instance }
output "private_ip" { value = module.instance.private_ip }
output "ipv6"       { value = module.instance.ipv6 }
