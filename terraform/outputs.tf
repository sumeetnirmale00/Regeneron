# =============================================================================
# Root Outputs – Snowflake Infrastructure
# =============================================================================

# -----------------------------------------------------------------------------
# Warehouses
# -----------------------------------------------------------------------------

output "warehouse_names" {
  description = "List of created warehouse names"
  value       = module.warehouses.warehouse_names
}

# -----------------------------------------------------------------------------
# Databases
# -----------------------------------------------------------------------------

output "database_names" {
  description = "List of created database names"
  value       = module.databases.database_names
}

output "schema_names" {
  description = "List of created schema names (DATABASE.SCHEMA)"
  value       = module.databases.schema_names
}

# -----------------------------------------------------------------------------
# Roles
# -----------------------------------------------------------------------------

output "role_names" {
  description = "List of created role names"
  value       = module.roles.role_names
}

# -----------------------------------------------------------------------------
# Users
# -----------------------------------------------------------------------------

output "user_names" {
  description = "List of created user names"
  value       = module.users.user_names
}
