# Azure - Virtual WAN and hub Module

## Introduction

This module will create a new virtual WAN and virtual hub in Azure.

Naming for this resource is as follows, based loosely on published RBA naming convention (https://github.com/gerryg80/python-azure-naming).

    AppGrp-<purpose><resourceVersion>-<environment><environmentInstance>-rg
    Example: AppGrp-auth02-dev04-rg

## How to use this as a module

Although the module can be customized to fit your individual requirements, you can use the module and rely on default configuration values to get up and running quickly:

```hcl
provider "azurerm" {
  features {}
}

module "virtualhub" {
  source = "../modules/virtualhub"

  azure_location             = "eastus2"
  resource_group_name        = "AppGrp-hub01-dev04-rg-abcd"
  shared_resource_group_name = "AppGrp-shared-dev04-rg-abcd"
  shared_network_id          = "/subscriptions/756...29d/resourceGroups/AppGrp-shared-dev04-rg-abcd/providers/Microsoft.Network/virtualNetworks/eus2-shared-dev01-vnet-abcd/subnets/subnet01"
  virtual_wan_name           = "eus2-virtualwan"
  virtual_hub_name           = "eus2-virtualhub"
  hub_address_prefix         = "10.2.0.0/23"
  hub_vnet_prefix            = "10.2.0.0/16"
  hub_subnet_prefix          = "10.2.0.0/24"
  firewall_name              = "eus2-firewall"
  firewall_policy_id         = "/subscriptions/756...29d/resourceGroups/AppGrp-hub01-dev04-rg-abcd/providers/Microsoft.Network/..."
  firewall_subnet_id         = "/subscriptions/756...29d/resourceGroups/AppGrp-hub01-dev04-rg-abcd/providers/Microsoft.Network/virtualNetworks/eus2-shared-dev01-vnet-abcd/subnets/AzureFirewallSubnet"
  spoke_destinations         = ["10.0.0.0/16", "10.1.0.0/16"]
}
```

<!--- BEGIN_TF_DOCS --->

## Providers

| Name    | Version  |
| ------- | -------- |
| azurerm | >= 2.0.0 |

## Inputs

| Name                       | Description                                                                                              | Type           | Default | Required |
| -------------------------- | -------------------------------------------------------------------------------------------------------- | -------------- | ------- | :------: |
| azure_location             | Azure location                                                                                           | `string`       | n/a     |   yes    |
| tags                       | Tags to be applied to resources (inclusive)                                                              | `map(string)`  | n/a     |   yes    |
| shared_resource_group_name | The name of the shared resource group where an app gateway or API management should reside               | `string`       | n/a     |   true   |
| shared_network_id          | The shared virtual network identifier                                                                    | `string`       | n/a     |   true   |
| shared_subnet_id           | The shared subnet identifier                                                                             | `string`       | n/a     |   true   |
| resource_group_name        | The name to use for the resource group                                                                   | `string`       | n/a     |   true   |
| virtual_network_name       | Desired name for the virtual network                                                                     | `string`       | n/a     |   yes    |
| virtual_wan_name           | Desired name for the virtual WAN                                                                         | `string`       | n/a     |   yes    |
| virtual_hub_name           | Desired name for the virtual hub                                                                         | `string`       | n/a     |   yes    |
| hub_address_prefix         | The IP address prefix (CIDR range) of the virtual hub. This must be a /23 or /24 according to Microsoft. | `string`       | n/a     |   yes    |
| hub_vnet_prefix            | The IP address prefix (CIDR range) of the hub virtual network                                            | `string`       | n/a     |   yes    |
| hub_subnet_prefix          | The IP address prefix (CIDR range) of the hub subnet                                                     | `string`       | n/a     |   yes    |
| firewall_name              | Desired name for the firewall                                                                            | `string`       | n/a     |   yes    |
| firewall_policy_id         | The identifier of the firewall policy to use with the firewall                                           | `string`       | n/a     |   yes    |
| spoke_destinations         | A list of destination CIDR blocks that should represent the network topology spokes                      | `list(string)` | n/a     |   yes    |

## Outputs

| Name           | Description                                         |
| -------------- | --------------------------------------------------- |
| virtual_wan_id | Virtual WAN identifier                              |
| virtual_hub_id | Virtual hub identifier                              |
| firewall_id    | Firewall identifier                                 |
| subnet01_id    | The subnet 01 identifier in the hub virtual network |

<!--- END_TF_DOCS --->
