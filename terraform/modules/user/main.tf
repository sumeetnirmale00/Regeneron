locals {
  users_map = { for user in var.users : user.name => user }
}

resource "snowflake_user" "this" {
  for_each = local.users_map

  name                 = each.value.name
  login_name           = each.value.login_name
  email                = each.value.email
  default_warehouse    = each.value.default_warehouse
  default_role         = each.value.default_role
  must_change_password = each.value.must_change_password
  comment              = each.value.comment
}
