output "retention_days" {
  description = "Number of retention days configured"
  value       = var.retention_days
}

output "databases_updated" {
  description = "List of databases with retention policy applied"
  value       = [for db in snowflake_database.retention : db.name]
}

output "schemas_updated" {
  description = "List of schemas with retention policy applied"
  value       = [for key, schema in snowflake_schema.retention : key]
}

output "tables_updated" {
  description = "List of tables with retention policy applied"
  value       = [for key, table in snowflake_table.retention : key]
}
