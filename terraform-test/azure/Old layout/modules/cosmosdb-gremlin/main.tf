resource "azurerm_cosmosdb_account" "instance" {
  name                = var.cosmosdb_name
  location            = var.azure_location
  resource_group_name = var.resource_group_name
  offer_type          = "Standard"
  public_network_access_enabled = false
  is_virtual_network_filter_enabled = true
  tags                = var.tags

  consistency_policy {
    consistency_level       = "Session"
    max_interval_in_seconds = 5
    max_staleness_prefix    = 100
  }

  capabilities {
    name = "EnableGremlin"
  }
  geo_location {
    location          = var.azure_location
    failover_priority = 0
  }

  backup {
    type                = "Periodic"
    interval_in_minutes = 240
    retention_in_hours  = 8
  }

  lifecycle {
    ignore_changes = [
      tags["createdon"]
    ]
  }
}

resource "azurerm_cosmosdb_gremlin_database" "gremlindb" {
  count               = length(var.gremlin_databases)
  name                = var.gremlin_databases[count.index]
  resource_group_name = azurerm_cosmosdb_account.instance.resource_group_name
  account_name        = azurerm_cosmosdb_account.instance.name
  autoscale_settings {
    max_throughput = 4000
  }
}
