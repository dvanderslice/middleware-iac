# kusto terraform module

A Terraform plan for building a Kusto cluster in Azure. This must be used as a module.

## Introduction

As part of the next-gen Insights application, Kusto is utilized for managing some of our data queries.

This module will create a Kusto cluster in Azure inside the resource group provided.

## How to use this as a module

Although the module can be customized to fit your individual requirements, you can use the module and rely on default configuration values to get up and running quickly:

```hcl
provider "azurerm" {
  features {}
}

module "kusto" {
  source = "../modules/kusto"

  azure_location                = "eastus2"
  resource_group_name           = "AppGrp-mul05-dev04-rg-abcd"
  kusto_name                    = "eus2mul05exp02p01dclabcd"
  kusto_sku_name                = "Standard_D13_v2"
  kusto_sku_capacity            = 2
  subnet_id                     = "/subscriptions/7561e71a-f6ea-4fbb-b139-801780a9d29d/resourceGroups/AppGrp-mul01-dev01-rg/providers/Microsoft.Network/virtualNetworks/eus2-mul01-dev01-vnet/subnets/subnet01"
  public_ip_name_for_engine     = "eus2-mul05-adx-engine-pip"
  public_ip_name_for_management = "eus2-mul05-data-management-pip"
}
```

<!--- BEGIN_TF_DOCS --->

## Providers

| Name    | Version  |
| ------- | -------- |
| azurerm | >= 2.0.0 |

## Inputs

| Name                          | Description                                                             | Type          | Default | Required |
| ----------------------------- | ----------------------------------------------------------------------- | ------------- | ------- | :------: |
| azure_location                | Azure location                                                          | `string`      | n/a     |   yes    |
| tags                          | Tags to be applied to resources (inclusive)                             | `map(string)` | n/a     |   yes    |
| resource_group_name           | The name to use for the resource group                                  | `string`      | n/a     |   yes    |
| kusto_name                    | The name to use for the Kusto cluster                                   | `string`      | n/a     |   yes    |
| subnet_id                     | The subnet identifier                                                   | `string`      | n/a     |   yes    |
| public_ip_name_for_engine     | The name to use for the Kusto cluster engine public IP address          | `string`      | n/a     |   yes    |
| public_ip_name_for_management | The name to use for the Kusto cluster data management public IP address | `string`      | n/a     |   yes    |

## Outputs

| Name                             | Description                                     |
| -------------------------------- | ----------------------------------------------- |
| kusto_cluster_id                 | Kusto cluster identifier                        |
| kusto_cluster_uri                | Kusto cluster endpoint                          |
| kusto_cluster_ingestion_uri      | Kusto cluster data ingestion endpoint           |
| kusto_cluster_adx_engine_ip      | Kusto cluster data ADX engine public IP address |
| kusto_cluster_data_management_ip | Kusto cluster data management public IP address |

<!--- END_TF_DOCS --->
