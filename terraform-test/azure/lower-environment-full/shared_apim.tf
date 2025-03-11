# -------------------------------------------------------------------------------------------------


data "azurerm_api_management" "shared_apim" {
  name                = "shared-${var.prod_env_name}${var.prod_env_key}-api"
  provider            = azurerm.Production
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
}

##Named Values - Depends on Functions

#Function Import

data "azurerm_function_app_host_keys" "auth-blue-function-key" {
  name                = azurerm_windows_function_app.auth_function_app_blue.name
  resource_group_name = module.auth_rg.name
}

data "azurerm_function_app_host_keys" "auth-green-function-key" {
  name                = azurerm_windows_function_app.auth_function_app_green.name
  resource_group_name = module.auth_rg.name
}

data "azurerm_function_app_host_keys" "core-blue-function-key" {
  name                = azurerm_windows_function_app.core_blue_function_app.name
  resource_group_name = module.rg.name
}

data "azurerm_function_app_host_keys" "core-green-function-key" {
  name                = azurerm_windows_function_app.core_green_function_app.name
  resource_group_name = module.rg.name
}

data "azurerm_function_app_host_keys" "gql-gate-blue-function-key" {
  name                = azurerm_windows_function_app.gql_gate_blue_function_app.name
  resource_group_name = module.rg.name
}

data "azurerm_function_app_host_keys" "gql-gate-green-function-key" {
  name                = azurerm_windows_function_app.gql_gate_green_function_app.name
  resource_group_name = module.rg.name
}

data "azurerm_function_app_host_keys" "notifications-blue-function-key" {
  name                = azurerm_windows_function_app.notifications_blue_function_app.name
  resource_group_name = module.rg.name
}

data "azurerm_function_app_host_keys" "notifications-green-function-key" {
  name                = azurerm_windows_function_app.notifications_green_function_app.name
  resource_group_name = module.rg.name
}

data "azurerm_function_app_host_keys" "nui-blue-function-key" {
  name                = azurerm_windows_function_app.nui_blue_function_app.name
  resource_group_name = module.rg.name
}

data "azurerm_function_app_host_keys" "nui-green-function-key" {
  name                = azurerm_windows_function_app.nui_green_function_app.name
  resource_group_name = module.rg.name
}

data "azurerm_function_app_host_keys" "linux-blue-function-key" {
  name                = azurerm_linux_function_app.linux_blue_function_app.name
  resource_group_name = module.lnx_rg.name
}

data "azurerm_function_app_host_keys" "linux-green-function-key" {
  name                = azurerm_linux_function_app.linux_green_function_app.name
  resource_group_name = module.lnx_rg.name
}


#Named Value Creation per environment 

resource "azurerm_api_management_named_value" "auth-demo-key" {
  name                = "${var.region_abbreviation}-${var.env_name}${var.env_key}-auth-demo-key"
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  api_management_name = data.azurerm_api_management.shared_apim.name
  display_name        = "${var.region_abbreviation}-${var.env_name}${var.env_key}-auth-demo-key"
  secret              = true
  value               = data.azurerm_function_app_host_keys.auth-blue-function-key.default_function_key
  provider            = azurerm.Production

}

resource "azurerm_api_management_named_value" "auth-blue-key" {
  name                = "${var.region_abbreviation}-${var.env_name}${var.env_key}-auth-blue-key"
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  api_management_name = data.azurerm_api_management.shared_apim.name
  display_name        = "${var.region_abbreviation}-${var.env_name}${var.env_key}-auth-blue-key"
  secret              = true
  value               = data.azurerm_function_app_host_keys.auth-blue-function-key.default_function_key
  provider            = azurerm.Production

}

resource "azurerm_api_management_named_value" "auth-green-key" {
  name                = "${var.region_abbreviation}-${var.env_name}${var.env_key}-auth-green-key"
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  api_management_name = data.azurerm_api_management.shared_apim.name
  display_name        = "${var.region_abbreviation}-${var.env_name}${var.env_key}-auth-green-key"
  secret              = true
  value               = data.azurerm_function_app_host_keys.auth-green-function-key.default_function_key
  provider            = azurerm.Production

}

resource "azurerm_api_management_named_value" "core-blue-key" {
  name                = "${var.region_abbreviation}-${var.env_name}${var.env_key}-core-blue-key"
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  api_management_name = data.azurerm_api_management.shared_apim.name
  display_name        = "${var.region_abbreviation}-${var.env_name}${var.env_key}-core-blue-key"
  secret              = true
  value               = data.azurerm_function_app_host_keys.core-blue-function-key.default_function_key
  provider            = azurerm.Production

}

resource "azurerm_api_management_named_value" "core-green-key" {
  name                = "${var.region_abbreviation}-${var.env_name}${var.env_key}-core-green-key"
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  api_management_name = data.azurerm_api_management.shared_apim.name
  display_name        = "${var.region_abbreviation}-${var.env_name}${var.env_key}-core-green-key"
  secret              = true
  value               = data.azurerm_function_app_host_keys.core-green-function-key.default_function_key
  provider            = azurerm.Production

}


resource "azurerm_api_management_named_value" "gql-gate-blue-key" {
  name                = "${var.region_abbreviation}-${var.env_name}${var.env_key}-gql-gate-blue-key"
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  api_management_name = data.azurerm_api_management.shared_apim.name
  display_name        = "${var.region_abbreviation}-${var.env_name}${var.env_key}-gql-gate-blue-key"
  secret              = true
  value               = data.azurerm_function_app_host_keys.gql-gate-blue-function-key.default_function_key
  provider            = azurerm.Production

}

resource "azurerm_api_management_named_value" "gql-gate-green-key" {
  name                = "${var.region_abbreviation}-${var.env_name}${var.env_key}-gql-gate-green-key"
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  api_management_name = data.azurerm_api_management.shared_apim.name
  display_name        = "${var.region_abbreviation}-${var.env_name}${var.env_key}-gql-gate-green-key"
  secret              = true
  value               = data.azurerm_function_app_host_keys.gql-gate-green-function-key.default_function_key
  provider            = azurerm.Production

}

resource "azurerm_api_management_named_value" "notifications-blue-key" {
  name                = "${var.region_abbreviation}-${var.env_name}${var.env_key}-notifications-blue-key"
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  api_management_name = data.azurerm_api_management.shared_apim.name
  display_name        = "${var.region_abbreviation}-${var.env_name}${var.env_key}-notifications-blue-key"
  secret              = true
  value               = data.azurerm_function_app_host_keys.notifications-blue-function-key.default_function_key
  provider            = azurerm.Production

}

resource "azurerm_api_management_named_value" "notifications-green-key" {
  name                = "${var.region_abbreviation}-${var.env_name}${var.env_key}-notifications-green-key"
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  api_management_name = data.azurerm_api_management.shared_apim.name
  display_name        = "${var.region_abbreviation}-${var.env_name}${var.env_key}-notifications-green-key"
  secret              = true
  value               = data.azurerm_function_app_host_keys.notifications-green-function-key.default_function_key
  provider            = azurerm.Production

}

resource "azurerm_api_management_named_value" "nui-blue-key" {
  name                = "${var.region_abbreviation}-${var.env_name}${var.env_key}-nui-blue-key"
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  api_management_name = data.azurerm_api_management.shared_apim.name
  display_name        = "${var.region_abbreviation}-${var.env_name}${var.env_key}-nui-blue-key"
  secret              = true
  value               = data.azurerm_function_app_host_keys.nui-blue-function-key.default_function_key
  provider            = azurerm.Production

}

resource "azurerm_api_management_named_value" "nui-green-key" {
  name                = "${var.region_abbreviation}-${var.env_name}${var.env_key}-nui-green-key"
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  api_management_name = data.azurerm_api_management.shared_apim.name
  display_name        = "${var.region_abbreviation}-${var.env_name}${var.env_key}-nui-green-key"
  secret              = true
  value               = data.azurerm_function_app_host_keys.nui-green-function-key.default_function_key
  provider            = azurerm.Production

}


resource "azurerm_api_management_named_value" "linux-blue-key" {
  name                = "${var.region_abbreviation}-${var.env_name}${var.env_key}-linux-blue-key"
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  api_management_name = data.azurerm_api_management.shared_apim.name
  display_name        = "${var.region_abbreviation}-${var.env_name}${var.env_key}-linux-blue-key"
  secret              = true
  value               = data.azurerm_function_app_host_keys.linux-blue-function-key.default_function_key
  provider            = azurerm.Production

}

resource "azurerm_api_management_named_value" "linux-green-key" {
  name                = "${var.region_abbreviation}-${var.env_name}${var.env_key}-linux-green-key"
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  api_management_name = data.azurerm_api_management.shared_apim.name
  display_name        = "${var.region_abbreviation}-${var.env_name}${var.env_key}-linux-green-key"
  secret              = true
  value               = data.azurerm_function_app_host_keys.linux-green-function-key.default_function_key
  provider            = azurerm.Production

}

##BACKENDS

resource "azurerm_api_management_backend" "auth-blue-backend-apim" {
  name                = "${var.region_abbreviation}-${var.env_name}${var.env_key}-auth-blue"
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  api_management_name = data.azurerm_api_management.shared_apim.name
  protocol            = "http"
  url                 = local.auth_blue_url
  resource_id         = "${local.auth_backend_resourceid_prefix}${azurerm_windows_function_app.auth_function_app_blue.name}"
  provider            = azurerm.Production

  credentials {
    header = {
      "x-functions-key" = "{{${var.region_abbreviation}-${var.env_name}${var.env_key}-auth-blue-key}}"
    }

  }
  depends_on = [
    azurerm_api_management_named_value.auth-blue-key
  ]

}

resource "azurerm_api_management_backend" "auth-green-backend-apim" {
  name                = "${var.region_abbreviation}-${var.env_name}${var.env_key}-auth-green"
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  api_management_name = data.azurerm_api_management.shared_apim.name
  protocol            = "http"
  url                 = local.auth_green_url
  resource_id         = "${local.auth_backend_resourceid_prefix}${azurerm_windows_function_app.auth_function_app_green.name}"
  provider            = azurerm.Production

  credentials {
    header = {
      "x-functions-key" = "{{${var.region_abbreviation}-${var.env_name}${var.env_key}-auth-green-key}}"
    }

  }
  depends_on = [
    azurerm_api_management_named_value.auth-green-key

  ]

}


resource "azurerm_api_management_backend" "analytics-blue" {
  name                = "${var.region_abbreviation}-${var.env_name}${var.env_key}-analytics-blue"
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  api_management_name = data.azurerm_api_management.shared_apim.name
  protocol            = "http"
  url                 = local.core_blue_analytics_url
  resource_id         = "${local.mul_backend_resourceid_prefix}${azurerm_windows_function_app.core_blue_function_app.name}"
  provider            = azurerm.Production

  credentials {
    header = {
      "x-functions-key" = "{{${var.region_abbreviation}-${var.env_name}${var.env_key}-core-blue-key}}"
    }

  }
  depends_on = [
    azurerm_api_management_named_value.core-blue-key

  ]

}

resource "azurerm_api_management_backend" "analytics-green" {
  name                = "${var.region_abbreviation}-${var.env_name}${var.env_key}-analytics-green"
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  api_management_name = data.azurerm_api_management.shared_apim.name
  protocol            = "http"
  url                 = local.core_green_analytics_url
  resource_id         = "${local.mul_backend_resourceid_prefix}${azurerm_windows_function_app.core_green_function_app.name}"
  provider            = azurerm.Production

  credentials {
    header = {
      "x-functions-key" = "{{${var.region_abbreviation}-${var.env_name}${var.env_key}-core-green-key}}"
    }

  }
  depends_on = [
    azurerm_api_management_named_value.core-green-key

  ]

}

resource "azurerm_api_management_backend" "core-blue" {
  name                = "${var.region_abbreviation}-${var.env_name}${var.env_key}-core-blue"
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  api_management_name = data.azurerm_api_management.shared_apim.name
  protocol            = "http"
  url                 = local.core_blue_api_url
  resource_id         = "${local.mul_backend_resourceid_prefix}${azurerm_windows_function_app.core_blue_function_app.name}"
  provider            = azurerm.Production

  credentials {
    header = {
      "x-functions-key" = "{{${var.region_abbreviation}-${var.env_name}${var.env_key}-core-blue-key}}"
    }

  }
  depends_on = [
    azurerm_api_management_named_value.core-blue-key
  ]

}

resource "azurerm_api_management_backend" "core-green" {
  name                = "${var.region_abbreviation}-${var.env_name}${var.env_key}-core-green"
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  api_management_name = data.azurerm_api_management.shared_apim.name
  protocol            = "http"
  url                 = local.core_green_api_url
  resource_id         = "${local.mul_backend_resourceid_prefix}${azurerm_windows_function_app.core_green_function_app.name}"
  provider            = azurerm.Production

  credentials {
    header = {
      "x-functions-key" = "{{${var.region_abbreviation}-${var.env_name}${var.env_key}-core-green-key}}"
    }

  }
  depends_on = [
    azurerm_api_management_named_value.core-green-key
  ]

}

resource "azurerm_api_management_backend" "equipments-blue" {
  name                = "${var.region_abbreviation}-${var.env_name}${var.env_key}-equipments-blue"
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  api_management_name = data.azurerm_api_management.shared_apim.name
  protocol            = "http"
  url                 = local.core_blue_equipments_url
  resource_id         = "${local.mul_backend_resourceid_prefix}${azurerm_windows_function_app.core_blue_function_app.name}"
  provider            = azurerm.Production

  credentials {
    header = {
      "x-functions-key" = "{{${var.region_abbreviation}-${var.env_name}${var.env_key}-core-blue-key}}"
    }

  }
  depends_on = [
    azurerm_api_management_named_value.core-blue-key
  ]

}

resource "azurerm_api_management_backend" "equipments-green" {
  name                = "${var.region_abbreviation}-${var.env_name}${var.env_key}-equipments-green"
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  api_management_name = data.azurerm_api_management.shared_apim.name
  protocol            = "http"
  url                 = local.core_green_equipments_url
  resource_id         = "${local.mul_backend_resourceid_prefix}${azurerm_windows_function_app.core_green_function_app.name}"
  provider            = azurerm.Production

  credentials {
    header = {
      "x-functions-key" = "{{${var.region_abbreviation}-${var.env_name}${var.env_key}-core-green-key}}"
    }

  }
  depends_on = [
    azurerm_api_management_named_value.core-green-key
  ]

}

resource "azurerm_api_management_backend" "graphql-blue" {
  name                = "${var.region_abbreviation}-${var.env_name}${var.env_key}-graphql-blue"
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  api_management_name = data.azurerm_api_management.shared_apim.name
  protocol            = "http"
  url                 = local.gql_blue_api_url
  resource_id         = "${local.mul_backend_resourceid_prefix}${azurerm_windows_function_app.gql_gate_blue_function_app.name}"
  provider            = azurerm.Production

  credentials {
    header = {
      "x-functions-key" = "{{${var.region_abbreviation}-${var.env_name}${var.env_key}-gql-gate-blue-key}}"
    }

  }
  depends_on = [
    azurerm_api_management_named_value.gql-gate-blue-key
  ]

}

resource "azurerm_api_management_backend" "graphql-green" {
  name                = "${var.region_abbreviation}-${var.env_name}${var.env_key}-graphql-green"
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  api_management_name = data.azurerm_api_management.shared_apim.name
  protocol            = "http"
  url                 = local.gql_green_api_url
  resource_id         = "${local.mul_backend_resourceid_prefix}${azurerm_windows_function_app.gql_gate_green_function_app.name}"
  provider            = azurerm.Production


  credentials {
    header = {
      "x-functions-key" = "{{${var.region_abbreviation}-${var.env_name}${var.env_key}-gql-gate-green-key}}"
    }

  }
  depends_on = [
    azurerm_api_management_named_value.gql-gate-green-key
  ]

}

resource "azurerm_api_management_backend" "navigation-blue" {
  name                = "${var.region_abbreviation}-${var.env_name}${var.env_key}-navigation-blue"
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  api_management_name = data.azurerm_api_management.shared_apim.name
  protocol            = "http"
  url                 = local.core_blue_navigation_url
  resource_id         = "${local.mul_backend_resourceid_prefix}${azurerm_windows_function_app.core_blue_function_app.name}"
  provider            = azurerm.Production

  credentials {
    header = {
      "x-functions-key" = "{{${var.region_abbreviation}-${var.env_name}${var.env_key}-core-blue-key}}"
    }

  }
  depends_on = [
    azurerm_api_management_named_value.core-blue-key
  ]

}

resource "azurerm_api_management_backend" "navigation-green" {
  name                = "${var.region_abbreviation}-${var.env_name}${var.env_key}-navigation-green"
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  api_management_name = data.azurerm_api_management.shared_apim.name
  protocol            = "http"
  url                 = local.core_green_navigation_url
  resource_id         = "${local.mul_backend_resourceid_prefix}${azurerm_windows_function_app.core_green_function_app.name}"
  provider            = azurerm.Production

  credentials {
    header = {
      "x-functions-key" = "{{${var.region_abbreviation}-${var.env_name}${var.env_key}-core-green-key}}"
    }

  }
  depends_on = [
    azurerm_api_management_named_value.core-green-key
  ]

}

resource "azurerm_api_management_backend" "notification-blue" {
  name                = "${var.region_abbreviation}-${var.env_name}${var.env_key}-notification-blue"
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  api_management_name = data.azurerm_api_management.shared_apim.name
  protocol            = "http"
  url                 = local.notifcation_blue_url
  resource_id         = "${local.mul_backend_resourceid_prefix}${azurerm_windows_function_app.notifications_blue_function_app.name}"
  provider            = azurerm.Production

  credentials {
    header = {
      "x-functions-key" = "{{${var.region_abbreviation}-${var.env_name}${var.env_key}-notifications-blue-key}}"
    }

  }
  depends_on = [
    azurerm_api_management_named_value.notifications-blue-key
  ]

}

resource "azurerm_api_management_backend" "notification-green" {
  name                = "${var.region_abbreviation}-${var.env_name}${var.env_key}-notification-green"
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  api_management_name = data.azurerm_api_management.shared_apim.name
  protocol            = "http"
  url                 = local.notifcation_green_url
  resource_id         = "${local.mul_backend_resourceid_prefix}${azurerm_windows_function_app.notifications_green_function_app.name}"
  provider            = azurerm.Production

  credentials {
    header = {
      "x-functions-key" = "{{${var.region_abbreviation}-${var.env_name}${var.env_key}-notifications-green-key}}"
    }

  }
  depends_on = [
    azurerm_api_management_named_value.notifications-green-key
  ]

}

resource "azurerm_api_management_backend" "nui-blue" {
  name                = "${var.region_abbreviation}-${var.env_name}${var.env_key}-nui-blue"
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  api_management_name = data.azurerm_api_management.shared_apim.name
  protocol            = "http"
  url                 = local.nui_blue_url
  resource_id         = "${local.mul_backend_resourceid_prefix}${azurerm_windows_function_app.nui_blue_function_app.name}"
  provider            = azurerm.Production

  credentials {
    header = {
      "x-functions-key" = "{{${var.region_abbreviation}-${var.env_name}${var.env_key}-nui-blue-key}}"
    }

  }
  depends_on = [
    azurerm_api_management_named_value.nui-blue-key
  ]

}

resource "azurerm_api_management_backend" "nui-green" {
  name                = "${var.region_abbreviation}-${var.env_name}${var.env_key}-nui-green"
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  api_management_name = data.azurerm_api_management.shared_apim.name
  protocol            = "http"
  url                 = local.nui_green_url
  resource_id         = "${local.mul_backend_resourceid_prefix}${azurerm_windows_function_app.nui_green_function_app.name}"
  provider            = azurerm.Production

  credentials {
    header = {
      "x-functions-key" = "{{${var.region_abbreviation}-${var.env_name}${var.env_key}-nui-green-key}}"
    }

  }
  depends_on = [
    azurerm_api_management_named_value.nui-green-key
  ]

}

resource "azurerm_api_management_backend" "partner-blue" {
  name                = "${var.region_abbreviation}-${var.env_name}${var.env_key}-partner-blue"
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  api_management_name = data.azurerm_api_management.shared_apim.name
  protocol            = "http"
  url                 = local.core_blue_partner_url
  resource_id         = "${local.mul_backend_resourceid_prefix}${azurerm_windows_function_app.core_blue_function_app.name}"
  provider            = azurerm.Production

  credentials {
    header = {
      "x-functions-key" = "{{${var.region_abbreviation}-${var.env_name}${var.env_key}-core-blue-key}}"
    }

  }
  depends_on = [
    azurerm_api_management_named_value.core-blue-key
  ]

}
resource "azurerm_api_management_backend" "partner-green" {
  name                = "${var.region_abbreviation}-${var.env_name}${var.env_key}-partner-green"
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  api_management_name = data.azurerm_api_management.shared_apim.name
  protocol            = "http"
  url                 = local.core_green_partner_url
  resource_id         = "${local.mul_backend_resourceid_prefix}${azurerm_windows_function_app.core_green_function_app.name}"
  provider            = azurerm.Production

  credentials {
    header = {
      "x-functions-key" = "{{${var.region_abbreviation}-${var.env_name}${var.env_key}-core-green-key}}"
    }

  }
  depends_on = [
    azurerm_api_management_named_value.core-green-key
  ]

}

resource "azurerm_api_management_backend" "users-blue" {
  name                = "${var.region_abbreviation}-${var.env_name}${var.env_key}-users-blue"
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  api_management_name = data.azurerm_api_management.shared_apim.name
  protocol            = "http"
  url                 = local.core_blue_users_url
  resource_id         = "${local.mul_backend_resourceid_prefix}${azurerm_windows_function_app.core_blue_function_app.name}"
  provider            = azurerm.Production

  credentials {
    header = {
      "x-functions-key" = "{{${var.region_abbreviation}-${var.env_name}${var.env_key}-core-blue-key}}"
    }

  }
  depends_on = [
    azurerm_api_management_named_value.core-blue-key
  ]

}

resource "azurerm_api_management_backend" "users-green" {
  name                = "${var.region_abbreviation}-${var.env_name}${var.env_key}-users-green"
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  api_management_name = data.azurerm_api_management.shared_apim.name
  protocol            = "http"
  url                 = local.core_green_users_url
  resource_id         = "${local.mul_backend_resourceid_prefix}${azurerm_windows_function_app.core_green_function_app.name}"
  provider            = azurerm.Production

  credentials {
    header = {
      "x-functions-key" = "{{${var.region_abbreviation}-${var.env_name}${var.env_key}-core-green-key}}"
    }

  }
  depends_on = [
    azurerm_api_management_named_value.core-green-key
  ]

}

resource "azurerm_api_management_backend" "validations-blue" {
  name                = "${var.region_abbreviation}-${var.env_name}${var.env_key}-validations-blue"
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  api_management_name = data.azurerm_api_management.shared_apim.name
  protocol            = "http"
  url                 = local.core_green_validations_url
  resource_id         = "${local.mul_backend_resourceid_prefix}${azurerm_windows_function_app.core_blue_function_app.name}"
  provider            = azurerm.Production

  credentials {
    header = {
      "x-functions-key" = "{{${var.region_abbreviation}-${var.env_name}${var.env_key}-core-blue-key}}"
    }

  }
  depends_on = [
    azurerm_api_management_named_value.core-blue-key
  ]

}

resource "azurerm_api_management_backend" "validations-green" {
  name                = "${var.region_abbreviation}-${var.env_name}${var.env_key}-validations-green"
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  api_management_name = data.azurerm_api_management.shared_apim.name
  protocol            = "http"
  url                 = local.core_green_validations_url
  resource_id         = "${local.mul_backend_resourceid_prefix}${azurerm_windows_function_app.core_green_function_app.name}"
  provider            = azurerm.Production

  credentials {
    header = {
      "x-functions-key" = "{{${var.region_abbreviation}-${var.env_name}${var.env_key}-core-green-key}}"
    }

  }
  depends_on = [
    azurerm_api_management_named_value.core-green-key
  ]

}

resource "azurerm_api_management_backend" "linux-blue-backend" {
  name                = "${var.region_abbreviation}-${var.env_name}${var.env_key}-linux-blue"
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  api_management_name = data.azurerm_api_management.shared_apim.name
  protocol            = "http"
  url                 = local.linux_blue_url
  resource_id         = "${local.mul_backend_resourceid_prefix}${azurerm_linux_function_app.linux_blue_function_app.name}"
  provider            = azurerm.Production

  credentials {
    header = {
      "x-functions-key" = "{{${var.region_abbreviation}-${var.env_name}${var.env_key}-linux-blue-key}}"
    }

  }
  depends_on = [
    azurerm_api_management_named_value.linux-blue-key
  ]

}

resource "azurerm_api_management_backend" "linux-green-backend" {
  name                = "${var.region_abbreviation}-${var.env_name}${var.env_key}-linux-green"
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  api_management_name = data.azurerm_api_management.shared_apim.name
  protocol            = "http"
  url                 = local.linux_green_url
  resource_id         = "${local.mul_backend_resourceid_prefix}${azurerm_linux_function_app.linux_green_function_app.name}"
  provider            = azurerm.Production

  credentials {
    header = {
      "x-functions-key" = "{{${var.region_abbreviation}-${var.env_name}${var.env_key}-linux-green-key}}"
    }

  }
  depends_on = [
    azurerm_api_management_named_value.linux-green-key
  ]

}
##APIS##

resource "azurerm_api_management_api" "alert-api-apim" {
  name                  = "${var.region_abbreviation}-${var.env_name}${var.env_key}-alert-api"
  resource_group_name   = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  api_management_name   = data.azurerm_api_management.shared_apim.name
  description           = "alert Service service endpoint"
  subscription_required = false
  revision              = "1"
  display_name          = "${var.region_abbreviation}-${var.env_name}${var.env_key}-alert API"
  path                  = "${var.region_abbreviation}-${var.env_name}${var.env_key}/alerts"
  protocols             = ["https"]
  provider              = azurerm.Production

}

resource "azurerm_api_management_api" "analytics-blue-api-apim" {
  name                  = "${var.region_abbreviation}-${var.env_name}${var.env_key}-analytics-blue-api"
  resource_group_name   = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  api_management_name   = data.azurerm_api_management.shared_apim.name
  description           = "Core endpoint"
  subscription_required = false
  revision              = "1"
  display_name          = "${var.region_abbreviation}-${var.env_name}${var.env_key}-analytics-blue"
  path                  = "${var.region_abbreviation}-${var.env_name}${var.env_key}/blue/analytics"
  protocols             = ["https"]
  provider              = azurerm.Production

}

resource "azurerm_api_management_api" "analytics-green-api-apim" {
  name                  = "${var.region_abbreviation}-${var.env_name}${var.env_key}-analytics-green-api"
  resource_group_name   = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  api_management_name   = data.azurerm_api_management.shared_apim.name
  description           = "Core endpoint"
  subscription_required = false
  revision              = "1"
  display_name          = "${var.region_abbreviation}-${var.env_name}${var.env_key}-analytics-green"
  path                  = "${var.region_abbreviation}-${var.env_name}${var.env_key}/green/analytics"
  protocols             = ["https"]
  provider              = azurerm.Production

}


resource "azurerm_api_management_api" "audit-logs-api-apim" {
  name                  = "${var.region_abbreviation}-${var.env_name}${var.env_key}-audit-logs-api"
  resource_group_name   = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  api_management_name   = data.azurerm_api_management.shared_apim.name
  description           = "Audit log service endpoint"
  subscription_required = false
  revision              = "1"
  display_name          = "${var.region_abbreviation}-${var.env_name}${var.env_key}-Audit logs API"
  path                  = "${var.region_abbreviation}-${var.env_name}${var.env_key}/auditLogs"
  protocols             = ["https"]
  provider              = azurerm.Production

}

resource "azurerm_api_management_api" "auth-blue-api-apim" {
  name                  = "${var.region_abbreviation}-${var.env_name}${var.env_key}-auth-blue-api"
  resource_group_name   = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  api_management_name   = data.azurerm_api_management.shared_apim.name
  description           = "Auth REST API"
  subscription_required = false
  revision              = "1"
  display_name          = "${var.region_abbreviation}-${var.env_name}${var.env_key}-auth-blue"
  path                  = "${var.region_abbreviation}-${var.env_name}${var.env_key}/blue/auth"
  protocols             = ["https"]
  provider              = azurerm.Production

}


resource "azurerm_api_management_api" "auth-green-api-apim" {
  name                  = "${var.region_abbreviation}-${var.env_name}${var.env_key}-auth-green-api"
  resource_group_name   = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  api_management_name   = data.azurerm_api_management.shared_apim.name
  description           = "Auth REST API"
  subscription_required = false
  revision              = "1"
  display_name          = "${var.region_abbreviation}-${var.env_name}${var.env_key}-auth-green"
  path                  = "${var.region_abbreviation}-${var.env_name}${var.env_key}/green/auth"
  protocols             = ["https"]
  provider              = azurerm.Production

}


resource "azurerm_api_management_api" "config-api" {
  name                  = "${var.region_abbreviation}-${var.env_name}${var.env_key}-config-api"
  resource_group_name   = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  api_management_name   = data.azurerm_api_management.shared_apim.name
  description           = "IoT Config service endpoint"
  subscription_required = false
  revision              = "1"
  display_name          = "${var.region_abbreviation}-${var.env_name}${var.env_key}-IoT Config API"
  path                  = "${var.region_abbreviation}-${var.env_name}${var.env_key}/config"
  protocols             = ["https"]
  provider              = azurerm.Production

}

resource "azurerm_api_management_api" "core-blue-api" {
  name                  = "${var.region_abbreviation}-${var.env_name}${var.env_key}-core-blue-api"
  resource_group_name   = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  api_management_name   = data.azurerm_api_management.shared_apim.name
  description           = "Core endpoint"
  subscription_required = false
  revision              = "1"
  display_name          = "${var.region_abbreviation}-${var.env_name}${var.env_key}-core-blue"
  path                  = "${var.region_abbreviation}-${var.env_name}${var.env_key}/blue/core"
  protocols             = ["https"]
  provider              = azurerm.Production

}


resource "azurerm_api_management_api" "core-green-api" {
  name                  = "${var.region_abbreviation}-${var.env_name}${var.env_key}-core-green-api"
  resource_group_name   = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  api_management_name   = data.azurerm_api_management.shared_apim.name
  description           = "Core endpoint"
  subscription_required = false
  revision              = "1"
  display_name          = "${var.region_abbreviation}-${var.env_name}${var.env_key}-core-green"
  path                  = "${var.region_abbreviation}-${var.env_name}${var.env_key}/green/core"
  protocols             = ["https"]
  provider              = azurerm.Production

}

resource "azurerm_api_management_api" "dataviews-api" {
  name                  = "${var.region_abbreviation}-${var.env_name}${var.env_key}-dataviews-api"
  resource_group_name   = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  api_management_name   = data.azurerm_api_management.shared_apim.name
  description           = "Dataview service endpoint"
  subscription_required = false
  revision              = "1"
  display_name          = "${var.region_abbreviation}-${var.env_name}${var.env_key}-Dataview API"
  path                  = "${var.region_abbreviation}-${var.env_name}${var.env_key}/dataviews"
  protocols             = ["https"]
  provider              = azurerm.Production

}

resource "azurerm_api_management_api" "device-provision-blue" {
  name                  = "${var.region_abbreviation}-${var.env_name}${var.env_key}-device-provision-blue"
  resource_group_name   = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  api_management_name   = data.azurerm_api_management.shared_apim.name
  description           = "Linux Blue Function"
  subscription_required = false
  revision              = "1"
  display_name          = "${var.region_abbreviation}-${var.env_name}${var.env_key}-device-provision-blue"
  path                  = "${var.region_abbreviation}-${var.env_name}${var.env_key}/blue/api"
  protocols             = ["https"]
  provider              = azurerm.Production

}

resource "azurerm_api_management_api" "device-provision-green" {
  name                  = "${var.region_abbreviation}-${var.env_name}${var.env_key}-device-provision-green"
  resource_group_name   = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  api_management_name   = data.azurerm_api_management.shared_apim.name
  description           = "Linux Green Function"
  subscription_required = false
  revision              = "1"
  display_name          = "${var.region_abbreviation}-${var.env_name}${var.env_key}-device-provision-green"
  path                  = "${var.region_abbreviation}-${var.env_name}${var.env_key}/green/api"
  protocols             = ["https"]
  provider              = azurerm.Production

}

resource "azurerm_api_management_api" "equipment-rules-api" {
  name                  = "${var.region_abbreviation}-${var.env_name}${var.env_key}-equipment-rules-api"
  resource_group_name   = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  api_management_name   = data.azurerm_api_management.shared_apim.name
  description           = "Equipment rules service endpoint"
  subscription_required = false
  revision              = "1"
  display_name          = "${var.region_abbreviation}-${var.env_name}${var.env_key}-Equipment Rules API"
  path                  = "${var.region_abbreviation}-${var.env_name}${var.env_key}/equipmentRules"
  protocols             = ["https"]
  provider              = azurerm.Production

}

resource "azurerm_api_management_api" "equipments-blue-api" {
  name                  = "${var.region_abbreviation}-${var.env_name}${var.env_key}-equipments-blue-api"
  resource_group_name   = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  api_management_name   = data.azurerm_api_management.shared_apim.name
  description           = "Equipment service endpoint"
  subscription_required = false
  revision              = "1"
  display_name          = "${var.region_abbreviation}-${var.env_name}${var.env_key}-equipment-blue"
  path                  = "${var.region_abbreviation}-${var.env_name}${var.env_key}/blue/equipments"
  protocols             = ["https"]
  provider              = azurerm.Production

}

resource "azurerm_api_management_api" "equipments-green-api" {
  name                  = "${var.region_abbreviation}-${var.env_name}${var.env_key}-equipments-green-api"
  resource_group_name   = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  api_management_name   = data.azurerm_api_management.shared_apim.name
  description           = "Equipment service endpoint"
  subscription_required = false
  revision              = "1"
  display_name          = "${var.region_abbreviation}-${var.env_name}${var.env_key}-equipment-green"
  path                  = "${var.region_abbreviation}-${var.env_name}${var.env_key}/green/equipments"
  protocols             = ["https"]
  provider              = azurerm.Production

}

resource "azurerm_api_management_api" "event-api" {
  name                  = "${var.region_abbreviation}-${var.env_name}${var.env_key}-event-api"
  resource_group_name   = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  api_management_name   = data.azurerm_api_management.shared_apim.name
  description           = "Event Service service endpoint"
  subscription_required = false
  revision              = "1"
  display_name          = "${var.region_abbreviation}-${var.env_name}${var.env_key}-Event API"
  path                  = "${var.region_abbreviation}-${var.env_name}${var.env_key}/events"
  protocols             = ["https"]
  provider              = azurerm.Production

}

resource "azurerm_api_management_api" "gateways-api" {
  name                  = "${var.region_abbreviation}-${var.env_name}${var.env_key}-gateways-api"
  resource_group_name   = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  api_management_name   = data.azurerm_api_management.shared_apim.name
  description           = "Gateway service endpoint"
  subscription_required = false
  revision              = "1"
  display_name          = "${var.region_abbreviation}-${var.env_name}${var.env_key}-Gateway API"
  path                  = "${var.region_abbreviation}-${var.env_name}${var.env_key}/gateways"
  protocols             = ["https"]
  provider              = azurerm.Production

}

resource "azurerm_api_management_api" "graphql-blue-api" {
  name                  = "${var.region_abbreviation}-${var.env_name}${var.env_key}-graphql-blue-api"
  resource_group_name   = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  api_management_name   = data.azurerm_api_management.shared_apim.name
  description           = "GraphQL API"
  subscription_required = false
  revision              = "1"
  display_name          = "${var.region_abbreviation}-${var.env_name}${var.env_key}-graphql-blue"
  path                  = "${var.region_abbreviation}-${var.env_name}${var.env_key}/blue/graphql"
  protocols             = ["https"]
  provider              = azurerm.Production

}

resource "azurerm_api_management_api" "graphql-green-api" {
  name                  = "${var.region_abbreviation}-${var.env_name}${var.env_key}-graphql-green-api"
  resource_group_name   = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  api_management_name   = data.azurerm_api_management.shared_apim.name
  description           = "GraphQL API"
  subscription_required = false
  revision              = "1"
  display_name          = "${var.region_abbreviation}-${var.env_name}${var.env_key}-graphql-green"
  path                  = "${var.region_abbreviation}-${var.env_name}${var.env_key}/green/graphql"
  protocols             = ["https"]
  provider              = azurerm.Production

}

resource "azurerm_api_management_api" "navigation-blue-api" {
  name                  = "${var.region_abbreviation}-${var.env_name}${var.env_key}-navigation-blue-api"
  resource_group_name   = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  api_management_name   = data.azurerm_api_management.shared_apim.name
  description           = "Navigation service endpoint"
  subscription_required = false
  revision              = "1"
  display_name          = "${var.region_abbreviation}-${var.env_name}${var.env_key}-navigation-blue"
  path                  = "${var.region_abbreviation}-${var.env_name}${var.env_key}/blue/navigation"
  protocols             = ["https"]
  provider              = azurerm.Production

}

resource "azurerm_api_management_api" "navigation-green-api" {
  name                  = "${var.region_abbreviation}-${var.env_name}${var.env_key}-navigation-green-api"
  resource_group_name   = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  api_management_name   = data.azurerm_api_management.shared_apim.name
  description           = "Navigation service endpoint"
  subscription_required = false
  revision              = "1"
  display_name          = "${var.region_abbreviation}-${var.env_name}${var.env_key}-navigation-green"
  path                  = "${var.region_abbreviation}-${var.env_name}${var.env_key}/green/navigation"
  protocols             = ["https"]
  provider              = azurerm.Production

}

resource "azurerm_api_management_api" "notification-blue-api" {
  name                  = "${var.region_abbreviation}-${var.env_name}${var.env_key}-notification-blue-api"
  resource_group_name   = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  api_management_name   = data.azurerm_api_management.shared_apim.name
  description           = "Foundations Notification REST API"
  subscription_required = false
  revision              = "1"
  display_name          = "${var.region_abbreviation}-${var.env_name}${var.env_key}-notification-blue"
  path                  = "${var.region_abbreviation}-${var.env_name}${var.env_key}/blue/notification"
  protocols             = ["https"]
  provider              = azurerm.Production

}

resource "azurerm_api_management_api" "notification-green-api" {
  name                  = "${var.region_abbreviation}-${var.env_name}${var.env_key}-notification-green-api"
  resource_group_name   = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  api_management_name   = data.azurerm_api_management.shared_apim.name
  description           = "Foundations Notification REST API"
  subscription_required = false
  revision              = "1"
  display_name          = "${var.region_abbreviation}-${var.env_name}${var.env_key}-notification-green"
  path                  = "${var.region_abbreviation}-${var.env_name}${var.env_key}/green/notification"
  protocols             = ["https"]
  provider              = azurerm.Production

}

resource "azurerm_api_management_api" "partner-blue-api" {
  name                  = "${var.region_abbreviation}-${var.env_name}${var.env_key}-partner-blue-api"
  resource_group_name   = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  api_management_name   = data.azurerm_api_management.shared_apim.name
  description           = "Partner service endpoint"
  subscription_required = false
  revision              = "1"
  display_name          = "${var.region_abbreviation}-${var.env_name}${var.env_key}-partner-blue"
  path                  = "${var.region_abbreviation}-${var.env_name}${var.env_key}/blue/partner"
  protocols             = ["https"]
  provider              = azurerm.Production

}

resource "azurerm_api_management_api" "partner-green-api" {
  name                  = "${var.region_abbreviation}-${var.env_name}${var.env_key}-partner-green-api"
  resource_group_name   = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  api_management_name   = data.azurerm_api_management.shared_apim.name
  description           = "Partner service endpoint"
  subscription_required = false
  revision              = "1"
  display_name          = "${var.region_abbreviation}-${var.env_name}${var.env_key}-partner-green"
  path                  = "${var.region_abbreviation}-${var.env_name}${var.env_key}/green/partner"
  protocols             = ["https"]
  provider              = azurerm.Production

}

resource "azurerm_api_management_api" "rule-api" {
  name                  = "${var.region_abbreviation}-${var.env_name}${var.env_key}-rule-api"
  resource_group_name   = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  api_management_name   = data.azurerm_api_management.shared_apim.name
  description           = "rule Service service endpoint"
  subscription_required = false
  revision              = "1"
  display_name          = "${var.region_abbreviation}-${var.env_name}${var.env_key}-rule API"
  path                  = "${var.region_abbreviation}-${var.env_name}${var.env_key}/rules"
  protocols             = ["https"]
  provider              = azurerm.Production

}

resource "azurerm_api_management_api" "team-api" {
  name                  = "${var.region_abbreviation}-${var.env_name}${var.env_key}-team-api"
  resource_group_name   = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  api_management_name   = data.azurerm_api_management.shared_apim.name
  description           = "team Service service endpoint"
  subscription_required = false
  revision              = "1"
  display_name          = "${var.region_abbreviation}-${var.env_name}${var.env_key}-team API"
  path                  = "${var.region_abbreviation}-${var.env_name}${var.env_key}/teams"
  protocols             = ["https"]
  provider              = azurerm.Production

}

resource "azurerm_api_management_api" "users-blue-api" {
  name                  = "${var.region_abbreviation}-${var.env_name}${var.env_key}-users-blue-api"
  resource_group_name   = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  api_management_name   = data.azurerm_api_management.shared_apim.name
  description           = "Users service endpoint"
  subscription_required = false
  revision              = "1"
  display_name          = "${var.region_abbreviation}-${var.env_name}${var.env_key}-users-blue"
  path                  = "${var.region_abbreviation}-${var.env_name}${var.env_key}/blue/users"
  protocols             = ["https"]
  provider              = azurerm.Production

}

resource "azurerm_api_management_api" "users-green-api" {
  name                  = "${var.region_abbreviation}-${var.env_name}${var.env_key}-users-green-api"
  resource_group_name   = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  api_management_name   = data.azurerm_api_management.shared_apim.name
  description           = "Users service endpoint"
  subscription_required = false
  revision              = "1"
  display_name          = "${var.region_abbreviation}-${var.env_name}${var.env_key}-users-green"
  path                  = "${var.region_abbreviation}-${var.env_name}${var.env_key}/green/users"
  protocols             = ["https"]
  provider              = azurerm.Production

}

resource "azurerm_api_management_api" "validations-blue-api" {
  name                  = "${var.region_abbreviation}-${var.env_name}${var.env_key}-validations-blue-api"
  resource_group_name   = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  api_management_name   = data.azurerm_api_management.shared_apim.name
  description           = "Validations service endpoint"
  subscription_required = false
  revision              = "1"
  display_name          = "${var.region_abbreviation}-${var.env_name}${var.env_key}-vvalidation-blue"
  path                  = "${var.region_abbreviation}-${var.env_name}${var.env_key}/blue/validations"
  protocols             = ["https"]
  provider              = azurerm.Production

}

resource "azurerm_api_management_api" "validations-green-api" {
  name                  = "${var.region_abbreviation}-${var.env_name}${var.env_key}-validations-green-api"
  resource_group_name   = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  api_management_name   = data.azurerm_api_management.shared_apim.name
  description           = "Validations service endpoint"
  subscription_required = false
  revision              = "1"
  display_name          = "${var.region_abbreviation}-${var.env_name}${var.env_key}-validation-green"
  path                  = "${var.region_abbreviation}-${var.env_name}${var.env_key}/green/validations"
  protocols             = ["https"]
  provider              = azurerm.Production

}

##Operations##

resource "azurerm_api_management_api_operation" "audit_logs_operation" {
  operation_id        = "auditLogs"
  api_name            = azurerm_api_management_api.audit-logs-api-apim.name
  api_management_name = data.azurerm_api_management.shared_apim.name
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  display_name        = "getAuditLogs"
  method              = "GET"
  url_template        = "/{entity_name}/{entity_id}"
  provider            = azurerm.Production

  template_parameter {
    name     = "entity_name"
    type     = "string"
    required = true
    values   = []

  }
  template_parameter {
    name     = "entity_id"
    type     = "string"
    required = true
    values   = []
  }
}


resource "azurerm_api_management_api_operation" "create_alert_operation" {
  operation_id        = "createAlert"
  api_name            = azurerm_api_management_api.alert-api-apim.name
  api_management_name = data.azurerm_api_management.shared_apim.name
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  display_name        = "createAlert"
  method              = "POST"
  url_template        = "/"
  provider            = azurerm.Production

}


resource "azurerm_api_management_api_operation" "create_dataviews_operation" {
  operation_id        = "createDataView"
  api_name            = azurerm_api_management_api.dataviews-api.name
  api_management_name = data.azurerm_api_management.shared_apim.name
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  display_name        = "createDataView"
  method              = "POST"
  url_template        = "/dataviews"
  provider            = azurerm.Production

}


resource "azurerm_api_management_api_operation" "create_dataviewsgroups_operation" {
  operation_id        = "createDataViewGroups"
  api_name            = azurerm_api_management_api.dataviews-api.name
  api_management_name = data.azurerm_api_management.shared_apim.name
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  display_name        = "createDataViewGroup"
  method              = "POST"
  url_template        = "/dataviewgroups"
  provider            = azurerm.Production

}


resource "azurerm_api_management_api_operation" "create_equipmentrule_operation_blue" {
  operation_id        = "PostEquipmentRule"
  api_name            = azurerm_api_management_api.equipments-blue-api.name
  api_management_name = data.azurerm_api_management.shared_apim.name
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  display_name        = "PostEquipmentRule"
  method              = "POST"
  url_template        = "/equipmentRules"
  provider            = azurerm.Production

}


resource "azurerm_api_management_api_operation" "create_equipmentrule_operation_green" {
  operation_id        = "PostEquipmentRule"
  api_name            = azurerm_api_management_api.equipments-green-api.name
  api_management_name = data.azurerm_api_management.shared_apim.name
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  display_name        = "PostEquipmentRule"
  method              = "POST"
  url_template        = "/equipmentRules"
  provider            = azurerm.Production

}



resource "azurerm_api_management_api_operation" "createMetricEvent_operation_blue" {
  operation_id        = "PostMetricEevents"
  api_name            = azurerm_api_management_api.equipments-blue-api.name
  api_management_name = data.azurerm_api_management.shared_apim.name
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  display_name        = "PostMetricEevents"
  method              = "POST"
  url_template        = "/metricEvents"
  provider            = azurerm.Production

}




resource "azurerm_api_management_api_operation" "createMetricEvent_operation_green" {
  operation_id        = "PostMetricEevents"
  api_name            = azurerm_api_management_api.equipments-green-api.name
  api_management_name = data.azurerm_api_management.shared_apim.name
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  display_name        = "PostMetricEevents"
  method              = "POST"
  url_template        = "/metricEvents"
  provider            = azurerm.Production

}



resource "azurerm_api_management_api_operation" "createrule_operation" {
  operation_id        = "createRule"
  api_name            = azurerm_api_management_api.rule-api.name
  api_management_name = data.azurerm_api_management.shared_apim.name
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  display_name        = "createRule"
  method              = "POST"
  url_template        = "/"
  provider            = azurerm.Production

}

resource "azurerm_api_management_api_operation" "createteam_operation" {
  operation_id        = "createTeam"
  api_name            = azurerm_api_management_api.team-api.name
  api_management_name = data.azurerm_api_management.shared_apim.name
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  display_name        = "createTeam"
  method              = "POST"
  url_template        = "/"
  provider            = azurerm.Production

}

resource "azurerm_api_management_api_operation" "deleteAlert_operation" {
  operation_id        = "deleteAlert"
  api_name            = azurerm_api_management_api.alert-api-apim.name
  api_management_name = data.azurerm_api_management.shared_apim.name
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  display_name        = "deleteAlert"
  method              = "DELETE"
  url_template        = "/{id}"
  provider            = azurerm.Production

  template_parameter {
    name     = "id"
    type     = "string"
    required = true
    values   = []
  }
}

resource "azurerm_api_management_api_operation" "deleteDataView_operation" {
  operation_id        = "deleteDataView"
  api_name            = azurerm_api_management_api.dataviews-api.name
  api_management_name = data.azurerm_api_management.shared_apim.name
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  display_name        = "deleteDataView"
  method              = "DELETE"
  url_template        = "/dataviews/{data_view_id}"
  provider            = azurerm.Production

  template_parameter {
    name     = "data_view_id"
    type     = "string"
    required = true
    values   = []
  }
}

resource "azurerm_api_management_api_operation" "deleteDataViewGroup_operation" {
  operation_id        = "deleteDataViewGroups"
  api_name            = azurerm_api_management_api.dataviews-api.name
  api_management_name = data.azurerm_api_management.shared_apim.name
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  display_name        = "deleteDataViewGroups"
  method              = "DELETE"
  url_template        = "/dataviewgroups/{data_view_group_id}"
  provider            = azurerm.Production

  template_parameter {
    name     = "data_view_group_id"
    type     = "string"
    required = true
    values   = []
  }
}

resource "azurerm_api_management_api_operation" "deleteRule_operation" {
  operation_id        = "deleteRule"
  api_name            = azurerm_api_management_api.rule-api.name
  api_management_name = data.azurerm_api_management.shared_apim.name
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  display_name        = "deleteRule"
  method              = "DELETE"
  url_template        = "/{id}"
  provider            = azurerm.Production

  template_parameter {
    name     = "id"
    type     = "string"
    required = true
    values   = []
  }
}

resource "azurerm_api_management_api_operation" "deleteteam_operation" {
  operation_id        = "deleteTeam"
  api_name            = azurerm_api_management_api.team-api.name
  api_management_name = data.azurerm_api_management.shared_apim.name
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  display_name        = "deleteTeam"
  method              = "DELETE"
  url_template        = "/{id}"
  provider            = azurerm.Production

  template_parameter {
    name     = "id"
    type     = "string"
    required = true
    values   = []
  }
}

resource "azurerm_api_management_api_operation" "getalert_operation" {
  operation_id        = "getAlert"
  api_name            = azurerm_api_management_api.alert-api-apim.name
  api_management_name = data.azurerm_api_management.shared_apim.name
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  display_name        = "getAlert"
  method              = "GET"
  url_template        = "/{id}"
  provider            = azurerm.Production

  template_parameter {
    name     = "id"
    type     = "string"
    required = true
    values   = []
  }
}

resource "azurerm_api_management_api_operation" "getAnalyticsData__blue_operation" {
  operation_id        = "getAnalyticsData"
  api_name            = azurerm_api_management_api.analytics-blue-api-apim.name
  api_management_name = data.azurerm_api_management.shared_apim.name
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  display_name        = "getAnalyticsData"
  method              = "POST"
  url_template        = "/{system_id}/{category_id}/{analytic_id}"
  provider            = azurerm.Production

  template_parameter {
    name     = "system_id"
    type     = "string"
    required = false
    values   = []
  }
  template_parameter {
    name     = "category_id"
    type     = "string"
    required = false
  }
  template_parameter {
    name     = "analytic_id"
    type     = "string"
    required = false
  }

}



resource "azurerm_api_management_api_operation" "getAnalyticsData_green_operation" {
  operation_id        = "getAnalyticsData"
  api_name            = azurerm_api_management_api.analytics-green-api-apim.name
  api_management_name = data.azurerm_api_management.shared_apim.name
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  display_name        = "getAnalyticsData"
  method              = "POST"
  url_template        = "/{system_id}/{category_id}/{analytic_id}"
  provider            = azurerm.Production

  template_parameter {
    name     = "system_id"
    type     = "string"
    values   = []
    required = false
  }
  template_parameter {
    name     = "category_id"
    type     = "string"
    required = false

  }
  template_parameter {
    name     = "analytic_id"
    type     = "string"
    required = false

  }

}


resource "azurerm_api_management_api_operation" "getAnalyticsDataLegacy_blue_operation" {
  operation_id        = "getAnalyticsDataLegacy"
  api_name            = azurerm_api_management_api.analytics-blue-api-apim.name
  api_management_name = data.azurerm_api_management.shared_apim.name
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  display_name        = "getAnalyticsDataLegacy"
  method              = "GET"
  url_template        = "/{system_id}"
  provider            = azurerm.Production

  template_parameter {
    name     = "system_id"
    type     = "string"
    required = false

    values = []
  }

}

resource "azurerm_api_management_api_operation" "getAnalyticsDataLegacy_green_operation" {
  operation_id        = "getAnalyticsDataLegacy"
  api_name            = azurerm_api_management_api.analytics-green-api-apim.name
  api_management_name = data.azurerm_api_management.shared_apim.name
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  display_name        = "getAnalyticsDataLegacy"
  method              = "GET"
  url_template        = "/{system_id}"
  provider            = azurerm.Production

  template_parameter {
    name     = "system_id"
    type     = "string"
    required = false

    values = []
  }

}


resource "azurerm_api_management_api_operation" "getConfig_operation" {
  operation_id        = "getConfig"
  api_name            = azurerm_api_management_api.config-api.name
  api_management_name = data.azurerm_api_management.shared_apim.name
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  display_name        = "getConfig"
  method              = "GET"
  url_template        = "/"
  provider            = azurerm.Production

}

resource "azurerm_api_management_api_operation" "users_blue_operation" {
  operation_id        = "GET-CoreGraph"
  api_name            = azurerm_api_management_api.core-blue-api.name
  api_management_name = data.azurerm_api_management.shared_apim.name
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  display_name        = "CoreGraph (GET)"
  method              = "GET"
  url_template        = "/core"
  provider            = azurerm.Production

}

resource "azurerm_api_management_api_operation" "users_green_operation" {
  operation_id        = "GET-CoreGraph"
  api_name            = azurerm_api_management_api.core-green-api.name
  api_management_name = data.azurerm_api_management.shared_apim.name
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  display_name        = "CoreGraph (GET)"
  method              = "GET"
  url_template        = "/core"
  provider            = azurerm.Production

}


resource "azurerm_api_management_api_operation" "getDataView_operation" {
  operation_id        = "getDataView"
  api_name            = azurerm_api_management_api.dataviews-api.name
  api_management_name = data.azurerm_api_management.shared_apim.name
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  display_name        = "getDataView"
  method              = "GET"
  url_template        = "/dataviews/{data_view_id}"
  provider            = azurerm.Production

  template_parameter {
    name     = "data_view_id"
    type     = "string"
    required = true
  }
}

resource "azurerm_api_management_api_operation" "getDataViewgroups_operation" {
  operation_id        = "getDataViewGroups"
  api_name            = azurerm_api_management_api.dataviews-api.name
  api_management_name = data.azurerm_api_management.shared_apim.name
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  display_name        = "getDataViewGroups"
  method              = "GET"
  url_template        = "/dataviewgroups"
  provider            = azurerm.Production

}

resource "azurerm_api_management_api_operation" "getDataViewRequests_operation" {
  operation_id        = "getDataViewRequests"
  api_name            = azurerm_api_management_api.dataviews-api.name
  api_management_name = data.azurerm_api_management.shared_apim.name
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  display_name        = "PostDataViewRequests"
  method              = "POST"
  url_template        = "/dataviews/{data_view_id}/requests"
  provider            = azurerm.Production

  template_parameter {
    name     = "data_view_id"
    type     = "string"
    required = true
  }
}

resource "azurerm_api_management_api_operation" "getDataViews_operation" {
  operation_id        = "getDataViews"
  api_name            = azurerm_api_management_api.dataviews-api.name
  api_management_name = data.azurerm_api_management.shared_apim.name
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  display_name        = "getDataViews"
  method              = "GET"
  url_template        = "/dataviews"
  provider            = azurerm.Production

}

resource "azurerm_api_management_api_operation" "getdocs_blue_operation" {
  operation_id        = "getDocs"
  api_name            = azurerm_api_management_api.notification-blue-api.name
  api_management_name = data.azurerm_api_management.shared_apim.name
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  display_name        = "getDocs"
  method              = "GET"
  url_template        = "/docs"
  provider            = azurerm.Production

}


resource "azurerm_api_management_api_operation" "getdocs_green_operation" {
  operation_id        = "getDocs"
  api_name            = azurerm_api_management_api.notification-green-api.name
  api_management_name = data.azurerm_api_management.shared_apim.name
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  display_name        = "getDocs"
  method              = "GET"
  url_template        = "/docs"
  provider            = azurerm.Production

}

resource "azurerm_api_management_api_operation" "getEquipmentAnomalies_blue_operation" {
  operation_id        = "getEquipmentAnomalies"
  api_name            = azurerm_api_management_api.equipments-blue-api.name
  api_management_name = data.azurerm_api_management.shared_apim.name
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  display_name        = "getEquipmentAnomalies"
  method              = "GET"
  url_template        = "/{equipment_id}/anomalies"
  provider            = azurerm.Production

  template_parameter {
    name     = "equipment_id"
    type     = "string"
    required = false

  }

}

resource "azurerm_api_management_api_operation" "getEquipmentAnomalies_green_operation" {
  operation_id        = "getEquipmentAnomalies"
  api_name            = azurerm_api_management_api.equipments-green-api.name
  api_management_name = data.azurerm_api_management.shared_apim.name
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  display_name        = "getEquipmentAnomalies"
  method              = "GET"
  url_template        = "/{equipment_id}/anomalies"
  provider            = azurerm.Production

  template_parameter {
    name     = "equipment_id"
    type     = "string"
    required = false

  }

}

resource "azurerm_api_management_api_operation" "getEquipmentrules_operation" {
  operation_id        = "getEquipmentAnomalies"
  api_name            = azurerm_api_management_api.equipment-rules-api.name
  api_management_name = data.azurerm_api_management.shared_apim.name
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  display_name        = "getEquipmentRules"
  method              = "GET"
  url_template        = "/equipmentRules"
  provider            = azurerm.Production

}

resource "azurerm_api_management_api_operation" "gql_blue_operation" {
  operation_id        = "GETGraphQL"
  api_name            = azurerm_api_management_api.graphql-blue-api.name
  api_management_name = data.azurerm_api_management.shared_apim.name
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  display_name        = "GETGraphQL"
  method              = "GET"
  url_template        = "/"
  provider            = azurerm.Production

}

resource "azurerm_api_management_api_operation" "gql_green_operation" {
  operation_id        = "GETGraphQL"
  api_name            = azurerm_api_management_api.graphql-green-api.name
  api_management_name = data.azurerm_api_management.shared_apim.name
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  display_name        = "GETGraphQL"
  method              = "GET"
  url_template        = "/"
  provider            = azurerm.Production

}


resource "azurerm_api_management_api_operation" "getmetricdata_blue_operation" {
  operation_id        = "getMetricData"
  api_name            = azurerm_api_management_api.equipments-blue-api.name
  api_management_name = data.azurerm_api_management.shared_apim.name
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  display_name        = "getMetricData"
  method              = "GET"
  url_template        = "/{equipment_id}/components/{component_id}/metrics/{metric_id}"
  provider            = azurerm.Production

  template_parameter {
    name     = "equipment_id"
    type     = "string"
    required = false

  }
  template_parameter {
    name     = "component_id"
    type     = "string"
    required = false

  }
  template_parameter {
    name     = "metric_id"
    type     = "string"
    required = false

  }
}


resource "azurerm_api_management_api_operation" "getmetricdata_green_operation" {
  operation_id        = "getMetricData"
  api_name            = azurerm_api_management_api.equipments-green-api.name
  api_management_name = data.azurerm_api_management.shared_apim.name
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  display_name        = "getMetricData"
  method              = "GET"
  url_template        = "/{equipment_id}/components/{component_id}/metrics/{metric_id}"
  provider            = azurerm.Production

  template_parameter {
    name     = "equipment_id"
    type     = "string"
    required = false

  }
  template_parameter {
    name     = "component_id"
    type     = "string"
    required = false

  }
  template_parameter {
    name     = "metric_id"
    type     = "string"
    required = false

  }
}


resource "azurerm_api_management_api_operation" "getmetricevents_operation" {
  operation_id        = "getMetricEvents"
  api_name            = azurerm_api_management_api.equipment-rules-api.name
  api_management_name = data.azurerm_api_management.shared_apim.name
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  display_name        = "getMetricEvents"
  method              = "GET"
  url_template        = "/metricEvents"
  provider            = azurerm.Production

}

resource "azurerm_api_management_api_operation" "getnavigation_blue_operation" {
  operation_id        = "getNavigation"
  api_name            = azurerm_api_management_api.navigation-blue-api.name
  api_management_name = data.azurerm_api_management.shared_apim.name
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  display_name        = "getNavigation"
  method              = "GET"
  url_template        = "/"
  provider            = azurerm.Production

}

resource "azurerm_api_management_api_operation" "getnavigation_green_operation" {
  operation_id        = "getNavigation"
  api_name            = azurerm_api_management_api.navigation-green-api.name
  api_management_name = data.azurerm_api_management.shared_apim.name
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  display_name        = "getNavigation"
  method              = "GET"
  url_template        = "/"
  provider            = azurerm.Production

}

resource "azurerm_api_management_api_operation" "getrule_operation" {
  operation_id        = "getRule"
  api_name            = azurerm_api_management_api.rule-api.name
  api_management_name = data.azurerm_api_management.shared_apim.name
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  display_name        = "getAlert"
  method              = "GET"
  url_template        = "/{id}"
  provider            = azurerm.Production

  template_parameter {
    name     = "id"
    type     = "string"
    required = true
  }
}

resource "azurerm_api_management_api_operation" "getrules_operation" {
  operation_id        = "getRules"
  api_name            = azurerm_api_management_api.rule-api.name
  api_management_name = data.azurerm_api_management.shared_apim.name
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  display_name        = "getRules"
  method              = "GET"
  url_template        = "/"
  provider            = azurerm.Production

}

resource "azurerm_api_management_api_operation" "core_getstatusinfo_blue_operation" {
  operation_id        = "getStatusInfo"
  api_name            = azurerm_api_management_api.core-blue-api.name
  api_management_name = data.azurerm_api_management.shared_apim.name
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  display_name        = "getCoreStatusInfo"
  method              = "GET"
  url_template        = "/status/info"
  provider            = azurerm.Production

}


resource "azurerm_api_management_api_operation" "core_getstatusinfo_green_operation" {
  operation_id        = "getStatusInfo"
  api_name            = azurerm_api_management_api.core-green-api.name
  api_management_name = data.azurerm_api_management.shared_apim.name
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  display_name        = "getCoreStatusInfo"
  method              = "GET"
  url_template        = "/status/info"
  provider            = azurerm.Production

}


resource "azurerm_api_management_api_operation" "gql_getstatusinfo_blue_operation" {
  operation_id        = "getStatusInfo"
  api_name            = azurerm_api_management_api.graphql-blue-api.name
  api_management_name = data.azurerm_api_management.shared_apim.name
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  display_name        = "getCoreStatusInfo"
  method              = "GET"
  url_template        = "/status/info"
  provider            = azurerm.Production

}

resource "azurerm_api_management_api_operation" "gql_getstatusinfo_green_operation" {
  operation_id        = "getStatusInfo"
  api_name            = azurerm_api_management_api.graphql-green-api.name
  api_management_name = data.azurerm_api_management.shared_apim.name
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  display_name        = "getCoreStatusInfo"
  method              = "GET"
  url_template        = "/status/info"
  provider            = azurerm.Production

}

resource "azurerm_api_management_api_operation" "notification_getstatusinfo_blue_operation" {
  operation_id        = "getStatusInfo"
  api_name            = azurerm_api_management_api.notification-blue-api.name
  api_management_name = data.azurerm_api_management.shared_apim.name
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  display_name        = "getCoreStatusInfo"
  method              = "GET"
  url_template        = "/status/info"
  provider            = azurerm.Production

}

resource "azurerm_api_management_api_operation" "notification_getstatusinfo_green_operation" {
  operation_id        = "getStatusInfo"
  api_name            = azurerm_api_management_api.notification-green-api.name
  api_management_name = data.azurerm_api_management.shared_apim.name
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  display_name        = "getCoreStatusInfo"
  method              = "GET"
  url_template        = "/status/info"
  provider            = azurerm.Production

}

resource "azurerm_api_management_api_operation" "getteam_operation" {
  operation_id        = "getTeam"
  api_name            = azurerm_api_management_api.team-api.name
  api_management_name = data.azurerm_api_management.shared_apim.name
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  display_name        = "getTeam"
  method              = "GET"
  url_template        = "/{id}"
  provider            = azurerm.Production

  template_parameter {
    name     = "id"
    type     = "string"
    required = true
  }
}

resource "azurerm_api_management_api_operation" "getteamgraph_operation" {
  operation_id        = "get-TeamGraph"
  api_name            = azurerm_api_management_api.alert-api-apim.name
  api_management_name = data.azurerm_api_management.shared_apim.name
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  display_name        = "TeamGraph (GET)"
  method              = "GET"
  url_template        = "/team/graphql"
  provider            = azurerm.Production

}

resource "azurerm_api_management_api_operation" "getteams_operation" {
  operation_id        = "getteams"
  api_name            = azurerm_api_management_api.team-api.name
  api_management_name = data.azurerm_api_management.shared_apim.name
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  display_name        = "getTeams"
  method              = "GET"
  url_template        = "/"
  provider            = azurerm.Production

}

resource "azurerm_api_management_api_operation" "getuserconfig_blue_operation" {
  operation_id        = "getUserConfig"
  api_name            = azurerm_api_management_api.users-blue-api.name
  api_management_name = data.azurerm_api_management.shared_apim.name
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  display_name        = "getUserConfig"
  method              = "GET"
  url_template        = "/{user_id}/config"
  provider            = azurerm.Production

  template_parameter {
    name     = "user_id"
    type     = "string"
    required = false


  }
}

resource "azurerm_api_management_api_operation" "getuserconfig_green_operation" {
  operation_id        = "getUserConfig"
  api_name            = azurerm_api_management_api.users-green-api.name
  api_management_name = data.azurerm_api_management.shared_apim.name
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  display_name        = "getUserConfig"
  method              = "GET"
  url_template        = "/{user_id}/config"
  provider            = azurerm.Production

  template_parameter {
    name     = "user_id"
    type     = "string"
    required = false

  }
}

resource "azurerm_api_management_api_operation" "healthcheck_operation" {
  operation_id        = "healthcheck"
  api_name            = azurerm_api_management_api.event-api.name
  api_management_name = data.azurerm_api_management.shared_apim.name
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  display_name        = "ping"
  method              = "GET"
  url_template        = "/"
  provider            = azurerm.Production

}

resource "azurerm_api_management_api_operation" "alert-graph_operation" {
  operation_id        = "POST-AlertGraph"
  api_name            = azurerm_api_management_api.alert-api-apim.name
  api_management_name = data.azurerm_api_management.shared_apim.name
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  display_name        = "AlertGraph (POST)"
  method              = "POST"
  url_template        = "/alert/graphql"
  provider            = azurerm.Production

}

resource "azurerm_api_management_api_operation" "postAnalyticsDataLegacy_blue_operation" {
  operation_id        = "postAnalyticsDataLegacy"
  api_name            = azurerm_api_management_api.analytics-blue-api-apim.name
  api_management_name = data.azurerm_api_management.shared_apim.name
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  display_name        = "getAnalyticsData"
  method              = "POST"
  url_template        = "/{system_id}"
  provider            = azurerm.Production

  template_parameter {
    name     = "system_id"
    type     = "string"
    required = false

  }
}


resource "azurerm_api_management_api_operation" "postAnalyticsDataLegacy_green_operation" {
  operation_id        = "postAnalyticsDataLegacy"
  api_name            = azurerm_api_management_api.analytics-green-api-apim.name
  api_management_name = data.azurerm_api_management.shared_apim.name
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  display_name        = "getAnalyticsData"
  method              = "POST"
  url_template        = "/{system_id}"
  provider            = azurerm.Production

  template_parameter {
    name     = "system_id"
    type     = "string"
    required = false

  }
}

resource "azurerm_api_management_api_operation" "POST-CoreGraph_blue_operation" {
  operation_id        = "POST-CoreGraph"
  api_name            = azurerm_api_management_api.users-blue-api.name
  api_management_name = data.azurerm_api_management.shared_apim.name
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  display_name        = "CoreGraph (POST)"
  method              = "POST"
  url_template        = "/core"
  provider            = azurerm.Production

}


resource "azurerm_api_management_api_operation" "POST-CoreGraph_green_operation" {
  operation_id        = "POST-CoreGraph"
  api_name            = azurerm_api_management_api.users-green-api.name
  api_management_name = data.azurerm_api_management.shared_apim.name
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  display_name        = "CoreGraph (POST)"
  method              = "POST"
  url_template        = "/core"
  provider            = azurerm.Production

}


resource "azurerm_api_management_api_operation" "postEquipmentGremlinQuery_blue_operation" {
  operation_id        = "postEquipmentGremlinQuery"
  api_name            = azurerm_api_management_api.equipments-blue-api.name
  api_management_name = data.azurerm_api_management.shared_apim.name
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  display_name        = "CoreGraph (POST)"
  method              = "POST"
  url_template        = "/gremlinQuery"
  provider            = azurerm.Production

}


resource "azurerm_api_management_api_operation" "postEquipmentGremlinQuery_green_operation" {
  operation_id        = "postEquipmentGremlinQuery"
  api_name            = azurerm_api_management_api.equipments-green-api.name
  api_management_name = data.azurerm_api_management.shared_apim.name
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  display_name        = "CoreGraph (POST)"
  method              = "POST"
  url_template        = "/gremlinQuery"
  provider            = azurerm.Production

}



resource "azurerm_api_management_api_operation" "postgraphql_blue_operation" {
  operation_id        = "postgraphql"
  api_name            = azurerm_api_management_api.graphql-blue-api.name
  api_management_name = data.azurerm_api_management.shared_apim.name
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  display_name        = "POSTGraphQL"
  method              = "POST"
  url_template        = "/"
  provider            = azurerm.Production

}

resource "azurerm_api_management_api_operation" "postgraphql_green_operation" {
  operation_id        = "postgraphql"
  api_name            = azurerm_api_management_api.graphql-green-api.name
  api_management_name = data.azurerm_api_management.shared_apim.name
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  display_name        = "POSTGraphQL"
  method              = "POST"
  url_template        = "/"
  provider            = azurerm.Production

}


resource "azurerm_api_management_api_operation" "post-postedgedeviceprovisionlinux_blue_operation" {
  operation_id        = "post-postedgedeviceprovisionlinux"
  api_name            = azurerm_api_management_api.device-provision-blue.name
  api_management_name = data.azurerm_api_management.shared_apim.name
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  display_name        = "postEdgeDeviceProvisionLinux"
  method              = "POST"
  url_template        = "/linux/edgeDevice/provision"
  provider            = azurerm.Production

}


resource "azurerm_api_management_api_operation" "post-postedgedeviceprovisionlinux_green_operation" {
  operation_id        = "post-postedgedeviceprovisionlinux"
  api_name            = azurerm_api_management_api.device-provision-green.name
  api_management_name = data.azurerm_api_management.shared_apim.name
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  display_name        = "postEdgeDeviceProvisionLinux"
  method              = "POST"
  url_template        = "/linux/edgeDevice/provision"
  provider            = azurerm.Production

}

resource "azurerm_api_management_api_operation" "POST-TeamGraph_operation" {
  operation_id        = "POST-TeamGraph"
  api_name            = azurerm_api_management_api.alert-api-apim.name
  api_management_name = data.azurerm_api_management.shared_apim.name
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  display_name        = "TeamGraph (POST)"
  method              = "POST"
  url_template        = "/team/graphql"
  provider            = azurerm.Production

}

resource "azurerm_api_management_api_operation" "putConfig_operation" {
  operation_id        = "putConfig"
  api_name            = azurerm_api_management_api.config-api.name
  api_management_name = data.azurerm_api_management.shared_apim.name
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  display_name        = "updateConfig"
  method              = "PUT"
  url_template        = "/"
  provider            = azurerm.Production

}

resource "azurerm_api_management_api_operation" "saveGatewayTelemetry_operation" {
  operation_id        = "saveGatewayTelemetry"
  api_name            = azurerm_api_management_api.gateways-api.name
  api_management_name = data.azurerm_api_management.shared_apim.name
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  display_name        = "PostGatewayMessage"
  method              = "POST"
  url_template        = "/message"
  provider            = azurerm.Production

}

resource "azurerm_api_management_api_operation" "partner_saveGatewayTelemetry_blue_operation" {
  operation_id        = "saveGatewayTelemetry"
  api_name            = azurerm_api_management_api.partner-blue-api.name
  api_management_name = data.azurerm_api_management.shared_apim.name
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  display_name        = "PostGatewayMessage"
  method              = "POST"
  url_template        = "/message"
  provider            = azurerm.Production

}

resource "azurerm_api_management_api_operation" "partner_saveGatewayTelemetry_green_operation" {
  operation_id        = "saveGatewayTelemetry"
  api_name            = azurerm_api_management_api.partner-green-api.name
  api_management_name = data.azurerm_api_management.shared_apim.name
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  display_name        = "PostGatewayMessage"
  method              = "POST"
  url_template        = "/message"
  provider            = azurerm.Production

}

resource "azurerm_api_management_api_operation" "sendEmail_blue_operation" {
  operation_id        = "sendEmail"
  api_name            = azurerm_api_management_api.notification-blue-api.name
  api_management_name = data.azurerm_api_management.shared_apim.name
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  display_name        = "sendEmail"
  method              = "POST"
  url_template        = "/email"
  provider            = azurerm.Production

}


resource "azurerm_api_management_api_operation" "sendEmail_green_operation" {
  operation_id        = "sendEmail"
  api_name            = azurerm_api_management_api.notification-green-api.name
  api_management_name = data.azurerm_api_management.shared_apim.name
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  display_name        = "sendEmail"
  method              = "POST"
  url_template        = "/email"
  provider            = azurerm.Production

}



resource "azurerm_api_management_api_operation" "sendtext_blue_operation" {
  operation_id        = "sendText"
  api_name            = azurerm_api_management_api.notification-blue-api.name
  api_management_name = data.azurerm_api_management.shared_apim.name
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  display_name        = "sendText"
  method              = "POST"
  url_template        = "/text"
  provider            = azurerm.Production

}


resource "azurerm_api_management_api_operation" "sendtext_green_operation" {
  operation_id        = "sendText"
  api_name            = azurerm_api_management_api.notification-green-api.name
  api_management_name = data.azurerm_api_management.shared_apim.name
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  display_name        = "sendText"
  method              = "POST"
  url_template        = "/text"
  provider            = azurerm.Production

}


resource "azurerm_api_management_api_operation" "updateAlertStatus_operation" {
  operation_id        = "updateAlertStatus"
  api_name            = azurerm_api_management_api.alert-api-apim.name
  api_management_name = data.azurerm_api_management.shared_apim.name
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  display_name        = "updateTeam"
  method              = "PUT"
  url_template        = "/{id}/status"
  provider            = azurerm.Production

  template_parameter {
    name     = "id"
    type     = "string"
    required = true
  }
}

resource "azurerm_api_management_api_operation" "updateDataView_operation" {
  operation_id        = "updateDataView"
  api_name            = azurerm_api_management_api.dataviews-api.name
  api_management_name = data.azurerm_api_management.shared_apim.name
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  display_name        = "updateDataView"
  method              = "PATCH"
  url_template        = "/dataviews/{data_view_id}"
  provider            = azurerm.Production

  template_parameter {
    name     = "data_view_id"
    type     = "string"
    required = true
  }
}

resource "azurerm_api_management_api_operation" "updateDataViewGroup_operation" {
  operation_id        = "updateDataViewGroup"
  api_name            = azurerm_api_management_api.dataviews-api.name
  api_management_name = data.azurerm_api_management.shared_apim.name
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  display_name        = "updateDataViewGroup"
  method              = "PATCH"
  url_template        = "/dataviewgroups/{data_view_group_id}"
  provider            = azurerm.Production

  template_parameter {
    name     = "data_view_group_id"
    type     = "string"
    required = true
  }
}

resource "azurerm_api_management_api_operation" "updateMetricEventStatus_operation" {
  operation_id        = "updateMetricEventStatus"
  api_name            = azurerm_api_management_api.equipment-rules-api.name
  api_management_name = data.azurerm_api_management.shared_apim.name
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  display_name        = "updateMetricEventStatus"
  method              = "POST"
  url_template        = "/metricEvents/{metric_event_id}/status"
  provider            = azurerm.Production

  template_parameter {
    name     = "metric_event_id"
    type     = "string"
    required = true
  }
}

resource "azurerm_api_management_api_operation" "updateRule_operation" {
  operation_id        = "updateRule"
  api_name            = azurerm_api_management_api.equipment-rules-api.name
  api_management_name = data.azurerm_api_management.shared_apim.name
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  display_name        = "PatchRule"
  method              = "PATCH"
  url_template        = "/{id}"
  provider            = azurerm.Production

  template_parameter {
    name     = "id"
    type     = "string"
    required = true
  }
}

resource "azurerm_api_management_api_operation" "updateTeam_operation" {
  operation_id        = "updateTeam"
  api_name            = azurerm_api_management_api.team-api.name
  api_management_name = data.azurerm_api_management.shared_apim.name
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  display_name        = "updateTeam"
  method              = "PUT"
  url_template        = "/{id}"
  provider            = azurerm.Production

  template_parameter {
    name     = "id"
    type     = "string"
    required = true
  }
}

resource "azurerm_api_management_api_operation" "validate_blue_operation" {
  operation_id        = "validate"
  api_name            = azurerm_api_management_api.validations-blue-api.name
  api_management_name = data.azurerm_api_management.shared_apim.name
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  display_name        = "PostValidate"
  method              = "POST"
  url_template        = "/validate/{entity_name}/{validation_rule}"
  provider            = azurerm.Production

  template_parameter {
    name     = "entity_name"
    type     = "string"
    required = true
  }
  template_parameter {
    name     = "validation_rule"
    type     = "string"
    required = false

  }
}


resource "azurerm_api_management_api_operation" "validate_green_operation" {
  operation_id        = "validate"
  api_name            = azurerm_api_management_api.validations-green-api.name
  api_management_name = data.azurerm_api_management.shared_apim.name
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  display_name        = "PostValidate"
  method              = "POST"
  url_template        = "/validate/{entity_name}/{validation_rule}"
  provider            = azurerm.Production

  template_parameter {
    name     = "entity_name"
    type     = "string"
    required = true
  }
  template_parameter {
    name     = "validation_rule"
    type     = "string"
    required = false

  }
}


resource "azurerm_api_management_api_operation" "verifyuser_blue_operation" {
  operation_id        = "verifyUser"
  api_name            = azurerm_api_management_api.users-blue-api.name
  api_management_name = data.azurerm_api_management.shared_apim.name
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  display_name        = "verifyUser"
  method              = "POST"
  url_template        = "/verify/{user_id}"
  provider            = azurerm.Production

  template_parameter {
    name     = "user_id"
    type     = "string"
    required = true
  }
}



resource "azurerm_api_management_api_operation" "verifyuser_green_operation" {
  operation_id        = "verifyUser"
  api_name            = azurerm_api_management_api.users-green-api.name
  api_management_name = data.azurerm_api_management.shared_apim.name
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  display_name        = "verifyUser"
  method              = "POST"
  url_template        = "/verify/{user_id}"
  provider            = azurerm.Production

  template_parameter {
    name     = "user_id"
    type     = "string"
    required = true
  }
}


resource "azurerm_api_management_api_operation" "appendRoleToGroup_blue_operation" {
  operation_id        = "appendRoleToGroup"
  api_name            = azurerm_api_management_api.auth-blue-api-apim.name
  api_management_name = data.azurerm_api_management.shared_apim.name
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  display_name        = "AppendRoleToGroup"
  method              = "PATCH"
  url_template        = "/group/{id}/append"
  provider            = azurerm.Production

  template_parameter {
    name     = "id"
    type     = "string"
    required = true
  }
}


resource "azurerm_api_management_api_operation" "appendRoleToGroup_green_operation" {
  operation_id        = "appendRoleToGroup"
  api_name            = azurerm_api_management_api.auth-green-api-apim.name
  api_management_name = data.azurerm_api_management.shared_apim.name
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  display_name        = "AppendRoleToGroup"
  method              = "PATCH"
  url_template        = "/group/{id}/append"
  provider            = azurerm.Production

  template_parameter {
    name     = "id"
    type     = "string"
    required = true
  }
}



resource "azurerm_api_management_api_operation" "authenticate_blue_operation" {
  operation_id        = "authenticate"
  api_name            = azurerm_api_management_api.auth-blue-api-apim.name
  api_management_name = data.azurerm_api_management.shared_apim.name
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  display_name        = "Authenticate"
  method              = "POST"
  url_template        = "/oauth/token"
  provider            = azurerm.Production

}



resource "azurerm_api_management_api_operation" "authenticate_green_operation" {
  operation_id        = "authenticate"
  api_name            = azurerm_api_management_api.auth-green-api-apim.name
  api_management_name = data.azurerm_api_management.shared_apim.name
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  display_name        = "Authenticate"
  method              = "POST"
  url_template        = "/oauth/token"
  provider            = azurerm.Production

}


resource "azurerm_api_management_api_operation" "authorizer_blue_operation" {
  operation_id        = "authorizer"
  api_name            = azurerm_api_management_api.auth-blue-api-apim.name
  api_management_name = data.azurerm_api_management.shared_apim.name
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  display_name        = "Authenticate"
  method              = "GET"
  url_template        = "/authorize"
  provider            = azurerm.Production

}


resource "azurerm_api_management_api_operation" "authorizer_green_operation" {
  operation_id        = "authorizer"
  api_name            = azurerm_api_management_api.auth-green-api-apim.name
  api_management_name = data.azurerm_api_management.shared_apim.name
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  display_name        = "Authenticate"
  method              = "GET"
  url_template        = "/authorize"
  provider            = azurerm.Production

}

resource "azurerm_api_management_api_operation" "bulkUpdateGroupMembers_blue_operation" {
  operation_id        = "bulkUpdateGroupMembers"
  api_name            = azurerm_api_management_api.auth-blue-api-apim.name
  api_management_name = data.azurerm_api_management.shared_apim.name
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  display_name        = "BulkUpdateGroupMembers"
  method              = "PUT"
  url_template        = "/group/{id}/members"
  provider            = azurerm.Production

  template_parameter {
    name     = "id"
    type     = "string"
    required = false
  }
}


resource "azurerm_api_management_api_operation" "bulkUpdateGroupMembers_green_operation" {
  operation_id        = "bulkUpdateGroupMembers"
  api_name            = azurerm_api_management_api.auth-green-api-apim.name
  api_management_name = data.azurerm_api_management.shared_apim.name
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  display_name        = "BulkUpdateGroupMembers"
  method              = "PUT"
  url_template        = "/group/{id}/members"
  provider            = azurerm.Production

  template_parameter {
    name     = "id"
    type     = "string"
    required = false
  }

}


resource "azurerm_api_management_api_operation" "checktoken_blue_operation" {
  operation_id        = "checkToken"
  api_name            = azurerm_api_management_api.auth-blue-api-apim.name
  api_management_name = data.azurerm_api_management.shared_apim.name
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  display_name        = "checkToken"
  method              = "POST"
  url_template        = "/oauth/check_token"
  provider            = azurerm.Production

}



resource "azurerm_api_management_api_operation" "checktoken_green_operation" {
  operation_id        = "checkToken"
  api_name            = azurerm_api_management_api.auth-green-api-apim.name
  api_management_name = data.azurerm_api_management.shared_apim.name
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  display_name        = "checkToken"
  method              = "POST"
  url_template        = "/oauth/check_token"
  provider            = azurerm.Production

}

resource "azurerm_api_management_api_operation" "configuration_blue_operation" {
  operation_id        = "configuration"
  api_name            = azurerm_api_management_api.auth-blue-api-apim.name
  api_management_name = data.azurerm_api_management.shared_apim.name
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  display_name        = "configuration"
  method              = "GET"
  url_template        = "/oauth/configuration"
  provider            = azurerm.Production

}

resource "azurerm_api_management_api_operation" "configuration_green_operation" {
  operation_id        = "configuration"
  api_name            = azurerm_api_management_api.auth-green-api-apim.name
  api_management_name = data.azurerm_api_management.shared_apim.name
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  display_name        = "configuration"
  method              = "GET"
  url_template        = "/oauth/configuration"
  provider            = azurerm.Production

}

resource "azurerm_api_management_api_operation" "createapplication_blue_operation" {
  operation_id        = "createApplication"
  api_name            = azurerm_api_management_api.auth-blue-api-apim.name
  api_management_name = data.azurerm_api_management.shared_apim.name
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  display_name        = "createApplication"
  method              = "POST"
  url_template        = "/application"
  provider            = azurerm.Production

}

resource "azurerm_api_management_api_operation" "createapplication_green_operation" {
  operation_id        = "createApplication"
  api_name            = azurerm_api_management_api.auth-green-api-apim.name
  api_management_name = data.azurerm_api_management.shared_apim.name
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  display_name        = "createApplication"
  method              = "POST"
  url_template        = "/application"
  provider            = azurerm.Production

}

resource "azurerm_api_management_api_operation" "creategroup_blue_operation" {
  operation_id        = "createGroup"
  api_name            = azurerm_api_management_api.auth-blue-api-apim.name
  api_management_name = data.azurerm_api_management.shared_apim.name
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  display_name        = "createGroup"
  method              = "POST"
  url_template        = "/group"
  provider            = azurerm.Production

}

resource "azurerm_api_management_api_operation" "creategroup_green_operation" {
  operation_id        = "createGroup"
  api_name            = azurerm_api_management_api.auth-green-api-apim.name
  api_management_name = data.azurerm_api_management.shared_apim.name
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  display_name        = "createGroup"
  method              = "POST"
  url_template        = "/group"
  provider            = azurerm.Production

}

resource "azurerm_api_management_api_operation" "createpermission_blue_operation" {
  operation_id        = "createPermission"
  api_name            = azurerm_api_management_api.auth-blue-api-apim.name
  api_management_name = data.azurerm_api_management.shared_apim.name
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  display_name        = "createPermission"
  method              = "POST"
  url_template        = "/permission"
  provider            = azurerm.Production

}

resource "azurerm_api_management_api_operation" "createpermission_green_operation" {
  operation_id        = "createPermission"
  api_name            = azurerm_api_management_api.auth-green-api-apim.name
  api_management_name = data.azurerm_api_management.shared_apim.name
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  display_name        = "createPermission"
  method              = "POST"
  url_template        = "/permission"
  provider            = azurerm.Production

}

resource "azurerm_api_management_api_operation" "createrole_blue_operation" {
  operation_id        = "createRole"
  api_name            = azurerm_api_management_api.auth-blue-api-apim.name
  api_management_name = data.azurerm_api_management.shared_apim.name
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  display_name        = "createRole"
  method              = "POST"
  url_template        = "/role"
  provider            = azurerm.Production

}

resource "azurerm_api_management_api_operation" "createrole_green_operation" {
  operation_id        = "createRole"
  api_name            = azurerm_api_management_api.auth-green-api-apim.name
  api_management_name = data.azurerm_api_management.shared_apim.name
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  display_name        = "createRole"
  method              = "POST"
  url_template        = "/role"
  provider            = azurerm.Production

}

resource "azurerm_api_management_api_operation" "createuser_blue_operation" {
  operation_id        = "createUser"
  api_name            = azurerm_api_management_api.auth-blue-api-apim.name
  api_management_name = data.azurerm_api_management.shared_apim.name
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  display_name        = "createUser"
  method              = "POST"
  url_template        = "/user"
  provider            = azurerm.Production

}

resource "azurerm_api_management_api_operation" "createuser_green_operation" {
  operation_id        = "createUser"
  api_name            = azurerm_api_management_api.auth-green-api-apim.name
  api_management_name = data.azurerm_api_management.shared_apim.name
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  display_name        = "createUser"
  method              = "POST"
  url_template        = "/user"
  provider            = azurerm.Production

}

resource "azurerm_api_management_api_operation" "deleteapplication_blue_operation" {
  operation_id        = "deleteApplication"
  api_name            = azurerm_api_management_api.auth-blue-api-apim.name
  api_management_name = data.azurerm_api_management.shared_apim.name
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  display_name        = "deleteApplication"
  method              = "DELETE"
  url_template        = "/application/{id}"
  provider            = azurerm.Production

  template_parameter {
    name     = "id"
    type     = "string"
    required = true
  }
}

resource "azurerm_api_management_api_operation" "deleteapplication_green_operation" {
  operation_id        = "deleteApplication"
  api_name            = azurerm_api_management_api.auth-green-api-apim.name
  api_management_name = data.azurerm_api_management.shared_apim.name
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  display_name        = "deleteApplication"
  method              = "DELETE"
  url_template        = "/application/{id}"
  provider            = azurerm.Production

  template_parameter {
    name     = "id"
    type     = "string"
    required = true
  }
}

resource "azurerm_api_management_api_operation" "deleteapplicationmembers_blue_operation" {
  operation_id        = "deleteApplicationMembers"
  api_name            = azurerm_api_management_api.auth-blue-api-apim.name
  api_management_name = data.azurerm_api_management.shared_apim.name
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  display_name        = "deleteApplicationMembers"
  method              = "DELETE"
  url_template        = "/application/{id}/members"
  provider            = azurerm.Production

  template_parameter {
    name     = "id"
    type     = "string"
    required = true
  }
}

resource "azurerm_api_management_api_operation" "deleteapplicationmembers_green_operation" {
  operation_id        = "deleteApplicationMembers"
  api_name            = azurerm_api_management_api.auth-green-api-apim.name
  api_management_name = data.azurerm_api_management.shared_apim.name
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  display_name        = "deleteApplicationMembers"
  method              = "DELETE"
  url_template        = "/application/{id}/members"
  provider            = azurerm.Production

  template_parameter {
    name     = "id"
    type     = "string"
    required = true
  }
}

resource "azurerm_api_management_api_operation" "deletegroup_blue_operation" {
  operation_id        = "deleteGroup"
  api_name            = azurerm_api_management_api.auth-blue-api-apim.name
  api_management_name = data.azurerm_api_management.shared_apim.name
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  display_name        = "deleteGroup"
  method              = "DELETE"
  url_template        = "/group/{id}"
  provider            = azurerm.Production

  template_parameter {
    name     = "id"
    type     = "string"
    required = true
  }
}

resource "azurerm_api_management_api_operation" "deletegroup_green_operation" {
  operation_id        = "deleteGroup"
  api_name            = azurerm_api_management_api.auth-green-api-apim.name
  api_management_name = data.azurerm_api_management.shared_apim.name
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  display_name        = "deleteGroup"
  method              = "DELETE"
  url_template        = "/group/{id}"
  provider            = azurerm.Production

  template_parameter {
    name     = "id"
    type     = "string"
    required = true
  }
}

resource "azurerm_api_management_api_operation" "deletepermission_blue_operation" {
  operation_id        = "deletePermission"
  api_name            = azurerm_api_management_api.auth-blue-api-apim.name
  api_management_name = data.azurerm_api_management.shared_apim.name
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  display_name        = "deletePermission"
  method              = "DELETE"
  url_template        = "/permission/{id}"
  provider            = azurerm.Production

  template_parameter {
    name     = "id"
    type     = "string"
    required = true
  }
}

resource "azurerm_api_management_api_operation" "deletepermission_green_operation" {
  operation_id        = "deletePermission"
  api_name            = azurerm_api_management_api.auth-green-api-apim.name
  api_management_name = data.azurerm_api_management.shared_apim.name
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  display_name        = "deletePermission"
  method              = "DELETE"
  url_template        = "/permission/{id}"
  provider            = azurerm.Production

  template_parameter {
    name     = "id"
    type     = "string"
    required = true
  }
}

resource "azurerm_api_management_api_operation" "deleterole_blue_operation" {
  operation_id        = "deleteRole"
  api_name            = azurerm_api_management_api.auth-blue-api-apim.name
  api_management_name = data.azurerm_api_management.shared_apim.name
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  display_name        = "deleteRole"
  method              = "DELETE"
  url_template        = "/role/{id}"
  provider            = azurerm.Production

  template_parameter {
    name     = "id"
    type     = "string"
    required = true
  }
}

resource "azurerm_api_management_api_operation" "deleterole_green_operation" {
  operation_id        = "deleteRole"
  api_name            = azurerm_api_management_api.auth-green-api-apim.name
  api_management_name = data.azurerm_api_management.shared_apim.name
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  display_name        = "deleteRole"
  method              = "DELETE"
  url_template        = "/role/{id}"
  provider            = azurerm.Production

  template_parameter {
    name     = "id"
    type     = "string"
    required = true
  }
}

resource "azurerm_api_management_api_operation" "deleteuser_blue_operation" {
  operation_id        = "deleteUser"
  api_name            = azurerm_api_management_api.auth-blue-api-apim.name
  api_management_name = data.azurerm_api_management.shared_apim.name
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  display_name        = "deleteUser"
  method              = "DELETE"
  url_template        = "/user/{id}"
  provider            = azurerm.Production

  template_parameter {
    name     = "id"
    type     = "string"
    required = true
  }
}

resource "azurerm_api_management_api_operation" "deleteuser_green_operation" {
  operation_id        = "deleteUser"
  api_name            = azurerm_api_management_api.auth-green-api-apim.name
  api_management_name = data.azurerm_api_management.shared_apim.name
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  display_name        = "deleteUser"
  method              = "DELETE"
  url_template        = "/user/{id}"
  provider            = azurerm.Production

  template_parameter {
    name     = "id"
    type     = "string"
    required = true
  }
}

resource "azurerm_api_management_api_operation" "docs_blue_operation" {
  operation_id        = "docs"
  api_name            = azurerm_api_management_api.auth-blue-api-apim.name
  api_management_name = data.azurerm_api_management.shared_apim.name
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  display_name        = "docs"
  method              = "GET"
  url_template        = "/docs"
  provider            = azurerm.Production

}

resource "azurerm_api_management_api_operation" "docs_green_operation" {
  operation_id        = "docs"
  api_name            = azurerm_api_management_api.auth-green-api-apim.name
  api_management_name = data.azurerm_api_management.shared_apim.name
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  display_name        = "docs"
  method              = "GET"
  url_template        = "/docs"
  provider            = azurerm.Production

}

resource "azurerm_api_management_api_operation" "expirepassword_blue_operation" {
  operation_id        = "expirePassword"
  api_name            = azurerm_api_management_api.auth-blue-api-apim.name
  api_management_name = data.azurerm_api_management.shared_apim.name
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  display_name        = "expirePassword"
  method              = "POST"
  url_template        = "/password/expire"
  provider            = azurerm.Production

}

resource "azurerm_api_management_api_operation" "expirepassword_green_operation" {
  operation_id        = "expirePassword"
  api_name            = azurerm_api_management_api.auth-green-api-apim.name
  api_management_name = data.azurerm_api_management.shared_apim.name
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  display_name        = "expirePassword"
  method              = "POST"
  url_template        = "/password/expire"
  provider            = azurerm.Production

}

resource "azurerm_api_management_api_operation" "finduser_blue_operation" {
  operation_id        = "findUser"
  api_name            = azurerm_api_management_api.auth-blue-api-apim.name
  api_management_name = data.azurerm_api_management.shared_apim.name
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  display_name        = "findUser"
  method              = "GET"
  url_template        = "/user"
  provider            = azurerm.Production

}

resource "azurerm_api_management_api_operation" "finduser_green_operation" {
  operation_id        = "findUser"
  api_name            = azurerm_api_management_api.auth-green-api-apim.name
  api_management_name = data.azurerm_api_management.shared_apim.name
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  display_name        = "findUser"
  method              = "GET"
  url_template        = "/user"
  provider            = azurerm.Production

}

resource "azurerm_api_management_api_operation" "getapplication_blue_operation" {
  operation_id        = "getApplication"
  api_name            = azurerm_api_management_api.auth-blue-api-apim.name
  api_management_name = data.azurerm_api_management.shared_apim.name
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  display_name        = "getApplication"
  method              = "GET"
  url_template        = "/application/{id}"
  provider            = azurerm.Production

  template_parameter {
    name     = "id"
    type     = "string"
    required = false
  }
}

resource "azurerm_api_management_api_operation" "getapplication_green_operation" {
  operation_id        = "getApplication"
  api_name            = azurerm_api_management_api.auth-green-api-apim.name
  api_management_name = data.azurerm_api_management.shared_apim.name
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  display_name        = "getApplication"
  method              = "GET"
  url_template        = "/application/{id}"
  provider            = azurerm.Production

  template_parameter {
    name     = "id"
    type     = "string"
    required = false
  }
}

resource "azurerm_api_management_api_operation" "getapplicationmembers_blue_operation" {
  operation_id        = "getApplicationMembers"
  api_name            = azurerm_api_management_api.auth-blue-api-apim.name
  api_management_name = data.azurerm_api_management.shared_apim.name
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  display_name        = "getApplicationMembers"
  method              = "GET"
  url_template        = "/application/{id}/members"
  provider            = azurerm.Production

  template_parameter {
    name     = "id"
    type     = "string"
    required = false
  }
}

resource "azurerm_api_management_api_operation" "getapplicationmembers_green_operation" {
  operation_id        = "getApplicationMembers"
  api_name            = azurerm_api_management_api.auth-green-api-apim.name
  api_management_name = data.azurerm_api_management.shared_apim.name
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  display_name        = "getApplicationMembers"
  method              = "GET"
  url_template        = "/application/{id}/members"
  provider            = azurerm.Production

  template_parameter {
    name     = "id"
    type     = "string"
    required = false
  }
}

resource "azurerm_api_management_api_operation" "getapplications_blue_operation" {
  operation_id        = "getApplications"
  api_name            = azurerm_api_management_api.auth-blue-api-apim.name
  api_management_name = data.azurerm_api_management.shared_apim.name
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  display_name        = "getApplications"
  method              = "GET"
  url_template        = "/application"
  provider            = azurerm.Production

}

resource "azurerm_api_management_api_operation" "getapplications_green_operation" {
  operation_id        = "getApplications"
  api_name            = azurerm_api_management_api.auth-green-api-apim.name
  api_management_name = data.azurerm_api_management.shared_apim.name
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  display_name        = "getApplications"
  method              = "GET"
  url_template        = "/application"
  provider            = azurerm.Production

}

resource "azurerm_api_management_api_operation" "getgroup_blue_operation" {
  operation_id        = "getGroup"
  api_name            = azurerm_api_management_api.auth-blue-api-apim.name
  api_management_name = data.azurerm_api_management.shared_apim.name
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  display_name        = "getGroup"
  method              = "GET"
  url_template        = "/group/{id}"
  provider            = azurerm.Production

  template_parameter {
    name     = "id"
    type     = "string"
    required = false
  }
}

resource "azurerm_api_management_api_operation" "getgroup_green_operation" {
  operation_id        = "getGroup"
  api_name            = azurerm_api_management_api.auth-green-api-apim.name
  api_management_name = data.azurerm_api_management.shared_apim.name
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  display_name        = "getGroup"
  method              = "GET"
  url_template        = "/group/{id}"
  provider            = azurerm.Production

  template_parameter {
    name     = "id"
    type     = "string"
    required = false
  }
}

resource "azurerm_api_management_api_operation" "getgroupmembers_blue_operation" {
  operation_id        = "getGroupMembers"
  api_name            = azurerm_api_management_api.auth-blue-api-apim.name
  api_management_name = data.azurerm_api_management.shared_apim.name
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  display_name        = "getGroupMembers"
  method              = "GET"
  url_template        = "/group/{id}/members"
  provider            = azurerm.Production

  template_parameter {
    name     = "id"
    type     = "string"
    required = false
  }
}

resource "azurerm_api_management_api_operation" "getgroupmembers_green_operation" {
  operation_id        = "getGroupMembers"
  api_name            = azurerm_api_management_api.auth-green-api-apim.name
  api_management_name = data.azurerm_api_management.shared_apim.name
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  display_name        = "getGroupMembers"
  method              = "GET"
  url_template        = "/group/{id}/members"
  provider            = azurerm.Production

  template_parameter {
    name     = "id"
    type     = "string"
    required = false
  }
}

resource "azurerm_api_management_api_operation" "getgroups_blue_operation" {
  operation_id        = "getGroups"
  api_name            = azurerm_api_management_api.auth-blue-api-apim.name
  api_management_name = data.azurerm_api_management.shared_apim.name
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  display_name        = "getGroups"
  method              = "GET"
  url_template        = "/group"
  provider            = azurerm.Production

}

resource "azurerm_api_management_api_operation" "getgroups_green_operation" {
  operation_id        = "getGroups"
  api_name            = azurerm_api_management_api.auth-green-api-apim.name
  api_management_name = data.azurerm_api_management.shared_apim.name
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  display_name        = "getGroups"
  method              = "GET"
  url_template        = "/group"
  provider            = azurerm.Production

}

resource "azurerm_api_management_api_operation" "getpermission_blue_operation" {
  operation_id        = "getPermission"
  api_name            = azurerm_api_management_api.auth-blue-api-apim.name
  api_management_name = data.azurerm_api_management.shared_apim.name
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  display_name        = "getPermission"
  method              = "GET"
  url_template        = "/permission/{id}"
  provider            = azurerm.Production

  template_parameter {
    name     = "id"
    type     = "string"
    required = false
  }
}

resource "azurerm_api_management_api_operation" "getpermission_green_operation" {
  operation_id        = "getPermission"
  api_name            = azurerm_api_management_api.auth-green-api-apim.name
  api_management_name = data.azurerm_api_management.shared_apim.name
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  display_name        = "getPermission"
  method              = "GET"
  url_template        = "/permission/{id}"
  provider            = azurerm.Production

  template_parameter {
    name     = "id"
    type     = "string"
    required = false
  }
}

resource "azurerm_api_management_api_operation" "getpermissionmembers_blue_operation" {
  operation_id        = "getPermissionMembers"
  api_name            = azurerm_api_management_api.auth-blue-api-apim.name
  api_management_name = data.azurerm_api_management.shared_apim.name
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  display_name        = "getPermissionMembers"
  method              = "GET"
  url_template        = "/permission/{id}/members"
  provider            = azurerm.Production

  template_parameter {
    name     = "id"
    type     = "string"
    required = false
  }
}

resource "azurerm_api_management_api_operation" "getpermissionmembers_green_operation" {
  operation_id        = "getPermissionMembers"
  api_name            = azurerm_api_management_api.auth-green-api-apim.name
  api_management_name = data.azurerm_api_management.shared_apim.name
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  display_name        = "getPermissionMembers"
  method              = "GET"
  url_template        = "/permission/{id}/members"
  provider            = azurerm.Production

  template_parameter {
    name     = "id"
    type     = "string"
    required = false
  }
}

resource "azurerm_api_management_api_operation" "getpermissions_blue_operation" {
  operation_id        = "getPermissions"
  api_name            = azurerm_api_management_api.auth-blue-api-apim.name
  api_management_name = data.azurerm_api_management.shared_apim.name
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  display_name        = "getPermissions"
  method              = "GET"
  url_template        = "/permission"
  provider            = azurerm.Production

}

resource "azurerm_api_management_api_operation" "getpermissions_green_operation" {
  operation_id        = "getPermissions"
  api_name            = azurerm_api_management_api.auth-green-api-apim.name
  api_management_name = data.azurerm_api_management.shared_apim.name
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  display_name        = "getPermissions"
  method              = "GET"
  url_template        = "/permission"
  provider            = azurerm.Production

}

resource "azurerm_api_management_api_operation" "getrole_blue_operation" {
  operation_id        = "getRole"
  api_name            = azurerm_api_management_api.auth-blue-api-apim.name
  api_management_name = data.azurerm_api_management.shared_apim.name
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  display_name        = "getRole"
  method              = "GET"
  url_template        = "/role/{id}"
  provider            = azurerm.Production

  template_parameter {
    name     = "id"
    type     = "string"
    required = false
  }
}

resource "azurerm_api_management_api_operation" "getrole_green_operation" {
  operation_id        = "getRole"
  api_name            = azurerm_api_management_api.auth-green-api-apim.name
  api_management_name = data.azurerm_api_management.shared_apim.name
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  display_name        = "getRole"
  method              = "GET"
  url_template        = "/role/{id}"
  provider            = azurerm.Production

  template_parameter {
    name     = "id"
    type     = "string"
    required = false
  }
}

resource "azurerm_api_management_api_operation" "getrolemembers_blue_operation" {
  operation_id        = "getRoleMembers"
  api_name            = azurerm_api_management_api.auth-blue-api-apim.name
  api_management_name = data.azurerm_api_management.shared_apim.name
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  display_name        = "getRoleMembers"
  method              = "GET"
  url_template        = "/role/{id}/members"
  provider            = azurerm.Production

  template_parameter {
    name     = "id"
    type     = "string"
    required = false
  }
}

resource "azurerm_api_management_api_operation" "getrolemembers_green_operation" {
  operation_id        = "getRoleMembers"
  api_name            = azurerm_api_management_api.auth-green-api-apim.name
  api_management_name = data.azurerm_api_management.shared_apim.name
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  display_name        = "getRoleMembers"
  method              = "GET"
  url_template        = "/role/{id}/members"
  provider            = azurerm.Production

  template_parameter {
    name     = "id"
    type     = "string"
    required = false
  }
}

resource "azurerm_api_management_api_operation" "getroles_blue_operation" {
  operation_id        = "getRoles"
  api_name            = azurerm_api_management_api.auth-blue-api-apim.name
  api_management_name = data.azurerm_api_management.shared_apim.name
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  display_name        = "getRoles"
  method              = "GET"
  url_template        = "/role"
  provider            = azurerm.Production

}

resource "azurerm_api_management_api_operation" "getroles_green_operation" {
  operation_id        = "getRoles"
  api_name            = azurerm_api_management_api.auth-green-api-apim.name
  api_management_name = data.azurerm_api_management.shared_apim.name
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  display_name        = "getRoles"
  method              = "GET"
  url_template        = "/role"
  provider            = azurerm.Production

}

resource "azurerm_api_management_api_operation" "getuser_blue_operation" {
  operation_id        = "getUser"
  api_name            = azurerm_api_management_api.auth-blue-api-apim.name
  api_management_name = data.azurerm_api_management.shared_apim.name
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  display_name        = "getUser"
  method              = "GET"
  url_template        = "/user/{id}"
  provider            = azurerm.Production

  template_parameter {
    name     = "id"
    type     = "string"
    required = false
  }
}

resource "azurerm_api_management_api_operation" "getuser_green_operation" {
  operation_id        = "getUser"
  api_name            = azurerm_api_management_api.auth-green-api-apim.name
  api_management_name = data.azurerm_api_management.shared_apim.name
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  display_name        = "getUser"
  method              = "GET"
  url_template        = "/user/{id}"
  provider            = azurerm.Production

  template_parameter {
    name     = "id"
    type     = "string"
    required = false
  }
}

resource "azurerm_api_management_api_operation" "getuserinfo_blue_operation" {
  operation_id        = "getUserInfo"
  api_name            = azurerm_api_management_api.auth-blue-api-apim.name
  api_management_name = data.azurerm_api_management.shared_apim.name
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  display_name        = "getUserInfo"
  method              = "GET"
  url_template        = "/userinfo"
  provider            = azurerm.Production

}

resource "azurerm_api_management_api_operation" "getuserinfo_green_operation" {
  operation_id        = "getUserInfo"
  api_name            = azurerm_api_management_api.auth-green-api-apim.name
  api_management_name = data.azurerm_api_management.shared_apim.name
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  display_name        = "getUserInfo"
  method              = "GET"
  url_template        = "/userinfo"
  provider            = azurerm.Production

}

resource "azurerm_api_management_api_operation" "getusers_blue_operation" {
  operation_id        = "getUsers"
  api_name            = azurerm_api_management_api.auth-blue-api-apim.name
  api_management_name = data.azurerm_api_management.shared_apim.name
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  display_name        = "getUsers"
  method              = "GET"
  url_template        = "/users"
  provider            = azurerm.Production

}

resource "azurerm_api_management_api_operation" "getusers_green_operation" {
  operation_id        = "getUsers"
  api_name            = azurerm_api_management_api.auth-green-api-apim.name
  api_management_name = data.azurerm_api_management.shared_apim.name
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  display_name        = "getUsers"
  method              = "GET"
  url_template        = "/users"
  provider            = azurerm.Production

}

resource "azurerm_api_management_api_operation" "ping_blue_operation" {
  operation_id        = "ping"
  api_name            = azurerm_api_management_api.auth-blue-api-apim.name
  api_management_name = data.azurerm_api_management.shared_apim.name
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  display_name        = "ping"
  method              = "GET"
  url_template        = "/health"
  provider            = azurerm.Production

}

resource "azurerm_api_management_api_operation" "ping_green_operation" {
  operation_id        = "ping"
  api_name            = azurerm_api_management_api.auth-green-api-apim.name
  api_management_name = data.azurerm_api_management.shared_apim.name
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  display_name        = "ping"
  method              = "GET"
  url_template        = "/health"
  provider            = azurerm.Production

}

resource "azurerm_api_management_api_operation" "removeRoleFromGroup_blue_operation" {
  operation_id        = "removeRoleFromGroup"
  api_name            = azurerm_api_management_api.auth-blue-api-apim.name
  api_management_name = data.azurerm_api_management.shared_apim.name
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  display_name        = "removeRoleFromGroup"
  method              = "PATCH"
  url_template        = "/group/{id}/remove"
  provider            = azurerm.Production

  template_parameter {
    name     = "id"
    type     = "string"
    required = false
  }
}

resource "azurerm_api_management_api_operation" "removeRoleFromGroup_green_operation" {
  operation_id        = "removeRoleFromGroup"
  api_name            = azurerm_api_management_api.auth-green-api-apim.name
  api_management_name = data.azurerm_api_management.shared_apim.name
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  display_name        = "removeRoleFromGroup"
  method              = "PATCH"
  url_template        = "/group/{id}/remove"
  provider            = azurerm.Production

  template_parameter {
    name     = "id"
    type     = "string"
    required = false
  }
}

resource "azurerm_api_management_api_operation" "resendVerifyUser_blue_operation" {
  operation_id        = "resendVerifyUser"
  api_name            = azurerm_api_management_api.auth-blue-api-apim.name
  api_management_name = data.azurerm_api_management.shared_apim.name
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  display_name        = "resendVerifyUser"
  method              = "PATCH"
  url_template        = "/user/verify"
  provider            = azurerm.Production

}

resource "azurerm_api_management_api_operation" "resendVerifyUser_green_operation" {
  operation_id        = "resendVerifyUser"
  api_name            = azurerm_api_management_api.auth-green-api-apim.name
  api_management_name = data.azurerm_api_management.shared_apim.name
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  display_name        = "resendVerifyUser"
  method              = "PATCH"
  url_template        = "/user/verify"
  provider            = azurerm.Production

}

resource "azurerm_api_management_api_operation" "resetpassword_blue_operation" {
  operation_id        = "resetPassword"
  api_name            = azurerm_api_management_api.auth-blue-api-apim.name
  api_management_name = data.azurerm_api_management.shared_apim.name
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  display_name        = "resetPassword"
  method              = "POST"
  url_template        = "/reset"
  provider            = azurerm.Production

}

resource "azurerm_api_management_api_operation" "resetpassword_green_operation" {
  operation_id        = "resetPassword"
  api_name            = azurerm_api_management_api.auth-green-api-apim.name
  api_management_name = data.azurerm_api_management.shared_apim.name
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  display_name        = "resetPassword"
  method              = "POST"
  url_template        = "/reset"
  provider            = azurerm.Production

}

resource "azurerm_api_management_api_operation" "revokeToken_blue_operation" {
  operation_id        = "revokeToken"
  api_name            = azurerm_api_management_api.auth-blue-api-apim.name
  api_management_name = data.azurerm_api_management.shared_apim.name
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  display_name        = "RevokeToken"
  method              = "POST"
  url_template        = "/oauth/revoke"
  provider            = azurerm.Production

}

resource "azurerm_api_management_api_operation" "revokeToken_green_operation" {
  operation_id        = "revokeToken"
  api_name            = azurerm_api_management_api.auth-green-api-apim.name
  api_management_name = data.azurerm_api_management.shared_apim.name
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  display_name        = "RevokeToken"
  method              = "POST"
  url_template        = "/oauth/revoke"
  provider            = azurerm.Production

}

resource "azurerm_api_management_api_operation" "SsoAuthorize_blue_operation" {
  operation_id        = "ssoAuthorize"
  api_name            = azurerm_api_management_api.auth-blue-api-apim.name
  api_management_name = data.azurerm_api_management.shared_apim.name
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  display_name        = "ssoAuthorize"
  method              = "POST"
  url_template        = "/sso/authorize"
  provider            = azurerm.Production

}

resource "azurerm_api_management_api_operation" "SsoAuthorize_green_operation" {
  operation_id        = "ssoAuthorize"
  api_name            = azurerm_api_management_api.auth-green-api-apim.name
  api_management_name = data.azurerm_api_management.shared_apim.name
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  display_name        = "ssoAuthorize"
  method              = "POST"
  url_template        = "/sso/authorize"
  provider            = azurerm.Production

}

resource "azurerm_api_management_api_operation" "SupportSsoAuthorize_blue_operation" {
  operation_id        = "supportSsoAuthorize"
  api_name            = azurerm_api_management_api.auth-blue-api-apim.name
  api_management_name = data.azurerm_api_management.shared_apim.name
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  display_name        = "supportSsoAuthorize"
  method              = "POST"
  url_template        = "/sso/support/authorize"
  provider            = azurerm.Production

}

resource "azurerm_api_management_api_operation" "SupportSsoAuthorize_green_operation" {
  operation_id        = "supportSsoAuthorize"
  api_name            = azurerm_api_management_api.auth-green-api-apim.name
  api_management_name = data.azurerm_api_management.shared_apim.name
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  display_name        = "supportSsoAuthorize"
  method              = "POST"
  url_template        = "/sso/support/authorize"
  provider            = azurerm.Production

}

resource "azurerm_api_management_api_operation" "updateApplication_blue_operation" {
  operation_id        = "updateApplication"
  api_name            = azurerm_api_management_api.auth-blue-api-apim.name
  api_management_name = data.azurerm_api_management.shared_apim.name
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  display_name        = "updateApplication"
  method              = "PUT"
  url_template        = "/application/{id}"
  provider            = azurerm.Production

  template_parameter {
    name     = "id"
    type     = "string"
    required = false
  }
}

resource "azurerm_api_management_api_operation" "updateApplication_green_operation" {
  operation_id        = "updateApplication"
  api_name            = azurerm_api_management_api.auth-green-api-apim.name
  api_management_name = data.azurerm_api_management.shared_apim.name
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  display_name        = "updateApplication"
  method              = "PUT"
  url_template        = "/application/{id}"
  provider            = azurerm.Production

  template_parameter {
    name     = "id"
    type     = "string"
    required = false
  }
}

resource "azurerm_api_management_api_operation" "updateApplicationmembers_blue_operation" {
  operation_id        = "updateApplicationMembers"
  api_name            = azurerm_api_management_api.auth-blue-api-apim.name
  api_management_name = data.azurerm_api_management.shared_apim.name
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  display_name        = "updateApplicationMembers"
  method              = "PATCH"
  url_template        = "/application/{id}/members"
  provider            = azurerm.Production

  template_parameter {
    name     = "id"
    type     = "string"
    required = false
  }
}

resource "azurerm_api_management_api_operation" "updateApplicationmembers_green_operation" {
  operation_id        = "updateApplicationMembers"
  api_name            = azurerm_api_management_api.auth-green-api-apim.name
  api_management_name = data.azurerm_api_management.shared_apim.name
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  display_name        = "updateApplicationMembers"
  method              = "PATCH"
  url_template        = "/application/{id}/members"
  provider            = azurerm.Production

  template_parameter {
    name     = "id"
    type     = "string"
    required = false
  }
}

resource "azurerm_api_management_api_operation" "updateGroup_blue_operation" {
  operation_id        = "updateGroup"
  api_name            = azurerm_api_management_api.auth-blue-api-apim.name
  api_management_name = data.azurerm_api_management.shared_apim.name
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  display_name        = "updateGroup"
  method              = "PUT"
  url_template        = "/group/{id}"
  provider            = azurerm.Production

  template_parameter {
    name     = "id"
    type     = "string"
    required = false
  }
}

resource "azurerm_api_management_api_operation" "updateGroup_green_operation" {
  operation_id        = "updateGroup"
  api_name            = azurerm_api_management_api.auth-green-api-apim.name
  api_management_name = data.azurerm_api_management.shared_apim.name
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  display_name        = "updateGroup"
  method              = "PUT"
  url_template        = "/group/{id}"
  provider            = azurerm.Production

  template_parameter {
    name     = "id"
    type     = "string"
    required = false
  }
}

resource "azurerm_api_management_api_operation" "updatePassword_blue_operation" {
  operation_id        = "updatePassword"
  api_name            = azurerm_api_management_api.auth-blue-api-apim.name
  api_management_name = data.azurerm_api_management.shared_apim.name
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  display_name        = "updatePassword"
  method              = "PUT"
  url_template        = "/password"
  provider            = azurerm.Production

}

resource "azurerm_api_management_api_operation" "updatePassword_green_operation" {
  operation_id        = "updatePassword"
  api_name            = azurerm_api_management_api.auth-green-api-apim.name
  api_management_name = data.azurerm_api_management.shared_apim.name
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  display_name        = "updatePassword"
  method              = "PUT"
  url_template        = "/password"
  provider            = azurerm.Production

}

resource "azurerm_api_management_api_operation" "updatePermission_blue_operation" {
  operation_id        = "updatePermission"
  api_name            = azurerm_api_management_api.auth-blue-api-apim.name
  api_management_name = data.azurerm_api_management.shared_apim.name
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  display_name        = "updatePermission"
  method              = "PUT"
  url_template        = "/permission/{id}"
  provider            = azurerm.Production

  template_parameter {
    name     = "id"
    type     = "string"
    required = false
  }
}

resource "azurerm_api_management_api_operation" "updatePermission_green_operation" {
  operation_id        = "updatePermission"
  api_name            = azurerm_api_management_api.auth-green-api-apim.name
  api_management_name = data.azurerm_api_management.shared_apim.name
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  display_name        = "updatePermission"
  method              = "PUT"
  url_template        = "/permission/{id}"
  provider            = azurerm.Production

  template_parameter {
    name     = "id"
    type     = "string"
    required = false
  }
}

resource "azurerm_api_management_api_operation" "updateRole_blue_operation" {
  operation_id        = "updateRole"
  api_name            = azurerm_api_management_api.auth-blue-api-apim.name
  api_management_name = data.azurerm_api_management.shared_apim.name
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  display_name        = "updateRole"
  method              = "PUT"
  url_template        = "/role/{id}"
  provider            = azurerm.Production

  template_parameter {
    name     = "id"
    type     = "string"
    required = false
  }
}

resource "azurerm_api_management_api_operation" "updateRole_green_operation" {
  operation_id        = "updateRole"
  api_name            = azurerm_api_management_api.auth-green-api-apim.name
  api_management_name = data.azurerm_api_management.shared_apim.name
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  display_name        = "updateRole"
  method              = "PUT"
  url_template        = "/role/{id}"
  provider            = azurerm.Production

  template_parameter {
    name     = "id"
    type     = "string"
    required = false
  }
}

resource "azurerm_api_management_api_operation" "updateUser_blue_operation" {
  operation_id        = "updateUser"
  api_name            = azurerm_api_management_api.auth-blue-api-apim.name
  api_management_name = data.azurerm_api_management.shared_apim.name
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  display_name        = "updateUser"
  method              = "PUT"
  url_template        = "/user/{id}"
  provider            = azurerm.Production

  template_parameter {
    name     = "id"
    type     = "string"
    required = false
  }
}

resource "azurerm_api_management_api_operation" "updateUser_green_operation" {
  operation_id        = "updateUser"
  api_name            = azurerm_api_management_api.auth-green-api-apim.name
  api_management_name = data.azurerm_api_management.shared_apim.name
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  display_name        = "updateUser"
  method              = "PUT"
  url_template        = "/user/{id}"
  provider            = azurerm.Production

  template_parameter {
    name     = "id"
    type     = "string"
    required = false
  }
}

resource "azurerm_api_management_api_operation" "validateReset_blue_operation" {
  operation_id        = "validateReset"
  api_name            = azurerm_api_management_api.auth-blue-api-apim.name
  api_management_name = data.azurerm_api_management.shared_apim.name
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  display_name        = "validateReset"
  method              = "POST"
  url_template        = "/reset/verify"
  provider            = azurerm.Production

}

resource "azurerm_api_management_api_operation" "validateReset_green_operation" {
  operation_id        = "validateReset"
  api_name            = azurerm_api_management_api.auth-green-api-apim.name
  api_management_name = data.azurerm_api_management.shared_apim.name
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  display_name        = "validateReset"
  method              = "POST"
  url_template        = "/reset/verify"
  provider            = azurerm.Production

}

resource "azurerm_api_management_api_operation" "verifyUser_blue_operation" {
  operation_id        = "verifyUser"
  api_name            = azurerm_api_management_api.auth-blue-api-apim.name
  api_management_name = data.azurerm_api_management.shared_apim.name
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  display_name        = "verifyUser"
  method              = "POST"
  url_template        = "/user/verify"
  provider            = azurerm.Production

}

resource "azurerm_api_management_api_operation" "verifyUser_green_operation" {
  operation_id        = "verifyUser"
  api_name            = azurerm_api_management_api.auth-green-api-apim.name
  api_management_name = data.azurerm_api_management.shared_apim.name
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
  display_name        = "verifyUser"
  method              = "POST"
  url_template        = "/user/verify"
  provider            = azurerm.Production

}
