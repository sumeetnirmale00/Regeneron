# =============================================================================
# Demo Terraform Variables – Snowflake Infrastructure
# =============================================================================

# -----------------------------------------------------------------------------
# Provider / Connection
# -----------------------------------------------------------------------------

snowflake_account       = "rc67432.us-east-1"
snowflake_user          = "TF_DEPLOY_SVC"
snowflake_role          = "SYSADMIN"
snowflake_authenticator = "SNOWFLAKE_JWT"

# -----------------------------------------------------------------------------
# Project Metadata
# -----------------------------------------------------------------------------

environment  = "prod"
project_name = "regeneron-data-platform"

# -----------------------------------------------------------------------------
# Warehouses
# -----------------------------------------------------------------------------

warehouses = [
  {
    name              = "ETL_WH"
    size              = "MEDIUM"
    auto_suspend      = 120
    auto_resume       = true
    min_cluster_count = 1
    max_cluster_count = 3
    comment           = "Warehouse for ETL/ELT data ingestion workloads"
  },
  {
    name              = "ANALYTICS_WH"
    size              = "LARGE"
    auto_suspend      = 300
    auto_resume       = true
    min_cluster_count = 1
    max_cluster_count = 4
    comment           = "Warehouse for analyst and BI tool queries"
  },
  {
    name              = "REPORTING_WH"
    size              = "SMALL"
    auto_suspend      = 60
    auto_resume       = true
    min_cluster_count = 1
    max_cluster_count = 2
    comment           = "Warehouse for scheduled reporting jobs"
  },
  {
    name              = "DATA_SCIENCE_WH"
    size              = "XLARGE"
    auto_suspend      = 600
    auto_resume       = true
    min_cluster_count = 1
    max_cluster_count = 2
    comment           = "Warehouse for data science and ML workloads"
  },
]

# -----------------------------------------------------------------------------
# Databases & Schemas
# -----------------------------------------------------------------------------

databases = [
  {
    name                        = "RAW_DB"
    comment                     = "Landing zone for raw ingested data"
    data_retention_time_in_days = 7
    schemas = [
      { name = "SALESFORCE", comment = "Salesforce CRM raw data" },
      { name = "SAP",        comment = "SAP ERP raw data" },
      { name = "KAFKA",      comment = "Kafka streaming raw events" },
    ]
  },
  {
    name                        = "ANALYTICS_DB"
    comment                     = "Curated analytics and reporting data"
    data_retention_time_in_days = 14
    schemas = [
      { name = "STAGING",    comment = "Intermediate staging tables" },
      { name = "MARTS",      comment = "Business-level data marts" },
      { name = "AGGREGATES", comment = "Pre-computed aggregate tables" },
    ]
  },
  {
    name                        = "DATA_SCIENCE_DB"
    comment                     = "Sandbox for data science experiments"
    data_retention_time_in_days = 3
    schemas = [
      { name = "FEATURES",   comment = "Feature store for ML models" },
      { name = "EXPERIMENTS", comment = "Experiment tracking data" },
    ]
  },
]

# -----------------------------------------------------------------------------
# Roles
# -----------------------------------------------------------------------------
#
#   SYSADMIN (built-in)
#     ├── DATA_ENGINEER
#     │     └── ETL_SERVICE_ROLE
#     ├── DATA_ANALYST
#     └── DATA_SCIENTIST
#
# -----------------------------------------------------------------------------

roles = [
  { name = "DATA_ENGINEER",    comment = "Role for data engineering team" },
  { name = "ETL_SERVICE_ROLE",  comment = "Service account role for ETL pipelines" },
  { name = "DATA_ANALYST",      comment = "Role for business analysts and BI users" },
  { name = "DATA_SCIENTIST",    comment = "Role for data science team" },
]

# -----------------------------------------------------------------------------
# Users
# -----------------------------------------------------------------------------

users = [
  {
    name                 = "ETL_SERVICE_USER"
    login_name           = "etl_svc"
    email                = "etl-service@regeneron-demo.com"
    default_warehouse    = "ETL_WH"
    default_role         = "ETL_SERVICE_ROLE"
    must_change_password = false
    comment              = "Service account for automated ETL pipelines"
  },
  {
    name                 = "JOHN_SMITH"
    login_name           = "jsmith"
    email                = "john.smith@regeneron-demo.com"
    default_warehouse    = "ANALYTICS_WH"
    default_role         = "DATA_ANALYST"
    must_change_password = true
    comment              = "Business analyst – Commercial Analytics"
  },
  {
    name                 = "SARAH_CHEN"
    login_name           = "schen"
    email                = "sarah.chen@regeneron-demo.com"
    default_warehouse    = "DATA_SCIENCE_WH"
    default_role         = "DATA_SCIENTIST"
    must_change_password = true
    comment              = "Senior data scientist – R&D"
  },
]

# -----------------------------------------------------------------------------
# Grants – Warehouses
# -----------------------------------------------------------------------------

warehouse_grants = [
  { role_name = "DATA_ENGINEER",    warehouse_name = "ETL_WH",          privileges = ["USAGE", "OPERATE", "MONITOR"] },
  { role_name = "ETL_SERVICE_ROLE",  warehouse_name = "ETL_WH",          privileges = ["USAGE", "OPERATE"] },
  { role_name = "DATA_ANALYST",      warehouse_name = "ANALYTICS_WH",    privileges = ["USAGE"] },
  { role_name = "DATA_ANALYST",      warehouse_name = "REPORTING_WH",    privileges = ["USAGE"] },
  { role_name = "DATA_SCIENTIST",    warehouse_name = "DATA_SCIENCE_WH", privileges = ["USAGE", "OPERATE", "MONITOR"] },
  { role_name = "DATA_SCIENTIST",    warehouse_name = "ANALYTICS_WH",    privileges = ["USAGE"] },
]

# -----------------------------------------------------------------------------
# Grants – Databases
# -----------------------------------------------------------------------------

database_grants = [
  { role_name = "DATA_ENGINEER",    database_name = "RAW_DB",          privileges = ["USAGE", "CREATE SCHEMA", "MONITOR"] },
  { role_name = "DATA_ENGINEER",    database_name = "ANALYTICS_DB",    privileges = ["USAGE", "CREATE SCHEMA", "MONITOR"] },
  { role_name = "ETL_SERVICE_ROLE",  database_name = "RAW_DB",          privileges = ["USAGE"] },
  { role_name = "ETL_SERVICE_ROLE",  database_name = "ANALYTICS_DB",    privileges = ["USAGE"] },
  { role_name = "DATA_ANALYST",      database_name = "ANALYTICS_DB",    privileges = ["USAGE"] },
  { role_name = "DATA_SCIENTIST",    database_name = "ANALYTICS_DB",    privileges = ["USAGE"] },
  { role_name = "DATA_SCIENTIST",    database_name = "DATA_SCIENCE_DB", privileges = ["USAGE", "CREATE SCHEMA", "MONITOR"] },
]

# -----------------------------------------------------------------------------
# Grants – Schemas
# -----------------------------------------------------------------------------

schema_grants = [
  { role_name = "ETL_SERVICE_ROLE", database_name = "RAW_DB",       schema_name = "SALESFORCE", privileges = ["USAGE", "CREATE TABLE", "CREATE VIEW"] },
  { role_name = "ETL_SERVICE_ROLE", database_name = "RAW_DB",       schema_name = "SAP",        privileges = ["USAGE", "CREATE TABLE", "CREATE VIEW"] },
  { role_name = "ETL_SERVICE_ROLE", database_name = "RAW_DB",       schema_name = "KAFKA",      privileges = ["USAGE", "CREATE TABLE", "CREATE VIEW"] },
  { role_name = "ETL_SERVICE_ROLE", database_name = "ANALYTICS_DB", schema_name = "STAGING",    privileges = ["USAGE", "CREATE TABLE", "CREATE VIEW"] },
  { role_name = "DATA_ANALYST",     database_name = "ANALYTICS_DB", schema_name = "MARTS",      privileges = ["USAGE"] },
  { role_name = "DATA_ANALYST",     database_name = "ANALYTICS_DB", schema_name = "AGGREGATES", privileges = ["USAGE"] },
  { role_name = "DATA_SCIENTIST",   database_name = "DATA_SCIENCE_DB", schema_name = "FEATURES",   privileges = ["USAGE", "CREATE TABLE", "CREATE VIEW"] },
  { role_name = "DATA_SCIENTIST",   database_name = "DATA_SCIENCE_DB", schema_name = "EXPERIMENTS", privileges = ["USAGE", "CREATE TABLE", "CREATE VIEW"] },
]

# -----------------------------------------------------------------------------
# Grants – Role Hierarchy
# -----------------------------------------------------------------------------

role_grants = [
  { role_name = "DATA_ENGINEER",    parent_role_name = "SYSADMIN" },
  { role_name = "ETL_SERVICE_ROLE",  parent_role_name = "DATA_ENGINEER" },
  { role_name = "DATA_ANALYST",      parent_role_name = "SYSADMIN" },
  { role_name = "DATA_SCIENTIST",    parent_role_name = "SYSADMIN" },
]
