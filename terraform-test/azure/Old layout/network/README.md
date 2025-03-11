# networking infrastructure per region

A Terraform plan for deploying all networking components. This excludes any customer specific resources.

## Background

This root terraform is designed to build all networking components. This includes the shared virtual network, subnets associated with the shared virtual network, public IP addresses, shared API management, the shared regional firewalls, the multi-tenant private virtual network, subnets associated with the private virtual network and the multi-tenant configuration storage account.

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
addresses = ["24.125.106.7", "64.19.223.82"]
```

2. Initialize the Terraform provider.

```bash
$ terraform init -backend-config="backend.tfvars"
```

3. Validate the Terraform plan.

```bash
$ terraform plan -var-file="backend.tfvars" -var-file="eus2.tfvars" -out eus2-network.tfplan
```

4. Implement the Terraform plan.

```bash
$ terraform apply -auto-approve eus2-network.tfplan
```

Example output:

```bash
Apply complete! Resources: 64 added, 0 changed, 2 destroyed.

The state of your infrastructure has been saved to the path
below. This state is required to modify and destroy your
infrastructure, so keep it safe. To inspect the complete state
use the `terraform show` command.

State path: terraform.tfstate

Outputs:

auth_id = "/subscriptions/7561e71a-f6ea-4fbb-b139-801780a9d29d/resourceGroups/AppGrp-auth01-dev01-rg-c837"
auth_name = "AppGrp-auth01-dev01-rg-c837"
auth_rg = {
  "id" = "/subscriptions/7561e71a-f6ea-4fbb-b139-801780a9d29d/resourceGroups/AppGrp-auth01-dev01-rg-c837"
  "name" = "AppGrp-auth01-dev01-rg-c837"
  "rg" = {
    "id" = "/subscriptions/7561e71a-f6ea-4fbb-b139-801780a9d29d/resourceGroups/AppGrp-auth01-dev01-rg-c837"
    "location" = "eastus2"
    "name" = "AppGrp-auth01-dev01-rg-c837"
    "tags" = tomap({
      "application" = "foundations"
      "contact" = "dl-global-digitalsolutions-dev@dematic.com"
      "costcenter" = "550164"
      "createdby" = "digitalsolutions-rd@dematic.com"
      "createdon" = "2021-09-27"
      "customer" = "digitalsolutions"
      "environment" = "dev"
      "lifetime" = "perpetual"
      "owner" = "jason.higgs@dematic.com"
      "program" = "CS Growth"
      "project" = "Insights NextGen"
      "role" = "api"
      "unique_id" = "c837"
    })
    "timeouts" = null /* object */
  }
}
auth_storage_account_id = "/subscriptions/7561e71a-f6ea-4fbb-b139-801780a9d29d/resourceGroups/AppGrp-auth01-dev01-rg-c837/providers/Microsoft.Storage/storageAccounts/eus2auth01d01sac837"
auth_storage_account_name = "eus2auth01d01sac837"
auth_storage_primary_access_key = <sensitive>
auth_storage_primary_connection_string = <sensitive>
auth_subnet01_id = "/subscriptions/7561e71a-f6ea-4fbb-b139-801780a9d29d/resourceGroups/AppGrp-auth01-dev01-rg-c837/providers/Microsoft.Network/virtualNetworks/eus2-auth01-dev01-vnet-c837/subnets/auth_subnet01"
auth_subnet02_id = "/subscriptions/7561e71a-f6ea-4fbb-b139-801780a9d29d/resourceGroups/AppGrp-auth01-dev01-rg-c837/providers/Microsoft.Network/virtualNetworks/eus2-auth01-dev01-vnet-c837/subnets/auth_subnet02"
firewall_id = "/subscriptions/7561e71a-f6ea-4fbb-b139-801780a9d29d/resourceGroups/AppGrp-hub01-dev01-rg-c837/providers/Microsoft.Network/azureFirewalls/eus2-firewall-c837"
firewall_policy_id = "/subscriptions/7561e71a-f6ea-4fbb-b139-801780a9d29d/resourceGroups/AppGrp-hub01-dev01-rg-c837/providers/Microsoft.Network/firewallPolicies/eus2-fw-policy-c837"
hub_id = "/subscriptions/7561e71a-f6ea-4fbb-b139-801780a9d29d/resourceGroups/AppGrp-hub01-dev01-rg-c837"
hub_name = "AppGrp-hub01-dev01-rg-c837"
hub_rg = {
  "id" = "/subscriptions/7561e71a-f6ea-4fbb-b139-801780a9d29d/resourceGroups/AppGrp-hub01-dev01-rg-c837"
  "name" = "AppGrp-hub01-dev01-rg-c837"
  "rg" = {
    "id" = "/subscriptions/7561e71a-f6ea-4fbb-b139-801780a9d29d/resourceGroups/AppGrp-hub01-dev01-rg-c837"
    "location" = "eastus2"
    "name" = "AppGrp-hub01-dev01-rg-c837"
    "tags" = tomap({
      "application" = "foundations"
      "contact" = "dl-global-digitalsolutions-dev@dematic.com"
      "costcenter" = "550164"
      "createdby" = "digitalsolutions-rd@dematic.com"
      "createdon" = "2021-09-27"
      "customer" = "digitalsolutions"
      "environment" = "dev"
      "lifetime" = "perpetual"
      "owner" = "jason.higgs@dematic.com"
      "program" = "CS Growth"
      "project" = "Insights NextGen"
      "role" = "api"
      "unique_id" = "c837"
    })
    "timeouts" = null /* object */
  }
}
mul_config_storage_account_id = "/subscriptions/7561e71a-f6ea-4fbb-b139-801780a9d29d/resourceGroups/AppGrp-mul01-dev01-rg-c837/providers/Microsoft.Storage/storageAccounts/eus2mul01confd01sac837"
mul_config_storage_account_name = "eus2mul01confd01sac837"
mul_config_storage_primary_access_key = <sensitive>
mul_config_storage_primary_connection_string = <sensitive>
mul_storage_account_id = "/subscriptions/7561e71a-f6ea-4fbb-b139-801780a9d29d/resourceGroups/AppGrp-mul01-dev01-rg-c837/providers/Microsoft.Storage/storageAccounts/eus2mul01func01d01sac837"
mul_storage_account_name = "eus2mul01func01d01sac837"
mul_storage_primary_access_key = <sensitive>
mul_storage_primary_connection_string = <sensitive>
private_id = "/subscriptions/7561e71a-f6ea-4fbb-b139-801780a9d29d/resourceGroups/AppGrp-pri01-dev01-rg-c837"
private_name = "AppGrp-pri01-dev01-rg-c837"
private_rg = {
  "id" = "/subscriptions/7561e71a-f6ea-4fbb-b139-801780a9d29d/resourceGroups/AppGrp-pri01-dev01-rg-c837"
  "name" = "AppGrp-pri01-dev01-rg-c837"
  "rg" = {
    "id" = "/subscriptions/7561e71a-f6ea-4fbb-b139-801780a9d29d/resourceGroups/AppGrp-pri01-dev01-rg-c837"
    "location" = "eastus2"
    "name" = "AppGrp-pri01-dev01-rg-c837"
    "tags" = tomap({
      "application" = "foundations"
      "contact" = "dl-global-digitalsolutions-dev@dematic.com"
      "costcenter" = "550164"
      "createdby" = "digitalsolutions-rd@dematic.com"
      "createdon" = "2021-09-27"
      "customer" = "digitalsolutions"
      "environment" = "dev"
      "lifetime" = "perpetual"
      "owner" = "jason.higgs@dematic.com"
      "program" = "CS Growth"
      "project" = "Insights NextGen"
      "role" = "api"
      "unique_id" = "c837"
    })
    "timeouts" = null /* object */
  }
}
private_subnet01_id = "/subscriptions/7561e71a-f6ea-4fbb-b139-801780a9d29d/resourceGroups/AppGrp-pri01-dev01-rg-c837/providers/Microsoft.Network/virtualNetworks/eus2-pri01-dev01-vnet-c837/subnets/private_subnet01"
rg = {
  "id" = "/subscriptions/7561e71a-f6ea-4fbb-b139-801780a9d29d/resourceGroups/AppGrp-mul01-dev01-rg-c837"
  "name" = "AppGrp-mul01-dev01-rg-c837"
  "rg" = {
    "id" = "/subscriptions/7561e71a-f6ea-4fbb-b139-801780a9d29d/resourceGroups/AppGrp-mul01-dev01-rg-c837"
    "location" = "eastus2"
    "name" = "AppGrp-mul01-dev01-rg-c837"
    "tags" = tomap({
      "application" = "foundations"
      "contact" = "dl-global-digitalsolutions-dev@dematic.com"
      "costcenter" = "550164"
      "createdby" = "digitalsolutions-rd@dematic.com"
      "createdon" = "2021-09-27"
      "customer" = "digitalsolutions"
      "environment" = "dev"
      "lifetime" = "perpetual"
      "owner" = "jason.higgs@dematic.com"
      "program" = "CS Growth"
      "project" = "Insights NextGen"
      "role" = "api"
      "unique_id" = "c837"
    })
    "timeouts" = null /* object */
  }
}
rg_id = "/subscriptions/7561e71a-f6ea-4fbb-b139-801780a9d29d/resourceGroups/AppGrp-mul01-dev01-rg-c837"
rg_name = "AppGrp-mul01-dev01-rg-c837"
subnet01_id = "/subscriptions/7561e71a-f6ea-4fbb-b139-801780a9d29d/resourceGroups/AppGrp-mul01-dev01-rg-c837/providers/Microsoft.Network/virtualNetworks/eus2-mul01-dev01-vnet-c837/subnets/subnet01"
subnet02_id = "/subscriptions/7561e71a-f6ea-4fbb-b139-801780a9d29d/resourceGroups/AppGrp-mul01-dev01-rg-c837/providers/Microsoft.Network/virtualNetworks/eus2-mul01-dev01-vnet-c837/subnets/subnet02"
subnet03_id = "/subscriptions/7561e71a-f6ea-4fbb-b139-801780a9d29d/resourceGroups/AppGrp-mul01-dev01-rg-c837/providers/Microsoft.Network/virtualNetworks/eus2-mul01-dev01-vnet-c837/subnets/subnet03"
unique_id = "c837"
virtual_hub_id = "/subscriptions/7561e71a-f6ea-4fbb-b139-801780a9d29d/resourceGroups/AppGrp-hub01-dev01-rg-c837/providers/Microsoft.Network/virtualHubs/eus2-virtualhub-c837"
virtual_wan_id = "/subscriptions/7561e71a-f6ea-4fbb-b139-801780a9d29d/resourceGroups/AppGrp-hub01-dev01-rg-c837/providers/Microsoft.Network/virtualWans/eus2-virtualwan-c837"
```

<!--- BEGIN_TF_DOCS --->

## Providers

| Name    | Version   |
| ------- | --------- |
| azurerm | >= 2.56.0 |
| http    | >= 2.1.0  |
| random  | >= 3.1.0  |

## Inputs

| Name                      | Description                                                                                                                                    | Type          | Default      | Required |
| ------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------- | ------------- | ------------ | :------: |
| azure_subscription_id     | Azure subscription Id                                                                                                                          | `string`      | n/a          |   yes    |
| azure_tenant_id           | Azure tenant Id                                                                                                                                | `string`      | n/a          |   yes    |
| azure_client_id           | Azure client Id                                                                                                                                | `string`      | n/a          |   yes    |
| azure_client_secret       | Azure client secret                                                                                                                            | `string`      | n/a          |   yes    |
| multi_regional_deployment | When true, deploy a Premium API management resource for multiple regions. Otherwise, a Developer API management in a single region is created. | `bool`        | `false`      |   yes    |
| azure_location            | Azure location                                                                                                                                 | `string`      | n/a          |   yes    |
| resource_version          | Provide a version identifier for the cloud deployment                                                                                          | `string`      | n/a          |   yes    |
| env_name                  | The environment abbreviation to be used in resource naming deployment                                                                          | `string`      | n/a          |   yes    |
| env_key                   | The environment instance identifier deployment                                                                                                 | `string`      | n/a          |   yes    |
| region_abbreviation       | Provide a shortened version of the azure location. This will be used in resource naming.                                                       | `string`      | n/a          |   yes    |
| addresses                 | Provide a list of IP addresses to allow access to the private storage accounts being created.                                                  | `string`      | n/a          |   yes    |
| base_cidr_block           | Base CIDR range for the virtual networks and subnets                                                                                           | `string`      | n/a          |   yes    |
| tags                      | Tags to be applied to resources (inclusive)                                                                                                    | `map(string)` | n/a          |   yes    |
| runtime_tags              | Additional tags that can be supplied in addition to what CI has defined in the tfvars file (inclusive)                                         | `map(string)` | {}           |    no    |
| createdon_format          | The date format to use when tagging                                                                                                            | `string`      | `YYYY-MM-DD` |    no    |
| random_id                 | Random identifier used with resource naming                                                                                                    | `string`      | n/a          |    no    |
| use_random_id             | If true, use a random identifier when naming resources                                                                                         | `bool`        | `false`      |    no    |

## Outputs

| Name                                         | Description                                                                         |
| -------------------------------------------- | ----------------------------------------------------------------------------------- |
| hub_rg                                       | Regional hub resource group resource                                                |
| hub_id                                       | Regional hub resource group identifier                                              |
| hub_name                                     | Regional hub resource group name                                                    |
| private_rg                                   | Regional private resource group resource                                            |
| private_id                                   | Regional private resource group identifier                                          |
| private_name                                 | Regional private resource group name                                                |
| rg                                           | Resource group resource                                                             |
| rg_id                                        | Resource group identifier                                                           |
| rg_name                                      | Resource group name                                                                 |
| unique_id                                    | Resource unique identifier (optional)                                               |
| private_subnet01_id                          | The subnet 01 identifier in the private virtual network for the private endpoints   |
| subnet01_id                                  | The subnet 01 identifier in the private virtual network                             |
| subnet02_id                                  | The subnet 02 identifier in the private virtual network                             |
| subnet03_id                                  | The subnet 03 identifier in the private virtual network                             |
| auth_subnet01_id                             | The subnet 01 identifier in the private auth virtual network                        |
| auth_subnet02_id                             | The subnet 02 identifier in the private auth virtual network                        |
| mul_storage_account_id                       | The storage account identifier for multi-tenant function app                        |
| mul_storage_account_name                     | The storage account name for multi-tenant function app                              |
| mul_storage_primary_connection_string        | The primary connection string to the storage account for multi-tenant function app  |
| mul_storage_primary_access_key               | The primary access key to the storage account for multi-tenant function app         |
| mul_config_storage_account_id                | The storage account identifier for multi-tenant configuration                       |
| mul_config_storage_account_name              | The storage account name for multi-tenant configuration                             |
| mul_config_storage_primary_connection_string | The primary connection string to the storage account for multi-tenant configuration |
| mul_config_storage_primary_access_key        | The primary access key to the storage account for multi-tenant configuration        |
| auth_storage_account_id                      | The storage account identifier for auth function app                                |
| auth_storage_account_name                    | The storage account name for auth function app                                      |
| auth_storage_primary_connection_string       | The primary connection string to the storage account for auth function app          |
| auth_storage_primary_access_key              | The primary access key to the storage account for auth function app                 |
| virtual_wan_id                               | The virtual WAN identifier                                                          |
| virtual_hub_id                               | The virtual hub identifier                                                          |
| firewall_id                                  | The firewall identifier                                                             |
| firewall_policy_id                           | The firewall policy identifier                                                      |

<!--- END_TF_DOCS --->
