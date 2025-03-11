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

output "apim_id" {
  description = "API management service identifier"
  value       = module.apim.apim_id
}

output "apim_management_url" {
  description = "API management URL"
  value       = module.apim.management_api_url
}
