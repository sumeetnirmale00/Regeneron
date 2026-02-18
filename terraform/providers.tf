# =============================================================================
# Terraform & Provider Configuration
# =============================================================================

terraform {
  required_version = ">= 1.6.0"

  required_providers {
    snowflake = {
      source  = "snowflakedb/snowflake"
      version = ">= 0.88.0"
    }
  }
}

provider "snowflake" {
  account       = var.snowflake_account
  user          = var.snowflake_user
  role          = var.snowflake_role
  authenticator = var.snowflake_authenticator
}
