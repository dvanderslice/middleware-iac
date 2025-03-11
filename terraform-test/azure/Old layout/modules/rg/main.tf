resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.azure_location
  tags     = var.tags

  lifecycle {
    ignore_changes = [
      tags["createdon"]
    ]
  }
}


