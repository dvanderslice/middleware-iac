variable "azure_location" {
  description = "The Azure location in which to deploy."
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

variable "resource_group_name" {
  description = "Name of the resource group to create."
  type        = string
}

variable "apim_name" {
  description = "Name of the API management service to create."
  type        = string
}

variable "apim_sku" {
  description = "SKU of the API management service."
  type        = string
  default     = "Developer_1"
}

variable "virtual_network_type" {
  description = "The type of virtual network you want to use. Valid values include: None, External, Internal."
  type        = string
  default     = "None"
}

variable "virtual_network_subnet" {
  description = "The Id of the subnet that will be used for the API Management."
  type        = string
  default     = null
}
