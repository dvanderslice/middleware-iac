# apim terraform module

A Terraform plan for building an API Management service in Azure. This must be used as a module.

## Introduction

As part of the next-gen Insights application, API Management is utilized for managing our API services.

This module will create a API management service in Azure inside the resource group provided.

## How to use this as a module

Although the module can be customized to fit your individual requirements, you can use the module and rely on default configuration values to get up and running quickly:

```hcl
provider "azurerm" {
  features {}
}

module "apim" {
  source = "../modules/apim"

  azure_location      = "eastus2"
  resource_group_name = "AppGrp-mul05-dev04-rg-abcd"
  apim_name           = "eus2-mul05auth-dev04-api-abcd"
}
```

<!--- BEGIN_TF_DOCS --->

## Providers

| Name    | Version  |
| ------- | -------- |
| azurerm | >= 2.0.0 |

## Inputs

| Name                   | Description                                                                                                                                                                                         | Type          | Default       | Required |
| ---------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------- | ------------- | :------: |
| azure_location         | Azure location                                                                                                                                                                                      | `string`      | n/a           |   yes    |
| tags                   | Tags to be applied to resources (inclusive)                                                                                                                                                         | `map(string)` | n/a           |   yes    |
| resource_group_name    | The name to use for the resource group                                                                                                                                                              | `string`      | n/a           |   yes    |
| apim_name              | The name to use for the API management service                                                                                                                                                      | `string`      | n/a           |   yes    |
| apim_sku               | The SKU of the API management service                                                                                                                                                               | `string`      | `Developer_1` |    no    |
| virtual_network_type   | The type of virtual network you want to use. A value of `None` requires a subnet to be identified using the `virtual_network_subnet` variable. Valid values include: `None`, `External`, `Internal` | `string`      | `None`        |
| virtual_network_subnet | The Id of the subnet that will be used for the API Management                                                                                                                                       | `string`      | ``            |    no    |

## Outputs

| Name               | Description               |
| ------------------ | ------------------------- |
| apim_id            | API management identifier |
| management_api_url | API management URL        |

<!--- END_TF_DOCS --->
