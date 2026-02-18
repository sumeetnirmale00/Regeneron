###############################################################################
# Snowflake Databases
###############################################################################

resource "snowflake_database" "this" {
  for_each = local.databases_map

  name                        = each.value.name
  comment                     = each.value.comment
  data_retention_time_in_days = each.value.data_retention_time_in_days

  lifecycle {
    prevent_destroy = true
  }
}

###############################################################################
# Flatten database + schema combinations
###############################################################################

locals {
  databases_map = { for db in var.databases : db.name => db }

  database_schemas = {
    for item in flatten([
      for db in var.databases : [
        for schema in db.schemas : {
          unique_key    = "${db.name}.${schema.name}"
          database_name = db.name
          schema_name   = schema.name
          comment       = schema.comment
        }
      ]
    ]) : item.unique_key => item
  }
}

###############################################################################
# Snowflake Schemas
###############################################################################

resource "snowflake_schema" "this" {
  for_each = local.database_schemas

  database = each.value.database_name
  name     = each.value.schema_name
  comment  = each.value.comment

  lifecycle {
    prevent_destroy = true
  }

  depends_on = [snowflake_database.this]
}
