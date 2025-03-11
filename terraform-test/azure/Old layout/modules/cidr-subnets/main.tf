locals {
  addrs_by_idx = cidrsubnets(var.base_cidr_block, var.networks[*].new_bits...)
  # We do not want the 0 index as that is reserved
  addrs_by_name = { for i, n in var.networks : n.name => local.addrs_by_idx[i] if n.name != null && i != 0 }
  network_objs = [for i, n in var.networks : {
    name       = n.name
    new_bits   = n.new_bits
    cidr_block = n.name != null ? local.addrs_by_idx[i] : tostring(null)
  }]
}
