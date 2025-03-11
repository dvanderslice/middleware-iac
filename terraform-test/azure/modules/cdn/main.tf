locals {
  account_tier             = (var.account_kind == "FileStorage" ? "Premium" : split("_", var.sku)[0])
  account_replication_type = (local.account_tier == "Premium" ? "LRS" : split("_", var.sku)[1])
  static_website_enabled   = var.enable_static_website ? [{}] : []
}

resource "azurerm_storage_account" "storeacc" {
  name                      = var.storage_account_name
  resource_group_name       = var.resource_group_name
  location                  = var.azure_location
  account_kind              = var.account_kind
  account_tier              = local.account_tier
  account_replication_type  = local.account_replication_type
  enable_https_traffic_only = var.enable_https_traffic
  tags                      = merge({ "name" = format("%s", var.storage_account_name) }, var.tags, )

  dynamic "static_website" {
    for_each = local.static_website_enabled
    content {
      index_document     = var.index_path
      error_404_document = var.custom_404_path
    }
  }

  identity {
    type = var.assign_identity ? "SystemAssigned" : null
  }

  lifecycle {
    ignore_changes = [
      tags["createdon"]
    ]
  }

}

# Following resource is not removed when we update the terraform plan with `false` after initial run. Need to check for the option to remove `$web` folder if we disable static website and update the plan. 
resource "null_resource" "copyfilesweb" {
  count = var.enable_static_website ? 1 : 0
  provisioner "local-exec" {
    command = "az storage blob upload-batch --no-progress --account-name ${azurerm_storage_account.storeacc.name} -s ${var.static_website_source_folder} -d '$web' --output none"
  }
}

resource "azurerm_cdn_profile" "cdn_profile" {
  count               = var.enable_static_website && var.enable_cdn_profile ? 1 : 0
  name                = var.cdn_profile_name
  resource_group_name = var.resource_group_name
  location            = var.azure_location
  sku                 = var.cdn_sku_profile
  tags                = merge({ "name" = format("%s", var.cdn_profile_name) }, var.tags, )

  lifecycle {
    ignore_changes = [
      tags["createdon"]
    ]
  }

}

resource "random_string" "unique" {
  count   = var.enable_static_website && var.enable_cdn_profile ? 1 : 0
  length  = 8
  special = false
  upper   = false
}

resource "azurerm_cdn_endpoint" "cdn_endpoint" {
  count                         = var.enable_static_website && var.enable_cdn_profile ? 1 : 0
  name                          = random_string.unique.0.result
  profile_name                  = azurerm_cdn_profile.cdn-profile.0.name
  location                      = var.azure_location
  resource_group_name           = var.resource_group_name
  origin_host_header            = azurerm_storage_account.storeacc.primary_web_host
  querystring_caching_behaviour = "IgnoreQueryString"

  origin {
    name      = "websiteorginaccount"
    host_name = azurerm_storage_account.storeacc.primary_web_host
  }

  lifecycle {
    ignore_changes = [
      tags["createdon"]
    ]
  }
}
