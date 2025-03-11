output "kusto_cluster_id" {
  description = "The Kusto cluster identifier"
  value       = azurerm_kusto_cluster.cluster.id
}

output "kusto_cluster_uri" {
  description = "The FQDN of the Kusto cluster"
  value       = azurerm_kusto_cluster.cluster.uri
}

output "kusto_cluster_ingestion_uri" {
  description = "The Kusto cluster URI to be used for data ingestion"
  value       = azurerm_kusto_cluster.cluster.data_ingestion_uri
}

output "kusto_cluster_adx_engine_ip" {
  description = "The Kusto cluster public IP address to be used for the ADX engine"
  value       = azurerm_public_ip.engine.ip_address
}

output "kusto_cluster_data_management_ip" {
  description = "The Kusto cluster public IP address to be used for data management"
  value       = azurerm_public_ip.management.ip_address
}
