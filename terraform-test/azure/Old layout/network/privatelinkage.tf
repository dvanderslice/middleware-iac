# -------------------------------------------------------------------------------------------------
# Create the network for private links
module "private_rg" {
  source = "../modules/rg"

  azure_location      = var.azure_location
  resource_group_name = local.private_resource_group_name

  tags = merge(local.resource_tags, {
    "environment" = var.env_name
    "role"        = "privateconnectivity"
    "createdon"   = local.tag_createdon
  })
}

resource "azurerm_virtual_network" "private_vnet" {
  name                = local.private_vnet_name
  address_space       = [module.vnet_addrs.networks[3].cidr_block]
  location            = var.azure_location
  resource_group_name = module.private_rg.name

  lifecycle {
    ignore_changes = [
      tags["createdon"],
    ]
  }

  tags = merge(local.resource_tags, {
    "environment" = var.env_name
    "role"        = "networking"
    "createdon"   = local.tag_createdon
  })
}

module "private_subnet_addrs" {
  source = "../modules/cidr-subnets"

  base_cidr_block = module.vnet_addrs.networks[3].cidr_block
  networks = [
   # {
    #  name     = "reserved"
    #  new_bits = 8
   # },
    {
      name     = "Storage_private_subnet01"
      new_bits = 2
    },
        {
      name     = "Data_private_subnet01"
      new_bits = 2
    },
        {
      name     = "Shared_private_subnet01"
      new_bits = 2
    },
      {
      name     = "Func_private_subnet01"
      new_bits = 2
    },
  ]
}

resource "azurerm_subnet" "storage_private_subnet" {
  name                 = "Storage_private_subnet01"
  resource_group_name  = module.private_rg.name
  virtual_network_name = azurerm_virtual_network.private_vnet.name
  address_prefixes     = [module.private_subnet_addrs.networks[0].cidr_block]
  enforce_private_link_endpoint_network_policies = true
}

resource "azurerm_subnet" "Data_private_subnet" {
  name                 = "Data_private_subnet01"
  resource_group_name  = module.private_rg.name
  virtual_network_name = azurerm_virtual_network.private_vnet.name
  address_prefixes     = [module.private_subnet_addrs.networks[1].cidr_block]
  enforce_private_link_endpoint_network_policies = true
}
resource "azurerm_subnet" "Shared_private_subnet" {
  name                 = "Shared_private_subnet01"
  resource_group_name  = module.private_rg.name
  virtual_network_name = azurerm_virtual_network.private_vnet.name
  address_prefixes     = [module.private_subnet_addrs.networks[2].cidr_block]
  enforce_private_link_endpoint_network_policies = true
}

resource "azurerm_subnet" "Func_private_subnet" {
  name                 = "Func_private_subnet01"
  resource_group_name  = module.private_rg.name
  virtual_network_name = azurerm_virtual_network.private_vnet.name
  address_prefixes     = [module.private_subnet_addrs.networks[3].cidr_block]
  enforce_private_link_endpoint_network_policies = true
}

##Create Private DNS Zones, all PaaS resources will use these Zones to resolve the private endpoints##
resource "azurerm_private_dns_zone" "privatedns_asp" {
  name                = "privatelink.azurewebsites.net"
  resource_group_name = module.private_rg.name
}

resource "azurerm_private_dns_zone" "privatedns_blob" {
  name                = "privatelink.blob.core.windows.net"
  resource_group_name = module.private_rg.name
}

resource "azurerm_private_dns_zone" "privatedns_file" {
  name                = "privatelink.file.core.windows.net"
  resource_group_name = module.private_rg.name
}

resource "azurerm_private_dns_zone" "privatedns_staticweb" {
  name                = "privatelink.web.core.windows.net"
  resource_group_name = module.private_rg.name
}

resource "azurerm_private_dns_zone" "privatedns_eventgrid" {
  name                = "privatelink.eventgrid.azure.net"
  resource_group_name = module.private_rg.name
}

resource "azurerm_private_dns_zone" "privatedns_table" {
  name                = "privatelink.table.core.windows.net"
  resource_group_name = module.private_rg.name
}

resource "azurerm_private_dns_zone" "privatedns_cosmosdocument" {
  name                = "privatelink.documents.azure.com"
  resource_group_name = module.private_rg.name
}

resource "azurerm_private_dns_zone" "privatedns_cosmosgremlin" {
  name                = "privatelink.gremlin.cosmos.azure.com"
  resource_group_name = module.private_rg.name
}

resource "azurerm_private_dns_zone" "privatedns_cosmosmongo" {
  name                = "privatelink.mongo.cosmos.azure.com"
  resource_group_name = module.private_rg.name
}

resource "azurerm_private_dns_zone" "privatedns_webpubsub" {
  name                = "privatelink.webpubsub.azure.com"
  resource_group_name = module.private_rg.name
}

resource "azurerm_private_dns_zone" "privatedns_redisent" {
  name                = "privatelink.redisenterprise.cache.azure.net"
  resource_group_name = module.private_rg.name
}

resource "azurerm_private_dns_zone" "privatedns_azuredevices" {
  name                = "privatelink.azure-devices.net"
  resource_group_name = module.private_rg.name
}

resource "azurerm_private_dns_zone" "privatedns_service_bus" {
  name                = "privatelink.servicebus.windows.net"
  resource_group_name = module.private_rg.name
}

resource "azurerm_private_dns_zone" "privatedns_azuredevices_provisioning" {
  name                = "privatelink.azure-devices-provisioning.net"
  resource_group_name = module.private_rg.name
}

resource "azurerm_private_dns_zone" "privatedns_kusto" {
  name                = "privatelink.eastus2.kusto.windows.net"
  resource_group_name = module.private_rg.name
}

resource "azurerm_private_dns_zone" "privatedns_queue" {
  name                = "privatelink.queue.core.windows.net"
  resource_group_name = module.private_rg.name
}

resource "azurerm_private_dns_zone" "privatedns_dfs" {
  name                = "privatelink.dfs.core.windows.nett"
  resource_group_name = module.private_rg.name
}
##Linking VNETs to Private DNS Zones to allow resolution

resource "azurerm_private_dns_zone_virtual_network_link" "function-link-to-pri-dns" {
  name                  = "function-link-to-pri-dns"
  resource_group_name   = module.private_rg.name
  private_dns_zone_name = azurerm_private_dns_zone.privatedns_asp.name
  virtual_network_id    = azurerm_virtual_network.private_vnet.id
}
resource "azurerm_private_dns_zone_virtual_network_link" "function-link-to-mul-dns" {
  name                  = "function-link-to-mul-dns"
  resource_group_name   = module.private_rg.name
  private_dns_zone_name = azurerm_private_dns_zone.privatedns_asp.name
  virtual_network_id    = azurerm_virtual_network.mul_vnet.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "function-link-to-auth-dns" {
  name                  = "function-link-to-auth-dns"
  resource_group_name   = module.private_rg.name
  private_dns_zone_name = azurerm_private_dns_zone.privatedns_asp.name
  virtual_network_id    = azurerm_virtual_network.auth_vnet.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "function-link-to-shared-dns" {
  name                  = "function-link-to-shared-dns"
  resource_group_name   = module.private_rg.name
  private_dns_zone_name = azurerm_private_dns_zone.privatedns_asp.name
  virtual_network_id    = azurerm_virtual_network.shared_vnet.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "blob-link-to-pri-dns" {
  name                  = "blob-link-to-pri-dns"
  resource_group_name   = module.private_rg.name
  private_dns_zone_name = azurerm_private_dns_zone.privatedns_blob.name
  virtual_network_id    = azurerm_virtual_network.private_vnet.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "blob-link-to-mul-dns" {
  name                  = "blob-link-to-mul-dns"
  resource_group_name   = module.private_rg.name
  private_dns_zone_name = azurerm_private_dns_zone.privatedns_blob.name
  virtual_network_id    = azurerm_virtual_network.mul_vnet.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "blob-link-to-shared-dns" {
  name                  = "blob-link-to-shared-dns"
  resource_group_name   = module.private_rg.name
  private_dns_zone_name = azurerm_private_dns_zone.privatedns_blob.name
  virtual_network_id    = azurerm_virtual_network.shared_vnet.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "blob-link-to-auth-dns" {
  name                  = "blob-link-to-auth-dns"
  resource_group_name   = module.private_rg.name
  private_dns_zone_name = azurerm_private_dns_zone.privatedns_blob.name
  virtual_network_id    = azurerm_virtual_network.auth_vnet.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "file-link-to-pri-dns" {
  name                  = "file-link-to-pri-dns"
  resource_group_name   = module.private_rg.name
  private_dns_zone_name = azurerm_private_dns_zone.privatedns_file.name
  virtual_network_id    = azurerm_virtual_network.private_vnet.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "file-link-to-mul-dns" {
  name                  = "file-link-to-mul-dns"
  resource_group_name   = module.private_rg.name
  private_dns_zone_name = azurerm_private_dns_zone.privatedns_file.name
  virtual_network_id    = azurerm_virtual_network.mul_vnet.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "file-link-to-auth-dns" {
  name                  = "file-link-to-auth-dns"
  resource_group_name   = module.private_rg.name
  private_dns_zone_name = azurerm_private_dns_zone.privatedns_file.name
  virtual_network_id    = azurerm_virtual_network.auth_vnet.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "file-link-to-shared-dns" {
  name                  = "file-link-to-shared-dns"
  resource_group_name   = module.private_rg.name
  private_dns_zone_name = azurerm_private_dns_zone.privatedns_file.name
  virtual_network_id    = azurerm_virtual_network.shared_vnet.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "staticweb-link-to-pri-dns" {
  name                  = "staticweb-link-to-pri-dns"
  resource_group_name   = module.private_rg.name
  private_dns_zone_name = azurerm_private_dns_zone.privatedns_staticweb.name
  virtual_network_id    = azurerm_virtual_network.private_vnet.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "staticweb-link-to-mul-dns" {
  name                  = "staticweb-link-to-mul-dns"
  resource_group_name   = module.private_rg.name
  private_dns_zone_name = azurerm_private_dns_zone.privatedns_staticweb.name
  virtual_network_id    = azurerm_virtual_network.mul_vnet.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "staticweb-link-to-auth-dns" {
  name                  = "staticweb-link-to-auth-dns"
  resource_group_name   = module.private_rg.name
  private_dns_zone_name = azurerm_private_dns_zone.privatedns_staticweb.name
  virtual_network_id    = azurerm_virtual_network.auth_vnet.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "staticweb-link-to-shared-dns" {
  name                  = "staticweb-link-to-shared-dns"
  resource_group_name   = module.private_rg.name
  private_dns_zone_name = azurerm_private_dns_zone.privatedns_staticweb.name
  virtual_network_id    = azurerm_virtual_network.shared_vnet.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "eventgrid-link-to-pri-dns" {
  name                  = "eventgrid-link-to-pri-dns"
  resource_group_name   = module.private_rg.name
  private_dns_zone_name = azurerm_private_dns_zone.privatedns_eventgrid.name
  virtual_network_id    = azurerm_virtual_network.private_vnet.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "eventgrid-link-to-mul-dns" {
  name                  = "eventgrid-link-to-mul-dns"
  resource_group_name   = module.private_rg.name
  private_dns_zone_name = azurerm_private_dns_zone.privatedns_eventgrid.name
  virtual_network_id    = azurerm_virtual_network.mul_vnet.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "eventgrid-link-to-auth-dns" {
  name                  = "eventgrid-link-to-auth-dns"
  resource_group_name   = module.private_rg.name
  private_dns_zone_name = azurerm_private_dns_zone.privatedns_eventgrid.name
  virtual_network_id    = azurerm_virtual_network.auth_vnet.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "eventgrid-link-to-shared-dns" {
  name                  = "eventgrid-link-to-shared-dns"
  resource_group_name   = module.private_rg.name
  private_dns_zone_name = azurerm_private_dns_zone.privatedns_eventgrid.name
  virtual_network_id    = azurerm_virtual_network.shared_vnet.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "cosmosdocument-link-to-pri-dns" {
  name                  = "cosmosdocument-link-to-pri-dns"
  resource_group_name   = module.private_rg.name
  private_dns_zone_name = azurerm_private_dns_zone.privatedns_cosmosdocument.name
  virtual_network_id    = azurerm_virtual_network.private_vnet.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "cosmosdocument-link-to-mul-dns" {
  name                  = "cosmosdocument-link-to-mul-dns"
  resource_group_name   = module.private_rg.name
  private_dns_zone_name = azurerm_private_dns_zone.privatedns_cosmosdocument.name
  virtual_network_id    = azurerm_virtual_network.mul_vnet.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "cosmosdocument-link-to-auth-dns" {
  name                  = "cosmosdocument-link-to-auth-dns"
  resource_group_name   = module.private_rg.name
  private_dns_zone_name = azurerm_private_dns_zone.privatedns_cosmosdocument.name
  virtual_network_id    = azurerm_virtual_network.auth_vnet.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "cosmosdocument-link-to-shared-dns" {
  name                  = "cosmosdocument-link-to-shared-dns"
  resource_group_name   = module.private_rg.name
  private_dns_zone_name = azurerm_private_dns_zone.privatedns_cosmosdocument.name
  virtual_network_id    = azurerm_virtual_network.shared_vnet.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "table-link-to-pri-dns" {
  name                  = "table-link-to-pri-dns"
  resource_group_name   = module.private_rg.name
  private_dns_zone_name = azurerm_private_dns_zone.privatedns_table.name
  virtual_network_id    = azurerm_virtual_network.private_vnet.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "table-link-to-mul-dns" {
  name                  = "table-link-to-mul-dns"
  resource_group_name   = module.private_rg.name
  private_dns_zone_name = azurerm_private_dns_zone.privatedns_table.name
  virtual_network_id    = azurerm_virtual_network.mul_vnet.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "table-link-to-auth-dns" {
  name                  = "table-link-to-auth-dns"
  resource_group_name   = module.private_rg.name
  private_dns_zone_name = azurerm_private_dns_zone.privatedns_table.name
  virtual_network_id    = azurerm_virtual_network.auth_vnet.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "table-link-to-shared-dns" {
  name                  = "table-link-to-shared-dns"
  resource_group_name   = module.private_rg.name
  private_dns_zone_name = azurerm_private_dns_zone.privatedns_table.name
  virtual_network_id    = azurerm_virtual_network.shared_vnet.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "cosmosgremlin-link-to-pri-dns" {
  name                  = "cosmosgremlinlink-to-pri-dns"
  resource_group_name   = module.private_rg.name
  private_dns_zone_name = azurerm_private_dns_zone.privatedns_cosmosgremlin.name
  virtual_network_id    = azurerm_virtual_network.private_vnet.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "cosmosgremlin-link-to-mul-dns" {
  name                  = "cosmosgremlinlink-to-mul-dns"
  resource_group_name   = module.private_rg.name
  private_dns_zone_name = azurerm_private_dns_zone.privatedns_cosmosgremlin.name
  virtual_network_id    = azurerm_virtual_network.mul_vnet.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "cosmosgremlin-link-to-auth-dns" {
  name                  = "cosmosgremlinlink-to-auth-dns"
  resource_group_name   = module.private_rg.name
  private_dns_zone_name = azurerm_private_dns_zone.privatedns_cosmosgremlin.name
  virtual_network_id    = azurerm_virtual_network.auth_vnet.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "cosmosgremlin-link-to-shared-dns" {
  name                  = "cosmosgremlinlink-to-shared-dns"
  resource_group_name   = module.private_rg.name
  private_dns_zone_name = azurerm_private_dns_zone.privatedns_cosmosgremlin.name
  virtual_network_id    = azurerm_virtual_network.shared_vnet.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "cosmosmongo-link-to-pri-dns" {
  name                  = "cosmosmongo-to-pri-dns"
  resource_group_name   = module.private_rg.name
  private_dns_zone_name = azurerm_private_dns_zone.privatedns_cosmosmongo.name
  virtual_network_id    = azurerm_virtual_network.private_vnet.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "cosmosmongo-link-to-mul-dns" {
  name                  = "cosmosmongo-to-mul-dns"
  resource_group_name   = module.private_rg.name
  private_dns_zone_name = azurerm_private_dns_zone.privatedns_cosmosmongo.name
  virtual_network_id    = azurerm_virtual_network.mul_vnet.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "cosmosmongo-link-to-auth-dns" {
  name                  = "cosmosmongo-to-auth-dns"
  resource_group_name   = module.private_rg.name
  private_dns_zone_name = azurerm_private_dns_zone.privatedns_cosmosmongo.name
  virtual_network_id    = azurerm_virtual_network.auth_vnet.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "cosmosmongo-link-to-shared-dns" {
  name                  = "cosmosmongo-to-shared-dns"
  resource_group_name   = module.private_rg.name
  private_dns_zone_name = azurerm_private_dns_zone.privatedns_cosmosmongo.name
  virtual_network_id    = azurerm_virtual_network.shared_vnet.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "webpubsub-link-to-pri-dns" {
  name                  = "webpubsub-to-pri-dns"
  resource_group_name   = module.private_rg.name
  private_dns_zone_name = azurerm_private_dns_zone.privatedns_webpubsub.name
  virtual_network_id    = azurerm_virtual_network.private_vnet.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "webpubsub-link-to-mul-dns" {
  name                  = "webpubsub-to-mul-dns"
  resource_group_name   = module.private_rg.name
  private_dns_zone_name = azurerm_private_dns_zone.privatedns_webpubsub.name
  virtual_network_id    = azurerm_virtual_network.mul_vnet.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "webpubsub-link-to-auth-dns" {
  name                  = "webpubsub-to-auth-dns"
  resource_group_name   = module.private_rg.name
  private_dns_zone_name = azurerm_private_dns_zone.privatedns_webpubsub.name
  virtual_network_id    = azurerm_virtual_network.auth_vnet.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "webpubsub-link-to-shared-dns" {
  name                  = "webpubsub-to-shared-dns"
  resource_group_name   = module.private_rg.name
  private_dns_zone_name = azurerm_private_dns_zone.privatedns_webpubsub.name
  virtual_network_id    = azurerm_virtual_network.shared_vnet.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "redisent-link-to-pri-dns" {
  name                  = "redisent-to-pri-dns"
  resource_group_name   = module.private_rg.name
  private_dns_zone_name = azurerm_private_dns_zone.privatedns_redisent.name
  virtual_network_id    = azurerm_virtual_network.private_vnet.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "redisent-link-to-mul-dns" {
  name                  = "redisent-to-mul-dns"
  resource_group_name   = module.private_rg.name
  private_dns_zone_name = azurerm_private_dns_zone.privatedns_redisent.name
  virtual_network_id    = azurerm_virtual_network.mul_vnet.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "redisent-link-to-auth-dns" {
  name                  = "redisent-to-auth-dns"
  resource_group_name   = module.private_rg.name
  private_dns_zone_name = azurerm_private_dns_zone.privatedns_redisent.name
  virtual_network_id    = azurerm_virtual_network.auth_vnet.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "redisent-link-to-shared-dns" {
  name                  = "redisent-to-shared-dns"
  resource_group_name   = module.private_rg.name
  private_dns_zone_name = azurerm_private_dns_zone.privatedns_redisent.name
  virtual_network_id    = azurerm_virtual_network.shared_vnet.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "azuredevices-link-to-pri-dns" {
  name                  = "devices-to-pri-dns"
  resource_group_name   = module.private_rg.name
  private_dns_zone_name = azurerm_private_dns_zone.privatedns_azuredevices.name
  virtual_network_id    = azurerm_virtual_network.private_vnet.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "azuredevices-link-to-mul-dns" {
  name                  = "devices-to-mul-dns"
  resource_group_name   = module.private_rg.name
  private_dns_zone_name = azurerm_private_dns_zone.privatedns_azuredevices.name
  virtual_network_id    = azurerm_virtual_network.mul_vnet.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "azuredevices-link-to-auth-dns" {
  name                  = "devices-to-auth-dns"
  resource_group_name   = module.private_rg.name
  private_dns_zone_name = azurerm_private_dns_zone.privatedns_azuredevices.name
  virtual_network_id    = azurerm_virtual_network.auth_vnet.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "azuredevices-link-to-shared-dns" {
  name                  = "devices-to-shared-dns"
  resource_group_name   = module.private_rg.name
  private_dns_zone_name = azurerm_private_dns_zone.privatedns_azuredevices.name
  virtual_network_id    = azurerm_virtual_network.shared_vnet.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "sb-link-to-pri-dns" {
  name                  = "sblink-to-pri-dns"
  resource_group_name   = module.private_rg.name
  private_dns_zone_name = azurerm_private_dns_zone.privatedns_service_bus.name
  virtual_network_id    = azurerm_virtual_network.private_vnet.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "sb-link-to-mul-dns" {
  name                  = "sblink-to-mul-dns"
  resource_group_name   = module.private_rg.name
  private_dns_zone_name = azurerm_private_dns_zone.privatedns_service_bus.name
  virtual_network_id    = azurerm_virtual_network.mul_vnet.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "sb-link-to-auth-dns" {
  name                  = "sblink-to-auth-dns"
  resource_group_name   = module.private_rg.name
  private_dns_zone_name = azurerm_private_dns_zone.privatedns_service_bus.name
  virtual_network_id    = azurerm_virtual_network.auth_vnet.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "sb-link-to-shared-dns" {
  name                  = "sblink-to-shared-dns"
  resource_group_name   = module.private_rg.name
  private_dns_zone_name = azurerm_private_dns_zone.privatedns_service_bus.name
  virtual_network_id    = azurerm_virtual_network.shared_vnet.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "dps-link-to-pri-dns" {
  name                  = "dps-to-pri-dns"
  resource_group_name   = module.private_rg.name
  private_dns_zone_name = azurerm_private_dns_zone.privatedns_azuredevices_provisioning.name
  virtual_network_id    = azurerm_virtual_network.private_vnet.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "dps-link-to-mul-dns" {
  name                  = "dps-to-mul-dns"
  resource_group_name   = module.private_rg.name
  private_dns_zone_name = azurerm_private_dns_zone.privatedns_azuredevices_provisioning.name
  virtual_network_id    = azurerm_virtual_network.mul_vnet.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "dps-link-to-auth-dns" {
  name                  = "dps-to-auth-dns"
  resource_group_name   = module.private_rg.name
  private_dns_zone_name = azurerm_private_dns_zone.privatedns_azuredevices_provisioning.name
  virtual_network_id    = azurerm_virtual_network.auth_vnet.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "dps-link-to-shared-dns" {
  name                  = "dps-to-shared-dns"
  resource_group_name   = module.private_rg.name
  private_dns_zone_name = azurerm_private_dns_zone.privatedns_azuredevices_provisioning.name
  virtual_network_id    = azurerm_virtual_network.shared_vnet.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "kusto-link-to-pri-dns" {
  name                  = "kusto-to-pri-dns"
  resource_group_name   = module.private_rg.name
  private_dns_zone_name = azurerm_private_dns_zone.privatedns_kusto.name
  virtual_network_id    = azurerm_virtual_network.private_vnet.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "kusto-link-to-mul-dns" {
  name                  = "kusto-to-mul-dns"
  resource_group_name   = module.private_rg.name
  private_dns_zone_name = azurerm_private_dns_zone.privatedns_kusto.name
  virtual_network_id    = azurerm_virtual_network.mul_vnet.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "kusto-link-to-auth-dns" {
  name                  = "kusto-to-auth-dns"
  resource_group_name   = module.private_rg.name
  private_dns_zone_name = azurerm_private_dns_zone.privatedns_kusto.name
  virtual_network_id    = azurerm_virtual_network.auth_vnet.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "kusto-link-to-shared-dns" {
  name                  = "kusto-to-shared-dns"
  resource_group_name   = module.private_rg.name
  private_dns_zone_name = azurerm_private_dns_zone.privatedns_kusto.name
  virtual_network_id    = azurerm_virtual_network.shared_vnet.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "queue-link-to-pri-dns" {
  name                  = "queue-to-pri-dns"
  resource_group_name   = module.private_rg.name
  private_dns_zone_name = azurerm_private_dns_zone.privatedns_queue.name
  virtual_network_id    = azurerm_virtual_network.private_vnet.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "queue-link-to-mul-dns" {
  name                  = "queue-to-mul-dns"
  resource_group_name   = module.private_rg.name
  private_dns_zone_name = azurerm_private_dns_zone.privatedns_queue.name
  virtual_network_id    = azurerm_virtual_network.mul_vnet.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "queue-link-to-auth-dns" {
  name                  = "queue-to-auth-dns"
  resource_group_name   = module.private_rg.name
  private_dns_zone_name = azurerm_private_dns_zone.privatedns_queue.name
  virtual_network_id    = azurerm_virtual_network.auth_vnet.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "queue-link-to-shared-dns" {
  name                  = "queue-to-shared-dns"
  resource_group_name   = module.private_rg.name
  private_dns_zone_name = azurerm_private_dns_zone.privatedns_queue.name
  virtual_network_id    = azurerm_virtual_network.shared_vnet.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "dfs-link-to-pri-dns" {
  name                  = "dfs-to-pri-dns"
  resource_group_name   = module.private_rg.name
  private_dns_zone_name = azurerm_private_dns_zone.privatedns_dfs.name
  virtual_network_id    = azurerm_virtual_network.private_vnet.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "dfs-link-to-mul-dns" {
  name                  = "dfs-to-mul-dns"
  resource_group_name   = module.private_rg.name
  private_dns_zone_name = azurerm_private_dns_zone.privatedns_dfs.name
  virtual_network_id    = azurerm_virtual_network.mul_vnet.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "dfs-link-to-auth-dns" {
  name                  = "dfs-to-auth-dns"
  resource_group_name   = module.private_rg.name
  private_dns_zone_name = azurerm_private_dns_zone.privatedns_dfs.name
  virtual_network_id    = azurerm_virtual_network.auth_vnet.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "dfs-link-to-shared-dns" {
  name                  = "dfs-to-shared-dns"
  resource_group_name   = module.private_rg.name
  private_dns_zone_name = azurerm_private_dns_zone.privatedns_dfs.name
  virtual_network_id    = azurerm_virtual_network.shared_vnet.id
}
##Create Private Endpoints for Resources##These are separate resources##Should consider looping through this deployment to validate
resource "azurerm_private_endpoint" "auth_function_app_blue_pe" {
  name                = "${local.auth_blue_function_app_name}-pe"
  location            = var.azure_location
  resource_group_name = module.private_rg.name
  subnet_id           = azurerm_subnet.Func_private_subnet.id

  private_service_connection {
    name                           = "${local.auth_blue_function_app_name}-pe"
    private_connection_resource_id = azurerm_function_app.auth_function_app_blue.id
    subresource_names              = ["sites"]
    is_manual_connection           = false
  }
    private_dns_zone_group {
    name                 = "private-dns-zone-group"
    private_dns_zone_ids = [azurerm_private_dns_zone.privatedns_asp.id]
  }
depends_on = [
  azurerm_function_app.auth_function_app_blue
]
}

resource "azurerm_private_endpoint" "auth_function_app_green_pe" {
  name                = "${local.auth_green_function_app_name}-pe"
  location            = var.azure_location
  resource_group_name = module.private_rg.name
  subnet_id           = azurerm_subnet.Func_private_subnet.id

  private_service_connection {
    name                           = "${local.auth_green_function_app_name}-pe"
    private_connection_resource_id = azurerm_function_app.auth_function_app_green.id
    subresource_names              = ["sites"]
    is_manual_connection           = false
  }
    private_dns_zone_group {
    name                 = "private-dns-zone-group"
    private_dns_zone_ids = [azurerm_private_dns_zone.privatedns_asp.id]
  }
depends_on = [
  azurerm_function_app.auth_function_app_green
]

}

resource "azurerm_private_endpoint" "data_dog_function_pe" {
  name                = "${local.datadog_function_app_name}-pe"
  location            = var.azure_location
  resource_group_name = module.private_rg.name
  subnet_id           = azurerm_subnet.Func_private_subnet.id

  private_service_connection {
    name                           = "${local.datadog_function_app_name}-pe"
    private_connection_resource_id = azurerm_function_app.datadog_function_app.id
    subresource_names              = ["sites"]
    is_manual_connection           = false
  }
    private_dns_zone_group {
    name                 = "private-dns-zone-group"
    private_dns_zone_ids = [azurerm_private_dns_zone.privatedns_asp.id]
  }
depends_on = [
  azurerm_function_app.datadog_function_app
]

}

resource "azurerm_private_endpoint" "ai_function_pe" {
  name                = "${local.ai_function_app_name}-pe"
  location            = var.azure_location
  resource_group_name = module.private_rg.name
  subnet_id           = azurerm_subnet.Func_private_subnet.id

  private_service_connection {
    name                           = "${local.datadog_function_app_name}-pe"
    private_connection_resource_id = azurerm_function_app.ai_function_app.id
    subresource_names              = ["sites"]
    is_manual_connection           = false
  }
    private_dns_zone_group {
    name                 = "private-dns-zone-group"
    private_dns_zone_ids = [azurerm_private_dns_zone.privatedns_asp.id]
  }
depends_on = [
  azurerm_function_app.ai_function_app
]
}

resource "azurerm_private_endpoint" "data_replay_function_pe" {
  name                = "${local.mul_function_app_name}-pe"
  location            = var.azure_location
  resource_group_name = module.private_rg.name
  subnet_id           = azurerm_subnet.Func_private_subnet.id

  private_service_connection {
    name                           = "${local.mul_function_app_name}-pe"
    private_connection_resource_id = azurerm_function_app.data_replay_function_app.id
    subresource_names              = ["sites"]
    is_manual_connection           = false
  }
    private_dns_zone_group {
    name                 = "private-dns-zone-group"
    private_dns_zone_ids = [azurerm_private_dns_zone.privatedns_asp.id]
  }
depends_on = [
  azurerm_function_app.data_replay_function_app
]
}

resource "azurerm_private_endpoint" "core_blue_function_pe" {
  name                = "${local.mul_core_blue_function_app_name}-pe"
  location            = var.azure_location
  resource_group_name = module.private_rg.name
  subnet_id           = azurerm_subnet.Func_private_subnet.id

  private_service_connection {
    name                           = "${local.mul_core_blue_function_app_name}-pe"
    private_connection_resource_id = azurerm_function_app.core_blue_function_app.id
    subresource_names              = ["sites"]
    is_manual_connection           = false
  }
    private_dns_zone_group {
    name                 = "private-dns-zone-group"
    private_dns_zone_ids = [azurerm_private_dns_zone.privatedns_asp.id]
  }
depends_on = [
  azurerm_function_app.core_blue_function_app
]
}

resource "azurerm_private_endpoint" "core_green_function_pe" {
  name                = "${local.mul_core_green_function_app_name}-pe"
  location            = var.azure_location
  resource_group_name = module.private_rg.name
  subnet_id           = azurerm_subnet.Func_private_subnet.id

  private_service_connection {
    name                           = "${local.mul_core_green_function_app_name}-pe"
    private_connection_resource_id = azurerm_function_app.core_green_function_app.id
    subresource_names              = ["sites"]
    is_manual_connection           = false
  }
    private_dns_zone_group {
    name                 = "private-dns-zone-group"
    private_dns_zone_ids = [azurerm_private_dns_zone.privatedns_asp.id]
  }
depends_on = [
  azurerm_function_app.core_green_function_app
]
}

resource "azurerm_private_endpoint" "gql_gate_blue_function_pe" {
  name                = "${local.mul_gql_gate_blue_function_app_name}-pe"
  location            = var.azure_location
  resource_group_name = module.private_rg.name
  subnet_id           = azurerm_subnet.Func_private_subnet.id

  private_service_connection {
    name                           = "${local.mul_gql_gate_blue_function_app_name}-pe"
    private_connection_resource_id = azurerm_function_app.gql_gate_blue_function_app.id
    subresource_names              = ["sites"]
    is_manual_connection           = false
  }
    private_dns_zone_group {
    name                 = "private-dns-zone-group"
    private_dns_zone_ids = [azurerm_private_dns_zone.privatedns_asp.id]
  }
depends_on = [
  azurerm_function_app.gql_gate_blue_function_app
]
}

resource "azurerm_private_endpoint" "gql_gate_green_function_pe" {
  name                = "${local.mul_gql_gate_green_function_app_name}-pe"
  location            = var.azure_location
  resource_group_name = module.private_rg.name
  subnet_id           = azurerm_subnet.Func_private_subnet.id

  private_service_connection {
    name                           = "${local.mul_gql_gate_green_function_app_name}-pe"
    private_connection_resource_id = azurerm_function_app.gql_gate_green_function_app.id
    subresource_names              = ["sites"]
    is_manual_connection           = false
  }
    private_dns_zone_group {
    name                 = "private-dns-zone-group"
    private_dns_zone_ids = [azurerm_private_dns_zone.privatedns_asp.id]
  }
depends_on = [
  azurerm_function_app.gql_gate_green_function_app
]
}

resource "azurerm_private_endpoint" "notifications_blue_function_pe" {
  name                = "${local.mul_notifications_blue_function_app_name}-pe"
  location            = var.azure_location
  resource_group_name = module.private_rg.name
  subnet_id           = azurerm_subnet.Func_private_subnet.id

  private_service_connection {
    name                           = "${local.mul_notifications_blue_function_app_name}-pe"
    private_connection_resource_id = azurerm_function_app.notifications_blue_function_app.id
    subresource_names              = ["sites"]
    is_manual_connection           = false
  }
    private_dns_zone_group {
    name                 = "private-dns-zone-group"
    private_dns_zone_ids = [azurerm_private_dns_zone.privatedns_asp.id]
  }
depends_on = [
  azurerm_function_app.notifications_blue_function_app
]
}

resource "azurerm_private_endpoint" "notifications_green_function_pe" {
  name                = "${local.mul_notifications_green_function_app_name}-pe"
  location            = var.azure_location
  resource_group_name = module.private_rg.name
  subnet_id           = azurerm_subnet.Func_private_subnet.id

  private_service_connection {
    name                           = "${local.mul_notifications_green_function_app_name}-pe"
    private_connection_resource_id = azurerm_function_app.notifications_green_function_app.id
    subresource_names              = ["sites"]
    is_manual_connection           = false
  }
    private_dns_zone_group {
    name                 = "private-dns-zone-group"
    private_dns_zone_ids = [azurerm_private_dns_zone.privatedns_asp.id]
  }
depends_on = [
  azurerm_function_app.notifications_green_function_app
]
}

resource "azurerm_private_endpoint" "nui_blue_function_pe" {
  name                = "${local.mul_nui_blue_function_app_name}-pe"
  location            = var.azure_location
  resource_group_name = module.private_rg.name
  subnet_id           = azurerm_subnet.Func_private_subnet.id

  private_service_connection {
    name                           = "${local.mul_nui_blue_function_app_name}-pe"
    private_connection_resource_id = azurerm_function_app.nui_blue_function_app.id
    subresource_names              = ["sites"]
    is_manual_connection           = false
  }
    private_dns_zone_group {
    name                 = "private-dns-zone-group"
    private_dns_zone_ids = [azurerm_private_dns_zone.privatedns_asp.id]
  }
depends_on = [
  azurerm_function_app.nui_blue_function_app
]
}

resource "azurerm_private_endpoint" "nui_green_function_pe" {
  name                = "${local.mul_nui_green_function_app_name}-pe"
  location            = var.azure_location
  resource_group_name = module.private_rg.name
  subnet_id           = azurerm_subnet.Func_private_subnet.id

  private_service_connection {
    name                           = "${local.mul_nui_green_function_app_name}-pe"
    private_connection_resource_id = azurerm_function_app.nui_green_function_app.id
    subresource_names              = ["sites"]
    is_manual_connection           = false
  }
    private_dns_zone_group {
    name                 = "private-dns-zone-group"
    private_dns_zone_ids = [azurerm_private_dns_zone.privatedns_asp.id]
  }
depends_on = [
  azurerm_function_app.nui_green_function_app
]
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
    private_connection_resource_id = azurerm_storage_account.function_storage_account[0].id
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
    private_connection_resource_id = azurerm_storage_account.function_storage_account[0].id
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
    private_connection_resource_id = azurerm_storage_account.auth_storage_account[0].id
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
    private_connection_resource_id = azurerm_storage_account.auth_storage_account[0].id
    subresource_names              = ["file"]
    is_manual_connection           = false
  }

      private_dns_zone_group {
    name                 = "private-dns-zone-group"
    private_dns_zone_ids = [azurerm_private_dns_zone.privatedns_file.id]
  }
}

resource "azurerm_private_endpoint" "cus_storage_account_blob_pe" {
  name                = "${azurerm_storage_account.cus_op_sa.name}-blob-pe"
  location            = var.azure_location
  resource_group_name = module.private_rg.name
  subnet_id           = azurerm_subnet.storage_private_subnet.id

  private_service_connection {
    name                           = "${azurerm_storage_account.cus_op_sa.name}-blob-pe"
    private_connection_resource_id = azurerm_storage_account.cus_op_sa.id
    subresource_names              = ["blob"]
    is_manual_connection           = false
  }

      private_dns_zone_group {
    name                 = "private-dns-zone-group"
    private_dns_zone_ids = [azurerm_private_dns_zone.privatedns_blob.id]
  }
}

resource "azurerm_private_endpoint" "cus_storage_account_file_pe" {
  name                = "${azurerm_storage_account.cus_op_sa.name}-file-pe"
  location            = var.azure_location
  resource_group_name = module.private_rg.name
  subnet_id           = azurerm_subnet.storage_private_subnet.id

  private_service_connection {
    name                           = "${azurerm_storage_account.cus_op_sa.name}-file-pe"
    private_connection_resource_id = azurerm_storage_account.cus_op_sa.id
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
    private_connection_resource_id = azurerm_eventhub.mul_eventhub.id
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
  depends_on = [
    module.cus_cosmosdb,
    azurerm_cosmosdb_account.instance
  ]
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
    depends_on = [
    module.cus_cosmosdb,
    azurerm_cosmosdb_account.instance
  ]

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
    private_connection_resource_id = azurerm_redis_enterprise_cluster.mul_redis_cluster.id
    subresource_names              = ["redisenterprise"]
   is_manual_connection           = false
  }
        private_dns_zone_group {
    name                 = "private-dns-zone-group"
   private_dns_zone_ids = [azurerm_private_dns_zone.privatedns_redisent.id]
 }

}