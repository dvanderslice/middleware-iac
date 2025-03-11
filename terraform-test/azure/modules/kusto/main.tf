

resource "azurerm_kusto_cluster" "cluster" {
  name                = var.kusto_name
  location            = var.azure_location
  resource_group_name = var.resource_group_name
  tags                = var.tags
  sku {
    name     = var.kusto_sku_name
    capacity = var.kusto_sku_capacity
  }
  virtual_network_configuration {
    subnet_id                    = var.subnet_id
    engine_public_ip_id          = azurerm_public_ip.engine.id
    data_management_public_ip_id = azurerm_public_ip.management.id
  }
  lifecycle {
    ignore_changes = [
      tags["createdon"]
    ]
  }
}

data "azurerm_kusto_cluster" "cluster_additionals" {
  name                = azurerm_kusto_cluster.cluster.name
  resource_group_name = azurerm_kusto_cluster.cluster.resource_group_name
  depends_on = [
    azurerm_kusto_cluster.cluster
  ]
}

resource "azurerm_public_ip" "engine" {
  name                = var.public_ip_name_for_engine
  resource_group_name = var.resource_group_name
  location            = var.azure_location
  sku = "Standard"
  allocation_method   = "Static"
  tags                = var.tags
}

resource "azurerm_public_ip" "management" {
  name                = var.public_ip_name_for_management
  resource_group_name = var.resource_group_name
  location            = var.azure_location
  sku = "Standard"
  allocation_method   = "Static"
  tags                = var.tags
}

# We are not creating a database as they are customer specific and should be in the customer terraform
