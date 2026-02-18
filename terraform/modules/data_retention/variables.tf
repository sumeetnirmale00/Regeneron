variable "retention_days" {
  description = "Number of days to retain data (default: 90)"
  type        = number
  default     = 90
}

variable "databases" {
  description = "List of database names to apply retention policy"
  type        = list(string)
  default     = []
}

variable "database_schemas" {
  description = "List of database schemas to apply retention policy"
  type = list(object({
    database = string
    schema   = string
  }))
  default = []
}


