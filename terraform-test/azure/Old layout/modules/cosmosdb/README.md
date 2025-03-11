# cosmosdb terraform module

A Terraform plan for building a CosmosDB in Azure. This must be used as a module.

## Introduction

As part of the next-gen Insights application, CosmosDB is utilized for managing some of our data persistence.

This module will create a CosmosDB account instance in Azure inside the resource group provided.

## How to use this as a module

Although the module can be customized to fit your individual requirements, you can use the module and rely on default configuration values to get up and running quickly:

```hcl
provider "azurerm" {
  features {}
}

module "cosmosdb" {
  source = "../modules/cosmosdb"

  azure_location      = "eastus2"
  resource_group_name = "AppGrp-mul05-dev04-rg-abcd"
  cosmosdb_name       = "eus2-mul05-dev04-cd-abcd"
}
```

<!--- BEGIN_TF_DOCS --->

## Providers

| Name    | Version  |
| ------- | -------- |
| azurerm | >= 2.0.0 |

## Inputs

| Name                | Description                                 | Type          | Default | Required |
| ------------------- | ------------------------------------------- | ------------- | ------- | :------: |
| azure_location      | Azure location                              | `string`      | n/a     |   yes    |
| tags                | Tags to be applied to resources (inclusive) | `map(string)` | n/a     |   yes    |
| resource_group_name | The name to use for the resource group      | `string`      | n/a     |   yes    |
| cosmosdb_name       | The name to use for the CosmosDB account    | `string`      | n/a     |   yes    |

## Outputs

| Name                         | Description                                                   |
| ---------------------------- | ------------------------------------------------------------- |
| cosmos_db_id                 | CosmosDB account identifier                                   |
| cosmos_db_endpoint           | CosmosDB connection endpoint                                  |
| cosmos_db_endpoints_read     | List of CosmosDB read endpoints                               |
| cosmos_db_endpoints_write    | List of CosmosDB write endpoints                              |
| cosmos_db_primary_key        | Primary master key for the CosmosDB account                   |
| cosmos_db_secondary_key      | Secondary master key for the CosmosDB account                 |
| cosmos_db_connection_strings | List of connection strings available for the CosmosDB account |

<!--- END_TF_DOCS --->
