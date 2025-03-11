output "virtual_wan_id" {
  description = "The virtual WAN identifier"
  value       = module.virtualhub.virtual_wan_id
}

output "virtual_hub_id" {
  description = "The virtual hub identifier"
  value       = module.virtualhub.virtual_hub_id
}

output "firewall_id" {
  description = "The firewall identifier"
  value       = module.virtualhub.firewall_id
}

#output "public_ip_id" {
#  description = "The public IP identifier"
#  value       = module.virtualhub.public_ip_id
#}

#output "public_ip" {
#  description = "The public IP address value"
#  value       = module.virtualhub.public_ip
#}

output "subnet01_id" {
  description = "The hub virtual network subnet 01 identifier"
  value       = module.virtualhub.subnet01_id
}
