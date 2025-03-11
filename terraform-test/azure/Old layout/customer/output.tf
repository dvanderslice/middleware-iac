output "unique_id" {
  description = "Resource unique identifier"
  value       = local.random_id
}

output "rg" {
  description = "Customer resource group resource"
  value       = module.rg
}

output "rg_id" {
  description = "Customer resource group Id"
  value       = module.rg.id
}

output "rg_name" {
  description = "Customer resource group name"
  value       = module.rg.name
}

output "subnet01_id" {
  description = "Subnet 01 Id in the private customer virtual network"
  value       = azurerm_subnet.cus_subnet01.id
}

output "subnet02_id" {
  description = "Subnet 02 Id in the private customer virtual network"
  value       = azurerm_subnet.cus_subnet02.id
}

output "cosmosdb_id" {
  description = "The CosmosDB identifier"
  value       = module.cosmosdb.cosmos_db_id
}

output "cosmos_db_endpoint" {
  description = "The CosmosDB endpoint"
  value       = module.cosmosdb.cosmos_db_endpoint
}

output "cosmos_db_endpoints_read" {
  description = "The CosmosDB read endpoints"
  value       = module.cosmosdb.cosmos_db_endpoints_read
}

output "cosmos_db_endpoints_write" {
  description = "The CosmosDB write endpoints"
  value       = module.cosmosdb.cosmos_db_endpoints_write
}

output "cosmos_db_primary_key" {
  description = "The CosmosDB primary key"
  value       = module.cosmosdb.cosmos_db_primary_key
  sensitive   = true
}

output "cosmos_db_secondary_key" {
  description = "The CosmosDB secondary key"
  value       = module.cosmosdb.cosmos_db_secondary_key
  sensitive   = true
}

output "cosmos_db_primary_readonly_key" {
  description = "The CosmosDB primary read-only key"
  value       = module.cosmosdb.cosmos_db_primary_readonly_key
  sensitive   = true
}

output "cosmos_db_secondary_readonly_key" {
  description = "The CosmosDB secondary read-only key"
  value       = module.cosmosdb.cosmos_db_secondary_readonly_key
  sensitive   = true
}

output "cosmos_db_connection_strings" {
  description = "The CosmosDB connection strings"
  value       = module.cosmosdb.cosmos_db_connection_strings
  sensitive   = true
}

output "op_storage_account_id" {
  value       = azurerm_storage_account.op_sa.id
  description = "The Id of the multi-purpose customer storage account."
}

output "op_storage_account_name" {
  value       = azurerm_storage_account.op_sa.name
  description = "The name of the multi-purpose customer storage account."
}

output "op_storage_primary_connection_string" {
  value       = azurerm_storage_account.op_sa.primary_connection_string
  sensitive   = true
  description = "The primary connection string for the multi-purpose customer storage account."
}

output "op_storage_primary_access_key" {
  value       = azurerm_storage_account.op_sa.primary_access_key
  sensitive   = true
  description = "The primary access key for the multi-purpose customer storage account."
}
