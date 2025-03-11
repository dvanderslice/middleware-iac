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
  description = "Name of the resource group to use."
  type        = string
}

variable "create_new_storage_account" {
  description = "When true, creates a new storage account for the function app deployment."
  type        = bool
  default     = true
}

variable "storage_account_name" {
  description = "Name of the storage account to create for staging code deployments for the function app."
  type        = string
}

variable "app_service_plan_name" {
  description = "Name of the app service plan to create."
  type        = string
}

variable "app_service_plan_linux" {
  description = "When true, uses a Linux plan."
  type        = bool
  default     = false
}

variable "app_insights_name" {
  description = "Name of the app insights to create."
  type        = string
}

variable "function_app_name" {
  description = "Name of the function app to create."
  type        = string
}

variable "function_runtime" {
  description = "The language worker runtime to load in the function app (ex. node, python, java)."
  type        = string
  default     = "node"
}

variable "subnet_id" {
  description = "The subnet identifier for the function app."
  type        = string
  default     = null
}
