data "azurerm_resources" "private_VNET" {
  type = "Microsoft.Network/virtualNetworks"
  name = local.private_vnet_name
  resource_group_name = local.private_resource_group_name
  }

data "azurerm_subnet" "privatestoragesubnet" {
  name                 = "storage_private_subnet01"
  virtual_network_name = data.azurerm_resources.private_VNET.name
  resource_group_name = local.private_resource_group_name
}

data "azurerm_subnet" "privatefunctionssubnet" {
  name                 = "func_private_subnet01"
  virtual_network_name = data.azurerm_resources.private_VNET.name
  resource_group_name = local.private_resource_group_name
}

data "azurerm_subnet" "privatedatasubnet" {
  name                 = "data_private_subnet01"
  virtual_network_name = data.azurerm_resources.private_VNET.name
  resource_group_name = local.private_resource_group_name
}

data "azurerm_subnet" "privatesharedsubnet" {
  name                 = "shared_private_subnet01"
  virtual_network_name = data.azurerm_resources.private_VNET.name
  resource_group_name = local.private_resource_group_name
}

data "azurerm_private_dns_zone" "azurewebsites" {
  name                = "privatelink.azurewebsites.net"
  resource_group_name = local.private_resource_group_name
}


data "azurerm_resources" "functions" {
  type = "Microsoft.Web/sites"

}


data "azurerm_resources" "storage" {
  type = "Microsoft.Storage/storageAccounts"

}

data "azurerm_resources" "eventhub" {
  type = "Microsoft.EventHub/namespaces"

}

data "azurerm_resources" "cosmosdb" {
  type = "Microsoft.DocumentDB/databaseAccounts"

}

data "azurerm_resources" "IotHubs" {
  type = "Microsoft.Devices/IotHubs"

}

data "azurerm_resources" "dps" {
  type = "Microsoft.Devices/ProvisioningServices"

}

data "azurerm_resources" "webpubsub" {
  type = "Microsoft.SignalRService/WebPubSub"

}

data "azurerm_resources" "redis" {
  type = "Microsoft.Cache/redisEnterprise"

}

data "azurerm_private_dns_zone" "web" {
  name                = "privatelink.azurewebsites.net"
}

data "azurerm_private_dns_zone" "blob" {
  name                = "privatelink.blob.core.windows.net"
}

data "azurerm_private_dns_zone" "file" {
  name                = "privatelink.file.core.windows.net"
}

data "azurerm_private_dns_zone" "staticweb" {
  name                = "privatelink.web.core.windows.net"
}

data "azurerm_private_dns_zone" "eventhub" {
  name                = "privatelink.eventgrid.azure.net"
}

data "azurerm_private_dns_zone" "table" {
  name                = "privatelink.table.core.windows.net"
}

data "azurerm_private_dns_zone" "cosmosdocument" {
  name                = "privatelink.documents.azure.com"
}

data "azurerm_private_dns_zone" "cosmosgremlin" {
  name                = "privatelink.gremlin.cosmos.azure.com"
}

data "azurerm_private_dns_zone" "cosmosmongo" {
  name                = "privatelink.mongo.cosmos.azure.com"
}

data "azurerm_private_dns_zone" "webpubsub" {
  name                = "privatelink.webpubsub.azure.com"
}

data "azurerm_private_dns_zone" "redis" {
  name                = "privatelink.redisenterprise.cache.azure.net"
}

data "azurerm_private_dns_zone" "iothub1" {
  name                = "privatelink.azure-devices.net"
}

data "azurerm_private_dns_zone" "iothub2" {
  name                = "privatelink.servicebus.windows.net"
}

data "azurerm_private_dns_zone" "dps" {
  name                = "privatelink.azure-devices-provisioning.net"
}

resource "azurerm_private_endpoint" "functions_pe" {
  count = length(data.azurerm_resources.functions.resources)
  name                = "${data.azurerm_resources.functions.resources[count.index].name}-pe"
  location            = var.azure_location
  resource_group_name = local.private_resource_group_name
  subnet_id           = data.azurerm_subnet.privatefunctionssubnet.id

  private_service_connection {
    name                           = "${data.azurerm_resources.functions.resources[count.index].name}"
    private_connection_resource_id = "${data.azurerm_resources.functions.resources[count.index].id}"
    subresource_names              = ["sites"]
    is_manual_connection           = false
  }
    private_dns_zone_group {
    name                 = "private-dns-zone-group"
    private_dns_zone_ids = [data.azurerm_private_dns_zone.web.id]
  }

}

resource "azurerm_private_endpoint" "blob_storage_pe" {
  count = length(data.azurerm_resources.storage.resources)
  name                = "${data.azurerm_resources.storage.resources[count.index].name}-blob-pe"
  location            = var.azure_location
  resource_group_name = local.private_resource_group_name
  subnet_id           = data.azurerm_subnet.privatestoragesubnet.id

  private_service_connection {
    name                           = "${data.azurerm_resources.storage.resources[count.index].name}"
    private_connection_resource_id = "${data.azurerm_resources.storage.resources[count.index].id}"
    subresource_names              = ["blob"]
    is_manual_connection           = false
  }

      private_dns_zone_group {
    name                 = "private-dns-zone-group"
    private_dns_zone_ids = [data.azurerm_private_dns_zone.blob.id]
  }


}

resource "azurerm_private_endpoint" "file_storage_pe" {
  count = length(data.azurerm_resources.storage.resources)
  name                = "${data.azurerm_resources.storage.resources[count.index].name}-file-pe"
  location            = var.azure_location
  resource_group_name = local.private_resource_group_name
  subnet_id           = data.azurerm_subnet.privatestoragesubnet.id

  private_service_connection {
    name                           = "${data.azurerm_resources.storage.resources[count.index].name}"
    private_connection_resource_id = "${data.azurerm_resources.storage.resources[count.index].id}"
    subresource_names              = ["file"]
    is_manual_connection           = false
  }

      private_dns_zone_group {
    name                 = "private-dns-zone-group"
    private_dns_zone_ids = [data.azurerm_private_dns_zone.file.id]
  }

}

resource "azurerm_private_endpoint" "eventhub_pe" {
  count = length(data.azurerm_resources.eventhub.resources)
  name                = "${data.azurerm_resources.eventhub.resources[count.index].name}-pe"
  location            = var.azure_location
  resource_group_name = local.private_resource_group_name
  subnet_id           = data.azurerm_subnet.privatesharedsubnet.id

  private_service_connection {
    name                           = "${data.azurerm_resources.eventhub.resources[count.index].name}"
    private_connection_resource_id = "${data.azurerm_resources.eventhub.resources[count.index].id}"
    subresource_names              = ["namespace"]
    is_manual_connection           = false
  }
      private_dns_zone_group {
    name                 = "private-dns-zone-group"
    private_dns_zone_ids = [data.azurerm_private_dns_zone.eventhub.id]
  }

}

resource "azurerm_private_endpoint" "cosmos_pe1" {
  count = length(data.azurerm_resources.cosmosdb.resources)
  name                = "${data.azurerm_resources.cosmosdb.resources[count.index].name}-pe"
  location            = var.azure_location
  resource_group_name = local.private_resource_group_name
  subnet_id           = data.azurerm_subnet.privatedatasubnet.id

  private_service_connection {
    name                           = "${data.azurerm_resources.cosmosdb.resources[count.index].name}"
    private_connection_resource_id = "${data.azurerm_resources.cosmosdb.resources[count.index].id}"
    subresource_names              = ["mongodb"]
    is_manual_connection           = false
  }
      private_dns_zone_group {
    name                 = "private-dns-zone-group"
    private_dns_zone_ids = [data.azurerm_private_dns_zone.cosmosmongo.id]
  }

}

resource "azurerm_private_endpoint" "cosmos_pe2" {
  count = length(data.azurerm_resources.cosmosdb.resources)
  name                = "${data.azurerm_resources.cosmosdb.resources[count.index].name}-pe"
  location            = var.azure_location
  resource_group_name = local.private_resource_group_name
  subnet_id           = data.azurerm_subnet.privatedatasubnet.id

  private_service_connection {
    name                           = "${data.azurerm_resources.cosmosdb.resources[count.index].name}"
    private_connection_resource_id = "${data.azurerm_resources.cosmosdb.resources[count.index].id}"
    subresource_names              = ["sql"]
    is_manual_connection           = false
  }
      private_dns_zone_group {
    name                 = "private-dns-zone-group"
    private_dns_zone_ids = [data.azurerm_private_dns_zone.cosmosdocument.id]
  }

}

resource "azurerm_private_endpoint" "cosmos_pe3" {
  count = length(data.azurerm_resources.cosmosdb.resources)
  name                = "${data.azurerm_resources.cosmosdb.resources[count.index].name}-pe"
  location            = var.azure_location
  resource_group_name = local.private_resource_group_name
  subnet_id           = data.azurerm_subnet.privatedatasubnet.id

  private_service_connection {
    name                           = "${data.azurerm_resources.cosmosdb.resources[count.index].name}"
    private_connection_resource_id = "${data.azurerm_resources.cosmosdb.resources[count.index].id}"
    subresource_names              = ["gremlin"]
    is_manual_connection           = false
  }
      private_dns_zone_group {
    name                 = "private-dns-zone-group"
    private_dns_zone_ids = [data.azurerm_private_dns_zone.cosmosgremlin.id]
  }

}

resource "azurerm_private_endpoint" "Iothub_pe" {
  count = length(data.azurerm_resources.IotHubs.resources)
  name                = "${data.azurerm_resources.IotHubs.resources[count.index].name}-pe"
  location            = var.azure_location
  resource_group_name = local.private_resource_group_name
  subnet_id           = data.azurerm_subnet.privatesharedsubnet.id

  private_service_connection {
    name                           = "${data.azurerm_resources.IotHubs.resources[count.index].name}"
    private_connection_resource_id = "${data.azurerm_resources.IotHubs.resources[count.index].id}"
    subresource_names              = ["iotHub"]
    is_manual_connection           = false
  }
        private_dns_zone_group {
    name                 = "private-dns-zone-group"
    private_dns_zone_ids = [data.azurerm_private_dns_zone.iothub1.id]
  }


}
resource "azurerm_private_endpoint" "dps_pe" {
  count = length(data.azurerm_resources.dps.resources)
  name                = "${data.azurerm_resources.dps.resources[count.index].name}-pe"
  location            = var.azure_location
  resource_group_name = local.private_resource_group_name
  subnet_id           = data.azurerm_subnet.privatesharedsubnet.id

  private_service_connection {
    name                           = "${data.azurerm_resources.dps.resources[count.index].name}"
    private_connection_resource_id = "${data.azurerm_resources.dps.resources[count.index].id}"
    subresource_names              = ["iotDPs"]
    is_manual_connection           = false
  }
        private_dns_zone_group {
    name                 = "private-dns-zone-group"
    private_dns_zone_ids = [data.azurerm_private_dns_zone.dps.id]
  }

}

resource "azurerm_private_endpoint" "webpubsub_pe" {
  count = length(data.azurerm_resources.webpubsub.resources)
  name                = "${data.azurerm_resources.webpubsub.resources[count.index].name}-pe"
  location            = var.azure_location
  resource_group_name = local.private_resource_group_name
  subnet_id           = data.azurerm_subnet.privatesharedsubnet.id

  private_service_connection {
    name                           = "${data.azurerm_resources.webpubsub.resources[count.index].name}"
    private_connection_resource_id = "${data.azurerm_resources.webpubsub.resources[count.index].id}"
    subresource_names              = ["webpubsub"]
    is_manual_connection           = false
  }
        private_dns_zone_group {
    name                 = "private-dns-zone-group"
    private_dns_zone_ids = [data.azurerm_private_dns_zone.webpubsub.id]
  }

}

resource "azurerm_private_endpoint" "redis_pe" {
  count = length(data.azurerm_resources.redis.resources)
  name                = "${data.azurerm_resources.redis.resources[count.index].name}-pe"
  location            = var.azure_location
  resource_group_name = local.private_resource_group_name
  subnet_id           = data.azurerm_subnet.privatesharedsubnet.id

  private_service_connection {
    name                           = "${data.azurerm_resources.redis.resources[count.index].name}"
    private_connection_resource_id = "${data.azurerm_resources.redis.resources[count.index].id}"
    subresource_names              = ["redisenterprise"]
    is_manual_connection           = false
  }
        private_dns_zone_group {
    name                 = "private-dns-zone-group"
    private_dns_zone_ids = [data.azurerm_private_dns_zone.redis.id]
  }

}
