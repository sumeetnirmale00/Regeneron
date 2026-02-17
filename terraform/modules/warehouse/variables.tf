variable "warehouses" {
  description = "List of Snowflake warehouses to create"
  type = list(object({
    name              = string
    size              = string
    auto_suspend      = optional(number, 300)
    auto_resume       = optional(bool, true)
    min_cluster_count = optional(number, 1)
    max_cluster_count = optional(number, 1)
    comment           = optional(string, "")
  }))
}
