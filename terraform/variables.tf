# =============================================================================
# Root Variables – Snowflake Infrastructure
# =============================================================================

# -----------------------------------------------------------------------------
# Provider / Connection
# -----------------------------------------------------------------------------

variable "snowflake_account" {
  description = "Snowflake account identifier"
  type        = string
}

variable "snowflake_user" {
  description = "Snowflake user for authentication"
  type        = string
}

variable "snowflake_role" {
  description = "Snowflake role used by Terraform"
  type        = string
  default     = "SYSADMIN"
}

variable "snowflake_authenticator" {
  description = "Authentication method (SNOWFLAKE_JWT, SNOWFLAKE, EXTERNALBROWSER)"
  type        = string
  default     = "SNOWFLAKE_JWT"
}

# -----------------------------------------------------------------------------
# Project Metadata
# -----------------------------------------------------------------------------

variable "environment" {
  description = "Deployment environment (prod, qa, stage)"
  type        = string

  validation {
    condition     = contains(["prod", "qa", "stage"], var.environment)
    error_message = "Environment must be one of: prod, qa, stage."
  }
}

variable "project_name" {
  description = "Project name used for tagging and naming"
  type        = string
  default     = "snowflake-infra"
}

# -----------------------------------------------------------------------------
# Warehouses
# -----------------------------------------------------------------------------

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
  default = []

  validation {
    condition = alltrue([
      for wh in var.warehouses :
      contains(["XSMALL", "X-SMALL", "SMALL", "MEDIUM", "LARGE", "XLARGE", "X-LARGE", "XXLARGE", "X2LARGE", "XXXLARGE", "X3LARGE", "X4LARGE"], upper(wh.size))
    ])
    error_message = "Warehouse size must be a valid Snowflake warehouse size."
  }
}

# -----------------------------------------------------------------------------
# Databases & Schemas
# -----------------------------------------------------------------------------

variable "databases" {
  description = "List of Snowflake databases and their schemas to create"
  type = list(object({
    name                        = string
    comment                     = optional(string, "")
    data_retention_time_in_days = optional(number, 1)
    schemas = optional(list(object({
      name    = string
      comment = optional(string, "")
    })), [])
  }))
  default = []
}

# -----------------------------------------------------------------------------
# Roles
# -----------------------------------------------------------------------------

variable "roles" {
  description = "List of Snowflake account roles to create"
  type = list(object({
    name    = string
    comment = optional(string, "")
  }))
  default = []
}

# -----------------------------------------------------------------------------
# Users
# -----------------------------------------------------------------------------

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
  default = []
}

# -----------------------------------------------------------------------------
# Grants – Warehouse
# -----------------------------------------------------------------------------

variable "warehouse_grants" {
  description = "List of warehouse privilege grants to account roles"
  type = list(object({
    role_name      = string
    warehouse_name = string
    privileges     = list(string)
  }))
  default = []
}

# -----------------------------------------------------------------------------
# Grants – Database
# -----------------------------------------------------------------------------

variable "database_grants" {
  description = "List of database privilege grants to account roles"
  type = list(object({
    role_name     = string
    database_name = string
    privileges    = list(string)
  }))
  default = []
}

# -----------------------------------------------------------------------------
# Grants – Schema
# -----------------------------------------------------------------------------

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

# -----------------------------------------------------------------------------
# Grants – Role Hierarchy
# -----------------------------------------------------------------------------

variable "role_grants" {
  description = "List of role hierarchy grants (child role granted to parent role)"
  type = list(object({
    role_name        = string
    parent_role_name = string
  }))
  default = []
}
