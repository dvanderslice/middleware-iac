# -------------------------------------------------------------------------------------------------
# Create the function app resources
data "azurerm_storage_account" "existing_storage_account" {
  count               = var.create_new_storage_account ? 0 : 1
  name                = local.mul_storage_name
  resource_group_name   = module.rg.name
}


resource "azurerm_storage_account" "function_storage_account" {
  count                     = var.create_new_storage_account ? 1 : 0
  name                      = local.mul_storage_name
  resource_group_name       = module.rg.name
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
    depends_on = [
    module.rg
  ]

}

resource "azurerm_app_service_plan" "mul_app_service_plan" {
  name                = local.mul_app_service_plan_name
  location            = var.azure_location
  resource_group_name       = module.rg.name
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
      depends_on = [
    module.rg
  ]

}

resource "azurerm_app_service_plan" "datadog_app_service_plan" {
  name                = local.datadog_app_service_plan_name
  location            = var.azure_location
  resource_group_name       = module.rg.name
  kind                = "elastic"
  tags                = var.tags

  sku {
    tier     = "ElasticPremium"
    size     = "EP2"
    capacity = 1
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

resource "azurerm_app_service_plan" "ai_app_service_plan" {
  name                = local.ai_app_service_plan_name
  location            = var.azure_location
  resource_group_name = module.ai_rg.name
  kind                = "linux"
  reserved            = true
  tags                = var.tags

  sku {
    tier     = "PremiumV2"
    size     = "P1v2"
    capacity = 1
  }

  lifecycle {
    ignore_changes = [
      tags["createdon"]
    ]
  }
}

resource "azurerm_application_insights" "insights" {
  name                = local.mul_app_service_plan_name
  location            = var.azure_location
  resource_group_name = module.rg.name
  application_type    = "web"
  tags                = var.tags

  lifecycle {
    ignore_changes = [
      tags["createdon"]
    ]
  }
      depends_on = [
    module.rg
  ]

}

resource "azurerm_application_insights" "data_dog_insights" {
  name                = local.datadog_app_insights_name
  location            = var.azure_location
  resource_group_name = module.rg.name
  application_type    = "web"
  tags                = var.tags

  lifecycle {
    ignore_changes = [
      tags["createdon"]
    ]
  }
      depends_on = [
    module.rg
  ]

}

resource "azurerm_application_insights" "ai_insights" {
  name                = local.ai_app_insights_name
  location            = var.azure_location
  resource_group_name = module.ai_rg.name
  application_type    = "web"
  tags                = var.tags

  lifecycle {
    ignore_changes = [
      tags["createdon"]
    ]
  }
}

resource "azurerm_function_app" "ai_function_app" {
 
  name                       = local.ai_function_app_name
  location                   = var.azure_location
  resource_group_name = module.ai_rg.name
  app_service_plan_id        = azurerm_app_service_plan.ai_app_service_plan.id
  storage_account_name       = local.ai_storage_name
  storage_account_access_key = var.create_new_storage_account ? azurerm_storage_account.function_storage_account[0].primary_access_key : data.azurerm_storage_account.existing_storage_account[0].primary_access_key
  version                    = "~3"
  tags                       = var.tags

  app_settings = {
    https_only                     = true
    FUNCTIONS_WORKER_RUNTIME       = "node"
    WEBSITE_NODE_DEFAULT_VERSION   = "~12"
    APPINSIGHTS_INSTRUMENTATIONKEY = azurerm_application_insights.ai_insights.instrumentation_key
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

resource "azurerm_function_app" "datadog_function_app" {
 
  name                       = local.datadog_function_app_name
  location                   = var.azure_location
  resource_group_name        = module.rg.name
  app_service_plan_id        = azurerm_app_service_plan.datadog_app_service_plan.id
  storage_account_name       = local.mul_storage_name
  storage_account_access_key = var.create_new_storage_account ? azurerm_storage_account.function_storage_account[0].primary_access_key : data.azurerm_storage_account.existing_storage_account[0].primary_access_key
  version                    = "~3"
  tags                       = var.tags

  app_settings = {
    https_only                     = true
    FUNCTIONS_WORKER_RUNTIME       = "node"
    WEBSITE_NODE_DEFAULT_VERSION   = "~12"
    APPINSIGHTS_INSTRUMENTATIONKEY = azurerm_application_insights.data_dog_insights.instrumentation_key
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

resource "azurerm_function_app" "data_replay_function_app" {
 
  name                       = local.mul_function_app_name
  location                   = var.azure_location
  resource_group_name        = module.rg.name
  app_service_plan_id        = azurerm_app_service_plan.mul_app_service_plan.id
  storage_account_name       = local.mul_storage_name
  storage_account_access_key = var.create_new_storage_account ? azurerm_storage_account.function_storage_account[0].primary_access_key : data.azurerm_storage_account.existing_storage_account[0].primary_access_key
  version                    = "~3"
  tags                       = var.tags

  app_settings = {
    https_only                     = true
    FUNCTIONS_WORKER_RUNTIME       = "node"
    WEBSITE_NODE_DEFAULT_VERSION   = "~12"
    APPINSIGHTS_INSTRUMENTATIONKEY = azurerm_application_insights.insights.instrumentation_key
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

resource "azurerm_function_app" "core_blue_function_app" {
 
  name                       = local.mul_core_blue_function_app_name
  location                   = var.azure_location
  resource_group_name        = module.rg.name
  app_service_plan_id        = azurerm_app_service_plan.mul_app_service_plan.id
  storage_account_name       = local.mul_storage_name
  storage_account_access_key = var.create_new_storage_account ? azurerm_storage_account.function_storage_account[0].primary_access_key : data.azurerm_storage_account.existing_storage_account[0].primary_access_key
  version                    = "~3"
  tags                       = var.tags

  app_settings = {
    https_only                     = true
    FUNCTIONS_WORKER_RUNTIME       = "node"
    WEBSITE_NODE_DEFAULT_VERSION   = "~12"
    APPINSIGHTS_INSTRUMENTATIONKEY = azurerm_application_insights.insights.instrumentation_key
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

resource "azurerm_function_app" "core_green_function_app" {
 
  name                       = local.mul_core_green_function_app_name
  location                   = var.azure_location
  resource_group_name        = module.rg.name
  app_service_plan_id        = azurerm_app_service_plan.mul_app_service_plan.id
  storage_account_name       = local.mul_storage_name
  storage_account_access_key = var.create_new_storage_account ? azurerm_storage_account.function_storage_account[0].primary_access_key : data.azurerm_storage_account.existing_storage_account[0].primary_access_key
  version                    = "~3"
  tags                       = var.tags

  app_settings = {
    https_only                     = true
    FUNCTIONS_WORKER_RUNTIME       = "node"
    WEBSITE_NODE_DEFAULT_VERSION   = "~12"
    APPINSIGHTS_INSTRUMENTATIONKEY = azurerm_application_insights.insights.instrumentation_key
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

resource "azurerm_function_app" "gql_gate_blue_function_app" {
 
  name                       = local.mul_gql_gate_blue_function_app_name
  location                   = var.azure_location
  resource_group_name        = module.rg.name
  app_service_plan_id        = azurerm_app_service_plan.mul_app_service_plan.id
  storage_account_name       = local.mul_storage_name
  storage_account_access_key = var.create_new_storage_account ? azurerm_storage_account.function_storage_account[0].primary_access_key : data.azurerm_storage_account.existing_storage_account[0].primary_access_key
  version                    = "~3"
  tags                       = var.tags

  app_settings = {
    https_only                     = true
    FUNCTIONS_WORKER_RUNTIME       = "node"
    WEBSITE_NODE_DEFAULT_VERSION   = "~12"
    APPINSIGHTS_INSTRUMENTATIONKEY = azurerm_application_insights.insights.instrumentation_key
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

resource "azurerm_function_app" "gql_gate_green_function_app" {
 
  name                       = local.mul_gql_gate_green_function_app_name
  location                   = var.azure_location
  resource_group_name        = module.rg.name
  app_service_plan_id        = azurerm_app_service_plan.mul_app_service_plan.id
  storage_account_name       = local.mul_storage_name
  storage_account_access_key = var.create_new_storage_account ? azurerm_storage_account.function_storage_account[0].primary_access_key : data.azurerm_storage_account.existing_storage_account[0].primary_access_key
  version                    = "~3"
  tags                       = var.tags

  app_settings = {
    https_only                     = true
    FUNCTIONS_WORKER_RUNTIME       = "node"
    WEBSITE_NODE_DEFAULT_VERSION   = "~12"
    APPINSIGHTS_INSTRUMENTATIONKEY = azurerm_application_insights.insights.instrumentation_key
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

resource "azurerm_function_app" "notifications_blue_function_app" {
 
  name                       = local.mul_notifications_blue_function_app_name
  location                   = var.azure_location
  resource_group_name        = module.rg.name
  app_service_plan_id        = azurerm_app_service_plan.mul_app_service_plan.id
  storage_account_name       = local.mul_storage_name
  storage_account_access_key = var.create_new_storage_account ? azurerm_storage_account.function_storage_account[0].primary_access_key : data.azurerm_storage_account.existing_storage_account[0].primary_access_key
  version                    = "~3"
  tags                       = var.tags

  app_settings = {
    https_only                     = true
    FUNCTIONS_WORKER_RUNTIME       = "node"
    WEBSITE_NODE_DEFAULT_VERSION   = "~12"
    APPINSIGHTS_INSTRUMENTATIONKEY = azurerm_application_insights.insights.instrumentation_key
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

resource "azurerm_function_app" "notifications_green_function_app" {
 
  name                       = local.mul_notifications_green_function_app_name
  location                   = var.azure_location
  resource_group_name        = module.rg.name
  app_service_plan_id        = azurerm_app_service_plan.mul_app_service_plan.id
  storage_account_name       = local.mul_storage_name
  storage_account_access_key = var.create_new_storage_account ? azurerm_storage_account.function_storage_account[0].primary_access_key : data.azurerm_storage_account.existing_storage_account[0].primary_access_key
  version                    = "~3"
  tags                       = var.tags

  app_settings = {
    https_only                     = true
    FUNCTIONS_WORKER_RUNTIME       = "node"
    WEBSITE_NODE_DEFAULT_VERSION   = "~12"
    APPINSIGHTS_INSTRUMENTATIONKEY = azurerm_application_insights.insights.instrumentation_key
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

resource "azurerm_function_app" "nui_blue_function_app" {
 
  name                       = local.mul_nui_blue_function_app_name
  location                   = var.azure_location
  resource_group_name        = module.rg.name
  app_service_plan_id        = azurerm_app_service_plan.mul_app_service_plan.id
  storage_account_name       = local.mul_storage_name
  storage_account_access_key = var.create_new_storage_account ? azurerm_storage_account.function_storage_account[0].primary_access_key : data.azurerm_storage_account.existing_storage_account[0].primary_access_key
  version                    = "~3"
  tags                       = var.tags

  app_settings = {
    https_only                     = true
    FUNCTIONS_WORKER_RUNTIME       = "node"
    WEBSITE_NODE_DEFAULT_VERSION   = "~12"
    APPINSIGHTS_INSTRUMENTATIONKEY = azurerm_application_insights.insights.instrumentation_key
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

resource "azurerm_function_app" "nui_green_function_app" {
 
  name                       = local.mul_nui_green_function_app_name
  location                   = var.azure_location
  resource_group_name        = module.rg.name
  app_service_plan_id        = azurerm_app_service_plan.mul_app_service_plan.id
  storage_account_name       = local.mul_storage_name
  storage_account_access_key = var.create_new_storage_account ? azurerm_storage_account.function_storage_account[0].primary_access_key : data.azurerm_storage_account.existing_storage_account[0].primary_access_key
  version                    = "~3"
  tags                       = var.tags

  app_settings = {
    https_only                     = true
    FUNCTIONS_WORKER_RUNTIME       = "node"
    WEBSITE_NODE_DEFAULT_VERSION   = "~12"
    APPINSIGHTS_INSTRUMENTATIONKEY = azurerm_application_insights.insights.instrumentation_key
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



resource "azurerm_app_service_virtual_network_swift_connection" "function_app1_VNET" {
  app_service_id = azurerm_function_app.data_replay_function_app.id
  subnet_id      = azurerm_subnet.mul_subnet02.id
}

resource "azurerm_app_service_virtual_network_swift_connection" "function_app2_VNET" {
  app_service_id = azurerm_function_app.core_blue_function_app.id
  subnet_id      = azurerm_subnet.mul_subnet02.id
}

resource "azurerm_app_service_virtual_network_swift_connection" "function_app3_VNET" {
  app_service_id = azurerm_function_app.core_green_function_app.id
  subnet_id      = azurerm_subnet.mul_subnet02.id
}

resource "azurerm_app_service_virtual_network_swift_connection" "function_app4_VNET" {
  app_service_id = azurerm_function_app.gql_gate_blue_function_app.id
  subnet_id      = azurerm_subnet.mul_subnet02.id
}

resource "azurerm_app_service_virtual_network_swift_connection" "function_app5_VNET" {
  app_service_id = azurerm_function_app.gql_gate_green_function_app.id
  subnet_id      = azurerm_subnet.mul_subnet02.id
}

resource "azurerm_app_service_virtual_network_swift_connection" "function_app6_VNET" {
  app_service_id = azurerm_function_app.nui_blue_function_app.id
  subnet_id      = azurerm_subnet.mul_subnet02.id
}

resource "azurerm_app_service_virtual_network_swift_connection" "function_app7_VNET" {
  app_service_id = azurerm_function_app.notifications_blue_function_app.id
  subnet_id      = azurerm_subnet.mul_subnet02.id
}

resource "azurerm_app_service_virtual_network_swift_connection" "function_app8_VNET" {
  app_service_id = azurerm_function_app.notifications_green_function_app.id
  subnet_id      = azurerm_subnet.mul_subnet02.id
}

resource "azurerm_app_service_virtual_network_swift_connection" "function_app9_VNET" {
  app_service_id = azurerm_function_app.nui_green_function_app.id
  subnet_id      = azurerm_subnet.mul_subnet02.id
}