variable "roles" {
  description = "List of Snowflake account roles to create"
  type = list(object({
    name    = string
    comment = optional(string, "")
  }))
}
