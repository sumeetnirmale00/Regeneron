locals {
  roles_map = { for role in var.roles : role.name => role }
}

resource "snowflake_account_role" "this" {
  for_each = local.roles_map

  name    = each.value.name
  comment = each.value.comment

  lifecycle {
    prevent_destroy = true
  }
}
