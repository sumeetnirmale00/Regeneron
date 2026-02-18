# =============================================================================
# Random/Dummy Values for Terraform Plan
# =============================================================================

# Provider / Connection
snowflake_account    = "random-account-12345"
snowflake_user       = "terraform_service_account"
snowflake_role       = "SYSADMIN"
snowflake_authenticator = "SNOWFLAKE_JWT"

# Project Metadata
environment  = "dev"
project_name = "snowflake-infra-demo"

# =============================================================================
# Warehouses - Random sizes and settings
# =============================================================================
warehouses = [
  {
    name              = "ETL_WH_DEV"
    size              = "X-SMALL"
    auto_suspend      = 180
    auto_resume       = true
    min_cluster_count = 1
    max_cluster_count = 2
    comment           = "ETL warehouse for data loading"
  },
  {
    name              = "ANALYTICS_WH_DEV"
    size              = "SMALL"
    auto_suspend      = 300
    auto_resume       = true
    min_cluster_count = 1
    max_cluster_count = 3
    comment           = "Analytics warehouse for reporting"
  },
  {
    name              = "DATA_SCIENCE_WH_DEV"
    size              = "MEDIUM"
    auto_suspend      = 600
    auto_resume       = true
    min_cluster_count = 1
    max_cluster_count = 2
    comment           = "Data science ML workloads"
  },
]

# =============================================================================
# Databases & Schemas
# =============================================================================
databases = [
  {
    name                        = "RAW_DB_DEV"
    comment                     = "Raw data landing zone"
    data_retention_time_in_days = 7
    schemas = [
      { name = "KAFKA_SCHEMA",  comment = "Kafka streaming data" },
      { name = "API_SCHEMA",    comment = "API ingested data" },
    ]
  },
  {
    name                        = "STAGE_DB_DEV"
    comment                     = "Staging/transformed data"
    data_retention_time_in_days = 14
    schemas = [
      { name = "CLEANSED",  comment = "Cleansed data" },
      { name = "ENRICHED",  comment = "Enriched data" },
    ]
  },
  {
    name                        = "ANALYTICS_DB_DEV"
    comment                     = "Analytics data warehouse"
    data_retention_time_in_days = 30
    schemas = [
      { name = "AGGREGATES",  comment = "Pre-computed aggregates" },
      { name = "MARTS",       comment = "Business marts" },
    ]
  },
]

# =============================================================================
# Roles
# =============================================================================
roles = [
  {
    name    = "DEV_ADMIN_ROLE"
    comment = "Development administrator"
  },
  {
    name    = "DEV_ENGINEER_ROLE"
    comment = "Data engineer role"
  },
  {
    name    = "DEV_ANALYST_ROLE"
    comment = "Business analyst role"
  },
  {
    name    = "DEV_SCIENTIST_ROLE"
    comment = "Data scientist role"
  },
]

# =============================================================================
# Users
# =============================================================================
users = [
  {
    name                 = "DEV_ETL_USER"
    login_name           = "dev_etl_svc"
    email                = "dev-etl@companydemo.com"
    default_warehouse    = "ETL_WH_DEV"
    default_role         = "DEV_ENGINEER_ROLE"
    must_change_password = false
    comment              = "ETL service account for dev"
  },
  {
    name                 = "DEV_ANALYST_USER"
    login_name           = "dev_analyst"
    email                = "analyst@companydemo.com"
    default_warehouse    = "ANALYTICS_WH_DEV"
    default_role         = "DEV_ANALYST_ROLE"
    must_change_password = true
    comment              = "Business analyst user"
  },
]

# =============================================================================
# Warehouse Grants
# =============================================================================
warehouse_grants = [
  {
    role_name      = "DEV_ENGINEER_ROLE"
    warehouse_name = "ETL_WH_DEV"
    privileges     = ["OPERATE", "USAGE"]
  },
  {
    role_name      = "DEV_ANALYST_ROLE"
    warehouse_name = "ANALYTICS_WH_DEV"
    privileges     = ["USAGE"]
  },
]

# =============================================================================
# Database Grants
# =============================================================================
database_grants = [
  {
    role_name     = "DEV_ENGINEER_ROLE"
    database_name = "RAW_DB_DEV"
    privileges    = ["CREATE SCHEMA", "USAGE", "MONITOR"]
  },
  {
    role_name     = "DEV_ANALYST_ROLE"
    database_name = "ANALYTICS_DB_DEV"
    privileges    = ["USAGE"]
  },
]

# =============================================================================
# Schema Grants
# =============================================================================
schema_grants = [
  {
    role_name     = "DEV_ENGINEER_ROLE"
    database_name = "RAW_DB_DEV"
    schema_name   = "KAFKA_SCHEMA"
    privileges    = ["CREATE TABLE", "CREATE VIEW", "USAGE"]
  },
  {
    role_name     = "DEV_ANALYST_ROLE"
    database_name = "ANALYTICS_DB_DEV"
    schema_name   = "MARTS"
    privileges    = ["USAGE", "SELECT"]
  },
]

# =============================================================================
# Role Hierarchy Grants
# =============================================================================
role_grants = [
  {
    role_name        = "DEV_ENGINEER_ROLE"
    parent_role_name = "SYSADMIN"
  },
  {
    role_name        = "DEV_ANALYST_ROLE"
    parent_role_name = "SYSADMIN"
  },
]

# =============================================================================
# Network Policies (Empty for dev)
# =============================================================================
network_policies = []
