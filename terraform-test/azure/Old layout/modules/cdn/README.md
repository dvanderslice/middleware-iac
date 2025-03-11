# cdn terraform module

A Terraform plan for building a CDN with static web site in Azure. This must be used as a module.

## Introduction

As part of the next-gen Insights application, this CDN is utilized for managing our web assets.

This module will create a storage account, CDN profile and CDN in Azure inside the resource group provided.

## How to use this as a module

Although the module can be customized to fit your individual requirements, you can use the module and rely on default configuration values to get up and running quickly:

```hcl
provider "azurerm" {
  features {}
}

module "cdn" {
  source = "../modules/cdn"

  azure_location               = "eastus2"
  resource_group_name          = "AppGrp-mul05-dev04-rg-abcd"
  storage_account_name         = "eus2mul05dev04saabcd"
  cdn_profile_name             = "eus2-mul05-dev04-cdn-abcd"
  static_website_source_folder = "./content"
}
```

<!--- BEGIN_TF_DOCS --->

## Providers

| Name    | Version  |
| ------- | -------- |
| azurerm | >= 2.0.0 |

## Inputs

| Name                         | Description                                                                   | Type          | Default           | Required |
| ---------------------------- | ----------------------------------------------------------------------------- | ------------- | ----------------- | :------: |
| azure_location               | Azure location                                                                | `string`      | n/a               |   yes    |
| tags                         | Tags to be applied to resources (inclusive)                                   | `map(string)` | n/a               |   yes    |
| resource_group_name          | The name to use for the resource group                                        | `string`      | n/a               |   yes    |
| storage_account_name         | The name to use for the storage account                                       | `string`      | n/a               |   yes    |
| cdn_profile_name             | The name to use for the CDN profile                                           | `string`      | n/a               |   yes    |
| static_website_source_folder | The source folder for the web site content                                    | `string`      | n/a               |   yes    |
| account_kind                 | The kind of storage account                                                   | `string`      | `StorageV2`       |    no    |
| sku                          | The SKU of the storage account                                                | `string`      | `Standard_GRS`    |    no    |
| access_tier                  | The access tier of the storage account                                        | `string`      | `Hot`             |    no    |
| enable_https_traffic         | Configure the storage account to accept requests from secure connections only | `bool`        | `true`            |    no    |
| enable_static_website        | Indicates if a static website to be enabled on the storage account            | `bool`        | `true`            |    no    |
| assign_identity              | Specifies the identity type of the Storage Account                            | `bool`        | `true`            |    no    |
| enable_cdn_profile           | Indicates the creation of a CDN profile and endpoint for static website       | `bool`        | `true`            |    no    |
| cdn_sku_profile              | The SKU of the CDN profile                                                    | `string`      | `Standard_Akamai` |    no    |
| index_path                   | Web site index path                                                           | `string`      | `index.html`      |    no    |
| custom_404_path              | Web site path for not found                                                   | `string`      | `404.html`        |    no    |

## Outputs

| Name                                 | Description                                          |
| ------------------------------------ | ---------------------------------------------------- |
| storage_account_id                   | The storage account identifier                       |
| storage_account_name                 | The storage account name                             |
| storage_primary_connection_string    | The primary connection string to the storage account |
| storage_primary_access_key           | The primary access key to the storage account        |
| static_website_cdn_endpoint_hostname | CDN endpoint URL for the static web site             |
| static_website_cdn_profile_name      | CDN profile name for the static web site             |
| static_website_url                   | The static web site URL                              |

<!--- END_TF_DOCS --->
