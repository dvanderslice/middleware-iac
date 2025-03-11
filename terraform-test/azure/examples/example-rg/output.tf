output "unique_id" {
  description = "Resource unique identifier"
  value       = local.random_id
}

output "rg" {
  description = "Resource group resource"
  value       = module.rg.rg
}

output "id" {
  description = "Resource group id"
  value       = module.rg.id
}

output "name" {
  description = "Resource group name"
  value       = module.rg.name
}
