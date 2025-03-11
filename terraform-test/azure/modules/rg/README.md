# Azure - Resource Group Module

## Introduction

This module will create a new Resource Group in Azure.

Naming for this resource is as follows, based loosely on published RBA naming convention (https://github.com/gerryg80/python-azure-naming).

    AppGrp-<purpose><resourceVersion>-<environment><environmentInstance>-rg
    Example: AppGrp-auth02-dev04-rg

## How to use this as a module

Although the module can be customized to fit your individual requirements, you can use the module and rely on default configuration values to get up and running quickly:

```hcl
provider "azurerm" {
  features {}
}

module "rg" {
  source = "../modules/rg"

  azure_location      = "eastus2"
  resource_group_name = "AppGrp-mul05-dev04-rg-abcd"
  create_lock         = false
}
```

<!--- BEGIN_TF_DOCS --->

## Providers

| Name    | Version  |
| ------- | -------- |
| azurerm | >= 2.0.0 |

## Inputs

| Name                | Description                                                | Type          | Default | Required |
| ------------------- | ---------------------------------------------------------- | ------------- | ------- | :------: |
| azure_location      | Azure location                                             | `string`      | n/a     |   yes    |
| tags                | Tags to be applied to resources (inclusive)                | `map(string)` | n/a     |   yes    |
| resource_group_name | The name to use for the resource group                     | `string`      | n/a     |   true   |
| create_lock         | If true, a resource lock will be set on the resource group | `bool`        | `false` |    no    |

## Outputs

| Name | Description             |
| ---- | ----------------------- |
| id   | Resource group id       |
| name | Resource group name     |
| rg   | Resource group resource |

<!--- END_TF_DOCS --->
