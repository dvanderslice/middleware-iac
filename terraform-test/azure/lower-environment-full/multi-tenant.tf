
# Create the configuration storage account
resource "azurerm_storage_account" "config_sa" {
  name                            = local.mul_config_storage_name
  resource_group_name             = module.rg.name
  location                        = var.azure_location
  account_tier                    = "Standard"
  account_replication_type        = "GRS"
  enable_https_traffic_only       = true
  allow_nested_items_to_be_public = false
  min_tls_version                 = "TLS1_2"

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

# Create configuration containers
resource "azurerm_storage_container" "container" {
  count                 = length(local.config_containers_list)
  name                  = local.config_containers_list[count.index].name
  storage_account_name  = azurerm_storage_account.config_sa.name
  container_access_type = local.config_containers_list[count.index].access_type
}

resource "azurerm_eventhub_namespace" "mul_eventhub_namespace" {
  name                     = local.eventhub_namespace_name
  location                 = var.azure_location
  resource_group_name      = module.rg.name
  sku                      = "Standard"
  capacity                 = 1
  auto_inflate_enabled     = true
  maximum_throughput_units = 1



  tags = merge(local.resource_tags, {
    "environment" = var.env_name
    "role"        = "eventhub"
    "createdon"   = local.tag_createdon
  })
  depends_on = [
    module.rg
  ]
}



# Create the deployment storage account
resource "azurerm_storage_account" "depl_sa" {
  name                            = local.mul_depl_sa_name
  resource_group_name             = module.rg.name
  location                        = var.azure_location
  account_tier                    = "Standard"
  account_replication_type        = "LRS"
  enable_https_traffic_only       = true
  allow_nested_items_to_be_public = false
  min_tls_version                 = "TLS1_2"

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

# Create depl containers
resource "azurerm_storage_container" "depl_container" {
  name                  = "config"
  storage_account_name  = azurerm_storage_account.depl_sa.name
  container_access_type = "private"
}

resource "azurerm_eventhub" "mul_eventhub" {
  name                = local.eventhub_hub_name
  namespace_name      = azurerm_eventhub_namespace.mul_eventhub_namespace.name
  resource_group_name = module.rg.name
  partition_count     = 4
  message_retention   = 1
}

resource "azurerm_eventhub_authorization_rule" "mul_eventhub_authorization_reader" {
  name                = "reader"
  namespace_name      = azurerm_eventhub_namespace.mul_eventhub_namespace.name
  eventhub_name       = azurerm_eventhub.mul_eventhub.name
  resource_group_name = module.rg.name
  listen              = true
  send                = false
  manage              = false
}

resource "azurerm_eventhub_authorization_rule" "mul_eventhub_authorization_sender" {
  name                = "sender"
  namespace_name      = azurerm_eventhub_namespace.mul_eventhub_namespace.name
  eventhub_name       = azurerm_eventhub.mul_eventhub.name
  resource_group_name = module.rg.name
  listen              = false
  send                = true
  manage              = false
}

resource "azurerm_eventhub_authorization_rule" "mul_eventhub_authorization_manage" {
  name                = "manage"
  namespace_name      = azurerm_eventhub_namespace.mul_eventhub_namespace.name
  eventhub_name       = azurerm_eventhub.mul_eventhub.name
  resource_group_name = module.rg.name
  listen              = true
  send                = true
  manage              = true
}

resource "azurerm_eventhub_namespace_authorization_rule" "mul_eventhub_namespace_authorization_reader" {
  name                = "reader"
  namespace_name      = azurerm_eventhub_namespace.mul_eventhub_namespace.name
  resource_group_name = module.rg.name

  listen = true
  send   = false
  manage = false
}

resource "azurerm_eventhub_namespace_authorization_rule" "mul_eventhub_namespace_authorization_sender" {
  name                = "sender"
  namespace_name      = azurerm_eventhub_namespace.mul_eventhub_namespace.name
  resource_group_name = module.rg.name

  listen = false
  send   = true
  manage = false
}

resource "azurerm_eventhub_namespace_authorization_rule" "mul_eventhub_namespace_authorization_manage" {
  name                = "manage"
  namespace_name      = azurerm_eventhub_namespace.mul_eventhub_namespace.name
  resource_group_name = module.rg.name

  listen = true
  send   = true
  manage = true
}

resource "azurerm_kusto_cluster" "kcluster" {
  name                          = local.kusto_name
  location                      = var.azure_location
  resource_group_name           = module.rg.name
  tags                          = var.tags
  public_network_access_enabled = false
  engine                        = "V3"
  sku {
    name     = "Standard_DS13_v2+1TB_PS"
    capacity = 2
  }
  lifecycle {
    ignore_changes = [
      tags["createdon"]
    ]
  }
}

# Create the storage for operational file processing
resource "azurerm_storage_account" "op_sa" {
  name                            = local.op_storage_name
  resource_group_name             = module.rg.name
  location                        = var.azure_location
  account_tier                    = "Standard"
  account_replication_type        = "LRS"
  enable_https_traffic_only       = true
  allow_nested_items_to_be_public = false
  min_tls_version                 = "TLS1_2"
  blob_properties {
    cors_rule {
      allowed_headers    = ["*"]
      allowed_methods    = ["GET", "PUT"]
      allowed_origins    = ["http://localhost:8080", local.op_storage_CORS_origin]
      exposed_headers    = ["*"]
      max_age_in_seconds = 3600
    }
  }
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
resource "azurerm_storage_container" "op_container" {
  count                 = length(local.op_containers_list)
  name                  = local.op_containers_list[count.index].name
  storage_account_name  = azurerm_storage_account.op_sa.name
  container_access_type = local.op_containers_list[count.index].access_type

  depends_on = [
    azurerm_storage_account.op_sa
  ]
}

# -------------------------------------------------------------------------------------------------
# Create the resources for AI anomaly detection
module "ai_rg" {
  source = "../modules/rg"

  azure_location      = var.azure_location
  resource_group_name = local.ai_resource_group_name

  tags = merge(local.resource_tags, {
    "environment" = var.env_name
    "role"        = "anomalydetection"
    "createdon"   = local.tag_createdon
  })
}

resource "azurerm_storage_account" "ai_sa" {
  name                            = local.ai_storage_name
  resource_group_name             = module.ai_rg.name
  location                        = var.azure_location
  account_tier                    = "Standard"
  account_replication_type        = "LRS"
  enable_https_traffic_only       = true
  allow_nested_items_to_be_public = false
  min_tls_version                 = "TLS1_2"

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
resource "azurerm_storage_container" "ai_container" {
  count                 = length(local.ai_containers_list)
  name                  = local.ai_containers_list[count.index].name
  storage_account_name  = azurerm_storage_account.ai_sa.name
  container_access_type = local.ai_containers_list[count.index].access_type
}

resource "azurerm_storage_account" "cfrn_sa" {
  name                            = local.cfrn_storage_name
  resource_group_name             = module.frn_rg.name
  location                        = var.azure_location
  account_tier                    = "Standard"
  account_replication_type        = "LRS"
  enable_https_traffic_only       = true
  allow_nested_items_to_be_public = false
  min_tls_version                 = "TLS1_2"
  static_website {
    index_document = "index.html"
  }
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

resource "azurerm_storage_account" "hlp_sa" {
  name                            = local.hlp_storage_name
  resource_group_name             = module.rg.name
  location                        = var.azure_location
  account_tier                    = "Standard"
  account_replication_type        = "LRS"
  enable_https_traffic_only       = true
  allow_nested_items_to_be_public = false
  min_tls_version                 = "TLS1_2"
  static_website {
    index_document = "index.html"
  }
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

resource "azurerm_storage_account_network_rules" "cfrn_sa_rules" {
  storage_account_id = azurerm_storage_account.cfrn_sa.id

  default_action = "Deny"
  bypass         = ["AzureServices"]
}
# Note that the anomaly detection function app is deployed once here, but the customer 
# terraform will also separately deploy just the function app itself for each customer,
# thus reusing the app insights, plan, storage, etc.


# -------------------------------------------------------------------------------------------------
# Create gremlin database in CosmosDB account. We are not creating databases as they require a site Id
resource "azurerm_cosmosdb_account" "instance" {
  name                              = local.cosmosdb_name
  location                          = var.azure_location
  resource_group_name               = module.rg.name
  offer_type                        = "Standard"
  public_network_access_enabled     = false
  is_virtual_network_filter_enabled = true
  tags                              = var.tags

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
  depends_on = [
    module.rg
  ]
}

resource "azurerm_web_pubsub" "mul_webhubservice" {
  name                = local.webpubsub_service_name
  resource_group_name = module.rg.name
  location            = var.azure_location

  sku      = "Standard_S1"
  capacity = 1

  public_network_access_enabled = false

  live_trace {
    enabled                   = true
    messaging_logs_enabled    = true
    connectivity_logs_enabled = false
  }

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_web_pubsub_hub" "webpubhub" {
  name          = local.webpubhub_hub_chat_name
  web_pubsub_id = azurerm_web_pubsub.mul_webhubservice.id
  event_handler {
    url_template       = "https://340b-73-82-170-154.ngrok.io/api/chat/upstream"
    user_event_pattern = "*"
    system_events      = ["connect", "connected", "disconnected"]
  }
  anonymous_connections_enabled = false

  depends_on = [
    azurerm_web_pubsub.mul_webhubservice
  ]
}

data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "utl_keyvault" {
  name                            = local.utl_keyvault_name
  location                        = var.azure_location
  resource_group_name             = module.utl_rg.name
  enabled_for_disk_encryption     = true
  enabled_for_deployment          = true
  enabled_for_template_deployment = true
  tenant_id                       = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days      = 7
  purge_protection_enabled        = false

  sku_name = "standard"

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "Get",
    ]

    secret_permissions = [
      "Get",
    ]

    storage_permissions = [
      "Get",
    ]
  }
  depends_on = [
    module.utl_rg
  ]
}
resource "azurerm_key_vault_access_policy" "digitalsolutions_dev2_contributor" {
  key_vault_id = azurerm_key_vault.utl_keyvault.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = "f2859897-a17f-41e7-9060-8d5a23bd8574"

  key_permissions = [
    "Get",
    "List",
    "Update",
    "Create",
    "Import"
  ]

  secret_permissions = [
    "Get",
    "List",
    "Set"
  ]

  certificate_permissions = [
    "Get",
    "List",
    "Update",
    "Create",
    "ManageContacts"
  ]
}

resource "azurerm_key_vault_access_policy" "frontdoor_premium" {
  key_vault_id = azurerm_key_vault.utl_keyvault.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = "c6b84a2b-def4-4764-86b3-541eff4f4c0d"

  key_permissions = [
    "Get",
    "List"
  ]

  secret_permissions = [
    "Get",
    "List"
  ]

  certificate_permissions = [
    "Get",
    "List",
    "Update",
    "Create",
    "Import",
    "Recover",
    "Backup",
    "Restore"
  ]
}

resource "azurerm_key_vault_access_policy" "azure-ict-dev-kv-admin" {
  key_vault_id = azurerm_key_vault.utl_keyvault.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = "7e53c3fa-3a21-4bb1-aed9-df013804d59f"

  key_permissions = [
    "Get",
    "List",
    "Update",
    "Create",
    "Import",
    "Delete"
  ]

  secret_permissions = [
    "Get",
    "List",
    "Set",
    "Delete",
    "Recover",
    "Backup",
    "Restore",
    "Purge"
  ]

  certificate_permissions = [
    "Get",
    "List",
    "Update",
    "Create",
    "Import",
    "Delete",
    "Recover",
    "Backup",
    "Restore",
    "ManageContacts",
    "Purge"
  ]
}


resource "azurerm_log_analytics_workspace" "utl_loganalytics" {
  name                = local.utl_log_analytics_workspace_name
  location            = var.azure_location
  resource_group_name = module.utl_rg.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
  depends_on = [
    module.utl_rg
  ]
}

resource "azurerm_container_registry" "acr" {
  name                = local.utl_acr_name
  location            = var.azure_location
  resource_group_name = module.utl_rg.name
  sku                 = "Standard"
  admin_enabled       = true
  depends_on = [
    module.utl_rg
  ]

}

resource "azurerm_iothub_dps" "mul_dps" {
  name                = local.mul_dps_name
  resource_group_name = module.rg.name
  location            = var.azure_location
  allocation_policy   = "Hashed"

  sku {
    name     = "S1"
    capacity = "1"
  }
}

resource "azurerm_redis_enterprise_cluster" "mul_redis_cluster" {
  name                = local.redis_instance_name
  resource_group_name = module.rg.name
  location            = var.azure_location
  minimum_tls_version = "1.2"
  sku_name            = "Enterprise_E10-2"
}

resource "azurerm_redis_enterprise_database" "mul_redis_database" {
  name              = "default"
  client_protocol   = "Encrypted"
  port              = 10000
  clustering_policy = "EnterpriseCluster"
  cluster_id        = azurerm_redis_enterprise_cluster.mul_redis_cluster.id

  module {
    name = "RedisBloom"
  }
  module {
    name = "RedisTimeSeries"
  }
  module {
    name = "RediSearch"
  }
}

