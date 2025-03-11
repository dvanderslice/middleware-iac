resource "random_id" "id" {
  count       = var.random_id == null ? 1 : 0
  byte_length = 2
}

locals {
  random_id           = var.random_id == null ? random_id.id[0].hex : var.random_id
  suffix              = local.random_id == null ? "" : "-${local.random_id}"
  resource_group_name = "AppGrp-${var.purpose}${var.resource_version}-${var.env_name}${var.env_key}-rg${local.suffix}"
  cosmosdb_name       = "${var.region_abbreviation}-${var.purpose}${var.resource_version}-${var.env_name}${var.env_key}-cd${local.suffix}"
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

module "db" {
  source = "../../modules/cosmosdb"

  azure_location      = var.azure_location
  resource_group_name = module.rg.name
  cosmosdb_name       = local.cosmosdb_name

  tags = merge(local.resource_tags, {
    "role"      = "database"
    "createdon" = local.tag_createdon
  })
}
