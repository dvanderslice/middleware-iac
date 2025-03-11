output "network_cidr_blocks" {
  value       = module.subnet_addrs.network_cidr_blocks
  description = "A map from network names to allocated address prefixes in CIDR notation."
}

output "networks" {
  value       = module.subnet_addrs.networks
  description = "A list of objects corresponding to each of the objects in the input variable 'networks', each extended with a new attribute 'cidr_block' giving the network's allocated address prefix."
}

output "base_cidr_block" {
  value       = var.base_cidr_block
  description = "Echoes back the base_cidr_block input variable value, for convenience if passing the result of this module elsewhere as an object."
}
