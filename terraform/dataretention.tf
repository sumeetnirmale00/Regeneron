# =============================================================================
# Data Retention Policy Configuration
# =============================================================================
# Data retention is enforced at the database level with a default of 90 days.
# This is configured in modules/database/variables.tf
#
# To override retention for specific databases, set data_retention_time_in_days
# in the databases variable in terraform.tfvars or your environment config.
# =============================================================================

# This module can be used to apply retention to additional schemas if needed
# module "data_retention" {
#   source = "./modules/data_retention"
#   retention_days = 90
#   databases = [for db in var.databases : db.name]
#   database_schemas = flatten([
#     for db in var.databases : [
#       for schema in db.schemas : {
#         database = db.name
#         schema   = schema.name
#       }
#     ]
#   ])
# }
