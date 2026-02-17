output "user_names" {
  description = "List of created user names"
  value       = [for user in snowflake_user.this : user.name]
}

output "users" {
  description = "Map of user details keyed by name"
  value = {
    for key, user in snowflake_user.this : key => {
      name       = user.name
      login_name = user.login_name
    }
  }
}
