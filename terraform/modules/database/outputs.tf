###############################################################################
# Outputs
###############################################################################

output "database_names" {
  description = "List of created database names"
  value       = [for db in snowflake_database.this : db.name]
}

output "databases" {
  description = "Map of database details keyed by name"
  value = {
    for key, db in snowflake_database.this : key => {
      name                        = db.name
      comment                     = db.comment
      data_retention_time_in_days = db.data_retention_time_in_days
    }
  }
}

output "schema_names" {
  description = "List of fully qualified schema names (DATABASE.SCHEMA)"
  value       = [for key, schema in snowflake_schema.this : key]
}
