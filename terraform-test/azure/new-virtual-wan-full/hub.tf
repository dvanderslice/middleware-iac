# -------------------------------------------------------------------------------------------------
# Create the hub network for virtual wan/virtual hub/firewall
#data "azurerm_resource_group" "shared_vnet" {
#name = local.shared_resource_group_name
#}

#data "azurerm_virtual_network" "shared_vnet" {
# name                = local.shared_vnet_name
# resource_group_name = local.shared_resource_group_name
#}

module "hub_rg" {
  source = "../modules/rg"

  azure_location      = var.azure_location
  resource_group_name = local.hub_resource_group_name

  tags = merge(local.resource_tags, {
    "environment" = var.env_name
    "role"        = "api"
    "createdon"   = local.tag_createdon
  })
}




# Set-up the firewall policy with rules
resource "azurerm_firewall_policy" "fw_policy" {
  name                = "${var.region_abbreviation}-${var.env_name}${var.env_key}-fwpolicy${local.suffix}"
  resource_group_name = module.hub_rg.name
  location            = var.azure_location
  sku                 = "Premium"
  insights {
    enabled                            = true
    default_log_analytics_workspace_id = azurerm_log_analytics_workspace.utl_loganalytics.id
  }
  intrusion_detection {
    mode = "Alert"
  }

  dns {
    proxy_enabled = true
  }

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


# Get all of the subnets for the hub
module "hub_subnet_addrs" {
  source = "../modules/cidr-subnets"

  base_cidr_block = module.vnet_addrs.networks[2].cidr_block
  networks = [
    {
      name     = "subnet01"
      new_bits = 4
    },
  ]
}

resource "azurerm_virtual_wan" "wan" {
  name                = "${var.region_abbreviation}-${var.env_name}${var.env_key}-virtualwan${local.suffix}"
  resource_group_name = module.hub_rg.name
  location            = var.azure_location
  tags                = var.tags

  lifecycle {
    ignore_changes = [
      tags["createdon"],
    ]
  }
  depends_on = [
    module.hub_rg
  ]
}

# Azure recommends an address prefix /23 CIDR but a /24 can work
resource "azurerm_virtual_hub" "hub" {
  name                = "${var.region_abbreviation}-${var.env_name}${var.env_key}-virtualhub${local.suffix}"
  resource_group_name = module.hub_rg.name
  location            = var.azure_location
  virtual_wan_id      = azurerm_virtual_wan.wan.id
  address_prefix      = module.vnet_addrs.networks[2].cidr_block
  tags                = var.tags

  lifecycle {
    ignore_changes = [
      tags["createdon"],
    ]
  }
}
resource "azurerm_vpn_server_configuration" "uservpnconfig" {
  name                     = "${var.region_abbreviation}-${var.env_name}${var.env_key}-userVPNconfig${local.suffix}"
  resource_group_name      = module.hub_rg.name
  location                 = var.azure_location
  vpn_authentication_types = ["Certificate"]
  vpn_protocols            = ["OpenVPN"]
  client_root_certificate {
    name             = "DigiCert-Federated-ID-Root-CA"
    public_cert_data = <<EOF
MIIC5zCCAc+gAwIBAgIQQP8Nl3V/Z49BJHjnh10C1DANBgkqhkiG9w0BAQsFADAW
MRQwEgYDVQQDDAtQMlNSb290Q2VydDAeFw0yMTEyMTQxNzM3MjVaFw0yMjEyMTQx
NzU3MjVaMBYxFDASBgNVBAMMC1AyU1Jvb3RDZXJ0MIIBIjANBgkqhkiG9w0BAQEF
AAOCAQ8AMIIBCgKCAQEA6GZi88rDZripuKDU36OKu6Ig+Ubx4EIfS9vhgmKuUCR6
pSXBgcFUUpEG+rqXH6XoLdZtzA+M9P+IfcNCmcI1uASDrTojog0WfL+cuBCzWHND
KB/HuiBO1xCwT4Gp+bFmZEMrr1HVQqfBr261CtXoMwi+9E1A6T/B5eNpqvWALXAa
4Z5veSoOSGSf6zcT4PifXkp0yNpkDbzZcrn7CkGW9mMrcB6qk7iS/f6Gewb11mzv
OONGfpDPStcPn2nyRcIKUXupArpi5aNWBOmw5y20Q+atbApy4VXGpH9d4J6BTubu
rbutp/7zEBTWSqA78H++nk5YEVWJXXiJQ0787zo80QIDAQABozEwLzAOBgNVHQ8B
Af8EBAMCAgQwHQYDVR0OBBYEFDAURwSOn+Oi5Cbsl7PO9fLUoU1tMA0GCSqGSIb3
DQEBCwUAA4IBAQCz/FKg3AEDzvivReQCfK6hakqO+d7/R1Fe5yJQz6tzeJdUicud
+PeMDjSfPnI9E4yUGYuFNTEo9mn6UE80XEYs92xsOClGRXbD5awlwA1JT/iisWXj
RIBJrZhKckifTXOiZ0gfvOgS8zUutv4Y+SyD4PyGEcJMC9AWnI0ZMI2jNlceD8ZY
nG1+OnkpbNHhcnLt1+E7hr0NSq7cwA/VtvVkZuIl2Fb5yD5PtV1mSYSr21uybvJS
C41SXSQbWpM+ZkYu1tCB+kfuqdqImGHaQ8bc+jYv+weK6p4IiDEm+RqHn6T3B05d
QKIFluIY4prmiTwL0LsnLZj6e0ZX5Q8tRE/z
EOF
  }

}

resource "azurerm_point_to_site_vpn_gateway" "p2sgateway" {
  name                        = "${var.region_abbreviation}-${var.env_name}${var.env_key}-userVPNgateway${local.suffix}"
  location                    = var.azure_location
  resource_group_name         = module.hub_rg.name
  virtual_hub_id              = azurerm_virtual_hub.hub.id
  vpn_server_configuration_id = azurerm_vpn_server_configuration.uservpnconfig.id
  scale_unit                  = 1
  connection_configuration {
    name = "P2S-VPN-Config"

    vpn_client_address_pool {
      address_prefixes = [
        var.p2svpnaddresspool
      ]
    }
  }

}

resource "azurerm_firewall" "firewall" {
  name                = "${var.region_abbreviation}-${var.env_name}${var.env_key}-firewall${local.suffix}"
  location            = var.azure_location
  resource_group_name = module.hub_rg.name
  firewall_policy_id  = azurerm_firewall_policy.fw_policy.id
  sku_name            = "AZFW_Hub"
  sku_tier            = "Premium"
  # Threat intelligence mode MUST be empty (even though Off works with the CLI) with SKU of "AZFW_Hub"
  # as it does not accept ThreatIntelMode in current sku AZFW_Hub
  # Original Error: Code="AzureFirewallInvalidRequest" Message="Request parameter VirtualHub can not be specified in current SKU AZFW_VNet for the Azure Firewall
  # https://githubmemory.com/repo/terraform-providers/terraform-provider-azurerm/issues/12623
  tags = var.tags

  virtual_hub {
    virtual_hub_id = azurerm_virtual_hub.hub.id
  }
}

data "azurerm_virtual_hub" "default_route" {
  name                = azurerm_virtual_hub.hub.name
  resource_group_name = module.hub_rg.name
  depends_on = [
    azurerm_virtual_hub.hub
  ]
}

resource "azurerm_virtual_hub_route_table" "custom_route1" {
  name           = "all_traffic_routing"
  virtual_hub_id = azurerm_virtual_hub.hub.id
  labels         = ["all_traffic"]

  route {
    name              = "all_traffic"
    destinations_type = "CIDR"
    destinations      = ["0.0.0.0/0", "192.168.0.0/16", "10.0.0.0/8", "172.16.0.0/12"]
    next_hop_type     = "ResourceId"
    next_hop          = azurerm_firewall.firewall.id
  }
}

resource "azurerm_virtual_hub_route_table" "custom_route2" {
  name           = "private_traffic_routing"
  virtual_hub_id = azurerm_virtual_hub.hub.id
  labels         = ["private_traffic"]

  route {
    name              = "all_traffic"
    destinations_type = "CIDR"
    destinations      = ["192.168.0.0/16", "10.0.0.0/8", "172.16.0.0/12"]
    next_hop_type     = "ResourceId"
    next_hop          = azurerm_firewall.firewall.id
  }
}

#resource "azurerm_virtual_hub_route_table_route" "default_route_add" {
#name           = "all_traffic"
#route_table_id = data.azurerm_virtual_hub.default_route.default_route_table_id
#destinations_type = "CIDR"
#destinations = ["0.0.0.0/0", "192.168.0.0/16", "10.0.0.0/8", "172.16.0.0/12"]
#next_hop_type = "ResourceId"
#next_hop = azurerm_firewall.firewall.id


#}
# Hub connections are used to peer the spoke virtual networks with the hub
resource "azurerm_virtual_hub_connection" "hub_to_private" {
  name                      = "${var.region_abbreviation}-hub-to-private${local.suffix}"
  virtual_hub_id            = azurerm_virtual_hub.hub.id
  remote_virtual_network_id = azurerm_virtual_network.private_vnet.id
  routing {
    associated_route_table_id = azurerm_virtual_hub_route_table.custom_route1.id
  }
  internet_security_enabled = true

}

resource "azurerm_virtual_hub_connection" "hub_to_mul" {
  name                      = "${var.region_abbreviation}-hub-to-mul${local.suffix}"
  virtual_hub_id            = azurerm_virtual_hub.hub.id
  remote_virtual_network_id = azurerm_virtual_network.mul_vnet.id
  routing {
    associated_route_table_id = azurerm_virtual_hub_route_table.custom_route1.id
  }
  internet_security_enabled = true
}

resource "azurerm_virtual_hub_connection" "hub_to_auth" {
  name                      = "${var.region_abbreviation}-hub-to-auth${local.suffix}"
  virtual_hub_id            = azurerm_virtual_hub.hub.id
  remote_virtual_network_id = azurerm_virtual_network.auth_vnet.id
  routing {
    associated_route_table_id = azurerm_virtual_hub_route_table.custom_route1.id
  }
  internet_security_enabled = true

}

resource "azurerm_virtual_hub_connection" "hub_to_shared" {
  name                      = "${var.region_abbreviation}-hub-to-shared${local.suffix}"
  virtual_hub_id            = azurerm_virtual_hub.hub.id
  remote_virtual_network_id = azurerm_virtual_network.shared_vnet.id
  routing {
    associated_route_table_id = azurerm_virtual_hub_route_table.custom_route2.id
  }

}

data "azurerm_firewall" "firewall" {
  name                = azurerm_firewall.firewall.name
  resource_group_name = module.hub_rg.name
}

resource "azurerm_monitor_diagnostic_setting" "example" {
  name               = "fw-monitoring"
  target_resource_id = data.azurerm_firewall.firewall.id

  log {
    category = "AzureFirewallApplicationRule"
    enabled  = true

    retention_policy {
      enabled = false
    }
  }

  log {
    category = "AzureFirewallNetworkRule"
    enabled  = true

    retention_policy {
      enabled = false
    }
  }


  log {
    category = "AzureFirewallDnsProxy"
    enabled  = true

    retention_policy {
      enabled = false
    }
  }

  log {
    category = "AZFWNetworkRule"
    enabled  = true

    retention_policy {
      enabled = false
    }
  }
  log {
    category = "AZFWApplicationRule"
    enabled  = true

    retention_policy {
      enabled = false
    }
  }

  log {
    category = "AZFWNatRule"
    enabled  = true

    retention_policy {
      enabled = false
    }
  }

  log {
    category = "AZFWThreatIntel"
    enabled  = true

    retention_policy {
      enabled = false
    }
  }


  log {
    category = "AZFWIdpsSignature"
    enabled  = true

    retention_policy {
      enabled = false
    }
  }

  log {
    category = "AZFWDnsQuery"
    enabled  = true

    retention_policy {
      enabled = false
    }
  }

  log {
    category = "AZFWFqdnResolveFailure"
    enabled  = true

    retention_policy {
      enabled = false
    }
  }

  log {
    category = "AZFWApplicationRuleAggregation"
    enabled  = true

    retention_policy {
      enabled = false
    }
  }


  log {
    category = "AZFWNetworkRuleAggregation"
    enabled  = true

    retention_policy {
      enabled = false
    }
  }


  log {
    category = "AZFWNatRuleAggregation"
    enabled  = true

    retention_policy {
      enabled = false
    }
  }
  metric {
    category = "AllMetrics"

    retention_policy {
      enabled = false
    }
  }
  log_analytics_workspace_id = azurerm_log_analytics_workspace.utl_loganalytics.id
}

resource "azurerm_monitor_action_group" "action_group" {
  name                = "${var.region_abbreviation}-${var.env_name}${var.env_key}-firewall-alerts${local.suffix}"
  resource_group_name = module.utl_rg.name
  short_name          = "fwmonitor"

  email_receiver {
    name                    = "sendtodevops"
    email_address           = "muhammad.ullah@dematic.com"
    use_common_alert_schema = true
  }
}

