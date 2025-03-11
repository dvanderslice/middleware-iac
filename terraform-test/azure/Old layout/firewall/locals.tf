resource "random_id" "id" {
  count       = var.random_id == null && var.use_random_id ? 1 : 0
  byte_length = 2
}

locals {
  random_id                   = var.random_id == null && var.use_random_id ? random_id.id[0].hex : var.random_id
  suffix                      = local.random_id == null || !var.use_random_id ? "" : "-${local.random_id}"
  shared_resource_group_name  = "AppGrp-shared${var.resource_version}-${var.env_name}${var.env_key}-rg${local.suffix}"
  hub_resource_group_name     = "AppGrp-hub${var.resource_version}-${var.env_name}${var.env_key}-rg${local.suffix}"
  private_resource_group_name = "AppGrp-pri${var.resource_version}-${var.env_name}${var.env_key}-rg${local.suffix}"
  auth_resource_group_name    = "AppGrp-auth${var.resource_version}-${var.env_name}${var.env_key}-rg${local.suffix}"
  mul_resource_group_name     = "AppGrp-mul${var.resource_version}-${var.env_name}${var.env_key}-rg${local.suffix}"
  shared_vnet_name            = "${var.region_abbreviation}-shared-${var.env_name}${var.env_key}-vnet${local.suffix}"
  private_vnet_name           = "${var.region_abbreviation}-pri${var.resource_version}-${var.env_name}${var.env_key}-vnet${local.suffix}"
  auth_vnet_name              = "${var.region_abbreviation}-auth${var.resource_version}-${var.env_name}${var.env_key}-vnet${local.suffix}"
  mul_vnet_name               = "${var.region_abbreviation}-mul${var.resource_version}-${var.env_name}${var.env_key}-vnet${local.suffix}"
  auth_vnet_ip_group_name          = "${var.region_abbreviation}-auth_vnet${var.resource_version}-${var.env_name}${var.env_key}-ipg"
  p2s_ip_group_name           = "${var.region_abbreviation}-p2s_vnet${var.resource_version}-${var.env_name}${var.env_key}-ipg"
  pri_vnet_ip_group_name      = "${var.region_abbreviation}-pri_vnet${var.resource_version}-${var.env_name}${var.env_key}-ipg"
  shared_vnet_ip_group_name   = "${var.region_abbreviation}-shared_vnet${var.resource_version}-${var.env_name}${var.env_key}-ipg"
  mul_vnet_ip_group_name      = "${var.region_abbreviation}-mul_vnet${var.resource_version}-${var.env_name}${var.env_key}-ipg"
  functions_private_subnet_ip_group_name      = "${var.region_abbreviation}-func_pri_subnet${var.resource_version}-${var.env_name}${var.env_key}-ipg"
  shared_private_subnet_ip_group_name      = "${var.region_abbreviation}-shared_pri_subnet${var.resource_version}-${var.env_name}${var.env_key}-ipg"
  storage_private_subnet_ip_group_name      = "${var.region_abbreviation}-storage_pri_subnet${var.resource_version}-${var.env_name}${var.env_key}-ipg"
  data_private_subnet_ip_group_name      = "${var.region_abbreviation}-data_pri_subnet${var.resource_version}-${var.env_name}${var.env_key}-ipg"

  tag_createdon               = formatdate("YYYY-MM-DD", timestamp())

  config_containers_list = [
    { name = "aiconfig", access_type = "private" },
    { name = "authconfig", access_type = "private" },
    { name = "config", access_type = "private" }
  ]

  resource_tags = merge(var.tags,
    var.runtime_tags, {
      "unique_id" = local.random_id
  })
}
