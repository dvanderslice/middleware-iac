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

module "lnx_rg" {
  source = "../modules/rg"

  azure_location      = var.azure_location
  resource_group_name = local.linux_resource_group_name

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
      new_bits = 3
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
      new_bits = 3
    },
    {
      name     = "subnet02"
      new_bits = 3
    },
    {
      name     = "subnet03"
      new_bits = 3
    },
    {
      name     = "subnet04"
      new_bits = 3
    },
    {
      name     = "subnet05"
      new_bits = 3
    },

  ]
}

resource "azurerm_subnet" "mul_subnet01" {
  name                 = "subnet01"
  resource_group_name  = module.rg.name
  virtual_network_name = azurerm_virtual_network.mul_vnet.name
  address_prefixes     = [module.mul_subnet_addrs.networks[0].cidr_block]
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
      name    = "Microsoft.Web/serverFarms"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }

  service_endpoints = ["Microsoft.Storage", "Microsoft.Web", "Microsoft.EventHub", "Microsoft.AzureCosmosDB"]
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

resource "azurerm_subnet" "mul_subnet05" {
  name                 = "subnet05"
  resource_group_name  = module.rg.name
  virtual_network_name = azurerm_virtual_network.mul_vnet.name
  address_prefixes     = [module.mul_subnet_addrs.networks[4].cidr_block]

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

resource "azurerm_network_security_group" "mul_nsg05" {
  name                = "${var.region_abbreviation}-mul${var.env_key}-back05-nsg${local.suffix}"
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
resource "azurerm_subnet_network_security_group_association" "mul_nsg_assoc01" {
  subnet_id                 = azurerm_subnet.mul_subnet01.id
  network_security_group_id = azurerm_network_security_group.mul_nsg01.id
}

resource "azurerm_subnet_network_security_group_association" "mul_nsg_assoc02" {
  subnet_id                 = azurerm_subnet.mul_subnet02.id
  network_security_group_id = azurerm_network_security_group.mul_nsg02.id
}

resource "azurerm_subnet_network_security_group_association" "mul_nsg_assoc03" {
  subnet_id                 = azurerm_subnet.mul_subnet03.id
  network_security_group_id = azurerm_network_security_group.mul_nsg03.id
}

resource "azurerm_subnet_network_security_group_association" "mul_nsg_assoc04" {
  subnet_id                 = azurerm_subnet.mul_subnet04.id
  network_security_group_id = azurerm_network_security_group.mul_nsg04.id
}

resource "azurerm_subnet_network_security_group_association" "mul_nsg_assoc05" {
  subnet_id                 = azurerm_subnet.mul_subnet05.id
  network_security_group_id = azurerm_network_security_group.mul_nsg05.id
}