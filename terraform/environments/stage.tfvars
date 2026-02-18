environment = "stage"

# =============================================================================
# Databases - REGN_GD_DB_TEST (QA+UAT)
# =============================================================================
databases = [
  {
    name                        = "REGN_GD_DB_TEST"
    comment                     = "Database for environment TEST (QA+UAT)"
    data_retention_time_in_days = 90
    schemas = [
      { name = "REGN_GD_SCH_RAW",  comment = "Schema for Raw data" },
      { name = "REGN_GD_SCH_STG",  comment = "Schema for cleansed and standardized data" },
      { name = "REGN_GD_SCH_STD",  comment = "Schema used for temporary tables for intermediate cleansing" },
      { name = "REGN_GD_SCH_PUB",  comment = "Schema for Publish data" },
      { name = "REGN_GD_SCH_ERR",  comment = "Schema for Error details" },
    ]
  },
]

# =============================================================================
# Warehouses - REGN_GD_WH_STAGE_<PURPOSE>
# =============================================================================
warehouses = [
  {
    name              = "REGN_GD_WH_STAGE_ETL"
    size              = "SMALL"
    auto_suspend      = 120
    auto_resume       = true
    min_cluster_count = 1
    max_cluster_count = 2
    comment           = "Warehouse for environment STAGE with purpose for ETL jobs"
  },
  {
    name              = "REGN_GD_WH_STAGE_USR"
    size              = "SMALL"
    auto_suspend      = 300
    auto_resume       = true
    min_cluster_count = 1
    max_cluster_count = 2
    comment           = "Warehouse for environment STAGE with purpose for Data management users and analytics users"
  },
  {
    name              = "REGN_GD_WH_STAGE_REPORTING"
    size              = "X-SMALL"
    auto_suspend      = 60
    auto_resume       = true
    min_cluster_count = 1
    max_cluster_count = 1
    comment           = "Warehouse for environment STAGE with purpose for Reporting and other Tools"
  },
]

# =============================================================================
# Roles - REGN_GD_ROL_<TYPE>
# =============================================================================
roles = [
  {
    name    = "REGN_GD_ROL_ADMIN"
    comment = "Roles for Admin users who will manage the Snowflake Platform across environments"
  },
  {
    name    = "REGN_GD_ROL_DEV"
    comment = "Roles for development team have read and write in DEV but Read only in QA, UAT & PROD"
  },
  {
    name    = "REGN_GD_ROL_QA"
    comment = "Roles for QA team have read and write in DEV & QA but Read only in PROD"
  },
  {
    name    = "REGN_GD_ROL_ETL"
    comment = "Role for ETL Pipeline for running Data Pipelines, common for all environment"
  },
  {
    name    = "REGN_GD_ROL_POWERBI"
    comment = "Roles specific to Power BI with read only access to specific tables and schema"
  },
  {
    name    = "REGN_GD_ROL_TABLEAU"
    comment = "Roles specific to Tableau with read only access to specific tables and schema"
  },
]

# =============================================================================
# Users (Service accounts and manual users)
# =============================================================================
# Users are typically created manually as per the requirements

# =============================================================================
# Network Policies
# =============================================================================
network_policies = []
