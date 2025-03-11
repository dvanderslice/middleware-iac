variable "azure_subscription_id" {
  type        = string
  description = "Azure subscription Id"
}

variable "azure_tenant_id" {
  type        = string
  description = "Azure tenant Id"
}

#variable "azure_client_id" {
  #type        = string
  #description = "Azure client Id for Lower Environment"
#}

#variable "azure_client_secret" {
  #type        = string
  #description = "Azure client secret for Lower Environment"
#}

#variable "azure_production_client_id" {
  #type        = string
  #description = "Azure client Id for Production Environment. This account should also have access to the lower environments resource groups as a contributor for the networking pieces."
#}

#variable "azure_production_client_secret" {
  #type        = string
  #description = "Azure client secret for Production Environment"
#s}

variable "multi_regional_deployment" {
  type        = bool
  description = "When true, deploy resources for multiple regions"
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

variable "customer_code" {
  description = "Customer code (resourceKey) from tenants.json (i.e. 04=demo, 15=Crocs.)"
  type        = string
}

variable "base_cidr_block" {
  description = "A CIDR block that virtual networks and subnets will be derived from"
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

variable "create_new_storage_account" {
  description = "When true, creates a new storage account for the function app deployment."
  type        = bool
  default     = true
}

variable "p2svpnaddresspool" {
  description = "Address space used for client VPN connections"
  type        = string
  default     = "172.29.1.0/24"
}

variable "prodhubrgname" {
  description = "Name of the Production Resource Group that houses the Virtual WAN and Firewall to integrate with"
  type        = string
  default     = "AppGrp-hub01-prd07-rg"
}

variable "prod_env_name" {
  description = "This should always be prd but in cases of testing this can be changed to another value"
  type        = string
  default     = "prd"
}

variable "prod_env_key" {
  description = "Env_key of production"
  type        = string
  default     = "07"
}
