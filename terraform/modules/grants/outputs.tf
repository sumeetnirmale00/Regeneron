###############################################################################
# Snowflake Grants Module – Outputs
###############################################################################

output "warehouse_grant_ids" {
  description = "Map of warehouse grant resource IDs"
  value = {
    for key, grant in snowflake_grant_privileges_to_account_role.warehouse : key => grant.id
  }
}

output "database_grant_ids" {
  description = "Map of database grant resource IDs"
  value = {
    for key, grant in snowflake_grant_privileges_to_account_role.database : key => grant.id
  }
}

output "schema_grant_ids" {
  description = "Map of schema grant resource IDs"
  value = {
    for key, grant in snowflake_grant_privileges_to_account_role.schema : key => grant.id
  }
}

output "role_hierarchy_grant_ids" {
  description = "Map of role hierarchy grant resource IDs"
  value = {
    for key, grant in snowflake_grant_account_role.hierarchy : key => grant.id
  }
}
