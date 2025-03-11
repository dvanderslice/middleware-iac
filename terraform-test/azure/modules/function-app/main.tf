data "azurerm_storage_account" "existing_storage_account" {
  count               = var.create_new_storage_account ? 0 : 1
  name                = var.storage_account_name
  resource_group_name = var.resource_group_name

  depends_on = [
    
  ]
}


resource "azurerm_storage_account" "storage_account" {
  count                     = var.create_new_storage_account ? 1 : 0
  name                      = var.storage_account_name
  resource_group_name       = var.resource_group_name
  location                  = var.azure_location
  account_tier              = "Standard"
  account_replication_type  = "LRS"
  enable_https_traffic_only = true
  allow_nested_items_to_be_public  = false
  min_tls_version           = "TLS1_2"
  tags                      = var.tags

  lifecycle {
    ignore_changes = [
      tags["createdon"],
    ]
  }
}

resource "azurerm_app_service_plan" "app_service_plan" {
  name                = var.app_service_plan_name
  location            = var.azure_location
  resource_group_name = var.resource_group_name
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


resource "azurerm_application_insights" "insights" {
  name                = var.app_insights_name
  location            = var.azure_location
  resource_group_name = var.resource_group_name
  application_type    = "web"
  tags                = var.tags

  lifecycle {
    ignore_changes = [
      tags["createdon"]
    ]
  }
}

resource "azurerm_function_app" "function_app_with_subnet" {
  count = var.subnet_id == null ? 0 : 1

  name                       = var.function_app_name
  location                   = var.azure_location
  resource_group_name        = var.resource_group_name
  app_service_plan_id        = azurerm_app_service_plan.app_service_plan.id
  storage_account_name       = var.storage_account_name
  storage_account_access_key = var.create_new_storage_account ? azurerm_storage_account.storage_account[0].primary_access_key : data.azurerm_storage_account.existing_storage_account[0].primary_access_key
  version                    = "~3"
  tags                       = var.tags

  app_settings = {
    https_only                     = true
    FUNCTIONS_WORKER_RUNTIME       = var.function_runtime
    WEBSITE_NODE_DEFAULT_VERSION   = "~12"
    APPINSIGHTS_INSTRUMENTATIONKEY = azurerm_application_insights.insights.instrumentation_key
    STORAGE_CONNECTION_STRING      = var.create_new_storage_account ? azurerm_storage_account.storage_account[0].primary_connection_string : data.azurerm_storage_account.existing_storage_account[0].primary_connection_string
    # With this setting we will force all outbound traffic through the VNet
    WEBSITE_VNET_ROUTE_ALL = "1"
    # Properties used to deploy the zip
    #HASH                     = filesha256("./build/core.zip")
    #WEBSITE_RUN_FROM_PACKAGE = "https://${azurerm_storage_account.function_sa.name}.blob.core.windows.net/${azurerm_storage_container.functions.name}/${azurerm_storage_blob.function_core.name}${data.azurerm_storage_account_sas.sas.sas}"
  }

  site_config {
    ip_restriction {
      name                      = "Function App Subnet"
      priority                  = 100
      action                    = "Allow"
      virtual_network_subnet_id = var.subnet_id
    }
  }

  lifecycle {
    ignore_changes = [
      tags["createdon"]
    ]
  }
}

resource "azurerm_function_app" "function_app" {
  count = var.subnet_id == null ? 1 : 0

  name                       = var.function_app_name
  location                   = var.azure_location
  resource_group_name        = var.resource_group_name
  app_service_plan_id        = azurerm_app_service_plan.app_service_plan.id
  storage_account_name       = var.storage_account_name
  storage_account_access_key = var.create_new_storage_account ? azurerm_storage_account.storage_account[0].primary_access_key : data.azurerm_storage_account.existing_storage_account[0].primary_access_key
  version                    = "~3"
  tags                       = var.tags

  app_settings = {
    https_only                     = true
    FUNCTIONS_WORKER_RUNTIME       = var.function_runtime
    WEBSITE_NODE_DEFAULT_VERSION   = "~12"
    APPINSIGHTS_INSTRUMENTATIONKEY = azurerm_application_insights.insights.instrumentation_key
    STORAGE_CONNECTION_STRING      = var.create_new_storage_account ? azurerm_storage_account.storage_account[0].primary_connection_string : data.azurerm_storage_account.existing_storage_account[0].primary_connection_string
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




