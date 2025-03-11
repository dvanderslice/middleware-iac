##Create Private Endpoints for Resources##These are separate resources##Should consider looping through this deployment to validate
resource "azurerm_private_endpoint" "auth_function_app_blue_pe" {
  name                = "${local.auth_blue_function_app_name}-pe"
  location            = var.azure_location
  resource_group_name = module.private_rg.name
  subnet_id           = azurerm_subnet.Func_private_subnet.id

  private_service_connection {
    name                           = "${local.auth_blue_function_app_name}-pe"
    private_connection_resource_id = azurerm_windows_function_app.auth_function_app_blue.id
    subresource_names              = ["sites"]
    is_manual_connection           = false
  }
    private_dns_zone_group {
    name                 = "private-dns-zone-group"
    private_dns_zone_ids = [azurerm_private_dns_zone.privatedns_asp.id]
  }
}

resource "azurerm_private_endpoint" "auth_function_app_green_pe" {
  name                = "${local.auth_green_function_app_name}-pe"
  location            = var.azure_location
  resource_group_name = module.private_rg.name
  subnet_id           = azurerm_subnet.Func_private_subnet.id

  private_service_connection {
    name                           = "${local.auth_green_function_app_name}-pe"
    private_connection_resource_id = azurerm_windows_function_app.auth_function_app_green.id
    subresource_names              = ["sites"]
    is_manual_connection           = false
  }
    private_dns_zone_group {
    name                 = "private-dns-zone-group"
    private_dns_zone_ids = [azurerm_private_dns_zone.privatedns_asp.id]
  }

}

resource "azurerm_private_endpoint" "data_dog_function_pe" {
  name                = "${local.datadog_function_app_name}-pe"
  location            = var.azure_location
  resource_group_name = module.private_rg.name
  subnet_id           = azurerm_subnet.Func_private_subnet.id

  private_service_connection {
    name                           = "${local.datadog_function_app_name}-pe"
    private_connection_resource_id = azurerm_windows_function_app.datadog_function_app.id
    subresource_names              = ["sites"]
    is_manual_connection           = false
  }
    private_dns_zone_group {
    name                 = "private-dns-zone-group"
    private_dns_zone_ids = [azurerm_private_dns_zone.privatedns_asp.id]
  }

}

resource "azurerm_private_endpoint" "ai_function_pe" {
  name                = "${local.ai_function_app_name}-pe"
  location            = var.azure_location
  resource_group_name = module.private_rg.name
  subnet_id           = azurerm_subnet.Func_private_subnet.id

  private_service_connection {
    name                           = "${local.datadog_function_app_name}-pe"
    private_connection_resource_id = azurerm_linux_function_app.ai_function_app.id
    subresource_names              = ["sites"]
    is_manual_connection           = false
  }
    private_dns_zone_group {
    name                 = "private-dns-zone-group"
    private_dns_zone_ids = [azurerm_private_dns_zone.privatedns_asp.id]
  }
}

resource "azurerm_private_endpoint" "data_replay_function_pe" {
  name                = "${local.mul_function_app_name}-pe"
  location            = var.azure_location
  resource_group_name = module.private_rg.name
  subnet_id           = azurerm_subnet.Func_private_subnet.id

  private_service_connection {
    name                           = "${local.mul_function_app_name}-pe"
    private_connection_resource_id = azurerm_windows_function_app.data_replay_function_app.id
    subresource_names              = ["sites"]
    is_manual_connection           = false
  }
    private_dns_zone_group {
    name                 = "private-dns-zone-group"
    private_dns_zone_ids = [azurerm_private_dns_zone.privatedns_asp.id]
  }
}

resource "azurerm_private_endpoint" "core_blue_function_pe" {
  name                = "${local.mul_core_blue_function_app_name}-pe"
  location            = var.azure_location
  resource_group_name = module.private_rg.name
  subnet_id           = azurerm_subnet.Func_private_subnet.id

  private_service_connection {
    name                           = "${local.mul_core_blue_function_app_name}-pe"
    private_connection_resource_id = azurerm_windows_function_app.core_blue_function_app.id
    subresource_names              = ["sites"]
    is_manual_connection           = false
  }
    private_dns_zone_group {
    name                 = "private-dns-zone-group"
    private_dns_zone_ids = [azurerm_private_dns_zone.privatedns_asp.id]
  }
}

resource "azurerm_private_endpoint" "core_green_function_pe" {
  name                = "${local.mul_core_green_function_app_name}-pe"
  location            = var.azure_location
  resource_group_name = module.private_rg.name
  subnet_id           = azurerm_subnet.Func_private_subnet.id

  private_service_connection {
    name                           = "${local.mul_core_green_function_app_name}-pe"
    private_connection_resource_id = azurerm_windows_function_app.core_green_function_app.id
    subresource_names              = ["sites"]
    is_manual_connection           = false
  }
    private_dns_zone_group {
    name                 = "private-dns-zone-group"
    private_dns_zone_ids = [azurerm_private_dns_zone.privatedns_asp.id]
  }
}

resource "azurerm_private_endpoint" "gql_gate_blue_function_pe" {
  name                = "${local.mul_gql_gate_blue_function_app_name}-pe"
  location            = var.azure_location
  resource_group_name = module.private_rg.name
  subnet_id           = azurerm_subnet.Func_private_subnet.id

  private_service_connection {
    name                           = "${local.mul_gql_gate_blue_function_app_name}-pe"
    private_connection_resource_id = azurerm_windows_function_app.gql_gate_blue_function_app.id
    subresource_names              = ["sites"]
    is_manual_connection           = false
  }
    private_dns_zone_group {
    name                 = "private-dns-zone-group"
    private_dns_zone_ids = [azurerm_private_dns_zone.privatedns_asp.id]
  }
}

resource "azurerm_private_endpoint" "gql_gate_green_function_pe" {
  name                = "${local.mul_gql_gate_green_function_app_name}-pe"
  location            = var.azure_location
  resource_group_name = module.private_rg.name
  subnet_id           = azurerm_subnet.Func_private_subnet.id

  private_service_connection {
    name                           = "${local.mul_gql_gate_green_function_app_name}-pe"
    private_connection_resource_id = azurerm_windows_function_app.gql_gate_green_function_app.id
    subresource_names              = ["sites"]
    is_manual_connection           = false
  }
    private_dns_zone_group {
    name                 = "private-dns-zone-group"
    private_dns_zone_ids = [azurerm_private_dns_zone.privatedns_asp.id]
  }
}

resource "azurerm_private_endpoint" "notifications_blue_function_pe" {
  name                = "${local.mul_notifications_blue_function_app_name}-pe"
  location            = var.azure_location
  resource_group_name = module.private_rg.name
  subnet_id           = azurerm_subnet.Func_private_subnet.id

  private_service_connection {
    name                           = "${local.mul_notifications_blue_function_app_name}-pe"
    private_connection_resource_id = azurerm_windows_function_app.notifications_blue_function_app.id
    subresource_names              = ["sites"]
    is_manual_connection           = false
  }
    private_dns_zone_group {
    name                 = "private-dns-zone-group"
    private_dns_zone_ids = [azurerm_private_dns_zone.privatedns_asp.id]
  }
}

resource "azurerm_private_endpoint" "notifications_green_function_pe" {
  name                = "${local.mul_notifications_green_function_app_name}-pe"
  location            = var.azure_location
  resource_group_name = module.private_rg.name
  subnet_id           = azurerm_subnet.Func_private_subnet.id

  private_service_connection {
    name                           = "${local.mul_notifications_green_function_app_name}-pe"
    private_connection_resource_id = azurerm_windows_function_app.notifications_green_function_app.id
    subresource_names              = ["sites"]
    is_manual_connection           = false
  }
    private_dns_zone_group {
    name                 = "private-dns-zone-group"
    private_dns_zone_ids = [azurerm_private_dns_zone.privatedns_asp.id]
  }
}

resource "azurerm_private_endpoint" "nui_blue_function_pe" {
  name                = "${local.mul_nui_blue_function_app_name}-pe"
  location            = var.azure_location
  resource_group_name = module.private_rg.name
  subnet_id           = azurerm_subnet.Func_private_subnet.id

  private_service_connection {
    name                           = "${local.mul_nui_blue_function_app_name}-pe"
    private_connection_resource_id = azurerm_windows_function_app.nui_blue_function_app.id
    subresource_names              = ["sites"]
    is_manual_connection           = false
  }
    private_dns_zone_group {
    name                 = "private-dns-zone-group"
    private_dns_zone_ids = [azurerm_private_dns_zone.privatedns_asp.id]
  }
}

resource "azurerm_private_endpoint" "nui_green_function_pe" {
  name                = "${local.mul_nui_green_function_app_name}-pe"
  location            = var.azure_location
  resource_group_name = module.private_rg.name
  subnet_id           = azurerm_subnet.Func_private_subnet.id

  private_service_connection {
    name                           = "${local.mul_nui_green_function_app_name}-pe"
    private_connection_resource_id = azurerm_windows_function_app.nui_green_function_app.id
    subresource_names              = ["sites"]
    is_manual_connection           = false
  }
    private_dns_zone_group {
    name                 = "private-dns-zone-group"
    private_dns_zone_ids = [azurerm_private_dns_zone.privatedns_asp.id]
  }
}

resource "azurerm_private_endpoint" "linux_blue_function_pe" {
  name                = "${local.linux_blue_function_app_name}-pe"
  location            = var.azure_location
  resource_group_name = module.private_rg.name
  subnet_id           = azurerm_subnet.Func_private_subnet.id

  private_service_connection {
    name                           = "${local.linux_blue_function_app_name}-pe"
    private_connection_resource_id = azurerm_linux_function_app.linux_blue_function_app.id
    subresource_names              = ["sites"]
    is_manual_connection           = false
  }
    private_dns_zone_group {
    name                 = "private-dns-zone-group"
    private_dns_zone_ids = [azurerm_private_dns_zone.privatedns_asp.id]
  }
}

resource "azurerm_private_endpoint" "linux_green_function_pe" {
  name                = "${local.linux_green_function_app_name}-pe"
  location            = var.azure_location
  resource_group_name = module.private_rg.name
  subnet_id           = azurerm_subnet.Func_private_subnet.id

  private_service_connection {
    name                           = "${local.linux_green_function_app_name}-pe"
    private_connection_resource_id = azurerm_linux_function_app.linux_green_function_app.id
    subresource_names              = ["sites"]
    is_manual_connection           = false
  }
    private_dns_zone_group {
    name                 = "private-dns-zone-group"
    private_dns_zone_ids = [azurerm_private_dns_zone.privatedns_asp.id]
  }
}

data "azurerm_resources" "storage" {
  type = "Microsoft.Storage/storageAccounts"

}

resource "azurerm_private_endpoint" "function_storage_account_blob_pe" {
  name                = "${local.mul_storage_name}-blob-pe"
  location            = var.azure_location
  resource_group_name = module.private_rg.name
  subnet_id           = azurerm_subnet.storage_private_subnet.id

  private_service_connection {
  name                = "${local.mul_storage_name}-blob-pe"
    private_connection_resource_id = azurerm_storage_account.function_storage_account.id
    subresource_names              = ["blob"]
    is_manual_connection           = false
  }

      private_dns_zone_group {
    name                 = "private-dns-zone-group"
    private_dns_zone_ids = [azurerm_private_dns_zone.privatedns_blob.id]
  }
}

resource "azurerm_private_endpoint" "function_storage_account_file_pe" {
  name                = "${local.mul_storage_name}-file-pe"
  location            = var.azure_location
  resource_group_name = module.private_rg.name
  subnet_id           = azurerm_subnet.storage_private_subnet.id

  private_service_connection {
  name                = "${local.mul_storage_name}-file-pe"
    private_connection_resource_id = azurerm_storage_account.function_storage_account.id
    subresource_names              = ["file"]
    is_manual_connection           = false
  }

      private_dns_zone_group {
    name                 = "private-dns-zone-group"
    private_dns_zone_ids = [azurerm_private_dns_zone.privatedns_file.id]
  }
}

resource "azurerm_private_endpoint" "linux_function_storage_account_blob_pe" {
  name                = "${local.linux_storage_name}-blob-pe"
  location            = var.azure_location
  resource_group_name = module.private_rg.name
  subnet_id           = azurerm_subnet.storage_private_subnet.id

  private_service_connection {
  name                = "${local.linux_storage_name}-blob-pe"
    private_connection_resource_id = azurerm_storage_account.linux_storage_account.id
    subresource_names              = ["blob"]
    is_manual_connection           = false
  }

      private_dns_zone_group {
    name                 = "private-dns-zone-group"
    private_dns_zone_ids = [azurerm_private_dns_zone.privatedns_blob.id]
  }
}

resource "azurerm_private_endpoint" "linux_function_storage_account_file_pe" {
  name                = "${local.linux_storage_name}-file-pe"
  location            = var.azure_location
  resource_group_name = module.private_rg.name
  subnet_id           = azurerm_subnet.storage_private_subnet.id

  private_service_connection {
  name                = "${local.linux_storage_name}-file-pe"
    private_connection_resource_id = azurerm_storage_account.linux_storage_account.id
    subresource_names              = ["file"]
    is_manual_connection           = false
  }

      private_dns_zone_group {
    name                 = "private-dns-zone-group"
    private_dns_zone_ids = [azurerm_private_dns_zone.privatedns_file.id]
  }
}

resource "azurerm_private_endpoint" "config_storage_account_blob_pe" {
  name                = "${azurerm_storage_account.config_sa.name}-blob-pe"
  location            = var.azure_location
  resource_group_name = module.private_rg.name
  subnet_id           = azurerm_subnet.storage_private_subnet.id

  private_service_connection {
    name                           = "${azurerm_storage_account.config_sa.name}-blob-pe"
    private_connection_resource_id = azurerm_storage_account.config_sa.id
    subresource_names              = ["blob"]
    is_manual_connection           = false
  }

      private_dns_zone_group {
    name                 = "private-dns-zone-group"
    private_dns_zone_ids = [azurerm_private_dns_zone.privatedns_blob.id]
  }
}

resource "azurerm_private_endpoint" "config_storage_account_file_pe" {
  name                = "${azurerm_storage_account.config_sa.name}-file-pe"
  location            = var.azure_location
  resource_group_name = module.private_rg.name
  subnet_id           = azurerm_subnet.storage_private_subnet.id

  private_service_connection {
    name                           = "${azurerm_storage_account.config_sa.name}-file-pe"
    private_connection_resource_id = azurerm_storage_account.config_sa.id
    subresource_names              = ["file"]
    is_manual_connection           = false
  }

      private_dns_zone_group {
    name                 = "private-dns-zone-group"
    private_dns_zone_ids = [azurerm_private_dns_zone.privatedns_file.id]
  }
}

resource "azurerm_private_endpoint" "op_storage_account_blob_pe" {
  name                = "${azurerm_storage_account.op_sa.name}-blob-pe"
  location            = var.azure_location
  resource_group_name = module.private_rg.name
  subnet_id           = azurerm_subnet.storage_private_subnet.id

  private_service_connection {
    name                           = "${azurerm_storage_account.op_sa.name}-blob-pe"
    private_connection_resource_id = azurerm_storage_account.op_sa.id
    subresource_names              = ["blob"]
    is_manual_connection           = false
  }

      private_dns_zone_group {
    name                 = "private-dns-zone-group"
    private_dns_zone_ids = [azurerm_private_dns_zone.privatedns_blob.id]
  }
}

resource "azurerm_private_endpoint" "op_storage_account_file_pe" {
  name                = "${azurerm_storage_account.op_sa.name}-file-pe"
  location            = var.azure_location
  resource_group_name = module.private_rg.name
  subnet_id           = azurerm_subnet.storage_private_subnet.id

  private_service_connection {
    name                           = "${azurerm_storage_account.op_sa.name}-file-pe"
    private_connection_resource_id = azurerm_storage_account.op_sa.id
    subresource_names              = ["file"]
    is_manual_connection           = false
  }

      private_dns_zone_group {
    name                 = "private-dns-zone-group"
    private_dns_zone_ids = [azurerm_private_dns_zone.privatedns_file.id]
  }
}

resource "azurerm_private_endpoint" "ai_storage_account_blob_pe" {
  name                = "${azurerm_storage_account.ai_sa.name}-blob-pe"
  location            = var.azure_location
  resource_group_name = module.private_rg.name
  subnet_id           = azurerm_subnet.storage_private_subnet.id

  private_service_connection {
    name                           = "${azurerm_storage_account.ai_sa.name}-blob-pe"
    private_connection_resource_id = azurerm_storage_account.ai_sa.id
    subresource_names              = ["blob"]
    is_manual_connection           = false
  }

      private_dns_zone_group {
    name                 = "private-dns-zone-group"
    private_dns_zone_ids = [azurerm_private_dns_zone.privatedns_blob.id]
  }
}

resource "azurerm_private_endpoint" "ai_storage_account_file_pe" {
  name                = "${azurerm_storage_account.ai_sa.name}-file-pe"
  location            = var.azure_location
  resource_group_name = module.private_rg.name
  subnet_id           = azurerm_subnet.storage_private_subnet.id

  private_service_connection {
    name                           = "${azurerm_storage_account.ai_sa.name}-file-pe"
    private_connection_resource_id = azurerm_storage_account.ai_sa.id
    subresource_names              = ["file"]
    is_manual_connection           = false
  }

      private_dns_zone_group {
    name                 = "private-dns-zone-group"
    private_dns_zone_ids = [azurerm_private_dns_zone.privatedns_file.id]
  }
}

resource "azurerm_private_endpoint" "cfrn_storage_account_blob_pe" {
  name                = "${azurerm_storage_account.cfrn_sa.name}-blob-pe"
  location            = var.azure_location
  resource_group_name = module.private_rg.name
  subnet_id           = azurerm_subnet.storage_private_subnet.id

  private_service_connection {
    name                           = "${azurerm_storage_account.cfrn_sa.name}-blob-pe"
    private_connection_resource_id = azurerm_storage_account.cfrn_sa.id
    subresource_names              = ["blob"]
    is_manual_connection           = false
  }

      private_dns_zone_group {
    name                 = "private-dns-zone-group"
    private_dns_zone_ids = [azurerm_private_dns_zone.privatedns_blob.id]
  }
}

resource "azurerm_private_endpoint" "cfrn_storage_account_file_pe" {
  name                = "${azurerm_storage_account.cfrn_sa.name}-file-pe"
  location            = var.azure_location
  resource_group_name = module.private_rg.name
  subnet_id           = azurerm_subnet.storage_private_subnet.id

  private_service_connection {
    name                           = "${azurerm_storage_account.cfrn_sa.name}-file-pe"
    private_connection_resource_id = azurerm_storage_account.cfrn_sa.id
    subresource_names              = ["file"]
    is_manual_connection           = false
  }

      private_dns_zone_group {
    name                 = "private-dns-zone-group"
    private_dns_zone_ids = [azurerm_private_dns_zone.privatedns_file.id]
  }
}
resource "azurerm_private_endpoint" "auth_storage_account_blob_pe" {
  name                = "${local.auth_storage_name}-blob-pe"
  location            = var.azure_location
  resource_group_name = module.private_rg.name
  subnet_id           = azurerm_subnet.storage_private_subnet.id

  private_service_connection {
  name                = "${local.auth_storage_name}-blob-pe"
    private_connection_resource_id = azurerm_storage_account.auth_storage_account.id
    subresource_names              = ["blob"]
    is_manual_connection           = false
  }

      private_dns_zone_group {
    name                 = "private-dns-zone-group"
    private_dns_zone_ids = [azurerm_private_dns_zone.privatedns_blob.id]
  }
}

resource "azurerm_private_endpoint" "auth_storage_account_file_pe" {
  name                = "${local.auth_storage_name}-file-pe"
  location            = var.azure_location
  resource_group_name = module.private_rg.name
  subnet_id           = azurerm_subnet.storage_private_subnet.id

  private_service_connection {
  name                = "${local.auth_storage_name}-file-pe"
    private_connection_resource_id = azurerm_storage_account.auth_storage_account.id
    subresource_names              = ["file"]
    is_manual_connection           = false
  }

      private_dns_zone_group {
    name                 = "private-dns-zone-group"
    private_dns_zone_ids = [azurerm_private_dns_zone.privatedns_file.id]
  }
}

#Uncomment to loop through all blob and file and add private endpoints
#resource "azurerm_private_endpoint" "blob_storage_pe" {
 # count = length(data.azurerm_resources.storage.resources)
 # name                = "${data.azurerm_resources.storage.resources[count.index].name}-blob-pe"
  #location            = var.azure_location
 # resource_group_name = module.private_rg.name
  #subnet_id           = azurerm_subnet.storage_private_subnet.id

 # private_service_connection {
  #  name                           = "${data.azurerm_resources.storage.resources[count.index].name}"
 #   private_connection_resource_id = "${data.azurerm_resources.storage.resources[count.index].id}"
  #  subresource_names              = ["blob"]
 #   is_manual_connection           = false
 # }

  #    private_dns_zone_group {
 #   name                 = "private-dns-zone-group"
  #  private_dns_zone_ids = [azurerm_private_dns_zone.privatedns_blob.id]
 # }
#}

#resource "azurerm_private_endpoint" "file_storage_pe" {
  #count = length(data.azurerm_resources.storage.resources)
  #name                = "${data.azurerm_resources.storage.resources[count.index].name}-file-pe"
  #location            = var.azure_location
  #resource_group_name = module.private_rg.name
 # subnet_id           = azurerm_subnet.storage_private_subnet.id

 # private_service_connection {
 #   name                           = "${data.azurerm_resources.storage.resources[count.index].name}"
 #   private_connection_resource_id = "${data.azurerm_resources.storage.resources[count.index].id}"
 #   subresource_names              = ["file"]
  #  is_manual_connection           = false
  #}

 #     private_dns_zone_group {
  #  name                 = "private-dns-zone-group"
 #   private_dns_zone_ids = [azurerm_private_dns_zone.privatedns_file.id]
 # }
#}

resource "azurerm_private_endpoint" "eventhub_pe" {
  name                = "${local.eventhub_namespace_name}-pe"
  location            = var.azure_location
  resource_group_name = module.private_rg.name
  subnet_id           = azurerm_subnet.Shared_private_subnet.id

  private_service_connection {
    name                           = "${local.eventhub_namespace_name}-pe"
    private_connection_resource_id = azurerm_eventhub_namespace.mul_eventhub_namespace.id
    subresource_names              = ["namespace"]
    is_manual_connection           = false
  }
      private_dns_zone_group {
    name                 = "private-dns-zone-group"
    private_dns_zone_ids = [azurerm_private_dns_zone.privatedns_service_bus.id]
  }
depends_on = [
  azurerm_eventhub_namespace.mul_eventhub_namespace
]
}

resource "azurerm_private_endpoint" "cosmos_gremlin_pe" {
  name                = "${local.cosmosdb_name}-gremlin-pe"
  location            = var.azure_location
  resource_group_name = module.private_rg.name
  subnet_id           = azurerm_subnet.Data_private_subnet.id

  private_service_connection {
    name                           = "${local.cosmosdb_name}-gremlin-pe"
    private_connection_resource_id = azurerm_cosmosdb_account.instance.id
    subresource_names              = ["Gremlin"]
    is_manual_connection           = false
  }
      private_dns_zone_group {
    name                 = "private-dns-zone-group"
    private_dns_zone_ids = [azurerm_private_dns_zone.privatedns_cosmosgremlin.id]
  }

}

resource "azurerm_private_endpoint" "cosmos_sql_pe" {
  name                = "${local.cosmosdb_name}-sql-pe"
  location            = var.azure_location
  resource_group_name = module.private_rg.name
  subnet_id           = azurerm_subnet.Data_private_subnet.id

  private_service_connection {
    name                           = "${local.cosmosdb_name}-sql-pe"
    private_connection_resource_id = azurerm_cosmosdb_account.instance.id
    subresource_names              = ["Sql"]
    is_manual_connection           = false
  }
      private_dns_zone_group {
    name                 = "private-dns-zone-group"
    private_dns_zone_ids = [azurerm_private_dns_zone.privatedns_cosmosdocument.id]
  }

}

resource "azurerm_private_endpoint" "dps_pe" {
  name                = "${local.mul_dps_name}-pe"
  location            = var.azure_location
  resource_group_name = module.private_rg.name
  subnet_id           = azurerm_subnet.Shared_private_subnet.id

  private_service_connection {
    name                           = "${local.mul_dps_name}-pe"
    private_connection_resource_id = azurerm_iothub_dps.mul_dps.id
    subresource_names              = ["iotDPs"]
    is_manual_connection           = false
  }
        private_dns_zone_group {
    name                 = "private-dns-zone-group"
    private_dns_zone_ids = [azurerm_private_dns_zone.privatedns_azuredevices_provisioning.id]
  }

}

resource "azurerm_private_endpoint" "webpubsub_pe" {
  name                = "${local.webpubsub_service_name}-pe"
  location            = var.azure_location
  resource_group_name = module.private_rg.name
  subnet_id           = azurerm_subnet.Shared_private_subnet.id

  private_service_connection {
    name                           = "${local.webpubsub_service_name}-pe"
    private_connection_resource_id = azurerm_web_pubsub.mul_webhubservice.id
    subresource_names              = ["webpubsub"]
    is_manual_connection           = false
  }
        private_dns_zone_group {
    name                 = "private-dns-zone-group"
    private_dns_zone_ids = [azurerm_private_dns_zone.privatedns_webpubsub.id]
  }
depends_on = [
  azurerm_web_pubsub.mul_webhubservice
]
}

resource "azurerm_private_endpoint" "redis_pe" {
  name                = "${local.redis_instance_name}-pe"
  location            = var.azure_location
  resource_group_name = module.private_rg.name
  subnet_id           = azurerm_subnet.Shared_private_subnet.id

 private_service_connection {
    name                           = "${local.redis_instance_name}-pe"
    private_connection_resource_id = azurerm_redis_enterprise_cluster.mul_redis_cluster.id
    subresource_names              = ["redisenterprise"]
   is_manual_connection           = false
  }
        private_dns_zone_group {
    name                 = "private-dns-zone-group"
   private_dns_zone_ids = [azurerm_private_dns_zone.privatedns_redisent.id]
 }

}

resource "azurerm_private_endpoint" "kusto_pe" {
  name                = "${local.kusto_name}-pe"
  location            = var.azure_location
  resource_group_name = module.private_rg.name
  subnet_id           = azurerm_subnet.Data_private_subnet.id

 private_service_connection {
    name                           = "${local.kusto_name}-pe"
    private_connection_resource_id = azurerm_kusto_cluster.kcluster.id
    subresource_names              = ["cluster"]
   is_manual_connection           = false
  }
        private_dns_zone_group {
    name                 = "private-dns-zone-group"
   private_dns_zone_ids = [azurerm_private_dns_zone.privatedns_kusto.id, azurerm_private_dns_zone.privatedns_blob.id, azurerm_private_dns_zone.privatedns_queue.id, azurerm_private_dns_zone.privatedns_table.id]
 }
depends_on = [
  azurerm_kusto_cluster.kcluster
]
}


