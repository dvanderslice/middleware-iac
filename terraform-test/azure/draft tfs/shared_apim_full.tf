# -------------------------------------------------------------------------------------------------
# Create the shared network for premium API management
module "shared_rg" {
  source = "../modules/rg"

  azure_location      = var.azure_location
  resource_group_name = local.shared_resource_group_name

  tags = merge(local.resource_tags, {
    "environment" = var.env_name
    "role"        = "api"
    "createdon"   = local.tag_createdon
  })
}

resource "azurerm_virtual_network" "shared_vnet" {
  name                = local.shared_vnet_name
  address_space       = [module.vnet_addrs.networks[1].cidr_block]
  location            = var.azure_location
  resource_group_name = module.shared_rg.name

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

module "shared_subnet_addrs" {
  source = "../modules/cidr-subnets"

  base_cidr_block = module.vnet_addrs.networks[1].cidr_block
  networks = [
   # {
    #  name     = "reserved"
     # new_bits = 8
    #},
    {
      name     = "subnet01"
      new_bits = 2
    }
  ]
}

resource "azurerm_network_security_group" "shared_APIM_subnet_NSG" {
  name                = local.apim_nsg_name
  location            = var.azure_location
  resource_group_name = module.shared_rg.name
}
resource "azurerm_network_security_rule" "apim-client-communications" {
    name                       = "apim-client-communications-inbound"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_ranges     = [443, 80, 3443]
    source_address_prefix      = "Internet"
    destination_address_prefix = "VirtualNetwork"
  resource_group_name = module.shared_rg.name
  network_security_group_name = azurerm_network_security_group.shared_APIM_subnet_NSG.name
}

resource "azurerm_network_security_rule" "apim-management" {
    name                       = "apim-management"
    priority                   = 120
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = 3443
    source_address_prefix      = "ApiManagement"
    destination_address_prefix = "VirtualNetwork"
  resource_group_name = module.shared_rg.name
  network_security_group_name = azurerm_network_security_group.shared_APIM_subnet_NSG.name
}

resource "azurerm_network_security_rule" "apim-premium_ilb" {
    name                       = "apim-premium-ilb"
    priority                   = 130
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = 6390
    source_address_prefix      = "AzureLoadBalancer"
    destination_address_prefix = "VirtualNetwork"
  resource_group_name = module.shared_rg.name
  network_security_group_name = azurerm_network_security_group.shared_APIM_subnet_NSG.name
}
resource "azurerm_subnet" "shared_subnet01" {
  name                 = "shared_subnet01"
  resource_group_name  = module.shared_rg.name
  virtual_network_name = azurerm_virtual_network.shared_vnet.name
  address_prefixes     = [module.shared_subnet_addrs.networks[0].cidr_block]

  # Search for "Force Tunneling Traffic to On-premises Firewall Using Express Route or Network Virtual Appliance" in:
  # https://docs.microsoft.com/en-us/azure/api-management/api-management-using-with-vnet#-common-network-configuration-issues
  service_endpoints = ["Microsoft.Storage", "Microsoft.EventHub", "Microsoft.Sql", "Microsoft.KeyVault"]
}

resource "azurerm_subnet_network_security_group_association" "shared_apim_NSG" {
  subnet_id                 = azurerm_subnet.shared_subnet01.id
  network_security_group_id = azurerm_network_security_group.shared_APIM_subnet_NSG.id
}

resource "azurerm_api_management" "apim-external" {

  name                 = local.apim_name
  location             = var.azure_location
  resource_group_name  = module.shared_rg.name
  publisher_name       = "Dematic Digital Solutions"
  publisher_email      = "digitalsolutions-rd@dematic.com"
  sku_name             = local.apim_sku
  tags                 = var.tags
  virtual_network_type = "External"


  virtual_network_configuration {
    subnet_id = azurerm_subnet.shared_subnet01.id
  }

  lifecycle {
    ignore_changes = [
      tags["createdon"]
    ]
  }
}


resource "azurerm_api_management_api" "alert-api-apim" {
  name                = "alert-api"
  resource_group_name    = module.shared_rg.name
  api_management_name = azurerm_api_management.apim-external.name
  description = "alert Service service endpoint"
  subscription_required = false
  revision            = "1"
  display_name        = "alert API"
  path                = "alerts"
  protocols           = ["https"]

}

resource "azurerm_api_management_api" "analytics-blue-api-apim" {
  name                = "analytics-blue-api"
  resource_group_name    = module.shared_rg.name
  api_management_name = azurerm_api_management.apim-external.name
  description = "Core endpoint"
  subscription_required = false
  revision            = "1"
  display_name        =  "analytics-blue"
  path                = "blue/analytics"
  protocols           = ["https"]

}

resource "azurerm_api_management_api" "analytics-green-api-apim" {
  name                = "analytics-green-api"
  resource_group_name    = module.shared_rg.name
  api_management_name = azurerm_api_management.apim-external.name
  description = "Core endpoint"
  subscription_required = false
  revision            = "1"
  display_name        =  "analytics-green"
  path                = "green/analytics"
  protocols           = ["https"]

}

resource "azurerm_api_management_api" "audit-logs-api-apim" {
  name                = "audit-logs-api"
  resource_group_name    = module.shared_rg.name
  api_management_name = azurerm_api_management.apim-external.name
  description = "Audit log service endpoint"
  subscription_required = false
  revision            = "1"
  display_name        = "Audit logs API"
  path                = "auditLogs"
  protocols           = ["https"]

}

resource "azurerm_api_management_api" "auth-blue-api-apim" {
  name                = "auth-blue-api"
  resource_group_name    = module.shared_rg.name
  api_management_name = azurerm_api_management.apim-external.name
  description = "Auth REST API"
  subscription_required = false
  revision            = "1"
  display_name        = "auth-blue"
  path                = "blue/auth"
  protocols           = ["https"]

}

resource "azurerm_api_management_api" "auth-green-api-apim" {
  name                = "auth-green-api"
  resource_group_name    = module.shared_rg.name
  api_management_name = azurerm_api_management.apim-external.name
  description = "Auth REST API"
  subscription_required = false
  revision            = "1"
  display_name        = "auth-green"
  path                = "green/auth"
  protocols           = ["https"]

}

resource "azurerm_api_management_backend" "auth-blue-backend" {
  name                = "auth-blue-backend"
  resource_group_name = module.shared_rg.name
  api_management_name = azurerm_api_management.apim-external.name
  protocol            = "http"
  url                 = local.auth_blue_url

  credentials {
    header = {
      "x-functions-key" =  "{{auth-blue-key}}"
    }

  }
}

resource "azurerm_api_management_backend" "auth-green-backend" {
  name                = "auth-green-backend"
  resource_group_name = module.shared_rg.name
  api_management_name = azurerm_api_management.apim-external.name
  protocol            = "http"
  url                 = local.auth_green_url

  credentials {
    header = {
      "x-functions-key" =  "{{auth-green-key}}"
    }

  }
}

resource "azurerm_api_management_api" "config-api" {
  name                = "config-api"
  resource_group_name    = module.shared_rg.name
  api_management_name = azurerm_api_management.apim-external.name
  description = "IoT Config service endpoint"
  subscription_required = false
  revision            = "1"
  display_name        = "IoT Config API"
  path                = "config"
  protocols           = ["https"]

}

resource "azurerm_api_management_api" "core-blue-api" {
  name                = "core-blue-api"
  resource_group_name    = module.shared_rg.name
  api_management_name = azurerm_api_management.apim-external.name
  description = "Core endpoint"
  subscription_required = false
  revision            = "1"
  display_name        = "core-blue"
  path                = "blue/core"
  protocols           = ["https"]

}

resource "azurerm_api_management_api" "core-green-api" {
  name                = "core-green-api"
  resource_group_name    = module.shared_rg.name
  api_management_name = azurerm_api_management.apim-external.name
  description = "Core endpoint"
  subscription_required = false
  revision            = "1"
  display_name        = "core-green"
  path                = "green/core"
  protocols           = ["https"]

}

resource "azurerm_api_management_api" "dataviews-api" {
  name                = "dataviews-api"
  resource_group_name    = module.shared_rg.name
  api_management_name = azurerm_api_management.apim-external.name
  description = "Dataview service endpoint"
  subscription_required = false
  revision            = "1"
  display_name        = "Dataview API"
  path                = "dataviews"
  protocols           = ["https"]

}

resource "azurerm_api_management_api" "device-provision-blue" {
  name                = "device-provision-blue"
  resource_group_name    = module.shared_rg.name
  api_management_name = azurerm_api_management.apim-external.name
  description = "Linux Blue Function"
  subscription_required = false
  revision            = "1"
  display_name        = "device-provision-blue"
  path                = "blue/api"
  protocols           = ["https"]

}

resource "azurerm_api_management_api" "device-provision-green" {
  name                = "device-provision-green"
  resource_group_name    = module.shared_rg.name
  api_management_name = azurerm_api_management.apim-external.name
  description = "Linux Green Function"
  subscription_required = false
  revision            = "1"
  display_name        = "device-provision-green"
  path                = "green/api"
  protocols           = ["https"]

}

resource "azurerm_api_management_api" "equipment-rules-api" {
  name                = "equipment-rules-api"
  resource_group_name    = module.shared_rg.name
  api_management_name = azurerm_api_management.apim-external.name
  description = "Equipment rules service endpoint"
  subscription_required = false
  revision            = "1"
  display_name        = "Equipment Rules API"
  path                = "equipmentRules"
  protocols           = ["https"]

}

resource "azurerm_api_management_api" "equipments-blue-api" {
  name                = "equipments-blue-api"
  resource_group_name    = module.shared_rg.name
  api_management_name = azurerm_api_management.apim-external.name
  description = "Equipment service endpoint"
  subscription_required = false
  revision            = "1"
  display_name        = "equipment-blue"
  path                = "blue/equipments"
  protocols           = ["https"]

}

resource "azurerm_api_management_api" "equipments-green-api" {
  name                = "equipments-green-api"
  resource_group_name    = module.shared_rg.name
  api_management_name = azurerm_api_management.apim-external.name
  description = "Equipment service endpoint"
  subscription_required = false
  revision            = "1"
  display_name        = "equipment-green"
  path                = "green/equipments"
  protocols           = ["https"]

}

resource "azurerm_api_management_api" "event-api" {
  name                = "event-api"
  resource_group_name    = module.shared_rg.name
  api_management_name = azurerm_api_management.apim-external.name
  description = "Event Service service endpoint"
  subscription_required = false
  revision            = "1"
  display_name        = "Event API"
  path                = "events"
  protocols           = ["https"]

}

resource "azurerm_api_management_api" "gateways-api" {
  name                = "gateways-api"
  resource_group_name    = module.shared_rg.name
  api_management_name = azurerm_api_management.apim-external.name
  description = "Gateway service endpoint"
  subscription_required = false
  revision            = "1"
  display_name        = "Gateway API"
  path                = "gateways"
  protocols           = ["https"]

}

resource "azurerm_api_management_api" "graphql-blue-api" {
  name                = "graphql-blue-api"
  resource_group_name    = module.shared_rg.name
  api_management_name = azurerm_api_management.apim-external.name
  description = "GraphQL API"
  subscription_required = false
  revision            = "1"
  display_name        = "graphql-blue"
  path                = "blue/graphql"
  protocols           = ["https"]

}

resource "azurerm_api_management_api" "graphql-green-api" {
  name                = "graphql-green-api"
  resource_group_name    = module.shared_rg.name
  api_management_name = azurerm_api_management.apim-external.name
  description = "GraphQL API"
  subscription_required = false
  revision            = "1"
  display_name        = "graphql-green"
  path                = "green/graphql"
  protocols           = ["https"]

}

resource "azurerm_api_management_api" "navigation-blue-api" {
  name                = "navigation-blue-api"
  resource_group_name    = module.shared_rg.name
  api_management_name = azurerm_api_management.apim-external.name
  description = "Navigation service endpoint"
  subscription_required = false
  revision            = "1"
  display_name        = "navigation-blue"
  path                = "blue/navigation"
  protocols           = ["https"]

}

resource "azurerm_api_management_api" "navigation-green-api" {
  name                = "navigation-green-api"
  resource_group_name    = module.shared_rg.name
  api_management_name = azurerm_api_management.apim-external.name
  description = "Navigation service endpoint"
  subscription_required = false
  revision            = "1"
  display_name        = "navigation-green"
  path                = "green/navigation"
  protocols           = ["https"]

}

resource "azurerm_api_management_api" "notification-blue-api" {
  name                = "notification-blue-api"
  resource_group_name    = module.shared_rg.name
  api_management_name = azurerm_api_management.apim-external.name
  description = "Foundations Notification REST API"
  subscription_required = false
  revision            = "1"
  display_name        = "notification-blue"
  path                = "blue/notification"
  protocols           = ["https"]

}

resource "azurerm_api_management_api" "notification-green-api" {
  name                = "notification-green-api"
  resource_group_name    = module.shared_rg.name
  api_management_name = azurerm_api_management.apim-external.name
  description = "Foundations Notification REST API"
  subscription_required = false
  revision            = "1"
  display_name        = "notification-green"
  path                = "green/notification"
  protocols           = ["https"]

}

resource "azurerm_api_management_api" "partner-blue-api" {
  name                = "partner-blue-api"
  resource_group_name    = module.shared_rg.name
  api_management_name = azurerm_api_management.apim-external.name
  description = "Partner service endpoint"
  subscription_required = false
  revision            = "1"
  display_name        = "partner-blue"
  path                = "blue/partner"
  protocols           = ["https"]

}

resource "azurerm_api_management_api" "partner-green-api" {
  name                = "partner-green-api"
  resource_group_name    = module.shared_rg.name
  api_management_name = azurerm_api_management.apim-external.name
  description = "Partner service endpoint"
  subscription_required = false
  revision            = "1"
  display_name        = "partner-green"
  path                = "green/partner"
  protocols           = ["https"]

}

resource "azurerm_api_management_api" "rule-api" {
  name                = "rule-api"
  resource_group_name    = module.shared_rg.name
  api_management_name = azurerm_api_management.apim-external.name
  description = "rule Service service endpoint"
  subscription_required = false
  revision            = "1"
  display_name        = "rule API"
  path                = "rules"
  protocols           = ["https"]

}

resource "azurerm_api_management_api" "team-api" {
  name                = "team-api"
  resource_group_name    = module.shared_rg.name
  api_management_name = azurerm_api_management.apim-external.name
  description = "team Service service endpoint"
  subscription_required = false
  revision            = "1"
  display_name        = "team API"
  path                = "teams"
  protocols           = ["https"]

}

resource "azurerm_api_management_api" "users-blue-api" {
  name                = "users-blue-api"
  resource_group_name    = module.shared_rg.name
  api_management_name = azurerm_api_management.apim-external.name
  description = "Users service endpoint"
  subscription_required = false
  revision            = "1"
  display_name        = "users-blue"
  path                = "blue/users"
  protocols           = ["https"]

}

resource "azurerm_api_management_api" "users-green-api" {
  name                = "users-green-api"
  resource_group_name    = module.shared_rg.name
  api_management_name = azurerm_api_management.apim-external.name
  description = "Users service endpoint"
  subscription_required = false
  revision            = "1"
  display_name        = "users-green"
  path                = "green/users"
  protocols           = ["https"]

}

resource "azurerm_api_management_api" "validations-blue-api" {
  name                = "validations-blue-api"
  resource_group_name    = module.shared_rg.name
  api_management_name = azurerm_api_management.apim-external.name
  description = "Validations service endpoint"
  subscription_required = false
  revision            = "1"
  display_name        = "validation-blue"
  path                = "blue/validations"
  protocols           = ["https"]

}

resource "azurerm_api_management_api" "validations-green-api" {
  name                = "validations-green-api"
  resource_group_name    = module.shared_rg.name
  api_management_name = azurerm_api_management.apim-external.name
  description = "Validations service endpoint"
  subscription_required = false
  revision            = "1"
  display_name        = "validation-green"
  path                = "green/validations"
  protocols           = ["https"]

}

##Named Values - Depends on Functions

#Function Import

data "azurerm_function_app" "auth-blue-function-key" {
  name                = azurerm_function_app.auth_function_app_blue.name
  resource_group_name = module.auth_rg.name
}

data "azurerm_function_app" "auth-green-function-key" {
  name                = azurerm_function_app.auth_function_app_green.name
  resource_group_name = module.auth_rg.name
}

data "azurerm_function_app" "core-blue-function-key" {
  name                = azurerm_function_app.core_blue_function_app.name
  resource_group_name = module.rg.name
}

data "azurerm_function_app" "core-green-function-key" {
  name                = azurerm_function_app.core_green_function_app.name
  resource_group_name = module.rg.name
}

data "azurerm_function_app" "gql-gate-blue-function-key" {
  name                = azurerm_function_app.gql_gate_blue_function_app.name
  resource_group_name = module.rg.name
}

data "azurerm_function_app" "gql-gate-green-function-key" {
  name                = azurerm_function_app.gql_gate_green_function_app.name
  resource_group_name = module.rg.name
}

data "azurerm_function_app" "notifications-blue-function-key" {
  name                = azurerm_function_app.notifications_blue_function_app.name
  resource_group_name = module.rg.name
}

data "azurerm_function_app" "notifications-green-function-key" {
  name                = azurerm_function_app.notifications_blue_function_app.name
  resource_group_name = module.rg.name
}

resource "azurerm_api_management_named_value" "auth-AmazonNA-key" {
  name                = "auth-AmazonNA-key"
  resource_group_name = module.shared_rg.name
  api_management_name = azurerm_api_management.apim-external.name
  display_name        = "auth-amazonna-key"
  value               = data.azurerm_function_app.auth-blue-function-key.connection_string[0].value
}

resource "azurerm_api_management_named_value" "auth-crocs-key" {
  name                = "auth-Crocs-key"
  resource_group_name = module.shared_rg.name
  api_management_name = azurerm_api_management.apim-external.name
  display_name        = "auth-Crocs-key"
  value               = data.azurerm_function_app.auth-blue-function-key.connection_string[0].value
}

resource "azurerm_api_management_named_value" "auth-demo2-key" {
  name                = "auth-demo2-key"
  resource_group_name = module.shared_rg.name
  api_management_name = azurerm_api_management.apim-external.name
  display_name        = "auth-demo2-key"
  value               = data.azurerm_function_app.auth-blue-function-key.connection_string[0].value
}

resource "azurerm_api_management_named_value" "auth-demo-key" {
  name                = "auth-demo-key"
  resource_group_name = module.shared_rg.name
  api_management_name = azurerm_api_management.apim-external.name
  display_name        = "auth-demo-key"
  value               = data.azurerm_function_app.auth-blue-function-key.connection_string[0].value
}

resource "azurerm_api_management_named_value" "auth-blue-key" {
  name                = "auth-blue-key"
  resource_group_name = module.shared_rg.name
  api_management_name = azurerm_api_management.apim-external.name
  display_name        = "auth-blue-key"
  value               = data.azurerm_function_app.auth-blue-function-key.connection_string[0].value
}

resource "azurerm_api_management_named_value" "auth-green-key" {
  name                = "auth-green-key"
  resource_group_name = module.shared_rg.name
  api_management_name = azurerm_api_management.apim-external.name
  display_name        = "auth-green-key"
  value               = data.azurerm_function_app.auth-green-function-key.connection_string[0].value
}

resource "azurerm_api_management_named_value" "core-blue-key" {
  name                = "core-blue-key"
  resource_group_name = module.shared_rg.name
  api_management_name = azurerm_api_management.apim-external.name
  display_name        = "core-blue-key"
  value               = data.azurerm_function_app.core-blue-function-key.connection_string[0].value
}

resource "azurerm_api_management_named_value" "core-green-key" {
  name                = "core-green-key"
  resource_group_name = module.shared_rg.name
  api_management_name = azurerm_api_management.apim-external.name
  display_name        = "core-green-key"
  value               = data.azurerm_function_app.core-green-function-key.connection_string[0].value
}

resource "azurerm_api_management_named_value" "frontdoor-id" {
  name                = "frontdoor-id"
  resource_group_name = module.shared_rg.name
  api_management_name = azurerm_api_management.apim-external.name
  display_name        = "frontdoor-id"
  value               = "bc90661f-27f0-4c1a-af0d-9f494eb6fb36"
}

resource "azurerm_api_management_named_value" "frontdoor-id-prem" {
  name                = "frontdoor-id-prem"
  resource_group_name = module.shared_rg.name
  api_management_name = azurerm_api_management.apim-external.name
  display_name        = "frontdoor-id-prem"
  value               = "bc90661f-27f0-4c1a-af0d-9f494eb6fb36"
}

resource "azurerm_api_management_named_value" "gql-gate-blue-key" {
  name                = "gql-gate-blue-key"
  resource_group_name = module.shared_rg.name
  api_management_name = azurerm_api_management.apim-external.name
  display_name        = "gql-gate-blue-key"
  value               = data.azurerm_function_app.gql-gate-blue-function-key.connection_string[0].value
}

resource "azurerm_api_management_named_value" "gql-gate-green-key" {
  name                = "gql-gate-green-key"
  resource_group_name = module.shared_rg.name
  api_management_name = azurerm_api_management.apim-external.name
  display_name        = "gql-gate-green-key"
  value               = data.azurerm_function_app.gql-gate-green-function-key.connection_string[0].value
}

resource "azurerm_api_management_named_value" "notifications-blue-key" {
  name                = "notifications-blue-key"
  resource_group_name = module.shared_rg.name
  api_management_name = azurerm_api_management.apim-external.name
  display_name        = "notifications-blue-key"
  value               = data.azurerm_function_app.notifications-blue-function-key.connection_string[0].value
}

resource "azurerm_api_management_named_value" "notifications-green-key" {
  name                = "notifications-green-key"
  resource_group_name = module.shared_rg.name
  api_management_name = azurerm_api_management.apim-external.name
  display_name        = "notifications-green-key"
  value               = data.azurerm_function_app.notifications-green-function-key.connection_string[1].value
}

##BACKENDS

resource "azurerm_api_management_backend" "auth-blue-backend-apim" {
  name                = "auth-blue-backend"
  resource_group_name = module.shared_rg.name
  api_management_name = azurerm_api_management.apim-external.name
  protocol            = "http"
  url                 = local.auth_blue_url

  credentials {
    header = {
      "x-functions-key" =  "{{auth-blue-key}}"
    }

  }
}

resource "azurerm_api_management_backend" "auth-green-backend-apim" {
  name                = "auth-green-backend"
  resource_group_name = module.shared_rg.name
  api_management_name = azurerm_api_management.apim-external.name
  protocol            = "http"
  url                 = local.auth_green_url

  credentials {
    header = {
      "x-functions-key" =  "{{auth-green-key}}"
    }

  }
}

resource "azurerm_api_management_backend" "analytics-blue" {
  name                = "analytics-blue"
  resource_group_name = module.shared_rg.name
  api_management_name = azurerm_api_management.apim-external.name
  protocol            = "http"
  url                 = local.core_blue_analytics_url

  credentials {
    header = {
      "x-functions-key" =  "{{core-blue-key}}"
    }

  }
}

resource "azurerm_api_management_backend" "analytics-green" {
  name                = "analytics-green"
  resource_group_name = module.shared_rg.name
  api_management_name = azurerm_api_management.apim-external.name
  protocol            = "http"
  url                 = local.core_green_analytics_url

  credentials {
    header = {
      "x-functions-key" =  "{{core-green-key}}"
    }

  }
}

resource "azurerm_api_management_backend" "core-blue" {
  name                = "core-blue"
  resource_group_name = module.shared_rg.name
  api_management_name = azurerm_api_management.apim-external.name
  protocol            = "http"
  url                 = local.core_blue_api_url

  credentials {
    header = {
      "x-functions-key" =  "{{core-blue-key}}"
    }

  }
}

resource "azurerm_api_management_backend" "core-green" {
  name                = "core-green"
  resource_group_name = module.shared_rg.name
  api_management_name = azurerm_api_management.apim-external.name
  protocol            = "http"
  url                 = local.core_green_api_url

  credentials {
    header = {
      "x-functions-key" =  "{{core-green-key}}"
    }

  }
}

resource "azurerm_api_management_backend" "equipments-blue" {
  name                = "equipments-blue"
  resource_group_name = module.shared_rg.name
  api_management_name = azurerm_api_management.apim-external.name
  protocol            = "http"
  url                 = local.core_blue_equipments_url

  credentials {
    header = {
      "x-functions-key" =  "{{core-blue-key}}"
    }

  }
}

resource "azurerm_api_management_backend" "equipments-green" {
  name                = "equipments-green"
  resource_group_name = module.shared_rg.name
  api_management_name = azurerm_api_management.apim-external.name
  protocol            = "http"
  url                 = local.core_green_equipments_url

  credentials {
    header = {
      "x-functions-key" =  "{{core-green-key}}"
    }

  }
}

resource "azurerm_api_management_backend" "graphql-blue" {
  name                = "graphql-blue"
  resource_group_name = module.shared_rg.name
  api_management_name = azurerm_api_management.apim-external.name
  protocol            = "http"
  url                 = local.gql_blue_api_url

  credentials {
    header = {
      "x-functions-key" =  "{{gql-gate-blue-key}}"
    }

  }
}

resource "azurerm_api_management_backend" "graphql-green" {
  name                = "graphql-green"
  resource_group_name = module.shared_rg.name
  api_management_name = azurerm_api_management.apim-external.name
  protocol            = "http"
  url                 = local.gql_green_api_url

  credentials {
    header = {
      "x-functions-key" =  "{{gql-gate-green-key}}"
    }

  }
}

resource "azurerm_api_management_backend" "navigation-blue" {
  name                = "navigation-blue"
  resource_group_name = module.shared_rg.name
  api_management_name = azurerm_api_management.apim-external.name
  protocol            = "http"
  url                 = local.core_blue_navigation_url

  credentials {
    header = {
      "x-functions-key" =  "{{core-blue-key}}"
    }

  }
}

resource "azurerm_api_management_backend" "navigation-green" {
  name                = "navigation-green"
  resource_group_name = module.shared_rg.name
  api_management_name = azurerm_api_management.apim-external.name
  protocol            = "http"
  url                 = local.core_green_navigation_url

  credentials {
    header = {
      "x-functions-key" =  "{{core-green-key}}"
    }

  }
}

resource "azurerm_api_management_backend" "notification-blue" {
  name                = "notification-blue"
  resource_group_name = module.shared_rg.name
  api_management_name = azurerm_api_management.apim-external.name
  protocol            = "http"
  url                 = local.notifcation_blue_url

  credentials {
    header = {
      "x-functions-key" =  "{{notifications-blue-key}}"
    }

  }
}

resource "azurerm_api_management_backend" "notification-green" {
  name                = "notification-green"
  resource_group_name = module.shared_rg.name
  api_management_name = azurerm_api_management.apim-external.name
  protocol            = "http"
  url                 = local.notifcation_green_url

  credentials {
    header = {
      "x-functions-key" =  "{{notifications-green-key}}"
    }

  }
}

resource "azurerm_api_management_backend" "partner-blue" {
  name                = "partner-blue"
  resource_group_name = module.shared_rg.name
  api_management_name = azurerm_api_management.apim-external.name
  protocol            = "http"
  url                 = local.core_blue_partner_url

  credentials {
    header = {
      "x-functions-key" =  "{{core-blue-key}}"
    }

  }
}

resource "azurerm_api_management_backend" "partner-green" {
  name                = "partner-green"
  resource_group_name = module.shared_rg.name
  api_management_name = azurerm_api_management.apim-external.name
  protocol            = "http"
  url                 = local.core_green_partner_url

  credentials {
    header = {
      "x-functions-key" =  "{{core-green-key}}"
    }

  }
}

resource "azurerm_api_management_backend" "users-blue" {
  name                = "users-blue"
  resource_group_name = module.shared_rg.name
  api_management_name = azurerm_api_management.apim-external.name
  protocol            = "http"
  url                 = local.core_blue_users_url

  credentials {
    header = {
      "x-functions-key" =  "{{core-blue-key}}"
    }

  }
}

resource "azurerm_api_management_backend" "users-green" {
  name                = "users-green"
  resource_group_name = module.shared_rg.name
  api_management_name = azurerm_api_management.apim-external.name
  protocol            = "http"
  url                 = local.core_green_users_url

  credentials {
    header = {
      "x-functions-key" =  "{{core-green-key}}"
    }

  }
}

resource "azurerm_api_management_backend" "validations-blue" {
  name                = "validations-blue"
  resource_group_name = module.shared_rg.name
  api_management_name = azurerm_api_management.apim-external.name
  protocol            = "http"
  url                 = local.core_green_validations_url

  credentials {
    header = {
      "x-functions-key" =  "{{core-blue-key}}"
    }

  }
}

resource "azurerm_api_management_backend" "validations-green" {
  name                = "validations-green"
  resource_group_name = module.shared_rg.name
  api_management_name = azurerm_api_management.apim-external.name
  protocol            = "http"
  url                 = local.core_green_validations_url

  credentials {
    header = {
      "x-functions-key" =  "{{core-green-key}}"
    }

  }
}


##Operations

resource "azurerm_api_management_api_operation" "GetAuditLogs" {
  operation_id        = "auditLogs"
  api_name            = azurerm_api_management_api.audit-logs-api-apim.name
  api_management_name = azurerm_api_management.apim-external.name
  resource_group_name = module.shared_rg.name
  display_name        = "GetAuditLogs"
  method              = "GET"
  url_template        = "/{entity_name}/{entity_id}"
  template_parameter {
    name = "entity_name"
    type = "string"
    required = true
    
  }
template_parameter {
  name = "entity_id"
  type = "string"
  required = true
}
}

resource "azurerm_api_management_api_operation" "authenticate-blue" {
  operation_id        = "authenticate-blue"
  api_name            = azurerm_api_management_api.auth-blue-api-apim.name
  api_management_name = azurerm_api_management.apim-external.name
  resource_group_name = module.shared_rg.name
  display_name        = "Authenticate-blue"
  method              = "POST"
  url_template        = "/oauth/token"

}

resource "azurerm_api_management_api_operation" "authenticate-green" {
  operation_id        = "authenticate-green"
  api_name            = azurerm_api_management_api.auth-green-api-apim.name
  api_management_name = azurerm_api_management.apim-external.name
  resource_group_name = module.shared_rg.name
  display_name        = "Authenticate-green"
  method              = "POST"
  url_template        = "/oauth/token"

}

resource "azurerm_api_management_api_operation" "authorizer-blue" {
  operation_id        = "authorizer-blue"
  api_name            = azurerm_api_management_api.auth-green-api-apim.name
  api_management_name = azurerm_api_management.apim-external.name
  resource_group_name = module.shared_rg.name
  display_name        = "Authenticate-blue"
  method              = "POST"
  url_template        = "/oauth/token"

}














resource "azurerm_api_management_policy" "policy" {
  api_management_id = azurerm_api_management.apim-external.id
  xml_content       = "<!--\r\n    IMPORTANT:\r\n    - Policy elements can appear only within the <inbound>, <outbound>, <backend> section elements.\r\n    - Only the <forward-request> policy element can appear within the <backend> section element.\r\n    - To apply a policy to the incoming request (before it is forwarded to the backend service), place a corresponding policy element within the <inbound> section element.\r\n    - To apply a policy to the outgoing response (before it is sent back to the caller), place a corresponding policy element within the <outbound> section element.\r\n    - To add a policy position the cursor at the desired insertion point and click on the round button associated with the policy.\r\n    - To remove a policy, delete the corresponding policy statement from the policy document.\r\n    - Policies are applied in the order of their appearance, from the top down.\r\n-->\r\n<policies>\r\n  <inbound />\r\n  <backend>\r\n    <forward-request />\r\n  </backend>\r\n  <outbound />\r\n</policies>"

}