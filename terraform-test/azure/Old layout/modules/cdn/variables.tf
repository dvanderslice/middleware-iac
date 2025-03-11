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

variable "storage_account_name" {
  description = "The name of the storage account to be created"
  type        = string
}

variable "account_kind" {
  description = "The kind of storage account."
  default     = "StorageV2"
  type        = string
}

variable "sku" {
  description = "The SKU of the storage account."
  default     = "Standard_GRS"
  type        = string
}

variable "access_tier" {
  description = "The access tier of the storage account."
  default     = "Hot"
  type        = string
}

variable "enable_https_traffic" {
  description = "Configure the storage account to accept requests from secure connections only. Possible values are `true` or `false`"
  default     = true
  type        = bool
}

variable "enable_static_website" {
  description = "Indicates if a static website to be enabled on the storage account. Possible values are `true` or `false`"
  default     = true
  type        = bool
}

variable "static_website_source_folder" {
  description = "Set a source folder path to copy static website files to static website storage blob"
  type        = string
}

variable "assign_identity" {
  description = "Specifies the identity type of the Storage Account. At this time the only allowed value is SystemAssigned."
  default     = true
  type        = bool
}

variable "enable_cdn_profile" {
  description = "Controls the creation of CDN profile and endpoint for static website. Possible values are `true` or `false`"
  default     = false
  type        = bool
}

variable "cdn_profile_name" {
  description = "Specifies the name of the CDN Profile"
  type        = string
}

variable "cdn_sku_profile" {
  description = "The SKU of the CDN profile. Accepted values are 'Standard_Akamai', 'Standard_ChinaCdn', 'Standard_Microsoft', 'Standard_Verizon' or 'Premium_Verizon'."
  default     = "Standard_Akamai"
  type        = string
}

variable "index_path" {
  description = "Web site index path"
  default     = "index.html"
  type        = string
}

variable "custom_404_path" {
  description = "Web site path for not found"
  default     = "404.html"
  type        = string
}
