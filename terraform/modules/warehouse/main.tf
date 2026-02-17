locals {
  warehouses_map = { for wh in var.warehouses : wh.name => wh }
}

resource "snowflake_warehouse" "this" {
  for_each = local.warehouses_map

  name              = each.value.name
  warehouse_size    = each.value.size
  auto_suspend      = each.value.auto_suspend
  auto_resume       = each.value.auto_resume
  min_cluster_count = each.value.min_cluster_count
  max_cluster_count = each.value.max_cluster_count
  comment           = each.value.comment
}
