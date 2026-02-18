###############################################################################
# Snowflake Network Policies Module
###############################################################################

locals {
  network_policies_map = { for policy in var.network_policies : policy.name => policy }
}

resource "snowflake_network_policy" "this" {
  for_each = local.network_policies_map

  name              = each.value.name
  comment           = each.value.comment
  allowed_ip_list   = each.value.allowed_ip_list
  blocked_ip_list   = each.value.blocked_ip_list

  lifecycle {
    prevent_destroy = true
  }
}
