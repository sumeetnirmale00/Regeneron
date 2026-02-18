###############################################################################
# Snowflake Data Retention Policy Module
# Updates data retention time for existing databases, schemas, and tables to 90 days
###############################################################################

locals {
  retention_days = var.retention_days
}

# -----------------------------------------------------------------------------
# Update database retention
# -----------------------------------------------------------------------------

resource "snowflake_database" "retention" {
  for_each = toset(var.databases)

  name                        = each.value
  data_retention_time_in_days = local.retention_days
}

# -----------------------------------------------------------------------------
# Update schema retention
# -----------------------------------------------------------------------------

resource "snowflake_schema" "retention" {
  for_each = { for s in var.database_schemas : "${s.database}.${s.schema}" => s }

  database                  = each.value.database
  name                      = each.value.schema
  data_retention_time_in_days = local.retention_days

  depends_on = [snowflake_database.retention]
}

# -----------------------------------------------------------------------------
# Table Data Retention
# -----------------------------------------------------------------------------
locals {
  table_list = [
    for t in var.tables : {
      database = t.database
      schema   = t.schema
      table    = t.table
    }
  ]
}

resource "snowflake_table" "retention" {
  for_each = { for idx, t in local.table_list : "${t.database}.${t.schema}.${t.table}" => t }

  database   = each.value.database
  schema     = each.value.schema
  name       = each.value.table
  data_retention_time_in_days = local.retention_days
  comment    = "Data retention set to ${local.retention_days} days"

  lifecycle {
    ignore_changes = [comment]
  }

  depends_on = [snowflake_schema.retention]
}
