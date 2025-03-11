variable "azure_subscription_id" {
  type        = string
  description = "Your Azure subscription Id"
}

variable "azure_tenant_id" {
  type        = string
  description = "Your Azure tenant Id"
}

variable "azure_client_id" {
  type        = string
  description = "The application client Id"
}

variable "azure_client_secret" {
  type        = string
  description = "The application client secret"
}

variable "azure_location" {
  type        = string
  description = "The Azure location in which to deploy"
}

variable "region_abbreviation" {
  type        = string
  description = "The Azure location in an abbreviated format"
}

variable "resource_version" {
  type        = string
  description = "The version of the resource deployment"
}

variable "env_name" {
  type        = string
  description = "The environment abbreviation to be used in resource naming (ex. dev, stg, prd)"
}

variable "env_key" {
  type        = string
  description = "The environment instance identifier"
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

variable "createdon_format" {
  type        = string
  default     = "YYYY-MM-DD"
  description = "Defines the date format to be used in tagging"
}

variable "create_lock" {
  type        = bool
  default     = true
  description = "If true, will use resource locking on the resource group"
}

variable "assign_unique_id" {
  type        = bool
  default     = true
  description = "If true, will append a unique identifier to the resource group and storage account names"
}

variable "random_id" {
  default     = null
  description = "Random Id suffix to use for ephemeral and unique resources. This also provides a way to use the same id across multiple terraform configurations/states."
}
