# If you want to use this as a root terraform, uncomment the below block
#provider "azurerm" {
#  subscription_id = var.azure_subscription_id
#  tenant_id       = var.azure_tenant_id
#  client_id       = var.azure_client_id
#  client_secret   = var.azure_client_secret
#}

resource "random_id" "id" {
  count       = var.random_id == null ? 1 : 0
  byte_length = 2
}

locals {
  resource_group_name = "AppGrp-tf${var.resource_version}-${var.env_name}${var.env_key}-rg"
  random_id           = var.assign_unique_id == true ? (var.random_id == null ? random_id.id[0].hex : var.random_id) : null
  suffix              = local.random_id == null ? "" : "-${local.random_id}"
  env_name_letter     = substr(var.env_name, 0, 1)
  created_on          = formatdate(var.createdon_format, timestamp())
  resource_tags = merge(var.tags,
    var.runtime_tags, {
      "createdon" = local.created_on
  })
}

resource "azurerm_resource_group" "tfstate_rg" {
  name     = var.assign_unique_id ? "${local.resource_group_name}${local.suffix}" : local.resource_group_name
  location = var.azure_location
  tags     = local.resource_tags

  lifecycle {
    ignore_changes = [
      tags["createdon"]
    ]
  }
}

resource "azurerm_management_lock" "rg_lock" {
  name       = "${azurerm_resource_group.tfstate_rg.name}-lock"
  count      = var.create_lock ? 1 : 0
  scope      = azurerm_resource_group.tfstate_rg.id
  lock_level = "CanNotDelete"
}

resource "azurerm_storage_account" "tfstate_sa" {
  name                     = "${var.region_abbreviation}tfstate${local.env_name_letter}${var.resource_version}sa${local.random_id}"
  resource_group_name      = azurerm_resource_group.tfstate_rg.name
  location                 = var.azure_location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  tags                     = local.resource_tags

  lifecycle {
    ignore_changes = [
      tags["createdon"]
    ]
  }
}

resource "azurerm_storage_container" "tfstate_blob" {
  name                  = "tfstate"
  storage_account_name  = azurerm_storage_account.tfstate_sa.name
  container_access_type = "private"
}
