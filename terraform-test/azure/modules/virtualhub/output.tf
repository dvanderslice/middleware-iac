output "virtual_wan_id" {
  description = "The virtual WAN identifier"
  value       = azurerm_virtual_wan.wan.id
}

output "virtual_hub_id" {
  description = "The virtual hub identifier"
  value       = azurerm_virtual_hub.hub.id
}

output "firewall_id" {
  description = "The firewall identifier"
  value       = azurerm_firewall.firewall.id
}


