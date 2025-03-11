output "unique_id" {
  description = "Resource unique identifier"
  value       = local.random_id
}

output "rg" {
  description = "Resource group resource"
  value       = module.rg
}

output "id" {
  description = "Resource group id"
  value       = module.rg.id
}

output "name" {
  description = "Resource group name"
  value       = module.rg.name
}

output "cosmos_db_id" {
  description = "CosmosDB Account Identifier"
  value       = module.db.cosmos_db_id
}

output "cosmos_db_endpoint" {
  description = "The endpoint used to connect to the CosmosDB account"
  value       = module.db.cosmos_db_endpoint
}

output "cosmos_db_endpoints_read" {
  description = "A list of read endpoints available to the CosmosDB account"
  value       = module.db.cosmos_db_endpoints_read
}

output "cosmos_db_endpoints_write" {
  description = "A list of write endpoints available to the CosmosDB account"
  value       = module.db.cosmos_db_endpoints_write
}

output "cosmos_db_primary_key" {
  description = "The primary master key to the CosmosDB account"
  value       = module.db.cosmos_db_primary_key
}

output "cosmos_db_secondary_key" {
  description = "The secondary master key to the CosmosDB account"
  value       = module.db.cosmos_db_secondary_key
}

output "cosmos_db_primary_readonly_key" {
  description = "The primary read-only master key to the CosmosDB account"
  value       = module.db.cosmos_db_primary_readonly_key
}

output "cosmos_db_secondary_readonly_key" {
  description = "The secondary read-only master key to the CosmosDB account"
  value       = module.db.cosmos_db_secondary_readonly_key
}

output "cosmos_db_connection_strings" {
  description = "A list of connection strings available to the CosmosDB account"
  value       = module.db.cosmos_db_connection_strings
}
