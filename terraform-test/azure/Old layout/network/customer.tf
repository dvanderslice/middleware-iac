# -------------------------------------------------------------------------------------------------
# Create the customer resources
# rg, vnet, 2 subnets, kusto, iot hub, cosmosdb, cosmosdb databases and collections, 
# stream analytics, IoT metric alerts, update config
module "cus_rg" {
  source = "../modules/rg"

  azure_location      = var.azure_location
  resource_group_name = local.cus_resource_group_name

  tags = merge(local.resource_tags, {
    "environment" = var.env_name
    "role"        = "api"
    "createdon"   = local.tag_createdon
  })
}

module "cus_cosmosdb" {
  source = "../modules/cosmosdb"

  azure_location      = var.azure_location
  resource_group_name = module.cus_rg.name
  cosmosdb_name       = local.cus_cosmosdb_name

  tags = merge(local.resource_tags, {
    "environment" = var.env_name
    "role"        = "data"
    "createdon"   = local.tag_createdon
  })
}

resource "azurerm_kusto_database" "cus_database" {
  name                = local.cus_kustodb_name
  resource_group_name = module.cus_rg.name
  location            = var.azure_location
  cluster_name        = local.kusto_name

  # These use the ISO-8601 standard outlined here: https://en.wikipedia.org/wiki/ISO_8601#Durations
  hot_cache_period   = "P31D"
  soft_delete_period = "P365D"

  depends_on = [
    module.kusto
  ]
}

# -------------------------------------------------------------------------------------------------
# Create the storage for operational file processing
resource "azurerm_storage_account" "cus_op_sa" {
  name                      = local.cus_op_storage_name
  resource_group_name       = module.cus_rg.name
  location                  = var.azure_location
  account_tier              = "Standard"
  account_replication_type  = "LRS"
  enable_https_traffic_only = true
  allow_nested_items_to_be_public  = false
  min_tls_version           = "TLS1_2"

  lifecycle {
    ignore_changes = [
      tags["createdon"],
    ]
  }

  tags = merge(local.resource_tags, {
    "environment" = var.env_name
    "role"        = "storage"
    "createdon"   = local.tag_createdon
  })
}

# Create anomaly detection containers
resource "azurerm_storage_container" "cus_op_container" {
  count                 = length(local.cus_op_containers_list)
  name                  = local.cus_op_containers_list[count.index].name
  storage_account_name  = azurerm_storage_account.cus_op_sa.name
  container_access_type = local.cus_op_containers_list[count.index].access_type
}
