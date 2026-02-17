environment = "qa"

warehouses = [
  {
    name              = "ETL_WH"
    size              = "X-SMALL"
    auto_suspend      = 120
    auto_resume       = true
    min_cluster_count = 1
    max_cluster_count = 1
    comment           = "QA ETL warehouse"
  },
  {
    name              = "ANALYTICS_WH"
    size              = "SMALL"
    auto_suspend      = 300
    auto_resume       = true
    min_cluster_count = 1
    max_cluster_count = 2
    comment           = "QA analytics warehouse"
  },
  {
    name              = "REPORTING_WH"
    size              = "X-SMALL"
    auto_suspend      = 60
    auto_resume       = true
    min_cluster_count = 1
    max_cluster_count = 1
    comment           = "QA reporting warehouse"
  },
]
