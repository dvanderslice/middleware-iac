resource "azurerm_cosmosdb_account" "instance" {
  name                 = var.cosmosdb_name
  location             = var.azure_location
  resource_group_name  = var.resource_group_name
  offer_type           = "Standard"
  kind                 = "MongoDB"
  mongo_server_version = 3.6
  is_virtual_network_filter_enabled = true
  public_network_access_enabled = false
  tags                 = var.tags

  consistency_policy {
    consistency_level       = "BoundedStaleness"
    max_interval_in_seconds = 10
    max_staleness_prefix    = 200
  }
#######ADD Throughput Value with VAR.######
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
