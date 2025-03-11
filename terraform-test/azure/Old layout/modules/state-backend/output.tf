output "storage_account_name" {
  value       = azurerm_storage_account.tfstate_sa.name
  description = "Terraform backend storage account"
}

output "primary_access_key" {
  value       = azurerm_storage_account.tfstate_sa.primary_access_key
  sensitive   = true
  description = "Terraform backend storage account primary access key"
}

output "primary_connection_string" {
  value       = azurerm_storage_account.tfstate_sa.primary_connection_string
  sensitive   = true
  description = "Terraform backend storage account primary connection string"
}

output "primary_blob_connection_string" {
  value       = azurerm_storage_account.tfstate_sa.primary_blob_connection_string
  sensitive   = true
  description = "Terraform backend storage account primary Blob service connection string"
}

output "container_name" {
  value       = azurerm_storage_container.tfstate_blob.name
  description = "Terraform backend storage container name"
}

output "rg" {
  description = "Resource group resource"
  value       = azurerm_resource_group.tfstate-rg
}

output "unique_id" {
  description = "Resource unique identifier"
  value       = local.random_id
}
