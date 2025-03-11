resource "random_id" "id" {
  count       = var.random_id == null && var.use_random_id ? 1 : 0
  byte_length = 2
}

locals {
  random_id                   = var.random_id == null && var.use_random_id ? random_id.id[0].hex : var.random_id
  suffix                      = local.random_id == null || !var.use_random_id ? "" : "-${local.random_id}"
  shared_resource_group_name  = "AppGrp-shared${var.resource_version}-${var.env_name}${var.env_key}-rg${local.suffix}"
  hub_resource_group_name     = "AppGrp-hub${var.resource_version}-${var.env_name}${var.env_key}-rg${local.suffix}"
  private_resource_group_name = "AppGrp-pri${var.resource_version}-${var.env_name}${var.env_key}-rg${local.suffix}"
  auth_resource_group_name    = "AppGrp-auth${var.resource_version}-${var.env_name}${var.env_key}-rg${local.suffix}"
  mul_resource_group_name     = "AppGrp-mul${var.resource_version}-${var.env_name}${var.env_key}-rg${local.suffix}"
  shared_vnet_name            = "${var.region_abbreviation}-shared-${var.env_name}${var.env_key}-vnet${local.suffix}"
  hub_vnet_name               = "${var.region_abbreviation}-hub${var.resource_version}-${var.env_name}${var.env_key}-vnet${local.suffix}"
  private_vnet_name           = "${var.region_abbreviation}-pri${var.resource_version}-${var.env_name}${var.env_key}-vnet${local.suffix}"
  auth_vnet_name              = "${var.region_abbreviation}-auth${var.resource_version}-${var.env_name}${var.env_key}-vnet${local.suffix}"
  mul_vnet_name               = "${var.region_abbreviation}-mul${var.resource_version}-${var.env_name}${var.env_key}-vnet${local.suffix}"
  mul_storage_name            = "${var.region_abbreviation}mul${var.resource_version}func01${substr(var.env_name, 0, 1)}${var.env_key}sa${substr(local.suffix, 1, 4)}"
  mul_config_storage_name     = "${var.region_abbreviation}mul${var.resource_version}conf01${substr(var.env_name, 0, 1)}${var.env_key}sa${substr(local.suffix, 1, 4)}"
  mul_function_app_name       = "${var.region_abbreviation}-mul${var.resource_version}func01-${var.env_name}${var.env_key}-data-replay-fa${local.suffix}"
  mul_core_blue_function_app_name       = "${var.region_abbreviation}-mul${var.resource_version}func01-${var.env_name}${var.env_key}-core-fa-blue${local.suffix}"
  mul_core_green_function_app_name       = "${var.region_abbreviation}-mul${var.resource_version}func01-${var.env_name}${var.env_key}-core-fa-green${local.suffix}"
  mul_gql_gate_blue_function_app_name       = "${var.region_abbreviation}-mul${var.resource_version}func01-${var.env_name}${var.env_key}-gql-gate-fa-blue${local.suffix}"
  mul_gql_gate_green_function_app_name       = "${var.region_abbreviation}-mul${var.resource_version}func01-${var.env_name}${var.env_key}-gql-gate-fa-green${local.suffix}"
  mul_notifications_blue_function_app_name       = "${var.region_abbreviation}-mul${var.resource_version}func01-${var.env_name}${var.env_key}-notifications-fa-blue${local.suffix}"
  mul_notifications_green_function_app_name       = "${var.region_abbreviation}-mul${var.resource_version}func01-${var.env_name}${var.env_key}-notifications-fa-green${local.suffix}"
  mul_nui_blue_function_app_name       = "${var.region_abbreviation}-mul${var.resource_version}func01-${var.env_name}${var.env_key}-nui-fa-blue${local.suffix}"
  mul_nui_green_function_app_name       = "${var.region_abbreviation}-mul${var.resource_version}func01-${var.env_name}${var.env_key}-nui-fa-green${local.suffix}"
  mul_app_service_plan_name   = "${var.region_abbreviation}-mul${var.resource_version}func01-${var.env_name}${var.env_key}-asp${local.suffix}"
  mul_app_insights_name       = "${var.region_abbreviation}-mul${var.resource_version}func01-${var.env_name}${var.env_key}-ai${local.suffix}"
  auth_storage_name           = "${var.region_abbreviation}mul${var.resource_version}auth01${substr(var.env_name, 0, 1)}${var.env_key}sa${substr(local.suffix, 1, 4)}"
  auth_blue_function_app_name      = "${var.region_abbreviation}-mul${var.resource_version}auth01-${var.env_name}${var.env_key}-fa-blue${local.suffix}"
  auth_green_function_app_name      = "${var.region_abbreviation}-mul${var.resource_version}auth01-${var.env_name}${var.env_key}-fa-green${local.suffix}"
  auth_app_service_plan_name  = "${var.region_abbreviation}-mul${var.resource_version}auth01-${var.env_name}${var.env_key}-asp${local.suffix}"
  auth_app_insights_name      = "${var.region_abbreviation}-mul${var.resource_version}auth01-${var.env_name}${var.env_key}-ai${local.suffix}"
  p2s_ip_group_name           = "${var.region_abbreviation}-p2s_vnet${var.resource_version}-${var.env_name}${var.env_key}-ipg"
  apim_sku                   = var.multi_regional_deployment ? "Premium_1" : "Developer_1"
  apim_name                  = "shared-${var.env_name}${var.env_key}-api${local.suffix}"
  apim_nsg_name              = "shared-${var.env_name}${var.env_key}-apim-nsg${local.suffix}"
  utl_resource_group_name   = "AppGrp-utl${var.resource_version}-${var.env_name}${var.env_key}-rg${local.suffix}"
  ai_resource_group_name     = "AppGrp-ai${var.resource_version}-${var.env_name}${var.env_key}-rg${local.suffix}"
  eventhub_namespace_name         = "${var.region_abbreviation}-mul${var.resource_version}fou-${var.env_name}${var.env_key}-ns${local.suffix}"
  eventhub_hub_name               = "${var.region_abbreviation}-mul${var.resource_version}log01-${var.env_name}${var.env_key}-hub${local.suffix}"
  kusto_name                      = "${var.region_abbreviation}mul${var.resource_version}exp01${substr(var.env_name, 0, 1)}${var.env_key}dcl${substr(local.suffix, 1, 4)}"
  cus_kusto_name                  = "${var.region_abbreviation}cus${var.resource_version}exp01${substr(var.env_name, 0, 1)}${var.env_key}dcl${substr(local.suffix, 1, 4)}"
  kusto_engine_public_ip_name     = "${var.region_abbreviation}-mul${var.resource_version}-adx-engine-pip"
  kusto_management_public_ip_name = "${var.region_abbreviation}-mul${var.resource_version}-data-management-pip"
  datadog_function_app_name       = "${var.region_abbreviation}-mul${var.resource_version}func01-${var.env_name}${var.env_key}-datadog-fa${local.suffix}"
  datadog_app_service_plan_name   = "${var.region_abbreviation}-mul${var.resource_version}datadog01-${var.env_name}${var.env_key}-asp${local.suffix}"
  datadog_app_insights_name       = "${var.region_abbreviation}-mul${var.resource_version}datadog01-${var.env_name}${var.env_key}-ai${local.suffix}"
  ai_function_app_name            = "${var.region_abbreviation}-mul${var.resource_version}func01-${var.env_name}${var.env_key}-ai-fa${local.suffix}"
  ai_app_service_plan_name        = "${var.region_abbreviation}-mul${var.resource_version}ai01-${var.env_name}${var.env_key}-asp${local.suffix}"
  ai_app_insights_name            = "${var.region_abbreviation}-mul${var.resource_version}ai01-${var.env_name}${var.env_key}-ai${local.suffix}"
  ai_fa_storage_name              = "${var.region_abbreviation}ai${var.resource_version}anom${substr(var.env_name, 0, 1)}${var.env_key}sa${substr(local.suffix, 1, 4)}"
  ai_storage_name                 = "${var.region_abbreviation}ai${var.resource_version}stor${substr(var.env_name, 0, 1)}${var.env_key}sa${substr(local.suffix, 1, 4)}"
  op_storage_name                 = "${var.region_abbreviation}mul${var.resource_version}stor${substr(var.env_name, 0, 1)}${var.env_key}sa${substr(local.suffix, 1, 4)}"
  cfrn_storage_name                 = "${var.region_abbreviation}cfrn${var.resource_version}stor${substr(var.env_name, 0, 1)}${var.env_key}sa${substr(local.suffix, 1, 4)}"
  cosmosdb_name                   = "${var.region_abbreviation}-mul${var.resource_version}-${var.env_name}${var.env_key}-cga${local.suffix}"
  redis_instance_name             = "${var.region_abbreviation}cus${var.env_name}${var.env_key}rc"
  webpubsub_service_name          = "${var.region_abbreviation}-mul${var.resource_version}-${var.env_name}${var.env_key}-pub${local.suffix}"
  webpubhub_hub_chat_name         = "chat${var.env_name}${var.env_key}_local"
  utl_keyvault_name               = "${var.region_abbreviation}-utl${var.resource_version}-${var.env_name}${var.env_key}-kv${local.suffix}"
  utl_acr_name                    = "${var.region_abbreviation}utl${var.resource_version}conatiner${var.resource_version}${var.env_name}${var.env_key}con${local.suffix}"
  mul_dps_name                    = "${var.region_abbreviation}-mul${var.resource_version}-${var.env_name}${var.env_key}-dp${local.suffix}"
  auth_vnet_ip_group_name          = "${var.region_abbreviation}-auth_vnet${var.resource_version}-${var.env_name}${var.env_key}-ipg"
  pri_vnet_ip_group_name      = "${var.region_abbreviation}-pri_vnet${var.resource_version}-${var.env_name}${var.env_key}-ipg"
  shared_vnet_ip_group_name   = "${var.region_abbreviation}-shared_vnet${var.resource_version}-${var.env_name}${var.env_key}-ipg"
  mul_vnet_ip_group_name      = "${var.region_abbreviation}-mul_vnet${var.resource_version}-${var.env_name}${var.env_key}-ipg"
  functions_private_subnet_ip_group_name      = "${var.region_abbreviation}-func_pri_subnet${var.resource_version}-${var.env_name}${var.env_key}-ipg"
  shared_private_subnet_ip_group_name      = "${var.region_abbreviation}-shared_pri_subnet${var.resource_version}-${var.env_name}${var.env_key}-ipg"
  storage_private_subnet_ip_group_name      = "${var.region_abbreviation}-storage_pri_subnet${var.resource_version}-${var.env_name}${var.env_key}-ipg"
  data_private_subnet_ip_group_name      = "${var.region_abbreviation}-data_pri_subnet${var.resource_version}-${var.env_name}${var.env_key}-ipg"
  mul_vnet_kusto_subnet01_ip_group_name      = "${var.region_abbreviation}-mul_vnet${var.resource_version}-${var.env_name}${var.env_key}-kusto-subnet01-ipg"
  mul_vnet_kusto_subnet03_ip_group_name      = "${var.region_abbreviation}-mul_vnet${var.resource_version}-${var.env_name}${var.env_key}-kusto-subnet03-ipg"
  mul_vnet_web_subnet02_ip_group_name      = "${var.region_abbreviation}-mul_vnet${var.resource_version}-${var.env_name}${var.env_key}-web-subnet02-ipg"
  mul_vnet_web_subnet04_ip_group_name      = "${var.region_abbreviation}-mul_vnet${var.resource_version}-${var.env_name}${var.env_key}-web-subnet04-ipg"
  utl_log_analytics_workspace_name         = "ds${var.env_name}${var.env_key}logAnalytics"
  cus_resource_group_name = "AppGrp-cus${var.resource_version}-${var.env_name}${var.env_key}-rg${local.suffix}"
  cus_storage_name        = "${var.region_abbreviation}cus${var.resource_version}func01${substr(var.env_name, 0, 1)}${var.env_key}sa${substr(local.suffix, 1, 4)}"
  cus_cosmosdb_name       = "${var.region_abbreviation}-cus${var.resource_version}-${var.env_name}${var.env_key}-cd${local.suffix}"
  cus_kustodb_name        = "${var.region_abbreviation}-cus${var.resource_version}-${var.env_name}${var.env_key}-ddb${local.suffix}"
  cus_op_storage_name     = "${var.region_abbreviation}cus${var.resource_version}stor01${substr(var.env_name, 0, 1)}${var.env_key}sa${substr(local.suffix, 1, 4)}"


  tag_createdon               = formatdate("YYYY-MM-DD", timestamp())

  config_containers_list = [
    { name = "aiconfig", access_type = "private" },
    { name = "authconfig", access_type = "private" },
    { name = "config", access_type = "private" }
  ]
  ai_containers_list = [
    { name = "datatransmitterconfigandsecrets", access_type = "private" },
    { name = "statuscontainer", access_type = "private" },
    { name = "tempdata", access_type = "private" }
  ]

  op_containers_list = [
    { name = "anomalydata", access_type = "private" },
    { name = "devicelease", access_type = "private" },
    { name = "downloads", access_type = "private" },
    { name = "elm", access_type = "private" },
    { name = "highwatermark", access_type = "private" },
    { name = "logs", access_type = "private" },
    { name = "maestro", access_type = "private" },
    { name = "maestropost", access_type = "private" },
    { name = "maestrotruncs", access_type = "private" },
    { name = "nui", access_type = "private" },
    { name = "pindata", access_type = "private" },
    { name = "procdones", access_type = "private" },
    { name = "procfiles", access_type = "private" },
    { name = "sensordata", access_type = "private" }
  ]

  resource_tags = merge(var.tags,
    var.runtime_tags, {
      "unique_id" = local.random_id
  })
  cus_op_containers_list = [
    { name = "logs", access_type = "private" },
    { name = "cache", access_type = "private" },
    { name = "devicecerts", access_type = "private" },
    { name = "devicelease", access_type = "private" },
    { name = "dexingest", access_type = "private" },
    { name = "dmsupload01", access_type = "private" },
    { name = "elm", access_type = "private" },
    { name = "eventqueue", access_type = "private" },
    { name = "maestro", access_type = "private" },
    { name = "maestropost", access_type = "private" },
    { name = "maestrotruncs", access_type = "private" },
    { name = "nui", access_type = "private" },
    { name = "opfilecomplete", access_type = "private" },
    { name = "partitionleasereq", access_type = "private" },
    { name = "procdones", access_type = "private" },
    { name = "processfolder", access_type = "private" },
    { name = "processgoh", access_type = "private" },
    { name = "processpick", access_type = "private" },
    { name = "procfiles", access_type = "private" },
    { name = "procmessages", access_type = "private" },
    { name = "statistics", access_type = "private" },
    { name = "statuscontainer", access_type = "private" }
  ]


}
