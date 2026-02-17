###############################################################################
# Snowflake Grants Module – Main
# Uses snowflake_grant_privileges_to_account_role (provider v2.x)
###############################################################################

# ---------------------------------------------------------------------------
# Locals – build unique keys for each grant combination
# ---------------------------------------------------------------------------
locals {
  warehouse_grants_map = {
    for grant in var.warehouse_grants :
    "${grant.role_name}_${grant.warehouse_name}" => grant
  }

  database_grants_map = {
    for grant in var.database_grants :
    "${grant.role_name}_${grant.database_name}" => grant
  }

  schema_grants_map = {
    for grant in var.schema_grants :
    "${grant.role_name}_${grant.database_name}_${grant.schema_name}" => grant
  }

  role_grants_map = {
    for grant in var.role_grants :
    "${grant.role_name}_${grant.parent_role_name}" => grant
  }
}

# ---------------------------------------------------------------------------
# Warehouse Grants
# ---------------------------------------------------------------------------
resource "snowflake_grant_privileges_to_account_role" "warehouse" {
  for_each = local.warehouse_grants_map

  account_role_name = each.value.role_name
  privileges        = each.value.privileges

  on_account_object {
    object_type = "WAREHOUSE"
    object_name = each.value.warehouse_name
  }
}

# ---------------------------------------------------------------------------
# Database Grants
# ---------------------------------------------------------------------------
resource "snowflake_grant_privileges_to_account_role" "database" {
  for_each = local.database_grants_map

  account_role_name = each.value.role_name
  privileges        = each.value.privileges

  on_account_object {
    object_type = "DATABASE"
    object_name = each.value.database_name
  }
}

# ---------------------------------------------------------------------------
# Schema Grants
# ---------------------------------------------------------------------------
resource "snowflake_grant_privileges_to_account_role" "schema" {
  for_each = local.schema_grants_map

  account_role_name = each.value.role_name
  privileges        = each.value.privileges

  on_schema {
    schema_name = "\"${each.value.database_name}\".\"${each.value.schema_name}\""
  }
}

# ---------------------------------------------------------------------------
# Role Hierarchy Grants  (grant child role → parent role)
# ---------------------------------------------------------------------------
resource "snowflake_grant_account_role" "hierarchy" {
  for_each = local.role_grants_map

  role_name        = each.value.role_name
  parent_role_name = each.value.parent_role_name
}
