variable "network_policies" {
  description = "List of Snowflake network policies to create"
  type = list(object({
    name             = string
    comment          = optional(string, "")
    allowed_ip_list  = optional(list(string), [])
    blocked_ip_list  = optional(list(string), [])
  }))
  default = []
}
