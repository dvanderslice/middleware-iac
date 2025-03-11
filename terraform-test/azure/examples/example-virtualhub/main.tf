resource "random_id" "id" {
  count       = var.random_id == null ? 1 : 0
  byte_length = 2
}

locals {
  random_id                   = var.random_id == null ? random_id.id[0].hex : var.random_id
  suffix                      = local.random_id == null ? "" : "-${local.random_id}"
  resource_group_name         = "AppGrp-${var.purpose}${var.resource_version}-${var.env_name}${var.env_key}-rg${local.suffix}"
  shared_resource_group_name  = "AppGrp-shared-${var.env_name}${var.env_key}-rg${local.suffix}"
  shared_vnet_name            = "${var.region_abbreviation}-shared-${var.env_name}${var.env_key}-vnet${local.suffix}"
  virtual_wan_name            = "${var.region_abbreviation}-virtualwan${local.suffix}"
  virtual_hub_name            = "${var.region_abbreviation}-virtualhub${local.suffix}"
  firewall_name               = "${var.region_abbreviation}-firewall${local.suffix}"
  public_ip_name              = "${var.region_abbreviation}-publicip${local.suffix}"
  virtual_network_name        = "${var.region_abbreviation}-hub-${var.env_name}${var.env_key}-vnet${local.suffix}"
  tag_createdon               = formatdate("YYYY-MM-DD", timestamp())

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

module "shared_rg" {
  source = "../../modules/rg"

  azure_location      = var.azure_location
  resource_group_name = local.shared_resource_group_name

  tags = merge(local.resource_tags, {
    "role"      = "application"
    "createdon" = local.tag_createdon
  })
}

resource "azurerm_virtual_network" "vnet" {
  name                = local.shared_vnet_name
  address_space       = ["10.1.0.0/16"]
  location            = var.azure_location
  resource_group_name = module.shared_rg.name

  lifecycle {
    ignore_changes = [
      tags["createdon"],
    ]
  }

  tags = merge(local.resource_tags, {
    "role"      = "network"
    "createdon" = local.tag_createdon
  })
}

resource "azurerm_subnet" "subnet01" {
  name                 = "shared_subnet01"
  resource_group_name  = module.shared_rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.1.1.0/24"]
}

resource "azurerm_firewall_policy" "fw_policy" {
  name                = "${var.region_abbreviation}-fw-policy${local.suffix}"
  resource_group_name = module.rg.name
  location            = var.azure_location

  dns {
    proxy_enabled = true
  }

  lifecycle {
    ignore_changes = [
      tags["createdon"],
    ]
  }

  tags = merge(local.resource_tags, {
    "environment" = var.env_name
    "role"        = "networking"
    "createdon"   = local.tag_createdon
  })
}

module "virtualhub" {
  source = "../../modules/virtualhub"

  azure_location             = var.azure_location
  resource_group_name        = module.rg.name
  shared_resource_group_name = module.shared_rg.name
  shared_network_id          = azurerm_virtual_network.vnet.id
  virtual_wan_name           = local.virtual_wan_name
  virtual_hub_name           = local.virtual_hub_name
  hub_address_prefix         = "10.2.0.0/23"
  firewall_name              = local.virtual_hub_name
  firewall_policy_id         = azurerm_firewall_policy.fw_policy.id
  virtual_network_name       = local.virtual_network_name
  spoke_destinations         = ["10.0.0.0/16", "10.1.0.0/16"]

  tags = merge(local.resource_tags, {
    "environment" = var.env_name
    "role"        = "firewall"
    "createdon"   = local.tag_createdon
  })
}
