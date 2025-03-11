![Control Tower Logical](/terraform-test/azure/images/logical.png)

# Environment as a Service Deployment of Azure Control Tower

Eventually terraform for GCP and AWS will get added here, but for now, this is
catering for Azure only.

## Pre-requisites

1. Terraform `v1.0.4` or later. You can get any version via the Hashicorp web site
   [downloads](https://www.terraform.io/downloads.html).
2. If using Azure, an Azure subscription. If you do not already have one, you
   can sign up for a [free trial](https://azure.microsoft.com/en-us/free/) that
   includes \$200 of free credit.
3. If using Azure, install the Azure CLI. Instructions are here:
   [install azure cli](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest)

## Running Locally

1. If developing a new module, ensure you create an example for it and test it.
   The example should follow the same pattern as the example in `examples/example-rg`.

2. If developing a new root, ensure you consume modules that exist in this
   repository. If a module from github is desired, fork it and create a new module
   for it in this repository in the `modules` folder. All roots should be contained
   in a folder that describes the purpose (i.e. networking, services, application,
   etc.) and that folder should be contained in the `azure` folder.

## Modifications

All development should take place in a feature or fix branch. When complete, the
branch should be merged into main via a merge request that is reviewed by another
member of the team.

## Module Creation

When creating terraform modules, the typical file structure consists of a `main.tf`, `variables.tf`, `README.md` and `output.tf` files.

The `main.tf` contains the primary configuration and resource declarations.

The `variables.tf` file contains all the variables required to successfully deploy all infrastructure within a module. If appropriate, reasonable defaults can be set for certain variables. If you want to ensure users specify a variable, the variable can be declared without a default value. This will force users to declare a value via the command line or within a terraform.tfvars file.

The `README.md` is used to document the module and how it can be used.

The `output.tf` contains values that will be output to the terminal. Output variables can be retrieved via the Terraform CLI and used after the infrastructure has been deployed.

```bash
.
├── main.tf
├── output.tf
├── README.md
└── variables.tf

0 directories, 4 files
```

After modules are created, clone an example root and consume the module to ensure the module works as intended.

## Deployment

For this version of the deployment, the two environment deployments are broken into two sections.
- New-Virtual-WAN-Full - Will deploy a virtual WAN and firewall for a new production level environment. With all multi-tenant components for Control Tower
- Lower-Environment-Full - Will deploy a hub within an existing Virtual WAN for a new lower environment, connecting to the existing hub. With all multi-tenant components for Control Tower

##Only components not included are the API Management specialization currently contained withing the stateless deplyoment. This can be deployed in another manner as well ,via ARM Templates.

Deployment Steps:

1. Create or modify tfvars files. This is vital to ensure resources are generated correctly and state files are sent to the backend storage account in the dev02 subscription.

2. Deploy the New-Virtual-WAN-Full.

```
cd azure/new-virtual-wan-full
terraform init -backend-config="backend.tfvars"
terraform plan -var-file="backend.tfvars" -var-file="weu.tfvars" -out weu-new-full.tfplan
terraform apply -auto-approve weu-new-full.tfplan
```

Or
3. Deploy the lower-environment-full.

```
cd ../lower-environment-full
terraform init -backend-config="backend.tfvars"
terraform plan -var-file="backend.tfvars" -var-file="weu.tfvars" -out weu-low-full.tfplan
terraform apply -auto-approve weu-low-full.tfplan
```


## Issues / Feedback / Feature Requests?

If you have any issues, comments or want to see new features, please file an
issue in the project repository:

https://gitlab.dematic.com/cloudresdev/terraform
