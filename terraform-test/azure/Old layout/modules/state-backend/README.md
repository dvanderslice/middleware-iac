# state-backend-azure

A Terraform plan for building a state locking backend in Azure. This can be used as a standalone plan or as a module (default).

## Background

By default, Terraform stores [state](https://www.terraform.io/docs/state/index.html) information about the infrastructure it manages in a local file named `terraform.tfstate`. Any modifications to infrastructure definitions will reference this state information and update it once the required changes have been implemented. However, local state management is not suitable for team collaboration. Each team member would need a current copy of the state file. Even then, they would need to ensure that only one team member at a time can make changes to the infrastructure in order to avoid conflicting changes.

Fortunately, Terraform supports [remote state](https://www.terraform.io/docs/state/remote.html) management using a number of different [backend](https://www.terraform.io/docs/backends) solutions in which to centrally store state information. Many of these backends also support [state locking](https://www.terraform.io/docs/state/locking.html) to ensure that only one team member at a time can make changes to the infrastructure.

## Implementation

The Terraform plan contained in this repository will create a backend in Azure for state file storage and locking operations. If you are using this as a module, please skip this section. This backend can be created as a root using the following steps:

1. Clone the repository to your local machine.

```bash
$ git clone https://github.com/stealthllama/state-backend-azure.git
```

2. Change into the repository directory.

```bash
$ cd state-backend-azure
```

3. Create a `terraform.tfvars` file containing the variables defined in `variables.tf` and their values.

```bash
azure_subscription_id = "MY_SUBSCRIPTION_ID"
azure_tenant_id = "MY_TENANT_ID"
azure_client_id = "MY_CLIENT_ID"
azure_client_secret = "MY_CLIENT_SECRET"
azure_location = "eastus2"
region_abbreviation = "eus2"
resource_version = "01"
env_name = "dev"
env_key = "04"
create_lock = false
```

4. Uncomment the provider block at the top of the main.tf file.

5. Initialize the Terraform provider.

```bash
$ terraform init
```

6. Validate the Terraform plan.

```bash
$ terraform plan
```

7. Once the terraform plan command is executed, the state file is created in the storage account container. To see the contents of the state file, you should use the following command.

```bash
$ terraform state pull
```

8. Implement the Terraform plan.

```bash
$ terraform apply
```

The Terraform plan will output the name of the Azure storage account, container name, connection strings and access keys used for state storage and locking. These values will be referenced in other Terraform plans that utilize this backend.

```bash
Apply complete! Resources: 4 added, 0 changed, 0 destroyed.

Outputs:

storage_account_name = eus2tfstated04sa
container_name = tfstate
primary_access_key = SUPERSECRETKEY
primary_connection_string = CONNECTIONSTRING
primary_blob_connection_string = CONNECTIONSTRING
rg = AppGrp-tf02-dev04-rg
unique_id = f0de
```

## How to use this as a module

Although the module can be customized to fit your individual requirements, you can use the module and rely on default configuration values to get up and running quickly:

```hcl
provider "azurerm" {
  features {}
}

module "state_backend" {
  source = "git@gitlab.dematic.com:dso/devops/terraform-modules/state-backend.git//?ref=master"

  azure_location       = "eastus2"
  region_abbreviation  = "eus2"
  resource_version     = "01"
  env_name             = "dev"
  env_key              = "04"
}
```

## Usage

Once the backend has been created it can be used by another Terraform plan. However, it is recommended that you create a separate backend for each Terraform project in order to ensure state files in the backend are not overwritten. We can mitigate overwriting files by using a name prefix for the key as can be seen in the below example.

To use this backend in a Terraform plan you will define a `backend` configuration such as the following either in an existing Terraform plan file or in a separate `backend.tf` file within the project directory:

```hcl
terraform {
  backend "azurerm" {
    storage_account_name    = "tfstate37589"
    container_name          = "tfstate"
    key                     = "<root_name>.terraform.tfstate"
    access_key              = "SUPERSECRETKEY"
  }
}
```

Once included in a Terraform plan the backend will need to be initialized with the remainder of the plan. The output of the `terraform init` command should include the following output:

```
Initializing the backend...

Successfully configured the backend "azurerm"! Terraform will automatically
use this backend unless the backend configuration changes.
```

From this point forward any Terraform commands issued within the project directory will reference the state information contained in the backend storage. All commands will also acquire a state lock in order to ensure the requestor has exclusive access to the state information. The lock will then be released once the command actions have completed.

<!--- BEGIN_TF_DOCS --->

## Providers

| Name    | Version   |
| ------- | --------- |
| azurerm | >= 1.44.0 |
| random  | >= 3.1.0  |

## Inputs

| Name                | Description                                                                                                                          | Type          | Default      | Required |
| ------------------- | ------------------------------------------------------------------------------------------------------------------------------------ | ------------- | ------------ | :------: |
| azure_location      | Azure location                                                                                                                       | `string`      | n/a          |   yes    |
| region_abbreviation | Provide a shortened version of the azure location                                                                                    | `string`      | n/a          |   yes    |
| resource_version    | Provide a version identifier for the cloud deployment                                                                                | `string`      | n/a          |   yes    |
| env_name            | The environment abbreviation to be used in resource naming deployment                                                                | `string`      | n/a          |   yes    |
| env_key             | The environment instance identifier deployment                                                                                       | `string`      | n/a          |   yes    |
| tags                | Tags to be applied to resources (inclusive)                                                                                          | `map(string)` | n/a          |   yes    |
| runtime_tags        | Additional tags that can be supplied in addition to what CI has defined in the tfvars file (inclusive)                               | `map(string)` | {}           |    no    |
| createdon_format    | The date format to use when tagging                                                                                                  | `string`      | `YYYY-MM-DD` |    no    |
| create_lock         | If true, the resource group will be resource locked thus preventing accidental deletion                                              | `bool`        | `true`       |    no    |
| assign_unique_id    | If true, the resource group and storage account names will be appended with 4 random alphanumeric characters                         | `bool`        | `false`      |    no    |
| random_id           | This provides a way to specify 4 random alphanumeric characters as an identifier for uniqueness rather than generating them randomly | `string`      | n/a          |    no    |

## Outputs

| Name                           | Description                                                      |
| ------------------------------ | ---------------------------------------------------------------- |
| storage_account_name           | Name of the storage account created                              |
| primary_access_key             | Terraform backend storage account primary access key             |
| primary_connection_string      | Terraform backend storage account primary connection string      |
| primary_blob_connection_string | Terraform backend storage account primary blob connection string |
| container_name                 | Terraform backend storage container name                         |
| rg                             | Resource group resource                                          |
| unique_id                      | Resource unique identifier (optional)                            |

<!--- END_TF_DOCS --->
