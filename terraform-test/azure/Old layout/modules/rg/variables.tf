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

variable "resource_group_name" {
  description = "Name of the resource group to create."
  type        = string
}

variable "create_lock" {
  description = "If true, a resource lock will be set on the resource group"
  default     = false
  type        = bool
}
