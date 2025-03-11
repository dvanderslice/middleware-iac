output "unique_id" {
  description = "Resource unique identifier"
  value       = local.random_id
}

output "rg" {
  description = "Resource group resource"
  value       = module.rg
}

output "id" {
  description = "Resource group Id"
  value       = module.rg.id
}

output "name" {
  description = "Resource group name"
  value       = module.rg.name
}

output "storage_account_id" {
  value       = module.function_app.storage_account_id
  description = "The Id of the storage account"
}

output "storage_account_name" {
  value       = module.function_app.storage_account_name
  description = "The name of the storage account"
}

output "storage_primary_connection_string" {
  value       = module.function_app.storage_primary_connection_string
  sensitive   = true
  description = "The primary connection string for the storage account"
}

output "storage_primary_access_key" {
  value       = module.function_app.storage_primary_access_key
  sensitive   = true
  description = "The primary access key for the storage account"
}

output "app_service_plan_id" {
  description = "App service plan Id"
  value       = module.function_app.app_service_plan_id
}

output "insights_app_id" {
  value       = module.function_app.insights_app_id
  description = "The app insights application identifier"
}

output "insights_instrumentation_key" {
  value       = module.function_app.insights_instrumentation_key
  description = "The app insights instrumentation key"
  sensitive   = true
}

output "insights_connection_string" {
  value       = module.function_app.insights_connection_string
  description = "The app insights connection string"
  sensitive   = true
}

output "function_app_id" {
  description = "Function app Id"
  value       = module.function_app.function_app_id
}

output "function_app_hostname" {
  description = "Function app hostname"
  value       = module.function_app.function_app_hostname
}
