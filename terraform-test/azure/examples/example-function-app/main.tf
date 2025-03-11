resource "random_id" "id" {
  count       = var.random_id == null ? 1 : 0
  byte_length = 2
}

locals {
  random_id             = var.random_id == null ? random_id.id[0].hex : var.random_id
  suffix                = local.random_id == null ? "" : "-${local.random_id}"
  resource_group_name   = "AppGrp-${var.purpose}${var.resource_version}-${var.env_name}${var.env_key}-rg${local.suffix}"
  storage_account_name  = "${var.region_abbreviation}${var.purpose}${var.resource_version}${substr(var.env_name, 0, 1)}${var.env_key}sa${substr(local.suffix, 1, 4)}"
  function_app_name     = "${var.region_abbreviation}-${var.purpose}${var.resource_version}${var.app_abbreviation}-${var.env_name}${var.env_key}-fa${local.suffix}"
  app_service_plan_name = "${var.region_abbreviation}-${var.purpose}${var.resource_version}${var.app_abbreviation}-${var.env_name}${var.env_key}-asp${local.suffix}"
  app_insights_name     = "${var.region_abbreviation}-${var.purpose}${var.resource_version}${var.app_abbreviation}-${var.env_name}${var.env_key}-ai${local.suffix}"
  tag_createdon         = formatdate("YYYY-MM-DD", timestamp())
  
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
    "role"      = "application"
    "createdon" = local.tag_createdon
  })
}

module "function_app" {
  source = "../../modules/function-app"

  azure_location        = var.azure_location
  resource_group_name   = module.rg.name
  storage_account_name  = local.storage_account_name
  function_app_name     = local.function_app_name
  app_service_plan_name = local.app_service_plan_name
  app_insights_name     = local.app_insights_name

  tags = merge(local.resource_tags, {
    "role"      = "application"
    "createdon" = local.tag_createdon
  })
}
