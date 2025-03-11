output "cosmos_db_id" {
  value = azurerm_cosmosdb_account.instance.id
}

output "cosmos_db_endpoint" {
  value = azurerm_cosmosdb_account.instance.endpoint
}

output "cosmos_db_endpoints_read" {
  value = azurerm_cosmosdb_account.instance.read_endpoints
}

output "cosmos_db_endpoints_write" {
  value = azurerm_cosmosdb_account.instance.write_endpoints
}

output "cosmos_db_primary_key" {
  value = azurerm_cosmosdb_account.instance.primary_key
}

output "cosmos_db_secondary_key" {
  value = azurerm_cosmosdb_account.instance.secondary_key
}

output "cosmos_db_primary_readonly_key" {
  value = azurerm_cosmosdb_account.instance.primary_readonly_key
}

output "cosmos_db_secondary_readonly_key" {
  value = azurerm_cosmosdb_account.instance.secondary_readonly_key
}

output "cosmos_db_connection_strings" {
  value = azurerm_cosmosdb_account.instance.connection_strings
}
