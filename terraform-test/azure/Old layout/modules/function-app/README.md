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

module "function_app" {
  source = "../modules/function-app"

  azure_location        = "eastus2"
  resource_group_name   = "AppGrp-mul05-dev04-rg-abcd"
  storage_account_name  = "eus2mul05authdev04saabcd"
  function_app_name     = "eus2-mul05auth-dev04-fa-abcd"
  app_service_plan_name = "eus2-mul05auth-dev04-asp-abcd"
}
```

<!--- BEGIN_TF_DOCS --->

## Providers

| Name    | Version  |
| ------- | -------- |
| azurerm | >= 2.0.0 |

## Inputs

| Name                       | Description                                             | Type          | Default | Required |
| -------------------------- | ------------------------------------------------------- | ------------- | ------- | :------: |
| azure_location             | Azure location                                          | `string`      | n/a     |   yes    |
| tags                       | Tags to be applied to resources (inclusive)             | `map(string)` | n/a     |   yes    |
| resource_group_name        | The name to use for the resource group                  | `string`      | n/a     |   yes    |
| create_new_storage_account | When true, uses a Linux plan                            | `bool`        | n/a     |  `true`  |
| storage_account_name       | The name to use for the storage account                 | `string`      | n/a     |   yes    |
| app_service_plan_name      | The name to use for the app service plan                | `string`      | n/a     |   yes    |
| app_service_plan_linux     | When true, uses a Linux plan                            | `bool`        | n/a     | `false`  |
| app_insights_name          | The name to use for the app insights                    | `string`      | n/a     |   yes    |
| function_app_name          | The name to use for the function app                    | `string`      | n/a     |   yes    |
| function_runtime           | The language worker runtime to load in the function app | `string`      | `node`  |   yes    |
| subnet_id                  | The subnet identifier for the function app              | `string`      | `null`  |    no    |

## Outputs

| Name                              | Description                                          |
| --------------------------------- | ---------------------------------------------------- |
| storage_account_id                | The storage account identifier                       |
| storage_account_name              | The storage account name                             |
| storage_primary_connection_string | The primary connection string to the storage account |
| storage_primary_access_key        | The primary access key to the storage account        |
| app_service_plan_id               | The app service plan identifier                      |
| insights_app_id                   | The app insights application identifier              |
| insights_instrumentation_key      | The app insights instrumentation key                 |
| insights_connection_string        | The app insights connection string                   |
| function_app_id                   | The function app identifier                          |
| function_app_hostname             | The function app hostname                            |

<!--- END_TF_DOCS --->
