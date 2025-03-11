resource "random_id" "id" {
  count       = var.random_id == null ? 1 : 0
  byte_length = 2
}

locals {
  random_id           = var.random_id == null ? random_id.id[0].hex : var.random_id
  suffix              = local.random_id == null ? "" : "-${local.random_id}"
  resource_group_name = "AppGrp-${var.purpose}${var.resource_version}-${var.env_name}${var.env_key}-rg${local.suffix}"
  kusto_name          = "${var.region_abbreviation}-${var.purpose}${var.resource_version}-${var.env_name}${var.env_key}-dcl${local.suffix}"
  tag_createdon       = formatdate("YYYY-MM-DD", timestamp())

  resource_tags = merge(var.tags,
    var.runtime_tags, {
      "unique_id" = local.random_id
  })
}

module "rg" {
  source = "../../modules/rg"

  azure_location      = var.azure_location
  resource_group_name = local.resource_group_name

  tags = merge(local.resource_tags, {
    "role"      = "data"
    "createdon" = local.tag_createdon
  })
}

module "kusto" {
  source = "../../modules/kusto"

  azure_location                = var.azure_location
  resource_group_name           = module.rg.name
  kusto_name                    = local.kusto_name
  kusto_sku_name                = "Standard_D13_v2"
  kusto_sku_capacity            = 2
  subnet_id                     = "/subscriptions/7561e71a-f6ea-4fbb-b139-801780a9d29d/resourceGroups/AppGrp-mul01-dev01-rg/providers/Microsoft.Network/virtualNetworks/eus2-mul01-dev01-vnet/subnets/subnet01"
  public_ip_name_for_engine     = "eus2-mul05-adx-engine-pip"
  public_ip_name_for_management = "eus2-mul05-data-management-pip"

  tags = merge(local.resource_tags, {
    "role"      = "database"
    "createdon" = local.tag_createdon
  })
}
