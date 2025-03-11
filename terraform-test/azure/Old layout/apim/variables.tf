variable "azure_subscription_id" {
  type        = string
  description = "Azure subscription Id"
}

variable "azure_tenant_id" {
  type        = string
  description = "Azure tenant Id"
}

variable "multi_regional_deployment" {
  type        = bool
  description = "When true, deploy resources for multiple regions"
  default     = false
}

variable "primary_region" {
  type        = bool
  description = "When true, the API management resource will get created rather than updated for a new region"
  default     = false
}

variable "azure_location" {
  description = "Azure region"
  type        = string
}

variable "resource_version" {
  description = "The version identifier"
  type        = string
}

variable "env_name" {
  description = "The environment abbreviation to be used in naming resources (i.e. dev, stg, etc.)"
  type        = string
}

variable "env_key" {
  description = "The environment instance identifier"
  type        = string
}

variable "region_abbreviation" {
  description = "An abbreviated version of the Azure region (i.e. eus2, weu1, etc.)"
  type        = string
}

variable "vnet_address_space" {
  description = "The CIDR range to use for the virtual network"
  type        = string
}

variable "subnet01_address_space" {
  description = "The CIDR range to use for the subnet01"
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
    "customer"    = "digitalsolutions"
    "lifetime"    = "perpetual"
    "owner"       = "jason.higgs@dematic.com"
    "program"     = "CS Growth"
    "project"     = "Insights NextGen"
  }
}

variable "runtime_tags" {
  type        = map(string)
  description = "Additional tags that can be supplied in addition to what CI has defined in the tfvars file"
  default     = {}
}

variable "random_id" {
  description = "Random identifier"
  default     = null
}

variable "use_random_id" {
  description = "If true, use a random identifier when naming resources"
  type        = bool
  default     = false
}
