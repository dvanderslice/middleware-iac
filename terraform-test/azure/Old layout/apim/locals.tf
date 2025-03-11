resource "random_id" "id" {
  count       = var.random_id == null && var.use_random_id ? 1 : 0
  byte_length = 2
}

locals {
  random_id                  = var.random_id == null && var.use_random_id ? random_id.id[0].hex : var.random_id
  suffix                     = local.random_id == null || !var.use_random_id ? "" : "-${local.random_id}"
  apim_sku                   = var.multi_regional_deployment ? "Premium_1" : "Developer_1"
  shared_resource_group_name = "AppGrp-shared${var.resource_version}-${var.env_name}${var.env_key}-rg${local.suffix}"
  apim_name                  = "shared-${var.env_name}${var.env_key}-apim${local.suffix}"
  apim_nsg_name              = "shared-${var.env_name}${var.env_key}-api-nsg${local.suffix}"
  shared_vnet_name           = "${var.region_abbreviation}-shared-${var.env_name}${var.env_key}-vnet${local.suffix}"
  tag_createdon              = formatdate("YYYY-MM-DD", timestamp())

  resource_tags = merge(var.tags,
    var.runtime_tags, {
      "unique_id" = local.random_id
  })
}
