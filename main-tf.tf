# Gets the current IP address for firewall rules
data "http" "current_public_ip" {
  url = "http://ipinfo.io/json"
  request_headers = {
    Accept = "application/json"
  }
}

# -------------------------------------------------------------------------------------------------
# Create the private network for multi-tenancy
module "rg" {
  source = "../modules/rg"

  azure_location      = var.azure_location
  resource_group_name = local.mul_resource_group_name

  tags = merge(local.resource_tags, {
    "environment" = var.env_name
    "role"        = "api"
    "createdon"   = local.tag_createdon
  })
}

module "utl_rg" {
  source = "../modules/rg"

  azure_location      = var.azure_location
  resource_group_name = local.utl_resource_group_name

  tags = merge(local.resource_tags, {
    "environment" = var.env_name
    "role"        = "api"
    "createdon"   = local.tag_createdon
  })
}

module "frn_rg" {
  source = "../modules/rg"

  azure_location      = var.azure_location
  resource_group_name = local.frn_resource_group_name

  tags = merge(local.resource_tags, {
    "environment" = var.env_name
    "role"        = "api"
    "createdon"   = local.tag_createdon
  })
}
# Get all of the virtual network CIDRs
module "vnet_addrs" {
  source = "../modules/cidr-subnets"

  base_cidr_block = var.base_cidr_block
  networks = [
   # {
     # name     = "reserved"
     # new_bits = 5
   # },
       {
      name     = local.mul_vnet_name
      new_bits = 1
    },
    {
      name     = local.shared_vnet_name
      new_bits = 5
    },
    {
      name     = local.hub_vnet_name
      new_bits = 4
    },
    {
      name     = local.private_vnet_name
      new_bits = 3
    },
    {
      name     = local.auth_vnet_name
      new_bits = 5
    },
  ]
}

resource "azurerm_virtual_network" "mul_vnet" {
  name                = local.mul_vnet_name
  address_space       = [module.vnet_addrs.networks[0].cidr_block]
  location            = var.azure_location
  resource_group_name = module.rg.name

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

# Get all of the subnets for multi-tenant
module "mul_subnet_addrs" {
  source = "../modules/cidr-subnets"

  base_cidr_block = module.vnet_addrs.networks[0].cidr_block
  networks = [
    #{
    #  name     = "reserved"
     # new_bits = 8
   # },
    {
      name     = "subnet01"
      new_bits = 2
    },
    {
      name     = "subnet02"
      new_bits = 3
    },
    {
      name     = "subnet03"
      new_bits = 2
    },
    {
      name     = "subnet04"
      new_bits = 3
    },
  ]
}

resource "azurerm_route_table" "kusto_route" {
  name                          = "kusto_rt"
  location                      = var.azure_location
  resource_group_name           = module.rg.name
}

resource "azurerm_subnet" "mul_subnet01" {
  name                 = "subnet01"
  resource_group_name  = module.rg.name
  virtual_network_name = azurerm_virtual_network.mul_vnet.name
  address_prefixes     = [module.mul_subnet_addrs.networks[0].cidr_block]

    # Delegate the subnet to "Microsoft.Kusto/clusters"
  delegation {
    name = "acctestdelegation"

    service_delegation {
      name    = "Microsoft.Kusto/clusters"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }

}

resource "azurerm_subnet_route_table_association" "mul_subnet01_kusto_rt" {
  subnet_id      = azurerm_subnet.mul_subnet01.id
  route_table_id = azurerm_route_table.kusto_route.id
}

resource "azurerm_subnet" "mul_subnet02" {
  name                 = "subnet02"
  resource_group_name  = module.rg.name
  virtual_network_name = azurerm_virtual_network.mul_vnet.name
  address_prefixes     = [module.mul_subnet_addrs.networks[1].cidr_block]

   # Delegate the subnet to "Microsoft.Web/serverFarms"
  delegation {
    name = "acctestdelegation"

    service_delegation {
      name    = "Microsoft.Web/serverFarms"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }

  service_endpoints = ["Microsoft.Storage", "Microsoft.Web", "Microsoft.EventHub", "Microsoft.AzureCosmosDB"]
}
resource "azurerm_subnet" "mul_subnet03" {
  name                 = "subnet03"
  resource_group_name  = module.rg.name
  virtual_network_name = azurerm_virtual_network.mul_vnet.name
  address_prefixes     = [module.mul_subnet_addrs.networks[2].cidr_block]

    # Delegate the subnet to "Microsoft.Kusto/clusters"
  delegation {
    name = "acctestdelegation"

    service_delegation {
      name    = "Microsoft.Kusto/clusters"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }

}

resource "azurerm_subnet_route_table_association" "mul_subnet03_kusto_rt" {
  subnet_id      = azurerm_subnet.mul_subnet03.id
  route_table_id = azurerm_route_table.kusto_route.id
}

resource "azurerm_subnet" "mul_subnet04" {
  name                 = "subnet04"
  resource_group_name  = module.rg.name
  virtual_network_name = azurerm_virtual_network.mul_vnet.name
  address_prefixes     = [module.mul_subnet_addrs.networks[3].cidr_block]

  # Delegate the subnet to "Microsoft.Web/serverFarms"
  delegation {
    name = "acctestdelegation"

    service_delegation {
      name    = "Microsoft.Web/serverFarms"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }

  service_endpoints = ["Microsoft.Storage", "Microsoft.Web", "Microsoft.EventHub", "Microsoft.AzureCosmosDB"]
}

resource "azurerm_network_security_group" "mul_nsg01" {
  name                = "${var.region_abbreviation}-mul${var.env_key}-back01-nsg${local.suffix}"
  location            = var.azure_location
  resource_group_name = module.rg.name

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

resource "azurerm_network_security_group" "mul_nsg02" {
  name                = "${var.region_abbreviation}-mul${var.env_key}-back02-nsg${local.suffix}"
  location            = var.azure_location
  resource_group_name = module.rg.name

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

resource "azurerm_network_security_group" "mul_nsg03" {
  name                = "${var.region_abbreviation}-mul${var.env_key}-back03-nsg${local.suffix}"
  location            = var.azure_location
  resource_group_name = module.rg.name

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

resource "azurerm_network_security_group" "mul_nsg04" {
  name                = "${var.region_abbreviation}-mul${var.env_key}-back04-nsg${local.suffix}"
  location            = var.azure_location
  resource_group_name = module.rg.name

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

# Rules for nsg01
resource "azurerm_network_security_rule" "mul_01_in110" {
  name                        = "Secure_Client_communication_to_API_Management"
  priority                    = 110
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefix       = "AzureFrontDoor.Backend"
  destination_address_prefix  = "VirtualNetwork"
  resource_group_name         = module.rg.name
  network_security_group_name = azurerm_network_security_group.mul_nsg01.name
}

resource "azurerm_network_security_rule" "mul_01_in120" {
  name                        = "Management_endpoint_for_Azure_portal_and_Powershell"
  priority                    = 120
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "3443"
  source_address_prefix       = "ApiManagement"
  destination_address_prefix  = "VirtualNetwork"
  resource_group_name         = module.rg.name
  network_security_group_name = azurerm_network_security_group.mul_nsg01.name
}

resource "azurerm_network_security_rule" "mul_01_in130" {
  name                        = "Dependency_on_Redis_Cache"
  priority                    = 130
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "6381-6383"
  source_address_prefix       = "VirtualNetwork"
  destination_address_prefix  = "VirtualNetwork"
  resource_group_name         = module.rg.name
  network_security_group_name = azurerm_network_security_group.mul_nsg01.name
}

resource "azurerm_network_security_rule" "mul_01_in180" {
  name                        = "Azure_Infrastructure_Load_Balancer"
  priority                    = 180
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "AzureLoadBalancer"
  destination_address_prefix  = "VirtualNetwork"
  resource_group_name         = module.rg.name
  network_security_group_name = azurerm_network_security_group.mul_nsg01.name
}

# Rules for nsg02
resource "azurerm_network_security_rule" "mul_02_in101" {
  name                        = "AllowAzureDataExplorerManagement"
  priority                    = 201
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefix       = "AzureDataExplorerManagement"
  destination_address_prefix  = "VirtualNetwork"
  resource_group_name         = module.rg.name
  network_security_group_name = azurerm_network_security_group.mul_nsg02.name
}

resource "azurerm_network_security_rule" "mul_02_in102" {
  name                        = "AllowAzureDataExplorerMonitoring"
  priority                    = 202
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefix       = "137.116.81.189"
  destination_address_prefix  = "VirtualNetwork"
  resource_group_name         = module.rg.name
  network_security_group_name = azurerm_network_security_group.mul_nsg02.name
}

resource "azurerm_network_security_rule" "mul_02_in103" {
  name                        = "AllowAzureLoadBalancer"
  priority                    = 203
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_ranges     = [443, 80]
  source_address_prefix       = "AzureLoadBalancer"
  destination_address_prefix  = "VirtualNetwork"
  resource_group_name         = module.rg.name
  network_security_group_name = azurerm_network_security_group.mul_nsg02.name
}

resource "azurerm_network_security_rule" "mul_02_in104" {
  name                        = "AllowAzureDataExplorerInternalCommunication"
  priority                    = 104
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "VirtualNetwork"
  destination_address_prefix  = "VirtualNetwork"
  resource_group_name         = module.rg.name
  network_security_group_name = azurerm_network_security_group.mul_nsg02.name
}

resource "azurerm_network_security_rule" "mul_02_in121" {
  name                        = "CODA_office"
  priority                    = 121
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefix       = "64.19.223.82/32"
  destination_address_prefix  = "VirtualNetwork"
  resource_group_name         = module.rg.name
  network_security_group_name = azurerm_network_security_group.mul_nsg02.name
}

resource "azurerm_network_security_rule" "mul_02_in1011" {
  name                        = "Runner_Whitelist_01"
  priority                    = 1011
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefix       = "52.167.120.105/32"
  destination_address_prefix  = "VirtualNetwork"
  resource_group_name         = module.rg.name
  network_security_group_name = azurerm_network_security_group.mul_nsg02.name
}

resource "azurerm_network_security_rule" "mul_02_out100" {
  name                        = "Outbound_01"
  priority                    = 200
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_ranges     = [443, 80]
  source_address_prefix       = "*"
  destination_address_prefix  = "Internet"
  resource_group_name         = module.rg.name
  network_security_group_name = azurerm_network_security_group.mul_nsg02.name
}

resource "azurerm_subnet_network_security_group_association" "mul_nsg_assoc01" {
  subnet_id                 = azurerm_subnet.mul_subnet01.id
  network_security_group_id = azurerm_network_security_group.mul_nsg02.id
}

resource "azurerm_subnet_network_security_group_association" "mul_nsg_assoc02" {
  subnet_id                 = azurerm_subnet.mul_subnet02.id
  network_security_group_id = azurerm_network_security_group.mul_nsg03.id
}

resource "azurerm_subnet_network_security_group_association" "mul_nsg_assoc03" {
  subnet_id                 = azurerm_subnet.mul_subnet03.id
  network_security_group_id = azurerm_network_security_group.mul_nsg02.id
}

resource "azurerm_subnet_network_security_group_association" "mul_nsg_assoc04" {
  subnet_id                 = azurerm_subnet.mul_subnet04.id
  network_security_group_id = azurerm_network_security_group.mul_nsg03.id
}

