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

output "kusto_cluster_id" {
  description = "The Kusto cluster identifier"
  value       = module.kusto.kusto_cluster_id
}

output "kusto_cluster_uri" {
  description = "The FQDN of the Kusto cluster"
  value       = module.kusto.kusto_cluster_uri
}

output "kusto_cluster_ingestion_uri" {
  description = "The Kusto cluster URI to be used for data ingestion"
  value       = module.kusto.kusto_cluster_ingestion_uri
}

output "kusto_cluster_adx_engine_ip" {
  description = "The Kusto cluster public IP address to be used for the ADX engine"
  value       = module.kusto.kusto_cluster_adx_engine_ip
}

output "kusto_cluster_data_management_ip" {
  description = "The Kusto cluster public IP address to be used for data management"
  value       = module.kusto.kusto_cluster_data_management_ip
}
