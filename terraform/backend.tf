# =============================================================================
# Terraform Backend Configuration
# =============================================================================
# This backend stores Terraform state remotely in an S3 bucket with DynamoDB
# state locking. Uncomment and configure the block below before running
# `terraform init`.
#
# Prerequisites:
#   1. Create an S3 bucket for state storage (enable versioning).
#   2. Create a DynamoDB table with a partition key named "LockID" (String).
#   3. Ensure the executing IAM principal has permissions for both resources.
#
# Usage:
#   terraform init \
#     -backend-config="bucket=<your-bucket>" \
#     -backend-config="key=snowflake-infra/${TF_VAR_environment}/terraform.tfstate" \
#     -backend-config="region=<your-region>" \
#     -backend-config="dynamodb_table=<your-lock-table>"
# =============================================================================

# terraform {
#   backend "s3" {
#     bucket         = "your-terraform-state-bucket"
#     key            = "snowflake/${var.environment}/terraform.tfstate"
#     region         = "us-east-1"
#     encrypt        = true
#     dynamodb_table = "terraform-state-lock"
#   }
# }
