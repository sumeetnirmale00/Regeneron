output "network_policy_names" {
  description = "List of created network policy names"
  value       = [for policy in snowflake_network_policy.this : policy.name]
}

output "network_policies" {
  description = "Map of network policy details keyed by name"
  value = {
    for key, policy in snowflake_network_policy.this : key => {
      name = policy.name
      comment = policy.comment
    }
  }
}
