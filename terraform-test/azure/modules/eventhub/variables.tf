variable "azure_location" {
  description = "The Azure location in which to deploy"
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
  description = "Name of the resource group"
  type        = string
}

variable "eventhub_namespace_name" {
  description = "Name of the event hub namespace to create"
  type        = string
}

variable "eventhub_namespace_hubs" {
  type        = any
  description = "Map to handle event hub creation. It supports the creation of the hub(s) and authorization_rules associated with each namespace created."
}
