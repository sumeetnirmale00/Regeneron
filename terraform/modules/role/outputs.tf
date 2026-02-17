output "role_names" {
  description = "List of created role names"
  value       = [for role in snowflake_account_role.this : role.name]
}

output "roles" {
  description = "Map of role details keyed by name"
  value = {
    for key, role in snowflake_account_role.this : key => {
      name    = role.name
      comment = role.comment
    }
  }
}
