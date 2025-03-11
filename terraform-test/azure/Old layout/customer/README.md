# customer terraform

A Terraform plan for deploying customer specific resources.

## Background

This root terraform is designed to build some customer components. Eventually, this should include the resource group, the virtual network, the subnets, the kusto database, cosmosdb with databases and collections, iot hub, datalake, stream analytics, and IoT metric alerts.

## Implementation

Change the module and variable values required for the module in the `main.tf` file. the following steps:

1. Create a `eus2.tfvars` file containing the variables defined in `variables.tf` and their values. Each region will have its own tfvars file.

```hcl
azure_subscription_id = "MY_SUBSCRIPTION_ID"
azure_tenant_id = "MY_TENANT_ID"
azure_client_id = "MY_CLIENT_ID"
azure_client_secret = "MY_CLIENT_SECRET"
multi_regional_deployment = true
azure_location = "eastus2"
resource_version = "01"
env_name = "dev"
env_key = "04"
region_abbreviation = "eus2"
vnet_address_space = "10.5.0.0/16"
subnet01_address_space = "10.5.1.0/24"
subnet02_address_space = "10.5.2.0/24"
```

2. Initialize the Terraform provider.

```bash
$ terraform init
```

3. Validate the Terraform plan.

```bash
$ terraform plan -var-file="backend.tfvars" -var-file="eus2.tfvars" -out eus2-cus01.tfplan
```

4. Implement the Terraform plan.

```bash
$ terraform apply -auto-approve eus2-cus01.tfplan
```

Example output:

```bash
Apply complete! Resources: 5 added, 0 changed, 0 destroyed.

The state of your infrastructure has been saved to the path
below. This state is required to modify and destroy your
infrastructure, so keep it safe. To inspect the complete state
use the `terraform show` command.

State path: terraform.tfstate

Outputs:

rg_id = "/subscriptions/7561e71a-f6ea-4fbb-b139-801780a9d29d/resourceGroups/AppGrp-mul01-dev01-rg-69e1"
rg_name = "AppGrp-mul01-dev01-rg-69e1"
rg = {
  "id" = "/subscriptions/7561e71a-f6ea-4fbb-b139-801780a9d29d/resourceGroups/AppGrp-mul01-dev01-rg-69e1"
  "name" = "AppGrp-mul01-dev01-rg-69e1"
  "rg" = {
    "id" = "/subscriptions/7561e71a-f6ea-4fbb-b139-801780a9d29d/resourceGroups/AppGrp-mul01-dev01-rg-69e1"
    "location" = "eastus2"
    "name" = "AppGrp-mul01-dev01-rg-69e1"
    "tags" = tomap({
      "application" = "foundations"
      "contact" = "dl-global-digitalsolutions-dev@dematic.com"
      "costcenter" = "550164"
      "createdby" = "digitalsolutions-rd@dematic.com"
      "createdon" = "2021-09-17"
      "customer" = "digitalsolutions"
      "environment" = "dev"
      "lifetime" = "perpetual"
      "owner" = "jason.higgs@dematic.com"
      "program" = "CS Growth"
      "project" = "Insights NextGen"
      "role" = "api"
      "unique_id" = "69e1"
    })
    "timeouts" = null /* object */
  }
}
subnet01_id = "/subscriptions/7561e71a-f6ea-4fbb-b139-801780a9d29d/resourceGroups/AppGrp-mul01-dev01-rg-69e1/providers/Microsoft.Network/virtualNetworks/eus2-mul01-dev01-vnet-69e1/subnets/subnet01"
subnet02_id = "/subscriptions/7561e71a-f6ea-4fbb-b139-801780a9d29d/resourceGroups/AppGrp-mul01-dev01-rg-69e1/providers/Microsoft.Network/virtualNetworks/eus2-mul01-dev01-vnet-69e1/subnets/subnet02"
...
```

<!--- BEGIN_TF_DOCS --->

## Providers

| Name    | Version   |
| ------- | --------- |
| azurerm | >= 2.56.0 |
| http    | >= 2.1.0  |
| random  | >= 3.1.0  |

## Inputs

| Name                                 | Description                                                                                                                                    | Type          | Default      | Required |
| ------------------------------------ | ---------------------------------------------------------------------------------------------------------------------------------------------- | ------------- | ------------ | :------: |
| azure_subscription_id                | Azure subscription Id                                                                                                                          | `string`      | n/a          |   yes    |
| azure_tenant_id                      | Azure tenant Id                                                                                                                                | `string`      | n/a          |   yes    |
| azure_client_id                      | Azure client Id                                                                                                                                | `string`      | n/a          |   yes    |
| azure_client_secret                  | Azure client secret                                                                                                                            | `string`      | n/a          |   yes    |
| multi_regional_deployment            | When true, deploy a Premium API management resource for multiple regions. Otherwise, a Developer API management in a single region is created. | `bool`        | `false`      |   yes    |
| azure_location                       | Azure location                                                                                                                                 | `string`      | n/a          |   yes    |
| resource_version                     | Provide a version identifier for the cloud deployment                                                                                          | `string`      | n/a          |   yes    |
| env_name                             | The environment abbreviation to be used in resource naming deployment                                                                          | `string`      | n/a          |   yes    |
| env_key                              | The environment instance identifier deployment                                                                                                 | `string`      | n/a          |   yes    |
| region_abbreviation                  | Provide a shortened version of the azure location. This will be used in resource naming.                                                       | `string`      | n/a          |   yes    |
| vnet_address_space                   | CIDR range for the virtual network.                                                                                                            | `string`      | n/a          |   yes    |
| subnet01_address_space               | CIDR range for subnet01                                                                                                                        | `string`      | n/a          |   yes    |
| subnet02_address_space               | CIDR range for subnet02                                                                                                                        | `string`      | n/a          |   yes    |
| kusto_cluster_name                   | Name of the kusto cluster in multi-tenant resource group                                                                                       | `string`      | n/a          |   yes    |
| op_storage_account_id                | The storage account identifier for multi-purpose multi-tenant                                                                                  |
| op_storage_account_name              | The name of the multi-purpose multi-tenant storage account                                                                                     |
| op_storage_primary_connection_string | The primary connection string for the multi-purpose multi-tenant storage account                                                               |
| op_storage_primary_access_key        | The primary access key for the multi-purpose multi-tenant storage account                                                                      |
| tags                                 | Tags to be applied to resources (inclusive)                                                                                                    | `map(string)` | n/a          |   yes    |
| runtime_tags                         | Additional tags that can be supplied in addition to what CI has defined in the tfvars file (inclusive)                                         | `map(string)` | {}           |    no    |
| createdon_format                     | The date format to use when tagging                                                                                                            | `string`      | `YYYY-MM-DD` |    no    |
| random_id                            | Random identifier used with resource naming                                                                                                    | `string`      | n/a          |    no    |
| use_random_id                        | If true, use a random identifier when naming resources                                                                                         | `bool`        | `false`      |    no    |

## Outputs

| Name                             | Description                                              |
| -------------------------------- | -------------------------------------------------------- |
| rg                               | Resource group resource                                  |
| rg_id                            | Resource group identifier                                |
| rg_name                          | Resource group name                                      |
| unique_id                        | Resource unique identifier (optional)                    |
| subnet01_id                      | The subnet 01 identifier in the customer virtual network |
| subnet02_id                      | The subnet 02 identifier in the customer virtual network |
| cosmosdb_id                      | CosmosDB identifier                                      |
| cosmos_db_endpoint               | The CosmosDB endpoint                                    |
| cosmos_db_endpoints_read         | The CosmosDB read endpoints                              |
| cosmos_db_endpoints_write        | The CosmosDB write endpoints                             |
| cosmos_db_primary_key            | The CosmosDB primary key                                 |
| cosmos_db_secondary_key          | The CosmosDB secondary key                               |
| cosmos_db_primary_readonly_key   | The CosmosDB primary read-only key                       |
| cosmos_db_secondary_readonly_key | The CosmosDB secondary read-only key                     |
| cosmos_db_connection_strings     | The CosmosDB connection strings                          |

<!--- END_TF_DOCS --->
