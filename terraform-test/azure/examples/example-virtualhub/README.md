# example module usage

A Terraform plan for testing the virtualhub terraform module.

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
purpose = "hub"
region_abbreviation = "eus2"
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
Apply complete! Resources: 12 added, 0 changed, 0 destroyed.

Outputs:

firewall_id = "/subscriptions/7561e71a-f6ea-4fbb-b139-801780a9d29d/resourceGroups/AppGrp-hub01-dev01-rg-dcb6/providers/Microsoft.Network/azureFirewalls/eus2-virtualhub-dcb6"
subnet01_id = "/subscriptions/7561e71a-f6ea-4fbb-b139-801780a9d29d/resourceGroups/AppGrp-hub01-dev01-rg-dcb6/providers/Microsoft.Network/virtualNetworks/eus2-hub-dev01-vnet-dcb6/subnets/AzureFirewallSubnet"
virtual_hub_id = "/subscriptions/7561e71a-f6ea-4fbb-b139-801780a9d29d/resourceGroups/AppGrp-hub01-dev01-rg-dcb6/providers/Microsoft.Network/virtualHubs/eus2-virtualhub-dcb6"
virtual_wan_id = "/subscriptions/7561e71a-f6ea-4fbb-b139-801780a9d29d/resourceGroups/AppGrp-hub01-dev01-rg-dcb6/providers/Microsoft.Network/virtualWans/eus2-virtualwan-dcb6"
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
| tags                  | Tags to be applied to resources (inclusive)                                                                                            | `map(string)` | n/a          |   yes    |
| runtime_tags          | Additional tags that can be supplied in addition to what CI has defined in the tfvars file (inclusive)                                 | `map(string)` | {}           |    no    |
| createdon_format      | The date format to use when tagging                                                                                                    | `string`      | `YYYY-MM-DD` |    no    |
| random_id             | Random identifier used with resource naming                                                                                            | `string`      | n/a          |    no    |

## Outputs

| Name           | Description                                         |
| -------------- | --------------------------------------------------- |
| virtual_wan_id | Virtual WAN identifier                              |
| virtual_hub_id | Virtual hub identifier                              |
| firewall_id    | Firewall identifier                                 |
| public_ip_id   | Public IP address identifier                        |
| public_ip      | Public IP address to the firewall                   |
| subnet01_id    | The subnet 01 identifier in the hub virtual network |

<!--- END_TF_DOCS --->
