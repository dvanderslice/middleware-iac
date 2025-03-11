# -------------------------------------------------------------------------------------------------
# Create the hub network for virtual wan/virtual hub/firewall
#data "azurerm_resource_group" "shared_vnet" {
#name = local.shared_resource_group_name
#}

#data "azurerm_virtual_network" "shared_vnet" {
# name                = local.shared_vnet_name
# resource_group_name = local.shared_resource_group_name
#}

data "azurerm_resource_group" "prod_vwan_rg" {
  provider = azurerm.Production
  name     = var.prodhubrgname
}

data "azurerm_resources" "prod-vwan-resource" {
  provider            = azurerm.Production
  type                = "Microsoft.Network/virtualWan"
  resource_group_name = var.prodhubrgname

}

data "azurerm_virtual_wan" "prod-vwan" {
  provider            = azurerm.Production
  name                = "${var.region_abbreviation}-${var.prod_env_name}${var.prod_env_key}-virtualwan${local.suffix}"
  resource_group_name = var.prodhubrgname
}

data "azurerm_firewall" "prod-firewall" {
  provider            = azurerm.Production
  name                = "${var.region_abbreviation}-${var.prod_env_name}${var.prod_env_key}-firewall${local.suffix}"
  resource_group_name = var.prodhubrgname
}

data "azurerm_virtual_hub" "prod-hub" {
  provider            = azurerm.Production
  name                = "${var.region_abbreviation}-${var.prod_env_name}${var.prod_env_key}-virtualhub${local.suffix}"
  resource_group_name = var.prodhubrgname
}

# Set-up the firewall rule collections with rules.tf

resource "azurerm_vpn_server_configuration" "uservpnconfig" {
  provider                 = azurerm.Production
  name                     = "${var.region_abbreviation}-${var.env_name}${var.env_key}-userVPNconfig${local.suffix}"
  resource_group_name      = var.prodhubrgname
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

resource "azurerm_virtual_hub" "hub" {
  provider            = azurerm.Production
  name                = "${var.region_abbreviation}-${var.env_name}${var.env_key}-virtualhub${local.suffix}"
  resource_group_name = var.prodhubrgname
  location            = var.azure_location
  virtual_wan_id      = data.azurerm_virtual_wan.prod-vwan.id
  address_prefix      = module.vnet_addrs.networks[0].cidr_block
  tags                = var.tags

  lifecycle {
    ignore_changes = [
      tags["createdon"],
    ]
  }
}

resource "azurerm_point_to_site_vpn_gateway" "p2sgateway" {
  provider                    = azurerm.Production
  name                        = "${var.region_abbreviation}-${var.env_name}${var.env_key}-userVPNgateway${local.suffix}"
  location                    = var.azure_location
  resource_group_name         = var.prodhubrgname
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

resource "azurerm_virtual_hub_route_table" "custom_route" {
  provider       = azurerm.Production
  name           = "${var.region_abbreviation}-${var.env_name}${var.env_key}-all_traffic_routing"
  virtual_hub_id = data.azurerm_virtual_hub.prod-hub.id
  labels         = ["${var.region_abbreviation}-${var.env_name}${var.env_key}-all_traffic"]

  route {
    name              = "all_traffic"
    destinations_type = "CIDR"
    destinations      = ["0.0.0.0/0", "192.168.0.0/16", "10.0.0.0/8", "172.16.0.0/12"]
    next_hop_type     = "ResourceId"
    next_hop          = data.azurerm_firewall.prod-firewall.id
  }
}


resource "azurerm_virtual_hub_connection" "hub_to_private" {
  provider                  = azurerm.Production
  name                      = "${var.region_abbreviation}-${var.env_name}${var.env_key}-hub-to-private${local.suffix}"
  virtual_hub_id            = data.azurerm_virtual_hub.prod-hub.id
  remote_virtual_network_id = azurerm_virtual_network.private_vnet.id
  routing {
    associated_route_table_id = azurerm_virtual_hub_route_table.custom_route.id
  }
  internet_security_enabled = true

}


resource "azurerm_virtual_hub_connection" "hub_to_mul" {
  provider                  = azurerm.Production
  name                      = "${var.region_abbreviation}-${var.env_name}${var.env_key}-hub-to-mul${local.suffix}"
  virtual_hub_id            = data.azurerm_virtual_hub.prod-hub.id
  remote_virtual_network_id = azurerm_virtual_network.mul_vnet.id
  routing {
    associated_route_table_id = azurerm_virtual_hub_route_table.custom_route.id
  }
  internet_security_enabled = true
}

resource "azurerm_virtual_hub_connection" "hub_to_auth" {
  provider                  = azurerm.Production
  name                      = "${var.region_abbreviation}-${var.env_name}${var.env_key}-hub-to-auth${local.suffix}"
  virtual_hub_id            = data.azurerm_virtual_hub.prod-hub.id
  remote_virtual_network_id = azurerm_virtual_network.auth_vnet.id
  routing {
    associated_route_table_id = azurerm_virtual_hub_route_table.custom_route.id
  }
  internet_security_enabled = true
}


