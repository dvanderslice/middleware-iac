output "storage_account_id" {
  value       = var.create_new_storage_account ? azurerm_storage_account.storage_account[0].id : null
  description = "The Id of the storage account."
}

output "storage_account_name" {
  value       = var.create_new_storage_account ? azurerm_storage_account.storage_account[0].name : null
  description = "Terraform function app storage account"
}

output "storage_primary_access_key" {
  value       = var.create_new_storage_account ? azurerm_storage_account.storage_account[0].primary_access_key : null
  sensitive   = true
  description = "Terraform function app storage account primary access key"
}

output "storage_primary_connection_string" {
  value       = var.create_new_storage_account ? azurerm_storage_account.storage_account[0].primary_connection_string : null
  sensitive   = true
  description = "Terraform function app storage account primary connection string"
}

output "storage_primary_blob_connection_string" {
  value       = var.create_new_storage_account ? azurerm_storage_account.storage_account[0].primary_blob_connection_string : null
  description = "Terraform function app storage account primary Blob service connection string"
}

output "app_service_plan_id" {
  value       = azurerm_app_service_plan.app_service_plan.id
  description = "Terraform app service plan identifier"
}

output "insights_app_id" {
  value       = azurerm_application_insights.insights.app_id
  description = "Terraform app insights application identifier"
}

output "insights_instrumentation_key" {
  value       = azurerm_application_insights.insights.instrumentation_key
  description = "Terraform app insights instrumentation key"
  sensitive   = true
}

output "insights_connection_string" {
  value       = azurerm_application_insights.insights.connection_string
  description = "Terraform app insights connection string"
  sensitive   = true
}

output "function_app_id" {
  value       = var.subnet_id == null ? azurerm_function_app.function_app[0].id : azurerm_function_app.function_app_with_subnet[0].id
  description = "Terraform function app identifier"
}

output "function_app_hostname" {
  value       = var.subnet_id == null ? azurerm_function_app.function_app[0].default_hostname : azurerm_function_app.function_app_with_subnet[0].default_hostname
  description = "Terraform function app default hostname"
}
