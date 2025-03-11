# This may need to be shared according to https://docs.microsoft.com/en-us/azure/virtual-wan/azure-monitor-insights
# one way is to deploy many hubs connected to the one VWAN
resource "azurerm_virtual_wan" "wan" {
  name                = var.virtual_wan_name
  resource_group_name = var.resource_group_name
  location            = var.azure_location
  tags                = var.tags

  lifecycle {
    ignore_changes = [
      tags["createdon"],
    ]
  }
}

# Azure recommends an address prefix /23 CIDR but a /24 can work
resource "azurerm_virtual_hub" "hub" {
  name                = var.virtual_hub_name
  resource_group_name = var.resource_group_name
  location            = var.azure_location
  virtual_wan_id      = azurerm_virtual_wan.wan.id
  address_prefix      = var.hub_address_prefix
  tags                = var.tags

  lifecycle {
    ignore_changes = [
      tags["createdon"],
    ]
  }
}
resource "azurerm_vpn_server_configuration" "uservpnconfig" {
  name                     = var.virtual_hub_name
  resource_group_name      = var.resource_group_name
  location                 = var.azure_location
  vpn_authentication_types = ["Certificate"]
  vpn_protocols = ["OpenVPN"]
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
  name                        = var.virtual_hub_name
  location                    = var.azure_location
  resource_group_name         = var.resource_group_name
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
  name                = var.firewall_name
  location            = var.azure_location
  resource_group_name = var.resource_group_name
  firewall_policy_id  = var.firewall_policy_id
  sku_name            = "AZFW_Hub"
  sku_tier            = "Premium"
  # Threat intelligence mode MUST be empty (even though Off works with the CLI) with SKU of "AZFW_Hub"
  # as it does not accept ThreatIntelMode in current sku AZFW_Hub
  # Original Error: Code="AzureFirewallInvalidRequest" Message="Request parameter VirtualHub can not be specified in current SKU AZFW_VNet for the Azure Firewall
  # https://githubmemory.com/repo/terraform-providers/terraform-provider-azurerm/issues/12623
  threat_intel_mode = ""
  tags              = var.tags

  virtual_hub {
    virtual_hub_id = azurerm_virtual_hub.hub.id
  }
}

