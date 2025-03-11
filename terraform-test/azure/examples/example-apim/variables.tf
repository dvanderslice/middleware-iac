variable "azure_subscription_id" {
  type        = string
  description = "Azure subscription Id"
}

variable "azure_tenant_id" {
  type        = string
  description = "Azure tenant Id"
}

variable "azure_client_id" {
  type        = string
  description = "Azure client Id"
}

variable "azure_client_secret" {
  type        = string
  description = "Azure client secret"
}

variable "azure_location" {
  description = "Azure Region"
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

variable "purpose" {
  description = "Defines the purpose of the resources contained in the group (i.e. auth, ai, etc.)"
  type        = string
}

variable "region_abbreviation" {
  description = "An abbreviated version of the Azure region (i.e. eus2, weu1, etc.)"
  type        = string
}

variable "app_abbreviation" {
  description = "Application abbreviation to be used in resource naming"
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

variable "runtime_tags" {
  type        = map(string)
  description = "Additional tags that can be supplied in addition to what CI has defined in the tfvars file"
  default     = {}
}

variable "random_id" {
  description = "Random identifier"
  default     = null
}
