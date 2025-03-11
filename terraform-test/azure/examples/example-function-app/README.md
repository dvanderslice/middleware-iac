# example module usage

A Terraform plan for testing the function-app terraform module.

## Background

This is an example root terraform plan designed to be an example and a method for testing various terraform modules.

## Implementation

Change the module and variable values required for the module in the `main.tf` file. the following steps:

1. Create a `terraform.tfvars` file containing the variables defined in `variables.tf` and their values.

```hcl
azure_subscription_id = "MY_SUBSCRIPTION_ID"
azure_tenant_id = "MY_TENANT_ID"
azure_client_id = "MY_CLIENT_ID"
azure_client_secret = "MY_CLIENT_SECRET"
azure_location = "eastus2"
resource_version = "01"
env_name = "dev"
env_key = "04"
purpose = "auth"
region_abbreviation = "eus2"
app_abbreviation = "auth"
```

2. Initialize the Terraform provider.

```bash
$ terraform init
```

3. Validate the Terraform plan.

```bash
$ terraform plan
```

4. Implement the Terraform plan.

```bash
$ terraform apply
```

Example output:

```bash
Apply complete! Resources: 6 added, 0 changed, 0 destroyed.

Outputs:

app_service_plan_id = "/subscriptions/7561e71a-f6ea-4fbb-b139-801780a9d29d/resourceGroups/AppGrp-kev01-dev01-rg-0229/providers/Microsoft.Web/serverfarms/eus2-kev01auth-dev01-asp-0229"
function_app_hostname = "eus2-kev01auth-dev01-fa-0229.azurewebsites.net"
function_app_id = "/subscriptions/7561e71a-f6ea-4fbb-b139-801780a9d29d/resourceGroups/AppGrp-kev01-dev01-rg-0229/providers/Microsoft.Web/sites/eus2-kev01auth-dev01-fa-0229"
id = "/subscriptions/7561e71a-f6ea-4fbb-b139-801780a9d29d/resourceGroups/AppGrp-kev01-dev01-rg-0229"
insights_app_id = "581a50b0-cd62-4eff-a2f0-6d52e1c2b8d5"
insights_connection_string = <sensitive>
insights_instrumentation_key = <sensitive>
name = "AppGrp-kev01-dev01-rg-0229"
rg = {
  "id" = "/subscriptions/7561e71a-f6ea-4fbb-b139-801780a9d29d/resourceGroups/AppGrp-kev01-dev01-rg-0229"
  "name" = "AppGrp-kev01-dev01-rg-0229"
  "rg" = {
    "id" = "/subscriptions/7561e71a-f6ea-4fbb-b139-801780a9d29d/resourceGroups/AppGrp-kev01-dev01-rg-0229"
    "location" = "eastus2"
    "name" = "AppGrp-kev01-dev01-rg-0229"
    "tags" = tomap({
      "application" = "foundations"
      "contact" = "dl-global-digitalsolutions-dev@dematic.com"
      "costcenter" = "550164"
      "createdby" = "digitalsolutions-rd@dematic.com"
      "createdon" = "2021-09-17"
      "environment" = "dev2"
      "lifetime" = "perpetual"
      "owner" = "jason.higgs@dematic.com"
      "role" = "application"
      "unique_id" = "0229"
    })
    "timeouts" = null /* object */
  }
}
storage_account_id = "/subscriptions/7561e71a-f6ea-4fbb-b139-801780a9d29d/resourceGroups/AppGrp-kev01-dev01-rg-0229/providers/Microsoft.Storage/storageAccounts/eus2kev01d01sa0229"
storage_account_name = "eus2kev01d01sa0229"
storage_primary_access_key = <sensitive>
storage_primary_connection_string = <sensitive>
unique_id = "0229"
```

<!--- BEGIN_TF_DOCS --->

## Providers

| Name    | Version   |
| ------- | --------- |
| azurerm | >= 2.56.0 |
| random  | >= 3.1.0  |

## Inputs

| Name                  | Description                                                                                                                            | Type          | Default      | Required |
| --------------------- | -------------------------------------------------------------------------------------------------------------------------------------- | ------------- | ------------ | :------: |
| azure_subscription_id | Azure subscription Id                                                                                                                  | `string`      | n/a          |   yes    |
| azure_tenant_id       | Azure tenant Id                                                                                                                        | `string`      | n/a          |   yes    |
| azure_client_id       | Azure client Id                                                                                                                        | `string`      | n/a          |   yes    |
| azure_client_secret   | Azure client secret                                                                                                                    | `string`      | n/a          |   yes    |
| azure_location        | Azure location                                                                                                                         | `string`      | n/a          |   yes    |
| resource_version      | Provide a version identifier for the cloud deployment                                                                                  | `string`      | n/a          |   yes    |
| env_name              | The environment abbreviation to be used in resource naming deployment                                                                  | `string`      | n/a          |   yes    |
| env_key               | The environment instance identifier deployment                                                                                         | `string`      | n/a          |   yes    |
| purpose               | The purpose code of the resource. This is used to group purpose-built resources like auth or ai. This will be used in resource naming. | `string`      | n/a          |   yes    |
| region_abbreviation   | Provide a shortened version of the azure location. This will be used in resource naming.                                               | `string`      | n/a          |   yes    |
| app_abbreviation      | Provide a shortened version of the app name                                                                                            | `string`      | n/a          |   yes    |
| tags                  | Tags to be applied to resources (inclusive)                                                                                            | `map(string)` | n/a          |   yes    |
| runtime_tags          | Additional tags that can be supplied in addition to what CI has defined in the tfvars file (inclusive)                                 | `map(string)` | {}           |    no    |
| createdon_format      | The date format to use when tagging                                                                                                    | `string`      | `YYYY-MM-DD` |    no    |
| random_id             | Random identifier used with resource naming                                                                                            | `string`      | n/a          |    no    |

## Outputs

| Name                              | Description                                          |
| --------------------------------- | ---------------------------------------------------- |
| rg                                | Resource group resource                              |
| id                                | Resource group identifier                            |
| name                              | Resource group name                                  |
| unique_id                         | Resource unique identifier (optional)                |
| storage_account_id                | The storage account identifier                       |
| storage_account_name              | The storage account name                             |
| storage_primary_connection_string | The primary connection string to the storage account |
| storage_primary_access_key        | The primary access key to the storage account        |
| app_service_plan_id               | The app service plan identifier                      |
| insights_app_id                   | The app insights application identifier              |
| insights_instrumentation_key      | The app insights instrumentation key                 |
| insights_connection_string        | The app insights connection string                   |
| function_app_id                   | The function app identifier                          |
| function_app_hostname             | Function app hostname                                |

<!--- END_TF_DOCS --->
