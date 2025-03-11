# Shared API Management

A Terraform plan for deploying the shared API management resource with related networking components.

## Background

This root terraform is designed to build just the shared API management resource with related networking components. This includes the shared resource group, shared virtual network, subnet associated with the shared virtual network, DDoS protection plan and shared API management.

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
vnet_address_space = "10.1.0.0/16"
subnet01_address_space = "10.1.1.0/24"
```

2. Initialize the Terraform provider.

```bash
$ terraform init -backend-config="backend.tfvars"
```

3. Validate the Terraform plan.

```bash
$ terraform plan -var-file="backend.tfvars" -var-file="eus2.tfvars" -out eus2-apim.tfplan
```

4. Implement the Terraform plan.

```bash
$ terraform apply -auto-approve eus2-apim.tfplan
```

Example output:

```bash
Apply complete! Resources: 6 added, 0 changed, 0 destroyed.

The state of your infrastructure has been saved to the path
below. This state is required to modify and destroy your
infrastructure, so keep it safe. To inspect the complete state
use the `terraform show` command.

State path: terraform.tfstate

Outputs:

shared_apim_id = "/subscriptions/7561e71a-f6ea-4fbb-b139-801780a9d29d/resourceGroups/AppGrp-shared01-dev01-rg-c837/providers/Microsoft.ApiManagement/service/shared-dev01-api-c837"
shared_id = "/subscriptions/7561e71a-f6ea-4fbb-b139-801780a9d29d/resourceGroups/AppGrp-shared01-dev01-rg-c837"
shared_name = "AppGrp-shared01-dev01-rg-c837"
shared_rg = {
  "id" = "/subscriptions/7561e71a-f6ea-4fbb-b139-801780a9d29d/resourceGroups/AppGrp-shared01-dev01-rg-c837"
  "name" = "AppGrp-shared01-dev01-rg-c837"
  "rg" = {
    "id" = "/subscriptions/7561e71a-f6ea-4fbb-b139-801780a9d29d/resourceGroups/AppGrp-shared01-dev01-rg-c837"
    "location" = "eastus2"
    "name" = "AppGrp-shared01-dev01-rg-c837"
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
shared_subnet01_id = "/subscriptions/7561e71a-f6ea-4fbb-b139-801780a9d29d/resourceGroups/AppGrp-shared01-dev01-rg-c837/providers/Microsoft.Network/virtualNetworks/eus2-shared-dev01-vnet-c837/subnets/shared_subnet01"
unique_id = "c837"
```

<!--- BEGIN_TF_DOCS --->

## Providers

| Name    | Version   |
| ------- | --------- |
| azurerm | >= 2.56.0 |
| http    | >= 2.1.0  |
| random  | >= 3.1.0  |

## Inputs

| Name                      | Description                                                                                                                                          | Type          | Default      | Required |
| ------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------- | ------------- | ------------ | :------: |
| azure_subscription_id     | Azure subscription Id                                                                                                                                | `string`      | n/a          |   yes    |
| azure_tenant_id           | Azure tenant Id                                                                                                                                      | `string`      | n/a          |   yes    |
| azure_client_id           | Azure client Id                                                                                                                                      | `string`      | n/a          |   yes    |
| azure_client_secret       | Azure client secret                                                                                                                                  | `string`      | n/a          |   yes    |
| multi_regional_deployment | When true, deploy a Premium API management resource for multiple regions. Otherwise, a Developer API management in a single region is created.       | `bool`        | `false`      |   yes    |
| primary_region            | When true, deploy a Premium API management resource in the specified region. Otherwise, the API managemen resource will exist in a different region. | `bool`        | `false`      |   yes    |
| azure_location            | Azure location                                                                                                                                       | `string`      | n/a          |   yes    |
| resource_version          | Provide a version identifier for the cloud deployment                                                                                                | `string`      | n/a          |   yes    |
| env_name                  | The environment abbreviation to be used in resource naming deployment                                                                                | `string`      | n/a          |   yes    |
| env_key                   | The environment instance identifier deployment                                                                                                       | `string`      | n/a          |   yes    |
| region_abbreviation       | Provide a shortened version of the azure location. This will be used in resource naming.                                                             | `string`      | n/a          |   yes    |
| vnet_address_space        | CIDR range for the virtual network.                                                                                                                  | `string`      | n/a          |   yes    |
| subnet01_address_space    | CIDR range for subnet01                                                                                                                              | `string`      | n/a          |   yes    |
| tags                      | Tags to be applied to resources (inclusive)                                                                                                          | `map(string)` | n/a          |   yes    |
| runtime_tags              | Additional tags that can be supplied in addition to what CI has defined in the tfvars file (inclusive)                                               | `map(string)` | {}           |    no    |
| createdon_format          | The date format to use when tagging                                                                                                                  | `string`      | `YYYY-MM-DD` |    no    |
| random_id                 | Random identifier used with resource naming                                                                                                          | `string`      | n/a          |    no    |
| use_random_id             | If true, use a random identifier when naming resources                                                                                               | `bool`        | `false`      |    no    |

## Outputs

| Name               | Description                                            |
| ------------------ | ------------------------------------------------------ |
| shared_rg          | Shared resource group resource                         |
| shared_id          | Shared resource group identifier                       |
| shared_name        | Shared resource group name                             |
| unique_id          | Resource unique identifier (optional)                  |
| shared_apim_id     | The shared API management service identifier           |
| shared_subnet01_id | The subnet 01 identifier in the shared virtual network |

<!--- END_TF_DOCS --->
