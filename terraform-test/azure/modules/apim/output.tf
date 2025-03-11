output "apim_id" {
  description = "API management Id"
  value       = length(azurerm_api_management.service) > 0 ? azurerm_api_management.service[0].id : azurerm_api_management.service_with_vnet[0].id
}

output "management_api_url" {
  description = "API management URL"
  value       = length(azurerm_api_management.service) > 0 ? azurerm_api_management.service[0].management_api_url : azurerm_api_management.service_with_vnet[0].management_api_url
}
