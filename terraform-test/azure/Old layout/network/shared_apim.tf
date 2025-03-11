# -------------------------------------------------------------------------------------------------
# Create the shared network for premium API management
module "shared_rg" {
  source = "../modules/rg"

  azure_location      = var.azure_location
  resource_group_name = local.shared_resource_group_name

  tags = merge(local.resource_tags, {
    "environment" = var.env_name
    "role"        = "api"
    "createdon"   = local.tag_createdon
  })
}

resource "azurerm_virtual_network" "shared_vnet" {
  name                = local.shared_vnet_name
  address_space       = [module.vnet_addrs.networks[1].cidr_block]
  location            = var.azure_location
  resource_group_name = module.shared_rg.name

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

module "shared_subnet_addrs" {
  source = "../modules/cidr-subnets"

  base_cidr_block = module.vnet_addrs.networks[1].cidr_block
  networks = [
   # {
    #  name     = "reserved"
     # new_bits = 8
    #},
    {
      name     = "subnet01"
      new_bits = 2
    }
  ]
}

resource "azurerm_network_security_group" "shared_APIM_subnet_NSG" {
  name                = local.apim_nsg_name
  location            = var.azure_location
  resource_group_name = module.shared_rg.name
}
resource "azurerm_network_security_rule" "apim-client-communications" {
    name                       = "apim-client-communications-inbound"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_ranges     = [443, 80, 3443]
    source_address_prefix      = "Internet"
    destination_address_prefix = "VirtualNetwork"
  resource_group_name = module.shared_rg.name
  network_security_group_name = azurerm_network_security_group.shared_APIM_subnet_NSG.name
}

resource "azurerm_network_security_rule" "apim-management" {
    name                       = "apim-management"
    priority                   = 120
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = 3443
    source_address_prefix      = "ApiManagement"
    destination_address_prefix = "VirtualNetwork"
  resource_group_name = module.shared_rg.name
  network_security_group_name = azurerm_network_security_group.shared_APIM_subnet_NSG.name
}

resource "azurerm_network_security_rule" "apim-premium_ilb" {
    name                       = "apim-premium-ilb"
    priority                   = 130
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = 6390
    source_address_prefix      = "AzureLoadBalancer"
    destination_address_prefix = "VirtualNetwork"
  resource_group_name = module.shared_rg.name
  network_security_group_name = azurerm_network_security_group.shared_APIM_subnet_NSG.name
}
resource "azurerm_subnet" "shared_subnet01" {
  name                 = "shared_subnet01"
  resource_group_name  = module.shared_rg.name
  virtual_network_name = azurerm_virtual_network.shared_vnet.name
  address_prefixes     = [module.shared_subnet_addrs.networks[0].cidr_block]

  # Search for "Force Tunneling Traffic to On-premises Firewall Using Express Route or Network Virtual Appliance" in:
  # https://docs.microsoft.com/en-us/azure/api-management/api-management-using-with-vnet#-common-network-configuration-issues
  service_endpoints = ["Microsoft.Storage", "Microsoft.EventHub", "Microsoft.Sql", "Microsoft.KeyVault"]
}

resource "azurerm_subnet_network_security_group_association" "shared_apim_NSG" {
  subnet_id                 = azurerm_subnet.shared_subnet01.id
  network_security_group_id = azurerm_network_security_group.shared_APIM_subnet_NSG.id
}

module "shared_apim" {
  source = "../modules/apim"
  #count  = var.primary_region ? 1 : 0

  azure_location         = var.azure_location
  resource_group_name    = module.shared_rg.name
  apim_name              = local.apim_name
  apim_sku               = local.apim_sku
  virtual_network_type   = "External"
  virtual_network_subnet = azurerm_subnet.shared_subnet01.id

  tags = merge(local.resource_tags, {
    "role"      = "api"
    "createdon" = local.tag_createdon
  })

 

}
