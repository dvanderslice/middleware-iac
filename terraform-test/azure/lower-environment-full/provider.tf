terraform {
  required_version = ">=0.14.7"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=2.68.0"
    }
  }
  backend "azurerm" {
    # Remote state storage - values are in the backend.tfvars file. Create manually from azure portal or with the CLI.
    # Typical variables used here:
    # storage_account_name = "" // existing storage account
    # container_name = "tfstate"
    # key = "terraform.tfstate"
    # resource_group_name = "" // resource group where storage account exists
  }
}

# Configure the Microsoft Azure Provider for the deploy subsciption
provider "azurerm" {
  subscription_id = var.azure_subscription_id
  tenant_id       = var.azure_tenant_id
  #client_id       = var.azure_client_id
  #client_secret   = var.azure_client_secret

  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}

provider "azurerm" {
  features {}

  alias           = "Production"
  subscription_id = "7561e71a-f6ea-4fbb-b139-801780a9d29d"
  tenant_id       = var.azure_tenant_id
  #client_id       = var.azure_production_client_id
  #client_secret   = var.azure_production_client_secret

}
