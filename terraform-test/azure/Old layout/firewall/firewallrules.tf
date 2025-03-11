##Data sources from the Network Deployment##

data "azurerm_resource_group" "shared_vnet" {
  name = local.shared_resource_group_name
}

data "azurerm_virtual_network" "shared_vnet" {
  name                = local.shared_vnet_name
  resource_group_name = local.shared_resource_group_name
}

data "azurerm_virtual_network" "auth_vnet" {
  name                = local.auth_vnet_name
  resource_group_name = local.auth_resource_group_name
}

data "azurerm_virtual_network" "mul_vnet" {
  name                = local.mul_vnet_name
  resource_group_name = local.mul_resource_group_name
}

data "azurerm_virtual_network" "private_vnet" {
  name                = local.private_vnet_name
  resource_group_name = local.private_resource_group_name
}

data "azurerm_subnet" "data_private_subnet_prefix" {
  name                 = "Data_private_subnet01"
  virtual_network_name = data.azurerm_virtual_network.private_vnet.name
  resource_group_name  = local.private_resource_group_name
}

data "azurerm_subnet" "storage_private_subnet_prefix" {
  name                 = "Storage_private_subnet01"
  virtual_network_name = data.azurerm_virtual_network.private_vnet.name
  resource_group_name  = local.private_resource_group_name
}

data "azurerm_subnet" "shared_private_subnet_prefix" {
  name                 = "Shared_private_subnet01"
  virtual_network_name = data.azurerm_virtual_network.private_vnet.name
  resource_group_name  = local.private_resource_group_name
}

data "azurerm_subnet" "func_private_subnet_prefix" {
  name                 = "Func_private_subnet01"
  virtual_network_name = data.azurerm_virtual_network.private_vnet.name
  resource_group_name  = local.private_resource_group_name
}

data "azurerm_firewall" "firewall" {
  name                = "${var.region_abbreviation}-${var.env_name}${var.env_key}-firewall${local.suffix}"
  resource_group_name = module.hub_rg.name
}

data "azurerm_firewall_policy" "firewallpolicy" {
  name                = "${var.region_abbreviation}-${var.env_name}${var.env_key}-fwpolicy${local.suffix}"
  resource_group_name = module.hub_rg.name
}
###Create IP Groups, these are based on VNET and/or Subnets
resource "azurerm_ip_group" "data_subnet_ipg" {
  name                = local.data_private_subnet_ip_group_name
  location            = var.azure_location
  resource_group_name = local.hub_resource_group_name

  cidrs = data.azurerm_subnet.data_private_subnet_prefix.address_prefixes
}

resource "azurerm_ip_group" "storage_subnet_ipg" {
  name                = local.storage_private_subnet_ip_group_name
  location            = var.azure_location
  resource_group_name = local.hub_resource_group_name

  cidrs = data.azurerm_subnet.storage_private_subnet_prefix.address_prefixes
}

resource "azurerm_ip_group" "sharedsubnet_ipg" {
  name                = local.shared_private_subnet_ip_group_name
  location            = var.azure_location
  resource_group_name = local.hub_resource_group_name

  cidrs = data.azurerm_subnet.shared_private_subnet_prefix.address_prefixes
}

resource "azurerm_ip_group" "func_subnet_ipg" {
  name                = local.func_private_subnet_ip_group_name
  location            = var.azure_location
  resource_group_name = local.hub_resource_group_name

  cidrs = data.azurerm_subnet.func_private_subnet_prefix.address_prefixes
}

resource "azurerm_ip_group" "auth_vnet_ipg" {
  name                = local.auth_vnet_ip_group_name
  location            = var.azure_location
  resource_group_name = local.hub_resource_group_name

  cidrs = data.azurerm_virtual_network.auth_vnet.address_space
}

resource "azurerm_ip_group" "shared_vnet_ipg" {
  name                = local.shared_vnet_ip_group_name
  location            = var.azure_location
  resource_group_name = local.hub_resource_group_name

  cidrs = data.azurerm_virtual_network.shared_vnet.address_space
}

resource "azurerm_ip_group" "private_vnet_ipg" {
  name                = local.pri_vnet_ip_group_name
  location            = var.azure_location
  resource_group_name = local.hub_resource_group_name

  cidrs = data.azurerm_virtual_network.private_vnet.address_space
}

resource "azurerm_ip_group" "private_vnet_ipg" {
  name                = local.pri_vnet_ip_group_name
  location            = var.azure_location
  resource_group_name = local.hub_resource_group_name

  cidrs = data.azurerm_virtual_network.private_vnet.address_space
}
##Create Firewall Rules##Rules are broken into collections by usage type. This can be further refined. Some collection groups do not have rules yet, but a placeholder has been created
resource "azurerm_firewall_policy_rule_collection_group" "Functions-Private-Endpoint-Access" {
  name               = "${var.region_abbreviation}-${var.env_name}${var.env_key}-functions-private-endpoint-access-rcg"
  firewall_policy_id = azurerm_firewall_policy.fw_policy.id
  priority           = 1000

resource "azurerm_firewall_policy_rule_collection_group" "Storage-Private-Endpoint-Access" {
  name               = "${var.region_abbreviation}-${var.env_name}${var.env_key}-functions-private-endpoint-access-rcg"
  firewall_policy_id = azurerm_firewall_policy.fw_policy.id
  priority           = 1100

resource "azurerm_firewall_policy_rule_collection_group" "Shared-Private-Endpoint-Access" {
  name               = "${var.region_abbreviation}-${var.env_name}${var.env_key}-functions-private-endpoint-access-rcg"
  firewall_policy_id = azurerm_firewall_policy.fw_policy.id
  priority           = 1200
}
resource "azurerm_firewall_policy_rule_collection_group" "Mul-Private-Endpoint-Access" {
  name               = "${var.region_abbreviation}-${var.env_name}${var.env_key}-functions-private-endpoint-access-rcg"
  firewall_policy_id = azurerm_firewall_policy.fw_policy.id
  priority           = 1300

  application_rule_collection {
    name     = "Mul-Kusto-Outbound-Access-Application-rc"
    priority = 1500
    action   = "Allow"
    rule {
      name = "shared-to-microsoft"
      protocols {
        type = "Http"
        port = 80
      }
      protocols {
        type = "Https"
        port = 443
      }
      source_ip_groups  = ["10.1.1.0/28"]
      destination_fqdns = ["*.microsoft.com"]
    }
  }

  network_rule_collection {
    name     = "insights-network-rc01"
    priority = 1100
    action   = "Allow"
    rule {
      name = "shared-to-gateway-function-app"
      source_addresses = [
        "10.1.1.0/28"
      ]

      destination_ports = [
        "443"
      ]

      protocols = [
        "TCP"
      ]

      destination_fqdns = [
        "${var.region_abbreviation}-mul${var.resource_version}func${var.resource_version}-${var.env_name}${var.env_key}-gateway-fa.azurewebsites.net"
      ]
    }
  }

  network_rule_collection {
    name     = "insights-network-rc02"
    priority = 1000
    action   = "Allow"
    rule {
      name = "shared-to-auth-function-app"
      source_addresses = [
        "10.1.1.0/28"
      ]

      destination_ports = [
        "443"
      ]

      protocols = [
        "TCP"
      ]

      destination_fqdns = [
        "${var.region_abbreviation}-mul${var.resource_version}auth${var.resource_version}-${var.env_name}${var.env_key}-fa.azurewebsites.net"
      ]
    }
  }
}