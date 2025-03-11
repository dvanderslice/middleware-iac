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
  name                                           = "Storage_private_subnet01"
  resource_group_name                            = module.private_rg.name
  virtual_network_name                           = azurerm_virtual_network.private_vnet.name
  address_prefixes                               = [module.private_subnet_addrs.networks[0].cidr_block]
  enforce_private_link_endpoint_network_policies = true
}

resource "azurerm_subnet" "Data_private_subnet" {
  name                                           = "Data_private_subnet01"
  resource_group_name                            = module.private_rg.name
  virtual_network_name                           = azurerm_virtual_network.private_vnet.name
  address_prefixes                               = [module.private_subnet_addrs.networks[1].cidr_block]
  enforce_private_link_endpoint_network_policies = true
}
resource "azurerm_subnet" "Shared_private_subnet" {
  name                                           = "Shared_private_subnet01"
  resource_group_name                            = module.private_rg.name
  virtual_network_name                           = azurerm_virtual_network.private_vnet.name
  address_prefixes                               = [module.private_subnet_addrs.networks[2].cidr_block]
  enforce_private_link_endpoint_network_policies = true
}

resource "azurerm_subnet" "Func_private_subnet" {
  name                                           = "Func_private_subnet01"
  resource_group_name                            = module.private_rg.name
  virtual_network_name                           = azurerm_virtual_network.private_vnet.name
  address_prefixes                               = [module.private_subnet_addrs.networks[3].cidr_block]
  enforce_private_link_endpoint_network_policies = true
}

resource "azurerm_network_security_group" "storage_private_nsg" {
  name                = "Storage_private_subnet01"
  location            = var.azure_location
  resource_group_name = module.private_rg.name
}

resource "azurerm_network_security_group" "data_private_nsg" {
  name                = "Data_private_subnet01"
  location            = var.azure_location
  resource_group_name = module.private_rg.name
}

resource "azurerm_network_security_group" "shared_private_nsg" {
  name                = "Shared_private_subnet01"
  location            = var.azure_location
  resource_group_name = module.private_rg.name
}

resource "azurerm_network_security_group" "func_private_nsg" {
  name                = "Func_private_subnet01"
  location            = var.azure_location
  resource_group_name = module.private_rg.name
}

resource "azurerm_subnet_network_security_group_association" "storage_private_nsga" {
  subnet_id                 = azurerm_subnet.storage_private_subnet.id
  network_security_group_id = azurerm_network_security_group.storage_private_nsg.id
}

resource "azurerm_subnet_network_security_group_association" "data_private_nsga" {
  subnet_id                 = azurerm_subnet.Data_private_subnet.id
  network_security_group_id = azurerm_network_security_group.data_private_nsg.id
}

resource "azurerm_subnet_network_security_group_association" "Shared_private_nsga" {
  subnet_id                 = azurerm_subnet.Shared_private_subnet.id
  network_security_group_id = azurerm_network_security_group.shared_private_nsg.id
}

resource "azurerm_subnet_network_security_group_association" "func_private_nsga" {
  subnet_id                 = azurerm_subnet.Func_private_subnet.id
  network_security_group_id = azurerm_network_security_group.func_private_nsg.id
}
##Import Private DNS Zones from Production##
data "azurerm_private_dns_zone" "privatedns_asp" {
  provider            = azurerm.Production
  name                = "privatelink.azurewebsites.net"
  resource_group_name = "AppGrp-pri${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
}

data "azurerm_private_dns_zone" "privatedns_blob" {
  provider            = azurerm.Production
  name                = "privatelink.blob.core.windows.net"
  resource_group_name = "AppGrp-pri${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
}

data "azurerm_private_dns_zone" "privatedns_file" {
  provider            = azurerm.Production
  name                = "privatelink.file.core.windows.net"
  resource_group_name = "AppGrp-pri${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
}

data "azurerm_private_dns_zone" "privatedns_staticweb" {
  provider            = azurerm.Production
  name                = "privatelink.web.core.windows.net"
  resource_group_name = "AppGrp-pri${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
}

data "azurerm_private_dns_zone" "privatedns_eventgrid" {
  provider            = azurerm.Production
  name                = "privatelink.eventgrid.azure.net"
  resource_group_name = "AppGrp-pri${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
}

data "azurerm_private_dns_zone" "privatedns_table" {
  provider            = azurerm.Production
  name                = "privatelink.table.core.windows.net"
  resource_group_name = "AppGrp-pri${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
}

data "azurerm_private_dns_zone" "privatedns_cosmosdocument" {
  provider            = azurerm.Production
  name                = "privatelink.documents.azure.com"
  resource_group_name = "AppGrp-pri${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
}

data "azurerm_private_dns_zone" "privatedns_cosmosgremlin" {
  provider            = azurerm.Production
  name                = "privatelink.gremlin.cosmos.azure.com"
  resource_group_name = "AppGrp-pri${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
}

data "azurerm_private_dns_zone" "privatedns_cosmosmongo" {
  provider            = azurerm.Production
  name                = "privatelink.mongo.cosmos.azure.com"
  resource_group_name = "AppGrp-pri${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
}

data "azurerm_private_dns_zone" "privatedns_webpubsub" {
  provider            = azurerm.Production
  name                = "privatelink.webpubsub.azure.com"
  resource_group_name = "AppGrp-pri${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
}

data "azurerm_private_dns_zone" "privatedns_redisent" {
  provider            = azurerm.Production
  name                = "privatelink.redisenterprise.cache.azure.net"
  resource_group_name = "AppGrp-pri${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
}

data "azurerm_private_dns_zone" "privatedns_azuredevices" {
  provider            = azurerm.Production
  name                = "privatelink.azure-devices.net"
  resource_group_name = "AppGrp-pri${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
}

data "azurerm_private_dns_zone" "privatedns_service_bus" {
  provider            = azurerm.Production
  name                = "privatelink.servicebus.windows.net"
  resource_group_name = "AppGrp-pri${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
}

data "azurerm_private_dns_zone" "privatedns_azuredevices_provisioning" {
  provider            = azurerm.Production
  name                = "privatelink.azure-devices-provisioning.net"
  resource_group_name = "AppGrp-pri${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
}

data "azurerm_private_dns_zone" "privatedns_kusto" {
  provider            = azurerm.Production
  name                = "privatelink.eastus2.kusto.windows.net"
  resource_group_name = "AppGrp-pri${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
}

data "azurerm_private_dns_zone" "privatedns_queue" {
  provider            = azurerm.Production
  name                = "privatelink.queue.core.windows.net"
  resource_group_name = "AppGrp-pri${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
}

data "azurerm_private_dns_zone" "privatedns_dfs" {
  provider            = azurerm.Production
  name                = "privatelink.dfs.core.windows.net"
  resource_group_name = "AppGrp-pri${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
}



##Linking VNETs to Private DNS Zones to allow resolution

resource "azurerm_private_dns_zone_virtual_network_link" "function-link-to-pri-dns" {
  provider              = azurerm.Production
  name                  = "function-link-to-pri-dns${var.env_name}${var.env_key}"
  resource_group_name   = "AppGrp-pri${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  private_dns_zone_name = data.azurerm_private_dns_zone.privatedns_asp.name
  virtual_network_id    = azurerm_virtual_network.private_vnet.id
}
resource "azurerm_private_dns_zone_virtual_network_link" "function-link-to-mul-dns" {
  provider              = azurerm.Production
  name                  = "function-link-to-mul-dns${var.env_name}${var.env_key}"
  resource_group_name   = "AppGrp-pri${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  private_dns_zone_name = data.azurerm_private_dns_zone.privatedns_asp.name
  virtual_network_id    = azurerm_virtual_network.mul_vnet.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "function-link-to-auth-dns" {
  provider              = azurerm.Production
  name                  = "function-link-to-auth-dns${var.env_name}${var.env_key}"
  resource_group_name   = "AppGrp-pri${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  private_dns_zone_name = data.azurerm_private_dns_zone.privatedns_asp.name
  virtual_network_id    = azurerm_virtual_network.auth_vnet.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "blob-link-to-pri-dns" {
  provider              = azurerm.Production
  name                  = "blob-link-to-pri-dns${var.env_name}${var.env_key}"
  resource_group_name   = "AppGrp-pri${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  private_dns_zone_name = data.azurerm_private_dns_zone.privatedns_blob.name
  virtual_network_id    = azurerm_virtual_network.private_vnet.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "blob-link-to-mul-dns" {
  provider              = azurerm.Production
  name                  = "blob-link-to-mul-dns${var.env_name}${var.env_key}"
  resource_group_name   = "AppGrp-pri${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  private_dns_zone_name = data.azurerm_private_dns_zone.privatedns_blob.name
  virtual_network_id    = azurerm_virtual_network.mul_vnet.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "blob-link-to-auth-dns" {
  provider              = azurerm.Production
  name                  = "blob-link-to-auth-dns${var.env_name}${var.env_key}"
  resource_group_name   = "AppGrp-pri${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  private_dns_zone_name = data.azurerm_private_dns_zone.privatedns_blob.name
  virtual_network_id    = azurerm_virtual_network.auth_vnet.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "file-link-to-pri-dns" {
  provider              = azurerm.Production
  name                  = "file-link-to-pri-dns${var.env_name}${var.env_key}"
  resource_group_name   = "AppGrp-pri${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  private_dns_zone_name = data.azurerm_private_dns_zone.privatedns_file.name
  virtual_network_id    = azurerm_virtual_network.private_vnet.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "file-link-to-mul-dns" {
  provider              = azurerm.Production
  name                  = "file-link-to-mul-dns${var.env_name}${var.env_key}"
  resource_group_name   = "AppGrp-pri${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  private_dns_zone_name = data.azurerm_private_dns_zone.privatedns_file.name
  virtual_network_id    = azurerm_virtual_network.mul_vnet.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "file-link-to-auth-dns" {
  provider              = azurerm.Production
  name                  = "file-link-to-auth-dns${var.env_name}${var.env_key}"
  resource_group_name   = "AppGrp-pri${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  private_dns_zone_name = data.azurerm_private_dns_zone.privatedns_file.name
  virtual_network_id    = azurerm_virtual_network.auth_vnet.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "staticweb-link-to-pri-dns" {
  provider              = azurerm.Production
  name                  = "staticweb-link-to-pri-dns${var.env_name}${var.env_key}"
  resource_group_name   = "AppGrp-pri${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  private_dns_zone_name = data.azurerm_private_dns_zone.privatedns_staticweb.name
  virtual_network_id    = azurerm_virtual_network.private_vnet.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "staticweb-link-to-mul-dns" {
  provider              = azurerm.Production
  name                  = "staticweb-link-to-mul-dns${var.env_name}${var.env_key}"
  resource_group_name   = "AppGrp-pri${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  private_dns_zone_name = data.azurerm_private_dns_zone.privatedns_staticweb.name
  virtual_network_id    = azurerm_virtual_network.mul_vnet.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "staticweb-link-to-auth-dns" {
  provider              = azurerm.Production
  name                  = "staticweb-link-to-auth-dns${var.env_name}${var.env_key}"
  resource_group_name   = "AppGrp-pri${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  private_dns_zone_name = data.azurerm_private_dns_zone.privatedns_staticweb.name
  virtual_network_id    = azurerm_virtual_network.auth_vnet.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "eventgrid-link-to-pri-dns" {
  provider              = azurerm.Production
  name                  = "eventgrid-link-to-pri-dns${var.env_name}${var.env_key}"
  resource_group_name   = "AppGrp-pri${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  private_dns_zone_name = data.azurerm_private_dns_zone.privatedns_eventgrid.name
  virtual_network_id    = azurerm_virtual_network.private_vnet.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "eventgrid-link-to-mul-dns" {
  provider              = azurerm.Production
  name                  = "eventgrid-link-to-mul-dns${var.env_name}${var.env_key}"
  resource_group_name   = "AppGrp-pri${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  private_dns_zone_name = data.azurerm_private_dns_zone.privatedns_eventgrid.name
  virtual_network_id    = azurerm_virtual_network.mul_vnet.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "eventgrid-link-to-auth-dns" {
  provider              = azurerm.Production
  name                  = "eventgrid-link-to-auth-dns${var.env_name}${var.env_key}"
  resource_group_name   = "AppGrp-pri${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  private_dns_zone_name = data.azurerm_private_dns_zone.privatedns_eventgrid.name
  virtual_network_id    = azurerm_virtual_network.auth_vnet.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "cosmosdocument-link-to-pri-dns" {
  provider              = azurerm.Production
  name                  = "cosmosdocument-link-to-pri-dns${var.env_name}${var.env_key}"
  resource_group_name   = "AppGrp-pri${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  private_dns_zone_name = data.azurerm_private_dns_zone.privatedns_cosmosdocument.name
  virtual_network_id    = azurerm_virtual_network.private_vnet.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "cosmosdocument-link-to-mul-dns" {
  provider              = azurerm.Production
  name                  = "cosmosdocument-link-to-mul-dns${var.env_name}${var.env_key}"
  resource_group_name   = "AppGrp-pri${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  private_dns_zone_name = data.azurerm_private_dns_zone.privatedns_cosmosdocument.name
  virtual_network_id    = azurerm_virtual_network.mul_vnet.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "cosmosdocument-link-to-auth-dns" {
  provider              = azurerm.Production
  name                  = "cosmosdocument-link-to-auth-dns${var.env_name}${var.env_key}"
  resource_group_name   = "AppGrp-pri${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  private_dns_zone_name = data.azurerm_private_dns_zone.privatedns_cosmosdocument.name
  virtual_network_id    = azurerm_virtual_network.auth_vnet.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "table-link-to-pri-dns" {
  provider              = azurerm.Production
  name                  = "table-link-to-pri-dns${var.env_name}${var.env_key}"
  resource_group_name   = "AppGrp-pri${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  private_dns_zone_name = data.azurerm_private_dns_zone.privatedns_table.name
  virtual_network_id    = azurerm_virtual_network.private_vnet.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "table-link-to-mul-dns" {
  provider              = azurerm.Production
  name                  = "table-link-to-mul-dns${var.env_name}${var.env_key}"
  resource_group_name   = "AppGrp-pri${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  private_dns_zone_name = data.azurerm_private_dns_zone.privatedns_table.name
  virtual_network_id    = azurerm_virtual_network.mul_vnet.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "table-link-to-auth-dns" {
  provider              = azurerm.Production
  name                  = "table-link-to-auth-dns${var.env_name}${var.env_key}"
  resource_group_name   = "AppGrp-pri${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  private_dns_zone_name = data.azurerm_private_dns_zone.privatedns_table.name
  virtual_network_id    = azurerm_virtual_network.auth_vnet.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "cosmosgremlin-link-to-pri-dns" {
  provider              = azurerm.Production
  name                  = "cosmosgremlinlink-to-pri-dns${var.env_name}${var.env_key}"
  resource_group_name   = "AppGrp-pri${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  private_dns_zone_name = data.azurerm_private_dns_zone.privatedns_cosmosgremlin.name
  virtual_network_id    = azurerm_virtual_network.private_vnet.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "cosmosgremlin-link-to-mul-dns" {
  provider              = azurerm.Production
  name                  = "cosmosgremlinlink-to-mul-dns${var.env_name}${var.env_key}"
  resource_group_name   = "AppGrp-pri${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  private_dns_zone_name = data.azurerm_private_dns_zone.privatedns_cosmosgremlin.name
  virtual_network_id    = azurerm_virtual_network.mul_vnet.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "cosmosgremlin-link-to-auth-dns" {
  provider              = azurerm.Production
  name                  = "cosmosgremlinlink-to-auth-dns${var.env_name}${var.env_key}"
  resource_group_name   = "AppGrp-pri${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  private_dns_zone_name = data.azurerm_private_dns_zone.privatedns_cosmosgremlin.name
  virtual_network_id    = azurerm_virtual_network.auth_vnet.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "cosmosmongo-link-to-pri-dns" {
  provider              = azurerm.Production
  name                  = "cosmosmongo-to-pri-dns${var.env_name}${var.env_key}"
  resource_group_name   = "AppGrp-pri${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  private_dns_zone_name = data.azurerm_private_dns_zone.privatedns_cosmosmongo.name
  virtual_network_id    = azurerm_virtual_network.private_vnet.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "cosmosmongo-link-to-mul-dns" {
  provider              = azurerm.Production
  name                  = "cosmosmongo-to-mul-dns${var.env_name}${var.env_key}"
  resource_group_name   = "AppGrp-pri${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  private_dns_zone_name = data.azurerm_private_dns_zone.privatedns_cosmosmongo.name
  virtual_network_id    = azurerm_virtual_network.mul_vnet.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "cosmosmongo-link-to-auth-dns" {
  provider              = azurerm.Production
  name                  = "cosmosmongo-to-auth-dns${var.env_name}${var.env_key}"
  resource_group_name   = "AppGrp-pri${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  private_dns_zone_name = data.azurerm_private_dns_zone.privatedns_cosmosmongo.name
  virtual_network_id    = azurerm_virtual_network.auth_vnet.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "webpubsub-link-to-pri-dns" {
  provider              = azurerm.Production
  name                  = "webpubsub-to-pri-dns-${var.env_name}${var.env_key}"
  resource_group_name   = "AppGrp-pri${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  private_dns_zone_name = data.azurerm_private_dns_zone.privatedns_webpubsub.name
  virtual_network_id    = azurerm_virtual_network.private_vnet.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "webpubsub-link-to-mul-dns" {
  provider              = azurerm.Production
  name                  = "webpubsub-to-mul-dns-${var.env_name}${var.env_key}"
  resource_group_name   = "AppGrp-pri${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  private_dns_zone_name = data.azurerm_private_dns_zone.privatedns_webpubsub.name
  virtual_network_id    = azurerm_virtual_network.mul_vnet.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "webpubsub-link-to-auth-dns" {
  provider              = azurerm.Production
  name                  = "webpubsub-to-auth-dns-${var.env_name}${var.env_key}"
  resource_group_name   = "AppGrp-pri${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  private_dns_zone_name = data.azurerm_private_dns_zone.privatedns_webpubsub.name
  virtual_network_id    = azurerm_virtual_network.auth_vnet.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "redisent-link-to-pri-dns" {
  provider              = azurerm.Production
  name                  = "redisent-to-pri-dns-${var.env_name}${var.env_key}"
  resource_group_name   = "AppGrp-pri${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  private_dns_zone_name = data.azurerm_private_dns_zone.privatedns_redisent.name
  virtual_network_id    = azurerm_virtual_network.private_vnet.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "redisent-link-to-mul-dns" {
  provider              = azurerm.Production
  name                  = "redisent-to-mul-dns-${var.env_name}${var.env_key}"
  resource_group_name   = "AppGrp-pri${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  private_dns_zone_name = data.azurerm_private_dns_zone.privatedns_redisent.name
  virtual_network_id    = azurerm_virtual_network.mul_vnet.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "redisent-link-to-auth-dns" {
  provider              = azurerm.Production
  name                  = "redisent-to-auth-dns-${var.env_name}${var.env_key}"
  resource_group_name   = "AppGrp-pri${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  private_dns_zone_name = data.azurerm_private_dns_zone.privatedns_redisent.name
  virtual_network_id    = azurerm_virtual_network.auth_vnet.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "azuredevices-link-to-pri-dns" {
  provider              = azurerm.Production
  name                  = "devices-to-pri-dns-${var.env_name}${var.env_key}"
  resource_group_name   = "AppGrp-pri${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  private_dns_zone_name = data.azurerm_private_dns_zone.privatedns_azuredevices.name
  virtual_network_id    = azurerm_virtual_network.private_vnet.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "azuredevices-link-to-mul-dns" {
  provider              = azurerm.Production
  name                  = "devices-to-mul-dns-${var.env_name}${var.env_key}"
  resource_group_name   = "AppGrp-pri${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  private_dns_zone_name = data.azurerm_private_dns_zone.privatedns_azuredevices.name
  virtual_network_id    = azurerm_virtual_network.mul_vnet.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "azuredevices-link-to-auth-dns" {
  provider              = azurerm.Production
  name                  = "devices-to-auth-dns-${var.env_name}${var.env_key}"
  resource_group_name   = "AppGrp-pri${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  private_dns_zone_name = data.azurerm_private_dns_zone.privatedns_azuredevices.name
  virtual_network_id    = azurerm_virtual_network.auth_vnet.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "sb-link-to-pri-dns" {
  provider              = azurerm.Production
  name                  = "sblink-to-pri-dns-${var.env_name}${var.env_key}"
  resource_group_name   = "AppGrp-pri${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  private_dns_zone_name = data.azurerm_private_dns_zone.privatedns_service_bus.name
  virtual_network_id    = azurerm_virtual_network.private_vnet.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "sb-link-to-mul-dns" {
  provider              = azurerm.Production
  name                  = "sblink-to-mul-dns-${var.env_name}${var.env_key}"
  resource_group_name   = "AppGrp-pri${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  private_dns_zone_name = data.azurerm_private_dns_zone.privatedns_service_bus.name
  virtual_network_id    = azurerm_virtual_network.mul_vnet.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "sb-link-to-auth-dns" {
  provider              = azurerm.Production
  name                  = "sblink-to-auth-dns-${var.env_name}${var.env_key}"
  resource_group_name   = "AppGrp-pri${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  private_dns_zone_name = data.azurerm_private_dns_zone.privatedns_service_bus.name
  virtual_network_id    = azurerm_virtual_network.auth_vnet.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "dps-link-to-pri-dns" {
  provider              = azurerm.Production
  name                  = "dps-to-pri-dns-${var.env_name}${var.env_key}"
  resource_group_name   = "AppGrp-pri${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  private_dns_zone_name = data.azurerm_private_dns_zone.privatedns_azuredevices_provisioning.name
  virtual_network_id    = azurerm_virtual_network.private_vnet.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "dps-link-to-mul-dns" {
  provider              = azurerm.Production
  name                  = "dps-to-mul-dns-${var.env_name}${var.env_key}"
  resource_group_name   = "AppGrp-pri${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  private_dns_zone_name = data.azurerm_private_dns_zone.privatedns_azuredevices_provisioning.name
  virtual_network_id    = azurerm_virtual_network.mul_vnet.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "dps-link-to-auth-dns" {
  provider              = azurerm.Production
  name                  = "dps-to-auth-dns-${var.env_name}${var.env_key}"
  resource_group_name   = "AppGrp-pri${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  private_dns_zone_name = data.azurerm_private_dns_zone.privatedns_azuredevices_provisioning.name
  virtual_network_id    = azurerm_virtual_network.auth_vnet.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "kusto-link-to-pri-dns" {
  provider              = azurerm.Production
  name                  = "kusto-to-pri-dns-${var.env_name}${var.env_key}"
  resource_group_name   = "AppGrp-pri${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  private_dns_zone_name = data.azurerm_private_dns_zone.privatedns_kusto.name
  virtual_network_id    = azurerm_virtual_network.private_vnet.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "kusto-link-to-mul-dns" {
  provider              = azurerm.Production
  name                  = "kusto-to-mul-dns-${var.env_name}${var.env_key}"
  resource_group_name   = "AppGrp-pri${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  private_dns_zone_name = data.azurerm_private_dns_zone.privatedns_kusto.name
  virtual_network_id    = azurerm_virtual_network.mul_vnet.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "kusto-link-to-auth-dns" {
  provider              = azurerm.Production
  name                  = "kusto-to-auth-dns-${var.env_name}${var.env_key}"
  resource_group_name   = "AppGrp-pri${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  private_dns_zone_name = data.azurerm_private_dns_zone.privatedns_kusto.name
  virtual_network_id    = azurerm_virtual_network.auth_vnet.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "queue-link-to-pri-dns" {
  provider              = azurerm.Production
  name                  = "queue-to-pri-dns-${var.env_name}${var.env_key}"
  resource_group_name   = "AppGrp-pri${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  private_dns_zone_name = data.azurerm_private_dns_zone.privatedns_queue.name
  virtual_network_id    = azurerm_virtual_network.private_vnet.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "queue-link-to-mul-dns" {
  provider              = azurerm.Production
  name                  = "queue-to-mul-dns-${var.env_name}${var.env_key}"
  resource_group_name   = "AppGrp-pri${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  private_dns_zone_name = data.azurerm_private_dns_zone.privatedns_queue.name
  virtual_network_id    = azurerm_virtual_network.mul_vnet.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "queue-link-to-auth-dns" {
  provider              = azurerm.Production
  name                  = "queue-to-auth-dns-${var.env_name}${var.env_key}"
  resource_group_name   = "AppGrp-pri${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  private_dns_zone_name = data.azurerm_private_dns_zone.privatedns_queue.name
  virtual_network_id    = azurerm_virtual_network.auth_vnet.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "dfs-link-to-pri-dns" {
  provider              = azurerm.Production
  name                  = "dfs-to-pri-dns-${var.env_name}${var.env_key}"
  resource_group_name   = "AppGrp-pri${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  private_dns_zone_name = data.azurerm_private_dns_zone.privatedns_dfs.name
  virtual_network_id    = azurerm_virtual_network.private_vnet.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "dfs-link-to-mul-dns" {
  provider              = azurerm.Production
  name                  = "dfs-to-mul-dns-${var.env_name}${var.env_key}"
  resource_group_name   = "AppGrp-pri${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  private_dns_zone_name = data.azurerm_private_dns_zone.privatedns_dfs.name
  virtual_network_id    = azurerm_virtual_network.mul_vnet.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "dfs-link-to-auth-dns" {
  provider              = azurerm.Production
  name                  = "dfs-to-auth-dns-${var.env_name}${var.env_key}"
  resource_group_name   = "AppGrp-pri${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  private_dns_zone_name = data.azurerm_private_dns_zone.privatedns_dfs.name
  virtual_network_id    = azurerm_virtual_network.auth_vnet.id
}
