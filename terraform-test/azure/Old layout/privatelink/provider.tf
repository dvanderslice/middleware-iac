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

# Configure the Microsoft Azure Provider
provider "azurerm" {
  subscription_id = var.azure_subscription_id
  tenant_id       = var.azure_tenant_id
  #client_id       = var.azure_client_id
  #client_secret   = var.azure_client_secret

  features {}
}
