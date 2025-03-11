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

variable "cosmosdb_name" {
  description = "Name of the CosmosDB account to create."
  type        = string
}

variable "gremlin_databases" {
  description = "List of CosmosDB graph databases to create."
  type        = list(string)
}
