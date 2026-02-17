environment = "prod"

warehouses = [
  {
    name              = "ETL_WH"
    size              = "MEDIUM"
    auto_suspend      = 120
    auto_resume       = true
    min_cluster_count = 1
    max_cluster_count = 3
    comment           = "Production ETL warehouse"
  },
  {
    name              = "ANALYTICS_WH"
    size              = "LARGE"
    auto_suspend      = 300
    auto_resume       = true
    min_cluster_count = 1
    max_cluster_count = 4
    comment           = "Production analytics warehouse"
  },
  {
    name              = "REPORTING_WH"
    size              = "SMALL"
    auto_suspend      = 60
    auto_resume       = true
    min_cluster_count = 1
    max_cluster_count = 2
    comment           = "Production reporting warehouse"
  },
]
