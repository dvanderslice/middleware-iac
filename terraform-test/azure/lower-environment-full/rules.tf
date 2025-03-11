
data "azurerm_firewall_policy" "prod_fw_policy" {
  provider            = azurerm.Production
  name                = "${var.region_abbreviation}-${var.prod_env_name}${var.prod_env_key}-fwpolicy${local.suffix}"
  resource_group_name = var.prodhubrgname
}

###Create IP Groups, these are based on VNET and/or Subnets
resource "azurerm_ip_group" "data_subnet_ipg" {
  name                = local.data_private_subnet_ip_group_name
  location            = var.azure_location
  resource_group_name = var.prodhubrgname
  provider            = azurerm.Production
  cidrs               = [module.private_subnet_addrs.networks[1].cidr_block]
}

resource "azurerm_ip_group" "storage_subnet_ipg" {
  name                = local.storage_private_subnet_ip_group_name
  location            = var.azure_location
  resource_group_name = var.prodhubrgname
  provider            = azurerm.Production

  cidrs = [module.private_subnet_addrs.networks[0].cidr_block]
}

resource "azurerm_ip_group" "sharedsubnet_ipg" {
  name                = local.shared_private_subnet_ip_group_name
  location            = var.azure_location
  resource_group_name = var.prodhubrgname
  provider            = azurerm.Production

  cidrs = [module.private_subnet_addrs.networks[2].cidr_block]
}

resource "azurerm_ip_group" "func_subnet_ipg" {
  name                = local.functions_private_subnet_ip_group_name
  location            = var.azure_location
  resource_group_name = var.prodhubrgname
  provider            = azurerm.Production

  cidrs = [module.private_subnet_addrs.networks[3].cidr_block]
}

resource "azurerm_ip_group" "auth_vnet_ipg" {
  name                = local.auth_vnet_ip_group_name
  location            = var.azure_location
  resource_group_name = var.prodhubrgname
  provider            = azurerm.Production

  cidrs = [module.vnet_addrs.networks[4].cidr_block]
}

data "azurerm_virtual_network" "prod_shared_vnet" {
  provider            = azurerm.Production
  name                = "${var.region_abbreviation}-shared${var.resource_version}-${var.prod_env_name}${var.prod_env_key}-vnet${local.suffix}"
  resource_group_name = "AppGrp-shared${var.prod_env_key}-${var.prod_env_name}${var.prod_env_key}-rg${local.suffix}"
}

resource "azurerm_ip_group" "shared_vnet_ipg" {
  name                = local.shared_vnet_ip_group_name
  location            = var.azure_location
  resource_group_name = var.prodhubrgname
  provider            = azurerm.Production

  cidrs = data.azurerm_virtual_network.prod_shared_vnet.address_space
}

resource "azurerm_ip_group" "private_vnet_ipg" {
  name                = local.pri_vnet_ip_group_name
  location            = var.azure_location
  resource_group_name = var.prodhubrgname
  provider            = azurerm.Production

  cidrs = [module.vnet_addrs.networks[3].cidr_block]
}

resource "azurerm_ip_group" "mul_vnet_ipg" {
  name                = local.mul_vnet_ip_group_name
  location            = var.azure_location
  resource_group_name = var.prodhubrgname
  provider            = azurerm.Production

  cidrs = [module.vnet_addrs.networks[0].cidr_block]
}

resource "azurerm_ip_group" "mul_kusto_subnet01_ipg" {
  name                = local.mul_vnet_kusto_subnet01_ip_group_name
  location            = var.azure_location
  resource_group_name = var.prodhubrgname
  provider            = azurerm.Production

  cidrs = [module.mul_subnet_addrs.networks[0].cidr_block]
}

resource "azurerm_ip_group" "mul_kusto_subnet03_ipg" {
  name                = local.mul_vnet_kusto_subnet03_ip_group_name
  location            = var.azure_location
  resource_group_name = var.prodhubrgname
  provider            = azurerm.Production

  cidrs = [module.mul_subnet_addrs.networks[2].cidr_block]
}

resource "azurerm_ip_group" "mul_web_subnet02_ipg" {
  name                = local.mul_vnet_web_subnet02_ip_group_name
  location            = var.azure_location
  resource_group_name = var.prodhubrgname
  provider            = azurerm.Production

  cidrs = [module.mul_subnet_addrs.networks[1].cidr_block]
}

resource "azurerm_ip_group" "mul_web_subnet04_ipg" {
  name                = local.mul_vnet_web_subnet04_ip_group_name
  location            = var.azure_location
  resource_group_name = var.prodhubrgname
  provider            = azurerm.Production

  cidrs = [module.mul_subnet_addrs.networks[3].cidr_block]
}

resource "azurerm_ip_group" "mul_web_subnet05_ipg" {
  name                = local.mul_vnet_web_subnet05_ip_group_name
  location            = var.azure_location
  resource_group_name = var.prodhubrgname
  provider            = azurerm.Production

  cidrs = [module.mul_subnet_addrs.networks[4].cidr_block]
}
##Create Firewall Rules##Rules are broken into collections by usage type. This can be further refined. Some collection groups do not have rules yet, but a placeholder has been created
resource "azurerm_firewall_policy_rule_collection_group" "Functions-Access" {
  name               = "${var.region_abbreviation}-${var.env_name}${var.env_key}-functions-private-endpoint-access-rcg"
  firewall_policy_id = data.azurerm_firewall_policy.prod_fw_policy.id
  priority           = 400
  provider           = azurerm.Production
  network_rule_collection {
    name     = "Private-Endpoint-Function-Apps-Internal-Network-Access-rc"
    priority = 110
    action   = "Allow"
    rule {
      name                  = "Auth-VNET-to-Pri-Function-Subnet"
      source_addresses      = azurerm_ip_group.auth_vnet_ipg.cidrs
      protocols             = ["TCP"]
      destination_ports     = ["443"]
      destination_addresses = azurerm_ip_group.func_subnet_ipg.cidrs

    }
    rule {
      name                  = "Shared-VNET-to-Pri-Functions-Subnet"
      source_addresses      = azurerm_ip_group.shared_vnet_ipg.cidrs
      protocols             = ["TCP"]
      destination_ports     = ["443"]
      destination_addresses = azurerm_ip_group.func_subnet_ipg.cidrs


    }
    rule {
      name                  = "Mul-VNET-to-Pri-Functions-Subnet"
      source_addresses      = azurerm_ip_group.mul_vnet_ipg.cidrs
      protocols             = ["TCP"]
      destination_ports     = ["443"]
      destination_addresses = azurerm_ip_group.func_subnet_ipg.cidrs

    }
    rule {
      name                  = "P2S-VNET-to-Pri-Functions-Subnet"
      source_addresses      = ["172.16.0.0/12"]
      protocols             = ["TCP"]
      destination_ports     = ["443"]
      destination_addresses = azurerm_ip_group.func_subnet_ipg.cidrs

    }
    rule {
      name                  = "Storage-Subnet-to-Pri-Functions-Subnet"
      source_addresses      = azurerm_ip_group.storage_subnet_ipg.cidrs
      protocols             = ["TCP"]
      destination_ports     = ["443"]
      destination_addresses = azurerm_ip_group.func_subnet_ipg.cidrs

    }
    ##REDIS ENT
  }

  network_rule_collection {
    name     = "${var.env_name}{var.env_key}-Private-Endpoint-Storage-Internal-Network-Access-rc"
    priority = 120
    action   = "Allow"
    rule {
      name                  = "Auth-VNET-to-Pri-Storage-Subnet"
      source_addresses      = azurerm_ip_group.auth_vnet_ipg.cidrs
      protocols             = ["TCP"]
      destination_ports     = ["443", "445"]
      destination_addresses = azurerm_ip_group.storage_subnet_ipg.cidrs

    }
    rule {
      name                  = "Shared-VNET-to-Pri-Storage-Subnet"
      source_addresses      = azurerm_ip_group.shared_vnet_ipg.cidrs
      protocols             = ["TCP"]
      destination_ports     = ["443", "445"]
      destination_addresses = azurerm_ip_group.storage_subnet_ipg.cidrs


    }
    rule {
      name                  = "Mul-VNET-to-Pri-Storage-Subnet"
      source_addresses      = azurerm_ip_group.mul_vnet_ipg.cidrs
      protocols             = ["TCP"]
      destination_ports     = ["443", "445"]
      destination_addresses = azurerm_ip_group.storage_subnet_ipg.cidrs

    }
    rule {
      name                  = "P2S-VNET-to-Pri-Storage-Subnet"
      source_addresses      = ["172.16.0.0/12"]
      protocols             = ["TCP"]
      destination_ports     = ["443", "445"]
      destination_addresses = azurerm_ip_group.storage_subnet_ipg.cidrs

    }
  }

  network_rule_collection {
    name     = "Private-Endpoint-Shared-Internal-Network-Access-rc"
    priority = 130
    action   = "Allow"
    rule {
      name                  = "Auth-VNET-to-Pri-Shared-Subnet"
      source_addresses      = azurerm_ip_group.auth_vnet_ipg.cidrs
      protocols             = ["TCP", "UDP"]
      destination_ports     = ["443", "6379", "6380", "8443", "8500", "10221-10231", "13000-13999", "15000-15999", "16001", "20226"]
      destination_addresses = azurerm_ip_group.sharedsubnet_ipg.cidrs

    }

    rule {
      name                  = "Shared-VNET-to-Pri-Shared-Subnet"
      source_addresses      = azurerm_ip_group.shared_vnet_ipg.cidrs
      protocols             = ["TCP", "UDP"]
      destination_ports     = ["443", "6379", "6380", "8443", "8500", "10221-10231", "13000-13999", "15000-15999", "16001", "20226"]
      destination_addresses = azurerm_ip_group.sharedsubnet_ipg.cidrs

    }

    rule {
      name                  = "Mul-VNET-to-Pri-Shared-Subnet"
      source_addresses      = azurerm_ip_group.mul_vnet_ipg.cidrs
      protocols             = ["TCP", "UDP"]
      destination_ports     = ["443", "6379", "6380", "8443", "8500", "10221-10231", "13000-13999", "15000-15999", "16001", "20226"]
      destination_addresses = azurerm_ip_group.sharedsubnet_ipg.cidrs

    }

    rule {
      name                  = "P2S-VNET-to-Pri-Shared-Subnet"
      source_addresses      = ["172.16.0.0/12"]
      protocols             = ["TCP", "UDP"]
      destination_ports     = ["443", "6379", "6380", "8443", "8500", "10221-10231", "13000-13999", "15000-15999", "16001", "20226"]
      destination_addresses = azurerm_ip_group.sharedsubnet_ipg.cidrs

    }
    rule {
      name                  = "Storage-Subnet-to-Pri-Shared-Subnet"
      source_addresses      = azurerm_ip_group.storage_subnet_ipg.cidrs
      protocols             = ["TCP", "UDP"]
      destination_ports     = ["443", "6379", "6380", "8443", "8500", "10221-10231", "13000-13999", "15000-15999", "16001", "20226"]
      destination_addresses = azurerm_ip_group.sharedsubnet_ipg.cidrs

    }

  }

  depends_on = [
    azurerm_ip_group.func_subnet_ipg,
    azurerm_ip_group.storage_subnet_ipg,
    azurerm_ip_group.shared_vnet_ipg,
    azurerm_ip_group.mul_vnet_ipg
  ]
}

resource "azurerm_firewall_policy_rule_collection_group" "Mul-VNET-Outbound-Access" {
  name               = "${var.region_abbreviation}-${var.env_name}${var.env_key}-mul-VNET-outbound-access-rcg"
  firewall_policy_id = data.azurerm_firewall_policy.prod_fw_policy.id
  priority           = 310
  provider           = azurerm.Production

  application_rule_collection {
    name     = "Mul-VNET-External-Outbound-Access-Application"
    priority = 140
    action   = "Allow"
    rule {
      name = "mul-to-blob"
      protocols {
        type = "Https"
        port = 443
      }
      source_addresses  = azurerm_ip_group.mul_vnet_ipg.cidrs
      destination_fqdns = ["*blob.core.windows.net"]
    }
    rule {
      name = "mul-to-s3"
      protocols {
        type = "Http"
        port = 80
      }
      protocols {
        type = "Https"
        port = 443
      }
      source_addresses  = azurerm_ip_group.mul_vnet_ipg.cidrs
      destination_fqdns = ["*.amazonaws.com"]

    }
    rule {
      name = "mul-to-azuread-sso"
      protocols {
        type = "Http"
        port = 80
      }
      protocols {
        type = "Https"
        port = 443
      }
      source_addresses  = azurerm_ip_group.mul_vnet_ipg.cidrs
      destination_fqdns = ["*.microsoftonline.com", "*visualstudio.com", "dc.services.visualstudio.com", "*.windows.net", "*.windows.com", "*.microsoft.com", "*.microsoft-ppe.com", "*.msftconnecttest.com", "*.microsoftmetrics.com"]
    }
    rule {
      name = "mul-to-appinsights"
      protocols {
        type = "Https"
        port = 443
      }
      source_addresses  = azurerm_ip_group.mul_vnet_ipg.cidrs
      destination_fqdns = ["*.azure.com"]
    }
    rule {
      name = "mul-adx-monitoring"
      protocols {
        type = "Https"
        port = 443
      }
      source_addresses  = azurerm_ip_group.mul_vnet_ipg.cidrs
      destination_fqdns = ["gcs.prod.monitoring.core.windows.net", "*.servicebus.windows.net", "*.microsoft-ppe.com", "*.msftconnecttest.com", "*prod.microsoftmetrics.com", "login.live.com", "azureprofilerfrontdoor.cloudapp.net", "*.azure.net", "*.trafficmanager.net"]
    }
    rule {
      name = "mul-adx-azure-services"
      protocols {
        type = "Http"
        port = 80
      }
      source_addresses  = azurerm_ip_group.mul_vnet_ipg.cidrs
      destination_fqdns = ["*.windowsupdate.com", "*.digicert.com", "ocsp.msocsp.com", "mscrl.microsoft.com", "crl.microsoft.com", "*.applicationinsights.azure.com", "*.azureedge.net", "*.sendgrid.com", "*.core.windows.net", "*.microsoft.com", "*.trafficmanager.net"]
    }
    rule {
      name = "mul-to-dematic-endpoints"
      protocols {
        type = "Https"
        port = 443
      }
      source_addresses  = azurerm_ip_group.mul_vnet_ipg.cidrs
      destination_fqdns = ["*.dematic.com"]

    }
    rule {
      name = "mul-to-sendgrid-redis"
      protocols {
        type = "Https"
        port = 443
      }
      source_addresses  = azurerm_ip_group.mul_vnet_ipg.cidrs
      destination_fqdns = ["*.sendgrid.com", "*.azurefd.net", "*.azureedge.net"]

    }
    rule {
      name = "mul-to-mongo-public"
      protocols {
        type = "Https"
        port = 1024
      }
      source_addresses  = azurerm_ip_group.mul_vnet_ipg.cidrs
      destination_fqdns = ["*.mongodb.net"]

    }


  }
  network_rule_collection {
    name     = "Mul-Kusto-Network-Access"
    priority = 120
    action   = "Allow"
    rule {
      name                  = "Kusto-to-ServiceTag"
      protocols             = ["TCP", "UDP"]
      source_addresses      = azurerm_ip_group.mul_vnet_ipg.cidrs
      destination_addresses = ["AzureActiveDirectory", "AzureMonitor", "AzureDataLake", "AzureEventGrid", "EventHub", "Storage", "SQL", "AzureCosmosDB", "AzureDataExplorer", "AzureIoTHub", "AzurePlatformDNS", "AppService", "AppServiceManagement", "ApplicationInsightsAvailability"]
      destination_ports     = ["*"]
    }
    rule {
      name                  = "Kusto-Time-Services-for-ADX"
      protocols             = ["UDP"]
      source_addresses      = azurerm_ip_group.mul_vnet_ipg.cidrs
      destination_addresses = ["*"]
      destination_ports     = ["123"]
    }
    rule {
      name                  = "Kusto-Cert-Auth-for-ADX"
      protocols             = ["TCP"]
      source_addresses      = azurerm_ip_group.mul_vnet_ipg.cidrs
      destination_addresses = ["*"]
      destination_ports     = ["80"]
    }
    rule {
      name                  = "Kusto-Monitoring-for-ADX-Inbound"
      protocols             = ["TCP"]
      source_addresses      = ["104.46.110.170", "40.70.147.14", "40.84.38.74", "52.247.116.27", "52.247.117.99", "52.177.182.76", "52.247.117.144", "52.247.116.99", "52.247.67.200", "52.247.119.96", "52.247.70.70"]
      destination_addresses = azurerm_ip_group.mul_vnet_ipg.cidrs
      destination_ports     = ["443"]
    }

  }

  application_rule_collection {
    name     = "Mul-Kusto-Application-Access"
    priority = 150
    action   = "Allow"
    rule {
      name = "kusto-to-monitoring"
      protocols {
        type = "Https"
        port = 443
      }
      protocols {
        type = "Https"
        port = 5671
      }

      source_addresses  = azurerm_ip_group.mul_vnet_ipg.cidrs
      destination_fqdns = ["*.windows.net"]
    }
    rule {
      name = "kusto-to-update"
      protocols {
        type = "Http"
        port = 80
      }
      protocols {
        type = "Https"
        port = 443
      }
      source_addresses  = azurerm_ip_group.mul_vnet_ipg.cidrs
      destination_fqdns = ["*.windowsupdate.com"]

    }
    rule {
      name = "kusto-to-digicert"
      protocols {
        type = "Http"
        port = 80
      }
      source_addresses  = azurerm_ip_group.mul_vnet_ipg.cidrs
      destination_fqdns = ["*.digicert.com"]
    }
    rule {
      name = "kusto-to-pki"
      protocols {
        type = "Http"
        port = 80
      }
      source_addresses  = azurerm_ip_group.mul_vnet_ipg.cidrs
      destination_fqdns = ["*.ocsp.msocsp.com"]
    }
    rule {
      name = "kusto-to-mscrl"
      protocols {
        type = "Http"
        port = 80
      }
      source_addresses  = azurerm_ip_group.mul_vnet_ipg.cidrs
      destination_fqdns = ["*.microsoft.com"]
    }
    rule {
      name = "kusto-to-windows"
      protocols {
        type = "Http"
        port = 80
      }
      protocols {
        type = "Https"
        port = 443

      }
      source_addresses  = azurerm_ip_group.mul_vnet_ipg.cidrs
      destination_fqdns = ["*.windows.com"]
    }
    rule {
      name = "kusto-to-ppe"
      protocols {
        type = "Https"
        port = 443
      }
      source_addresses  = azurerm_ip_group.mul_vnet_ipg.cidrs
      destination_fqdns = ["*.microsoft-ppe.com"]
    }
    rule {
      name = "kusto-to-test"
      protocols {
        type = "Http"
        port = 80
      }
      protocols {
        type = "Https"
        port = 443

      }
      source_addresses  = azurerm_ip_group.mul_vnet_ipg.cidrs
      destination_fqdns = ["*.msftconnecttest.com"]
    }
    rule {
      name = "kusto-to-login"
      protocols {
        type = "Http"
        port = 80
      }
      protocols {
        type = "Https"
        port = 443

      }
      source_addresses  = azurerm_ip_group.mul_vnet_ipg.cidrs
      destination_fqdns = ["*.live.com"]
    }
    rule {
      name = "kusto-to-ha"
      protocols {
        type = "Http"
        port = 80
      }
      protocols {
        type = "Https"
        port = 443

      }
      source_addresses  = azurerm_ip_group.mul_vnet_ipg.cidrs
      destination_fqdns = ["*.azureprofilerfrontdoor.cloudapp.net", "*.vault.azure.net", "*.azureprofiler.trafficmanager.net", "*.azure.net", "*.passport.net", "www.nuget.org", "*.microsoftmetrics.com"]
    }
  }
  network_rule_collection {
    name     = "Mul-FA-Outbound-MongoDB"
    priority = 125
    action   = "Allow"
    rule {
      name                  = "MUL-FA-Outbound-to-Private-MongoDB-SaaS"
      protocols             = ["TCP", "UDP"]
      source_addresses      = azurerm_ip_group.mul_vnet_ipg.cidrs
      destination_addresses = ["10.0.0.0/8"]
      destination_ports     = ["1024", "1025", "1026"]
    }


  }
      network_rule_collection {
    name     = "Mul-Customer-Outbound"
    priority = 125
    action   = "Allow"
    rule {
      name                  = "Customer-FA-to-Redis"
      protocols             = ["TCP", "UDP"]
      source_addresses      = azurerm_ip_group.mul_vnet_ipg.cidrs
      destination_addresses = azurerm_ip_group.sharedsubnet_ipg.cidrs
      destination_ports     = ["10000"]
    }


  }

}
resource "azurerm_firewall_policy_rule_collection_group" "Auth-VNET-Outbound-Access" {
  name               = "${var.region_abbreviation}-${var.env_name}${var.env_key}-auth-VNET-outbound-access-rcg"
  firewall_policy_id = data.azurerm_firewall_policy.prod_fw_policy.id
  priority           = 350
  provider           = azurerm.Production

  application_rule_collection {
    name     = "Auth-VNET-External-Outbound-Access"
    priority = 200
    action   = "Allow"
    rule {
      name = "auth-to-blob"
      protocols {
        type = "Https"
        port = 443
      }
      source_addresses  = azurerm_ip_group.auth_vnet_ipg.cidrs
      destination_fqdns = ["*blob.core.windows.net"]
    }
    rule {
      name = "auth-to-azuread-sso"
      protocols {
        type = "Http"
        port = 80
      }
      protocols {
        type = "Https"
        port = 443
      }
      source_addresses  = azurerm_ip_group.auth_vnet_ipg.cidrs
      destination_fqdns = ["*.microsoftonline.com", "*visualstudio.com", "dc.services.visualstudio.com", "*.windows.net", "*.windows.com", "*.microsoft.com", "*.microsoft-ppe.com", "*.msftconnecttest.com", "*.microsoftmetrics.com"]
    }
    rule {
      name = "auth-to-appinsights"
      protocols {
        type = "Https"
        port = 443
      }
      source_addresses  = azurerm_ip_group.auth_vnet_ipg.cidrs
      destination_fqdns = ["*.azure.com"]
    }
    rule {
      name = "auth-to-dematic-endpoints"
      protocols {
        type = "Https"
        port = 443
      }
      source_addresses  = azurerm_ip_group.auth_vnet_ipg.cidrs
      destination_fqdns = ["*.dematic.com"]

    }
    rule {
      name = "auth-to-sendgrid-redis"
      protocols {
        type = "Https"
        port = 443
      }
      source_addresses  = azurerm_ip_group.auth_vnet_ipg.cidrs
      destination_fqdns = ["*.sendgrid.com", "*.azurefd.net", "*.azureedge.net"]

    }
    rule {
      name = "auth-to-mongo-public"
      protocols {
        type = "Https"
        port = 1024
      }
      source_addresses  = azurerm_ip_group.auth_vnet_ipg.cidrs
      destination_fqdns = ["*.mongodb.net"]

    }



  }
  network_rule_collection {
    name     = "Auth-ServiceTag-Access"
    priority = 120
    action   = "Allow"
    rule {
      name                  = "Auth-to-https-ServiceTag"
      protocols             = ["TCP", "UDP"]
      source_addresses      = azurerm_ip_group.auth_vnet_ipg.cidrs
      destination_addresses = ["AzureActiveDirectory", "AzureMonitor", "ApiManagement", "AzureEventGrid", "EventHub", "Storage", "SQL", "AzureCosmosDB", "AzureDataExplorer", "AzureIoTHub", "AzurePlatformDNS", "AzurePlatformIMDS", "AzurePlatformLKM", "AppService", "AppServiceManagement", "ApplicationInsightsAvailability"]
      destination_ports     = ["*"]
    }

  }
  network_rule_collection {
    name     = "Auth-FA-Outbound-MongoDB"
    priority = 125
    action   = "Allow"
    rule {
      name                  = "Auth-FA-Outbound-to-Private-MongoDB-SaaS"
      protocols             = ["TCP", "UDP"]
      source_addresses      = azurerm_ip_group.auth_vnet_ipg.cidrs
      destination_addresses = ["10.0.0.0/8"]
      destination_ports     = ["1024", "1025", "1026"]
    }


  }

}

resource "azurerm_firewall_policy_rule_collection_group" "Shared-APIM-Access" {
  name               = "${var.region_abbreviation}-${var.env_name}${var.env_key}-Shared-APIM-access-rcg"
  firewall_policy_id = data.azurerm_firewall_policy.prod_fw_policy.id
  priority           = 335
  provider           = azurerm.Production

  application_rule_collection {
    name     = "Shared-APIM-Application"
    priority = 210
    action   = "Allow"

    rule {
      name = "Shared-APIM-monitoring"
      protocols {
        type = "Https"
        port = 443
      }
      protocols {
        type = "Https"
        port = 1886
      }
      protocols {
        type = "Https"
        port = 445
      }
      protocols {
        type = "Http"
        port = 80
      }
      source_addresses  = azurerm_ip_group.shared_vnet_ipg.cidrs
      destination_fqdns = ["*.windows.net", "*.microsoft-ppe.com", "*.msftconnecttest.com", "*prod.microsoftmetrics.com", "login.live.com", "azureprofilerfrontdoor.cloudapp.net", "*.azure.net", "azureprofiler.trafficmanager.net", "*.msn.com", "*.microsoft.com"]
    }

  }
  network_rule_collection {
    name     = "Shared-APIM-Network"
    priority = 120
    action   = "Allow"

    rule {
      name                  = "Shared-APIM-Service-Tags"
      protocols             = ["TCP", "UDP"]
      source_addresses      = azurerm_ip_group.shared_vnet_ipg.cidrs
      destination_addresses = ["AzureActiveDirectory", "AzureMonitor", "AzureDataLake", "AzureEventGrid", "EventHub", "Storage", "SQL", "AzureCosmosDB", "AzureDataExplorer", "AzureKeyVault", "AzurePlatformDNS", "AzureFrontDoor.Backend", "AzureFrontDoor.FirstParty", "AzureFrontDoor.Frontend"]
      destination_ports     = ["*"]

    }
    rule {
      name                  = "Shared-APIM-to-Auth-Internal"
      protocols             = ["TCP"]
      source_addresses      = azurerm_ip_group.shared_vnet_ipg.cidrs
      destination_addresses = azurerm_ip_group.auth_vnet_ipg.cidrs
      destination_ports     = ["443"]

    }
    rule {
      name                  = "Shared-APIM-to-MUL-Internal"
      protocols             = ["TCP"]
      source_addresses      = azurerm_ip_group.shared_vnet_ipg.cidrs
      destination_addresses = azurerm_ip_group.mul_vnet_ipg.cidrs
      destination_ports     = ["443"]

    }
    rule {
      name                  = "MUL-Internal-to-Shared-APIM"
      protocols             = ["TCP"]
      source_addresses      = azurerm_ip_group.mul_vnet_ipg.cidrs
      destination_addresses = azurerm_ip_group.shared_vnet_ipg.cidrs
      destination_ports     = ["443"]

    }
    rule {
      name                  = "Shared-APIM-Azure-Platform"
      protocols             = ["TCP"]
      source_addresses      = azurerm_ip_group.shared_vnet_ipg.cidrs
      destination_addresses = ["*"]
      destination_ports     = ["12000"]

    }

  }
}
resource "azurerm_firewall_policy_rule_collection_group" "P2s-Access" {
  name               = "${var.region_abbreviation}-${var.env_name}${var.env_key}-P2s-VPN-access-rcg"
  firewall_policy_id = data.azurerm_firewall_policy.prod_fw_policy.id
  priority           = 440
  provider           = azurerm.Production

  network_rule_collection {
    name     = "Client-VPN-Network"
    priority = 110
    action   = "Allow"

    rule {
      name                  = "client-vpn-to-pri-vnet"
      protocols             = ["TCP"]
      source_addresses      = [var.p2svpnaddresspool]
      destination_addresses = azurerm_ip_group.private_vnet_ipg.cidrs
      destination_ports     = ["*"]

    }
    rule {
      name                  = "client-vpn-to-mul-vnet"
      protocols             = ["TCP"]
      source_addresses      = [var.p2svpnaddresspool]
      destination_addresses = azurerm_ip_group.mul_vnet_ipg.cidrs
      destination_ports     = ["*"]

    }
    rule {
      name                  = "client-vpn-to-shared-vnet"
      protocols             = ["TCP"]
      source_addresses      = [var.p2svpnaddresspool]
      destination_addresses = azurerm_ip_group.shared_vnet_ipg.cidrs
      destination_ports     = ["*"]

    }
    rule {
      name                  = "client-vpn-to-service-tags"
      protocols             = ["TCP"]
      source_addresses      = [var.p2svpnaddresspool]
      destination_addresses = ["ApiManagement", "AzureIMDS", "AzurePlatformLKM", "AppService", "AppServiceManagement", "AzureCloud", "AzureActiveDirectory", "AzureMonitor", "AzureDataLake", "AzureEventGrid", "EventHub", "Storage", "SQL", "AzureCosmosDB", "AzureDataExplorer", "AzureKeyVault", "AzurePlatformDNS", "AzureFrontDoor.Backend", "AzureFrontDoor.FirstParty", "AzureFrontDoor.Frontend", "AzureDataExplorerManagement", "AzureEventGrid", "AzureIoTHub", "AzureKeyVault", "AzurePortal", "AzureResourceManager", "MicrosoftContainerRegistry", "ServiceBus"]
      destination_ports     = ["*"]

    }

  }
}
