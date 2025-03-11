# -------------------------------------------------------------------------------------------------
# Create the private network for auth
module "auth_rg" {
  source = "../modules/rg"

  azure_location      = var.azure_location
  resource_group_name = local.auth_resource_group_name

  tags = merge(local.resource_tags, {
    "environment" = var.env_name
    "role"        = "api"
    "createdon"   = local.tag_createdon
  })
}

resource "azurerm_virtual_network" "auth_vnet" {
  name                = local.auth_vnet_name
  address_space       = [module.vnet_addrs.networks[4].cidr_block]
  location            = var.azure_location
  resource_group_name = module.auth_rg.name

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

# Get all of the subnets for auth
module "auth_subnet_addrs" {
  source = "../modules/cidr-subnets"

  base_cidr_block = module.vnet_addrs.networks[4].cidr_block
  networks = [
   # {
    #  name     = "reserved"
     # new_bits = 8
    #},
    {
      name     = "subnet01"
      new_bits = 1
    }
  ]
}

resource "azurerm_subnet" "auth_subnet01" {
  name                 = "auth_subnet01"
  resource_group_name  = module.auth_rg.name
  virtual_network_name = azurerm_virtual_network.auth_vnet.name
  address_prefixes     = [module.vnet_addrs.networks[4].cidr_block]


  # Delegate the subnet to "Microsoft.Web/serverFarms"
  delegation {
    name = "acctestdelegation"

    service_delegation {
      name    = "Microsoft.Web/serverFarms"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }

  service_endpoints = ["Microsoft.AzureCosmosDB"]
}

resource "azurerm_network_security_group" "auth_nsg01" {
  name                = "${var.region_abbreviation}-auth${var.resource_version}-back01-nsg${local.suffix}"
  location            = var.azure_location
  resource_group_name = module.auth_rg.name

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

resource "azurerm_network_security_group" "auth_nsg02" {
  name                = "${var.region_abbreviation}-auth${var.resource_version}-back02-nsg${local.suffix}"
  location            = var.azure_location
  resource_group_name = module.auth_rg.name

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

resource "azurerm_storage_account" "auth_storage_account" {
  count                     = var.create_new_storage_account ? 1 : 0
  name                      = local.auth_storage_name
  resource_group_name = module.auth_rg.name
  location                  = var.azure_location
  account_tier              = "Standard"
  account_replication_type  = "LRS"
  enable_https_traffic_only = true
  min_tls_version           = "TLS1_2"
  tags                      = var.tags
  allow_nested_items_to_be_public  = "false"
  lifecycle {
    ignore_changes = [
      tags["createdon"],
    ]
  }
}

resource "azurerm_app_service_plan" "auth_app_service_plan" {
  name                = local.auth_app_service_plan_name
  location            = var.azure_location
  resource_group_name = module.auth_rg.name
  kind                = "elastic"
  tags                = var.tags

  sku {
    tier     = "ElasticPremium"
    size     = "EP1"
    capacity = 1
  }

  lifecycle {
    ignore_changes = [
      tags["createdon"]
    ]
  }
}

resource "azurerm_application_insights" "auth_insights" {
  name                = local.auth_app_service_plan_name
  location            = var.azure_location
  resource_group_name = module.auth_rg.name
  application_type    = "web"
  tags                = var.tags

  lifecycle {
    ignore_changes = [
      tags["createdon"]
    ]
  }
}
resource "azurerm_function_app" "auth_function_app_blue" {
 
  name                       = local.auth_blue_function_app_name
  location                   = var.azure_location
  resource_group_name = module.auth_rg.name
  app_service_plan_id        = azurerm_app_service_plan.auth_app_service_plan.id
  storage_account_name       = local.auth_storage_name
  storage_account_access_key = var.create_new_storage_account ? azurerm_storage_account.auth_storage_account[0].primary_access_key : data.azurerm_storage_account.existing_storage_account[0].primary_access_key
  version                    = "~3"
  tags                       = var.tags

  app_settings = {
    https_only                     = true
    FUNCTIONS_WORKER_RUNTIME       = "node"
    WEBSITE_NODE_DEFAULT_VERSION   = "~12"
    APPINSIGHTS_INSTRUMENTATIONKEY = azurerm_application_insights.auth_insights.instrumentation_key
    STORAGE_CONNECTION_STRING      = var.create_new_storage_account ? azurerm_storage_account.function_storage_account[0].primary_connection_string : data.azurerm_storage_account.existing_storage_account[0].primary_connection_string
    # With this setting we will force all outbound traffic through the VNet
    WEBSITE_VNET_ROUTE_ALL = "1"
    # Properties used to deploy the zip
    #HASH                     = filesha256("./build/core.zip")
    #WEBSITE_RUN_FROM_PACKAGE = "https://${azurerm_storage_account.function_sa.name}.blob.core.windows.net/${azurerm_storage_container.functions.name}/${azurerm_storage_blob.function_core.name}${data.azurerm_storage_account_sas.sas.sas}"
  }

  lifecycle {
    ignore_changes = [
      tags["createdon"]
    ]
  }
}

resource "azurerm_function_app" "auth_function_app_green" {
 
  name                       = local.auth_green_function_app_name
  location                   = var.azure_location
  resource_group_name = module.auth_rg.name
  app_service_plan_id        = azurerm_app_service_plan.auth_app_service_plan.id
  storage_account_name       = local.auth_storage_name
  storage_account_access_key = var.create_new_storage_account ? azurerm_storage_account.auth_storage_account[0].primary_access_key : data.azurerm_storage_account.existing_storage_account[0].primary_access_key
  version                    = "~3"
  tags                       = var.tags

  app_settings = {
    https_only                     = true
    FUNCTIONS_WORKER_RUNTIME       = "node"
    WEBSITE_NODE_DEFAULT_VERSION   = "~12"
    APPINSIGHTS_INSTRUMENTATIONKEY = azurerm_application_insights.auth_insights.instrumentation_key
    STORAGE_CONNECTION_STRING      = var.create_new_storage_account ? azurerm_storage_account.function_storage_account[0].primary_connection_string : data.azurerm_storage_account.existing_storage_account[0].primary_connection_string
    # With this setting we will force all outbound traffic through the VNet
    WEBSITE_VNET_ROUTE_ALL = "1"
    # Properties used to deploy the zip
    #HASH                     = filesha256("./build/core.zip")
    #WEBSITE_RUN_FROM_PACKAGE = "https://${azurerm_storage_account.function_sa.name}.blob.core.windows.net/${azurerm_storage_container.functions.name}/${azurerm_storage_blob.function_core.name}${data.azurerm_storage_account_sas.sas.sas}"
  }

  lifecycle {
    ignore_changes = [
      tags["createdon"]
    ]
  }
}


resource "azurerm_app_service_virtual_network_swift_connection" "auth_swift_con_blue" {
  app_service_id = azurerm_function_app.auth_function_app_blue.id
  subnet_id      = azurerm_subnet.auth_subnet01.id
}

resource "azurerm_app_service_virtual_network_swift_connection" "auth_swift_con_green" {
  app_service_id = azurerm_function_app.auth_function_app_green.id
  subnet_id      = azurerm_subnet.auth_subnet01.id
}