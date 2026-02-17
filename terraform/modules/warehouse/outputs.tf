output "warehouse_names" {
  description = "List of created warehouse names"
  value       = [for wh in snowflake_warehouse.this : wh.name]
}

output "warehouses" {
  description = "Map of warehouse details keyed by name"
  value = {
    for key, wh in snowflake_warehouse.this : key => {
      name                = wh.name
      fully_qualified_name = wh.fully_qualified_name
    }
  }
}
