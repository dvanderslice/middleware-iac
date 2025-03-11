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

variable "kusto_name" {
  description = "Name of the kusto cluster"
  type        = string
}

variable "kusto_sku_name" {
  description = "Name of the kusto SKU"
  type        = string
}

variable "kusto_sku_capacity" {
  description = "Capacity of the cluster"
  type        = number
}

variable "subnet_id" {
  description = "Subnet identifier"
  type        = string
}

variable "public_ip_name_for_engine" {
  description = "Name of the public IP address resource for the ADX engine"
  type        = string
}

variable "public_ip_name_for_management" {
  description = "Name of the public IP address resource for the ADX data management"
  type        = string
}
