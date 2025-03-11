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

output "storage_account_id" {
  value       = module.cdn.storage_account_id
  description = "The Id of the storage account"
}

output "storage_account_name" {
  value       = module.cdn.storage_account_name
  description = "The name of the storage account"
}

output "storage_primary_connection_string" {
  value       = module.cdn.storage_primary_connection_string
  sensitive   = true
  description = "The primary connection string for the storage account"
}

output "storage_primary_access_key" {
  value       = module.cdn.storage_primary_access_key
  sensitive   = true
  description = "The primary access key for the storage account"
}

output "static_website_cdn_endpoint_hostname" {
  value       = module.cdn.static_website_cdn_endpoint_hostname
  description = "CDN endpoint URL for static web site"
}

output "static_website_cdn_profile_name" {
  value       = module.cdn.static_website_cdn_profile_name
  description = "CDN profile name for the static web site"
}

output "static_website_url" {
  value       = module.cdn.static_website_url
  description = "The static web site URL"
}
