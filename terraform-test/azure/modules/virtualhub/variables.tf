variable "azure_location" {
  description = "Azure Region"
  type        = string
}

variable "tags" {
  description = "Tags to be applied to resources (inclusive)"
  type        = map(string)
  default = {
    "application" = "foundations"
    "contact"     = "dl-global-digitalsolutions-dev@dematic.com"
    "costcenter"  = "550164"
    "createdby"   = "digitalsolutions-rd@dematic.com"
    "environment" = "dev2"
    "lifetime"    = "perpetual"
    "owner"       = "jason.higgs@dematic.com"
  }
}

variable "shared_resource_group_name" {
  description = "Name of the shared resource group. This is usually where an application gateway or API management is located."
  type        = string
}

variable "shared_network_id" {
  description = "Name of the shared network identifier"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group to use"
  type        = string
}

variable "virtual_network_name" {
  description = "Desired name of the virtual network"
  type        = string
}

variable "virtual_wan_name" {
  description = "Desired name of the virtual WAN"
  type        = string
}

variable "virtual_hub_name" {
  description = "Desired name of the virtual hub"
  type        = string
}

variable "hub_address_prefix" {
  description = "The IP address prefix (CIDR range) of the virtual hub. This must be a /23 or /24 according to Microsoft."
  type        = string
}

variable "hub_vnet_prefix" {
  description = "The IP address prefix (CIDR range) of the hub virtual network"
  type        = string
}

variable "hub_subnet_prefix" {
  description = "The IP address prefix (CIDR range) of the hub subnet"
  type        = string
}

variable "firewall_name" {
  description = "Desired name of the firewall"
  type        = string
}

variable "firewall_policy_id" {
  description = "The firewall policy identifier to use in the firewall"
  type        = string
}

variable "spoke_destinations" {
  description = "A list of destination CIDR blocks that should represent the network topology spokes"
  type        = list(any)
}
variable "p2svpnaddresspool"{
  description = "Address space used for client VPN connections"
  type        = string
  default     = "172.28.0.0/24"
  }