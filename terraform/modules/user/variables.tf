variable "users" {
  description = "List of Snowflake users to create"
  type = list(object({
    name                 = string
    login_name           = string
    email                = optional(string, "")
    default_warehouse    = optional(string, "")
    default_role         = optional(string, "")
    must_change_password = optional(bool, true)
    comment              = optional(string, "")
  }))
}
