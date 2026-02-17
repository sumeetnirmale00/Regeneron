###############################################################################
# Snowflake Grants Module – Variables
# Uses snowflake_grant_privileges_to_account_role (provider v2.x)
###############################################################################

variable "warehouse_grants" {
  description = "List of warehouse privilege grants to account roles"
  type = list(object({
    role_name      = string
    warehouse_name = string
    privileges     = list(string)
  }))
  default = []
}

variable "database_grants" {
  description = "List of database privilege grants to account roles"
  type = list(object({
    role_name     = string
    database_name = string
    privileges    = list(string)
  }))
  default = []
}

variable "schema_grants" {
  description = "List of schema privilege grants to account roles"
  type = list(object({
    role_name     = string
    database_name = string
    schema_name   = string
    privileges    = list(string)
  }))
  default = []
}

variable "role_grants" {
  description = "List of role hierarchy grants (child role granted to parent role)"
  type = list(object({
    role_name        = string
    parent_role_name = string
  }))
  default = []
}
