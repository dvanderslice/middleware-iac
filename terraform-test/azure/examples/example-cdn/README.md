# example module usage

A Terraform plan for testing the cosmosdb terraform module.

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
static_website_source_folder = "./content"
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
Apply complete! Resources: 4 added, 0 changed, 0 destroyed.

Outputs:

id = /subscriptions/afacff74-9c36-4ff8-b306-329bf66e143f/resourceGroups/AppGrp-mul02-dev04-rg-f0de
name = AppGrp-mul02-dev04-rg-f0de
unique_id = f0de
...
```

<!--- BEGIN_TF_DOCS --->

## Providers

| Name    | Version   |
| ------- | --------- |
| azurerm | >= 2.56.0 |
| random  | >= 3.1.0  |
| null    | >= 3.1.0  |

## Inputs

| Name                         | Description                                                                                                                            | Type          | Default      | Required |
| ---------------------------- | -------------------------------------------------------------------------------------------------------------------------------------- | ------------- | ------------ | :------: |
| azure_subscription_id        | Azure subscription Id                                                                                                                  | `string`      | n/a          |   yes    |
| azure_tenant_id              | Azure tenant Id                                                                                                                        | `string`      | n/a          |   yes    |
| azure_client_id              | Azure client Id                                                                                                                        | `string`      | n/a          |   yes    |
| azure_client_secret          | Azure client secret                                                                                                                    | `string`      | n/a          |   yes    |
| azure_location               | Azure location                                                                                                                         | `string`      | n/a          |   yes    |
| resource_version             | Provide a version identifier for the cloud deployment                                                                                  | `string`      | n/a          |   yes    |
| env_name                     | The environment abbreviation to be used in resource naming deployment                                                                  | `string`      | n/a          |   yes    |
| env_key                      | The environment instance identifier deployment                                                                                         | `string`      | n/a          |   yes    |
| purpose                      | The purpose code of the resource. This is used to group purpose-built resources like auth or ai. This will be used in resource naming. | `string`      | n/a          |   yes    |
| region_abbreviation          | Provide a shortened version of the azure location. This will be used in resource naming.                                               | `string`      | n/a          |   yes    |
| tags                         | Tags to be applied to resources (inclusive)                                                                                            | `map(string)` | n/a          |   yes    |
| runtime_tags                 | Additional tags that can be supplied in addition to what CI has defined in the tfvars file (inclusive)                                 | `map(string)` | {}           |    no    |
| createdon_format             | The date format to use when tagging                                                                                                    | `string`      | `YYYY-MM-DD` |    no    |
| random_id                    | Random identifier used with resource naming                                                                                            | `string`      | n/a          |    no    |
| static_website_source_folder | Provide the source folder for the web content                                                                                          | `string`      | n/a          |   yes    |

## Outputs

| Name                                 | Description                                          |
| ------------------------------------ | ---------------------------------------------------- |
| rg                                   | Resource group resource                              |
| id                                   | Resource group identifier                            |
| name                                 | Resource group name                                  |
| unique_id                            | Resource unique identifier (optional)                |
| storage_account_id                   | The storage account identifier                       |
| storage_account_name                 | The storage account name                             |
| storage_primary_connection_string    | The primary connection string to the storage account |
| storage_primary_access_key           | The primary access key to the storage account        |
| static_website_cdn_endpoint_hostname | CDN endpoint URL for the static web site             |
| static_website_cdn_profile_name      | CDN profile name for the static web site             |
| static_website_url                   | The static web site URL                              |

<!--- END_TF_DOCS --->
