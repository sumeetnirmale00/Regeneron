variable "databases" {
  description = "List of Snowflake databases and their schemas to create"
  type = list(object({
    name                        = string
    comment                     = optional(string, "")
    data_retention_time_in_days = optional(number, 90)
    schemas = optional(list(object({
      name    = string
      comment = optional(string, "")
    })), [])
  }))
}
