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
  hub_vnet_name               = "${var.region_abbreviation}-hub${var.resource_version}-${var.env_name}${var.env_key}-vnet${local.suffix}"
  private_vnet_name           = "${var.region_abbreviation}-pri${var.resource_version}-${var.env_name}${var.env_key}-vnet${local.suffix}"
  auth_vnet_name              = "${var.region_abbreviation}-auth${var.resource_version}-${var.env_name}${var.env_key}-vnet${local.suffix}"
  vnet_name                   = "${var.region_abbreviation}-mul${var.resource_version}-${var.env_name}${var.env_key}-vnet${local.suffix}"
  mul_storage_name            = "${var.region_abbreviation}mul${var.resource_version}func01${substr(var.env_name, 0, 1)}${var.env_key}sa${substr(local.suffix, 1, 4)}"
  mul_config_storage_name     = "${var.region_abbreviation}mul${var.resource_version}conf01${substr(var.env_name, 0, 1)}${var.env_key}sa${substr(local.suffix, 1, 4)}"
  mul_function_app_name       = "${var.region_abbreviation}-mul${var.resource_version}func01-${var.env_name}${var.env_key}-data-replay-fa${local.suffix}"
  mul_app_service_plan_name   = "${var.region_abbreviation}-mul${var.resource_version}func01-${var.env_name}${var.env_key}-asp${local.suffix}"
  mul_app_insights_name       = "${var.region_abbreviation}-mul${var.resource_version}func01-${var.env_name}${var.env_key}-ai${local.suffix}"
  auth_storage_name           = "${var.region_abbreviation}mul${var.resource_version}auth01${substr(var.env_name, 0, 1)}${var.env_key}sa${substr(local.suffix, 1, 4)}"
  auth_function_app_name      = "${var.region_abbreviation}-auth${var.resource_version}auth01-${var.env_name}${var.env_key}-fa${local.suffix}"
  auth_app_service_plan_name  = "${var.region_abbreviation}-auth${var.resource_version}auth01-${var.env_name}${var.env_key}-asp${local.suffix}"
  auth_app_insights_name      = "${var.region_abbreviation}-auth${var.resource_version}auth01-${var.env_name}${var.env_key}-ai${local.suffix}"
  
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


