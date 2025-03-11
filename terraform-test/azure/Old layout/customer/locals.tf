resource "random_id" "id" {
  count       = var.random_id == null && var.use_random_id ? 1 : 0
  byte_length = 2
}

locals {
  random_id           = var.random_id == null && var.use_random_id ? random_id.id[0].hex : var.random_id
  suffix              = local.random_id == null || !var.use_random_id ? "" : "-${local.random_id}"
  resource_group_name = "AppGrp-cus${var.resource_version}-${var.env_name}${var.env_key}-rg${local.suffix}"
  mul_resource_group_name = "AppGrp-mul${var.resource_version}-${var.env_name}${var.env_key}-rg${local.suffix}"
  vnet_name           = "${var.region_abbreviation}-cus${var.resource_version}-${var.env_name}${var.env_key}-vnet${local.suffix}"
  storage_name        = "${var.region_abbreviation}cus${var.resource_version}func01${substr(var.env_name, 0, 1)}${var.env_key}sa${substr(local.suffix, 1, 4)}"
  cosmosdb_name       = "${var.region_abbreviation}-cus${var.resource_version}-${var.env_name}${var.env_key}-cd${local.suffix}"
  kustodb_name        = "${var.region_abbreviation}-cus${var.resource_version}-${var.env_name}${var.env_key}-ddb${local.suffix}"
  op_storage_name     = "${var.region_abbreviation}cus${var.resource_version}stor01${substr(var.env_name, 0, 1)}${var.env_key}sa${substr(local.suffix, 1, 4)}"
  tag_createdon       = formatdate("YYYY-MM-DD", timestamp())

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

  resource_tags = merge(var.tags,
    var.runtime_tags, {
      "unique_id" = local.random_id
  })
}
