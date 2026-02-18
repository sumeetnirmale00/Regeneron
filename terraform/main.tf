# =============================================================================
# Root Module – Snowflake Infrastructure
# =============================================================================
# Orchestrates child modules to provision warehouses, databases, roles, users,
# and grants in Snowflake.
# =============================================================================

locals {
  common_tags = {
    environment  = var.environment
    project_name = var.project_name
    managed_by   = "terraform"
  }
}

# -----------------------------------------------------------------------------
# Warehouses
# -----------------------------------------------------------------------------

module "warehouses" {
  source = "./modules/warehouse"

  warehouses = var.warehouses
}

# -----------------------------------------------------------------------------
# Databases & Schemas
# -----------------------------------------------------------------------------

module "databases" {
  source = "./modules/database"

  databases = var.databases
}

# -----------------------------------------------------------------------------
# Roles
# -----------------------------------------------------------------------------

module "roles" {
  source = "./modules/role"

  roles = var.roles
}

# -----------------------------------------------------------------------------
# Users
# -----------------------------------------------------------------------------

module "users" {
  source = "./modules/user"

  users = var.users

  depends_on = [
    module.warehouses,
    module.roles,
  ]
}

# -----------------------------------------------------------------------------
# Network Policies
# -----------------------------------------------------------------------------

module "network_policies" {
  source = "./modules/network_policy"

  network_policies = var.network_policies
}

# -----------------------------------------------------------------------------
# Grants
# -----------------------------------------------------------------------------
# The grants module receives all grant definitions and manages them centrally
# using the v2.x `snowflake_grant_privileges_to_account_role` resource.
# -----------------------------------------------------------------------------

module "grants" {
  source = "./modules/grants"

  warehouse_grants = var.warehouse_grants
  database_grants  = var.database_grants
  schema_grants    = var.schema_grants
  role_grants      = var.role_grants

  depends_on = [
    module.warehouses,
    module.databases,
    module.roles,
    module.users,
    module.network_policies,
  ]
}
