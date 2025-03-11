# -------------------------------------------------------------------------------------------------
# Create the function app resources
data "azurerm_storage_account" "existing_storage_account1" {
  count               = var.create_new_storage_account ? 0 : 1
  name                = local.mul_storage_name
  resource_group_name = module.rg.name
}


resource "azurerm_storage_account" "function_storage_account" {
  name                            = local.mul_storage_name
  resource_group_name             = module.rg.name
  location                        = var.azure_location
  account_tier                    = "Standard"
  account_replication_type        = "LRS"
  enable_https_traffic_only       = true
  allow_nested_items_to_be_public = false
  min_tls_version                 = "TLS1_2"
  tags                            = var.tags

  lifecycle {
    ignore_changes = [
      tags["createdon"],
    ]
  }
  depends_on = [
    module.rg
  ]

}

resource "azurerm_storage_account" "linux_storage_account" {
  name                            = local.linux_storage_name
  resource_group_name             = module.lnx_rg.name
  location                        = var.azure_location
  account_tier                    = "Standard"
  account_replication_type        = "LRS"
  enable_https_traffic_only       = true
  allow_nested_items_to_be_public = false
  min_tls_version                 = "TLS1_2"
  tags                            = var.tags

  lifecycle {
    ignore_changes = [
      tags["createdon"],
    ]
  }
}

resource "azurerm_service_plan" "mul_app_service_plan" {
  name                = local.mul_app_service_plan_name
  resource_group_name = module.rg.name
  location            = var.azure_location
  os_type             = "Windows"
  sku_name            = "EP1"
  worker_count        = 1
  lifecycle {
    ignore_changes = [
      tags["createdon"]
    ]
  }

}

resource "azurerm_service_plan" "datadog_app_service_plan" {
  name                = local.datadog_app_service_plan_name
  resource_group_name = module.rg.name
  location            = var.azure_location
  os_type             = "Windows"
  sku_name            = "EP2"
  worker_count        = 1
  lifecycle {
    ignore_changes = [
      tags["createdon"]
    ]
  }

}

resource "azurerm_service_plan" "ai_app_service_plan" {
  name                = local.ai_app_service_plan_name
  resource_group_name = module.ai_rg.name
  location            = var.azure_location
  os_type             = "Linux"
  sku_name            = "EP2"
  worker_count        = 1
  lifecycle {
    ignore_changes = [
      tags["createdon"]
    ]
  }

}

resource "azurerm_service_plan" "lnx_app_service_plan" {
  name                = local.linux_app_service_plan_name
  resource_group_name = module.lnx_rg.name
  location            = var.azure_location
  os_type             = "Linux"
  sku_name            = "EP2"
  worker_count        = 2
  lifecycle {
    ignore_changes = [
      tags["createdon"]
    ]
  }

}


resource "azurerm_application_insights" "insights" {
  name                = local.mul_app_insights_name
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

resource "azurerm_application_insights" "linux_insights" {
  name                = local.linux_app_insights_name
  location            = var.azure_location
  resource_group_name = module.lnx_rg.name
  application_type    = "web"
  tags                = var.tags

  lifecycle {
    ignore_changes = [
      tags["createdon"]
    ]
  }
}

resource "azurerm_linux_function_app" "ai_function_app" {
  name                       = local.ai_function_app_name
  resource_group_name        = module.ai_rg.name
  location                   = var.azure_location
  storage_account_name       = azurerm_storage_account.function_storage_account.name
  storage_account_access_key = azurerm_storage_account.function_storage_account.primary_access_key
  service_plan_id            = azurerm_service_plan.ai_app_service_plan.id
  tags                       = var.tags
  https_only                 = true

  site_config {
    minimum_tls_version      = 1.2
    vnet_route_all_enabled   = true
    elastic_instance_minimum = 1
    application_stack {
      python_version = "3.7"
    }

  }
  app_settings = {
    https_only                     = true
    FUNCTIONS_WORKER_RUNTIME       = "python"
    WEBSITE_NODE_DEFAULT_VERSION   = "3.7"
    APPINSIGHTS_INSTRUMENTATIONKEY = azurerm_application_insights.ai_insights.instrumentation_key
    STORAGE_CONNECTION_STRING      = azurerm_storage_account.function_storage_account.primary_connection_string
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

resource "azurerm_linux_function_app" "linux_blue_function_app" {
  name                       = local.linux_blue_function_app_name
  resource_group_name        = module.lnx_rg.name
  location                   = var.azure_location
  storage_account_name       = azurerm_storage_account.linux_storage_account.name
  storage_account_access_key = azurerm_storage_account.linux_storage_account.primary_access_key
  service_plan_id            = azurerm_service_plan.lnx_app_service_plan.id
  tags                       = var.tags
  https_only                 = true

  site_config {
    minimum_tls_version      = 1.2
    vnet_route_all_enabled   = true
    elastic_instance_minimum = 1
    application_stack {
      node_version = "16"
    }

  }
  app_settings = {
    FUNCTIONS_EXTENSION_VERSION    = "~4"
    FUNCTIONS_WORKER_RUNTIME       = "node"
    WEBSITE_NODE_DEFAULT_VERSION   = "~16"
    APPINSIGHTS_INSTRUMENTATIONKEY = azurerm_application_insights.linux_insights.instrumentation_key
    STORAGE_CONNECTION_STRING      = azurerm_storage_account.linux_storage_account.primary_connection_string
    # With this setting we will force all outbound traffic through the VNet
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

resource "azurerm_linux_function_app" "linux_green_function_app" {
  name                       = local.linux_green_function_app_name
  resource_group_name        = module.lnx_rg.name
  location                   = var.azure_location
  storage_account_name       = azurerm_storage_account.linux_storage_account.name
  storage_account_access_key = azurerm_storage_account.linux_storage_account.primary_access_key
  service_plan_id            = azurerm_service_plan.lnx_app_service_plan.id
  tags                       = var.tags
  https_only                 = true

  site_config {
    minimum_tls_version      = 1.2
    vnet_route_all_enabled   = true
    elastic_instance_minimum = 1
    application_stack {
      node_version = "16"
    }

  }
  app_settings = {
    FUNCTIONS_EXTENSION_VERSION    = "~4"
    FUNCTIONS_WORKER_RUNTIME       = "node"
    WEBSITE_NODE_DEFAULT_VERSION   = "~16"
    APPINSIGHTS_INSTRUMENTATIONKEY = azurerm_application_insights.linux_insights.instrumentation_key
    STORAGE_CONNECTION_STRING      = azurerm_storage_account.linux_storage_account.primary_connection_string
    # With this setting we will force all outbound traffic through the VNet
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

resource "azurerm_windows_function_app" "datadog_function_app" {
  name                       = local.datadog_function_app_name
  resource_group_name        = module.rg.name
  location                   = var.azure_location
  storage_account_name       = azurerm_storage_account.function_storage_account.name
  storage_account_access_key = azurerm_storage_account.function_storage_account.primary_access_key
  service_plan_id            = azurerm_service_plan.datadog_app_service_plan.id
  tags                       = var.tags
  https_only                 = true

  site_config {
    minimum_tls_version      = 1.2
    vnet_route_all_enabled   = true
    elastic_instance_minimum = 1
    application_stack {
      node_version = "~14"
    }

  }
  app_settings = {
    FUNCTIONS_EXTENSION_VERSION    = "~3"
    FUNCTIONS_WORKER_RUNTIME       = "node"
    WEBSITE_NODE_DEFAULT_VERSION   = "~16"
    APPINSIGHTS_INSTRUMENTATIONKEY = azurerm_application_insights.data_dog_insights.instrumentation_key
    STORAGE_CONNECTION_STRING      = azurerm_storage_account.function_storage_account.primary_connection_string
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

resource "azurerm_windows_function_app" "data_replay_function_app" {
  name                        = local.mul_function_app_name
  resource_group_name         = module.rg.name
  location                    = var.azure_location
  storage_account_name        = azurerm_storage_account.function_storage_account.name
  storage_account_access_key  = azurerm_storage_account.function_storage_account.primary_access_key
  service_plan_id             = azurerm_service_plan.mul_app_service_plan.id
  functions_extension_version = "~3"
  tags                        = var.tags
  https_only                  = true

  site_config {
    minimum_tls_version      = 1.2
    vnet_route_all_enabled   = true
    elastic_instance_minimum = 1
    application_stack {
      node_version = "~16"
    }

  }
  app_settings = {
    FUNCTIONS_EXTENSION_VERSION = "~4"

    https_only                     = true
    FUNCTIONS_WORKER_RUNTIME       = "node"
    WEBSITE_NODE_DEFAULT_VERSION   = "~16"
    APPINSIGHTS_INSTRUMENTATIONKEY = azurerm_application_insights.insights.instrumentation_key
    STORAGE_CONNECTION_STRING      = azurerm_storage_account.function_storage_account.primary_connection_string
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


resource "azurerm_windows_function_app" "core_blue_function_app" {
  name                       = local.mul_core_blue_function_app_name
  resource_group_name        = module.rg.name
  location                   = var.azure_location
  storage_account_name       = azurerm_storage_account.function_storage_account.name
  storage_account_access_key = azurerm_storage_account.function_storage_account.primary_access_key
  service_plan_id            = azurerm_service_plan.mul_app_service_plan.id
  tags                       = var.tags
  https_only                 = true

  site_config {
    minimum_tls_version      = 1.2
    vnet_route_all_enabled   = true
    elastic_instance_minimum = 1
    application_stack {
      node_version = "~16"
    }

  }
  app_settings = {
    FUNCTIONS_EXTENSION_VERSION    = "~4"
    FUNCTIONS_WORKER_RUNTIME       = "node"
    WEBSITE_NODE_DEFAULT_VERSION   = "~16"
    APPINSIGHTS_INSTRUMENTATIONKEY = azurerm_application_insights.insights.instrumentation_key
    STORAGE_CONNECTION_STRING      = azurerm_storage_account.function_storage_account.primary_connection_string
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

resource "azurerm_windows_function_app" "core_green_function_app" {
  name                       = local.mul_core_green_function_app_name
  resource_group_name        = module.rg.name
  location                   = var.azure_location
  storage_account_name       = azurerm_storage_account.function_storage_account.name
  storage_account_access_key = azurerm_storage_account.function_storage_account.primary_access_key
  service_plan_id            = azurerm_service_plan.mul_app_service_plan.id
  tags                       = var.tags
  https_only                 = true

  site_config {
    minimum_tls_version      = 1.2
    vnet_route_all_enabled   = true
    elastic_instance_minimum = 1
    application_stack {
      node_version = "~16"
    }

  }
  app_settings = {
    FUNCTIONS_EXTENSION_VERSION    = "~4"
    FUNCTIONS_WORKER_RUNTIME       = "node"
    WEBSITE_NODE_DEFAULT_VERSION   = "~16"
    APPINSIGHTS_INSTRUMENTATIONKEY = azurerm_application_insights.insights.instrumentation_key
    STORAGE_CONNECTION_STRING      = azurerm_storage_account.function_storage_account.primary_connection_string
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

resource "azurerm_windows_function_app" "gql_gate_blue_function_app" {
  name                       = local.mul_gql_gate_blue_function_app_name
  resource_group_name        = module.rg.name
  location                   = var.azure_location
  storage_account_name       = azurerm_storage_account.function_storage_account.name
  storage_account_access_key = azurerm_storage_account.function_storage_account.primary_access_key
  service_plan_id            = azurerm_service_plan.mul_app_service_plan.id
  tags                       = var.tags
  https_only                 = true

  site_config {
    minimum_tls_version      = 1.2
    vnet_route_all_enabled   = true
    elastic_instance_minimum = 1
    application_stack {
      node_version = "~16"
    }

  }
  app_settings = {
    FUNCTIONS_EXTENSION_VERSION    = "~4"
    FUNCTIONS_WORKER_RUNTIME       = "node"
    WEBSITE_NODE_DEFAULT_VERSION   = "~16"
    APPINSIGHTS_INSTRUMENTATIONKEY = azurerm_application_insights.insights.instrumentation_key
    STORAGE_CONNECTION_STRING      = azurerm_storage_account.function_storage_account.primary_connection_string
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

resource "azurerm_windows_function_app" "gql_gate_green_function_app" {
  name                       = local.mul_gql_gate_green_function_app_name
  resource_group_name        = module.rg.name
  location                   = var.azure_location
  storage_account_name       = azurerm_storage_account.function_storage_account.name
  storage_account_access_key = azurerm_storage_account.function_storage_account.primary_access_key
  service_plan_id            = azurerm_service_plan.mul_app_service_plan.id
  tags                       = var.tags
  https_only                 = true

  site_config {
    minimum_tls_version      = 1.2
    vnet_route_all_enabled   = true
    elastic_instance_minimum = 1
    application_stack {
      node_version = "~16"
    }

  }
  app_settings = {
    FUNCTIONS_EXTENSION_VERSION    = "~4"
    FUNCTIONS_WORKER_RUNTIME       = "node"
    WEBSITE_NODE_DEFAULT_VERSION   = "~16"
    APPINSIGHTS_INSTRUMENTATIONKEY = azurerm_application_insights.insights.instrumentation_key
    STORAGE_CONNECTION_STRING      = azurerm_storage_account.function_storage_account.primary_connection_string
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

resource "azurerm_windows_function_app" "notifications_blue_function_app" {
  name                       = local.mul_notifications_blue_function_app_name
  resource_group_name        = module.rg.name
  location                   = var.azure_location
  storage_account_name       = azurerm_storage_account.function_storage_account.name
  storage_account_access_key = azurerm_storage_account.function_storage_account.primary_access_key
  service_plan_id            = azurerm_service_plan.mul_app_service_plan.id
  tags                       = var.tags
  https_only                 = true

  site_config {
    minimum_tls_version      = 1.2
    vnet_route_all_enabled   = true
    elastic_instance_minimum = 1
    application_stack {
      node_version = "~16"
    }

  }
  app_settings = {
    FUNCTIONS_EXTENSION_VERSION    = "~4"
    FUNCTIONS_WORKER_RUNTIME       = "node"
    WEBSITE_NODE_DEFAULT_VERSION   = "~16"
    APPINSIGHTS_INSTRUMENTATIONKEY = azurerm_application_insights.insights.instrumentation_key
    STORAGE_CONNECTION_STRING      = azurerm_storage_account.function_storage_account.primary_connection_string
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

resource "azurerm_windows_function_app" "notifications_green_function_app" {
  name                       = local.mul_notifications_green_function_app_name
  resource_group_name        = module.rg.name
  location                   = var.azure_location
  storage_account_name       = azurerm_storage_account.function_storage_account.name
  storage_account_access_key = azurerm_storage_account.function_storage_account.primary_access_key
  service_plan_id            = azurerm_service_plan.mul_app_service_plan.id
  tags                       = var.tags
  https_only                 = true

  site_config {
    minimum_tls_version    = 1.2
    vnet_route_all_enabled = true
    application_stack {
      node_version = "~16"
    }

  }
  app_settings = {
    FUNCTIONS_EXTENSION_VERSION    = "~4"
    FUNCTIONS_WORKER_RUNTIME       = "node"
    WEBSITE_NODE_DEFAULT_VERSION   = "~16"
    APPINSIGHTS_INSTRUMENTATIONKEY = azurerm_application_insights.insights.instrumentation_key
    STORAGE_CONNECTION_STRING      = azurerm_storage_account.function_storage_account.primary_connection_string
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

resource "azurerm_windows_function_app" "nui_blue_function_app" {
  name                       = local.mul_nui_blue_function_app_name
  resource_group_name        = module.rg.name
  location                   = var.azure_location
  storage_account_name       = azurerm_storage_account.function_storage_account.name
  storage_account_access_key = azurerm_storage_account.function_storage_account.primary_access_key
  service_plan_id            = azurerm_service_plan.mul_app_service_plan.id
  tags                       = var.tags
  https_only                 = true

  site_config {
    minimum_tls_version      = 1.2
    vnet_route_all_enabled   = true
    elastic_instance_minimum = 1
    application_stack {
      node_version = "~16"
    }

  }
  app_settings = {
    FUNCTIONS_EXTENSION_VERSION    = "~4"
    FUNCTIONS_WORKER_RUNTIME       = "node"
    WEBSITE_NODE_DEFAULT_VERSION   = "~16"
    APPINSIGHTS_INSTRUMENTATIONKEY = azurerm_application_insights.insights.instrumentation_key
    STORAGE_CONNECTION_STRING      = azurerm_storage_account.function_storage_account.primary_connection_string
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

resource "azurerm_windows_function_app" "nui_green_function_app" {
  name                        = local.mul_nui_green_function_app_name
  resource_group_name         = module.rg.name
  location                    = var.azure_location
  storage_account_name        = azurerm_storage_account.function_storage_account.name
  storage_account_access_key  = azurerm_storage_account.function_storage_account.primary_access_key
  service_plan_id             = azurerm_service_plan.mul_app_service_plan.id
  functions_extension_version = "~4"
  tags                        = var.tags
  https_only                  = true

  site_config {
    minimum_tls_version      = 1.2
    vnet_route_all_enabled   = true
    elastic_instance_minimum = 1
    application_stack {
      node_version = "~16"
    }

  }
  app_settings = {
    FUNCTIONS_EXTENSION_VERSION    = "~4"
    FUNCTIONS_WORKER_RUNTIME       = "node"
    WEBSITE_NODE_DEFAULT_VERSION   = "~16"
    APPINSIGHTS_INSTRUMENTATIONKEY = azurerm_application_insights.insights.instrumentation_key
    STORAGE_CONNECTION_STRING      = azurerm_storage_account.function_storage_account.primary_connection_string
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
  app_service_id = azurerm_windows_function_app.data_replay_function_app.id
  subnet_id      = azurerm_subnet.mul_subnet01.id
}

resource "azurerm_app_service_virtual_network_swift_connection" "function_app2_VNET" {
  app_service_id = azurerm_windows_function_app.core_blue_function_app.id
  subnet_id      = azurerm_subnet.mul_subnet01.id
}

resource "azurerm_app_service_virtual_network_swift_connection" "function_app3_VNET" {
  app_service_id = azurerm_windows_function_app.core_green_function_app.id
  subnet_id      = azurerm_subnet.mul_subnet01.id
}

resource "azurerm_app_service_virtual_network_swift_connection" "function_app4_VNET" {
  app_service_id = azurerm_windows_function_app.gql_gate_blue_function_app.id
  subnet_id      = azurerm_subnet.mul_subnet01.id
}

resource "azurerm_app_service_virtual_network_swift_connection" "function_app5_VNET" {
  app_service_id = azurerm_windows_function_app.gql_gate_green_function_app.id
  subnet_id      = azurerm_subnet.mul_subnet01.id
}

resource "azurerm_app_service_virtual_network_swift_connection" "function_app6_VNET" {
  app_service_id = azurerm_windows_function_app.nui_blue_function_app.id
  subnet_id      = azurerm_subnet.mul_subnet01.id
}

resource "azurerm_app_service_virtual_network_swift_connection" "function_app6b_VNET" {
  app_service_id = azurerm_windows_function_app.nui_green_function_app.id
  subnet_id      = azurerm_subnet.mul_subnet01.id
}

resource "azurerm_app_service_virtual_network_swift_connection" "function_app7_VNET" {
  app_service_id = azurerm_windows_function_app.notifications_blue_function_app.id
  subnet_id      = azurerm_subnet.mul_subnet01.id
}

resource "azurerm_app_service_virtual_network_swift_connection" "function_app8_VNET" {
  app_service_id = azurerm_windows_function_app.notifications_green_function_app.id
  subnet_id      = azurerm_subnet.mul_subnet01.id
}

resource "azurerm_app_service_virtual_network_swift_connection" "function_app10_VNET" {
  app_service_id = azurerm_linux_function_app.ai_function_app.id
  subnet_id      = azurerm_subnet.mul_subnet02.id
}

resource "azurerm_app_service_virtual_network_swift_connection" "function_app11_VNET" {
  app_service_id = azurerm_linux_function_app.linux_blue_function_app.id
  subnet_id      = azurerm_subnet.mul_subnet03.id
}

resource "azurerm_app_service_virtual_network_swift_connection" "function_app12_VNET" {
  app_service_id = azurerm_linux_function_app.linux_green_function_app.id
  subnet_id      = azurerm_subnet.mul_subnet03.id
}

resource "azurerm_app_service_virtual_network_swift_connection" "function_app13_VNET" {
  app_service_id = azurerm_windows_function_app.datadog_function_app.id
  subnet_id      = azurerm_subnet.mul_subnet04.id
}
