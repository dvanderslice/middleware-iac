output "unique_id" {
  description = "Resource unique identifier"
  value       = local.random_id
}

output "shared_rg" {
  description = "Shared resource group resource"
  value       = module.shared_rg
}

output "shared_id" {
  description = "Shared resource group Id"
  value       = module.shared_rg.id
}

output "shared_name" {
  description = "Shared resource group name"
  value       = module.shared_rg.name
}

output "shared_apim_id" {
  description = "Shared API management service identifier"
  value       = var.primary_region ? module.shared_apim[0].apim_id : null
}

output "shared_subnet01_id" {
  description = "Subnet Id in the shared virtual network"
  value       = azurerm_subnet.shared_subnet01.id
}
