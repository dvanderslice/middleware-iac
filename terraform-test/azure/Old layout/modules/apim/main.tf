resource "azurerm_api_management" "service_with_vnet" {
  count = var.virtual_network_type == "None" ? 0 : 1

  name                 = var.apim_name
  location             = var.azure_location
  resource_group_name  = var.resource_group_name
  publisher_name       = "Dematic Digital Solutions"
  publisher_email      = "digitalsolutions-rd@dematic.com"
  sku_name             = var.apim_sku
  tags                 = var.tags
  virtual_network_type = var.virtual_network_type


  virtual_network_configuration {
    subnet_id = var.virtual_network_subnet
  }

  lifecycle {
    ignore_changes = [
      tags["createdon"]
    ]
  }
}

resource "azurerm_api_management" "service" {
  count = var.virtual_network_type == "None" ? 1 : 0

  name                = var.apim_name
  location            = var.azure_location
  resource_group_name = var.resource_group_name
  publisher_name      = "Dematic Digital Solutions"
  publisher_email     = "digitalsolutions-rd@dematic.com"
  sku_name            = var.apim_sku
  tags                = var.tags

  lifecycle {
    ignore_changes = [
      tags["createdon"]
    ]
  }
}

