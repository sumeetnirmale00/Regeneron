# Snowflake Infrastructure – Terraform Documentation

This document provides a comprehensive overview of the Terraform-managed Snowflake infrastructure, including architecture, module descriptions, inputs, outputs, lifecycle policies, and operational guidance.

---

## Table of Contents

1. [Architecture Overview](#architecture-overview)
2. [Project Structure](#project-structure)
3. [Provider Configuration](#provider-configuration)
4. [Backend Configuration](#backend-configuration)
5. [Modules](#modules)
   - [Warehouse Module](#warehouse-module)
   - [Database Module](#database-module)
   - [Role Module](#role-module)
   - [User Module](#user-module)
   - [Grants Module](#grants-module)
6. [Lifecycle Policies](#lifecycle-policies)
7. [Environments](#environments)
8. [Dependency Graph](#dependency-graph)
9. [Usage](#usage)

---

## Architecture Overview

This project provisions and manages a complete Snowflake data platform environment using Terraform. The infrastructure is organized into five core modules that handle compute (warehouses), storage (databases & schemas), access control (roles, users, and grants). All resources are managed through a single root module (`main.tf`) that orchestrates the child modules with explicit dependency ordering.

```
┌─────────────────────────────────────────────────────┐
│                   Root Module                       │
│                   (main.tf)                         │
├──────────┬──────────┬─────────┬──────────┬──────────┤
│Warehouses│Databases │  Roles  │  Users   │  Grants  │
│          │& Schemas │         │          │          │
└──────────┴──────────┴─────────┴──────────┴──────────┘
       │          │         │        │           │
       │          │         │        │           │
       ▼          ▼         ▼        ▼           ▼
   Snowflake  Snowflake  Snowflake Snowflake  Snowflake
   Warehouse  Database   Account   User       Grant
   Resources  + Schema   Roles     Resources  Privileges
              Resources
```

---

## Project Structure

```
terraform/
├── main.tf                        # Root module – orchestrates all child modules
├── variables.tf                   # Root-level input variables
├── outputs.tf                     # Root-level outputs
├── providers.tf                   # Terraform & Snowflake provider configuration
├── backend.tf                     # Remote state backend configuration (S3 + DynamoDB)
├── terraform.tfvars               # Default variable values
├── infra.md                       # This documentation file
├── environments/
│   ├── prod.tfvars                # Production environment variables
│   ├── qa.tfvars                  # QA environment variables
│   └── stage.tfvars               # Staging environment variables
└── modules/
    ├── warehouse/                 # Snowflake warehouse provisioning
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    ├── database/                  # Snowflake database & schema provisioning
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    ├── role/                      # Snowflake account role provisioning
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    ├── user/                      # Snowflake user provisioning
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    └── grants/                    # Snowflake privilege & role hierarchy grants
        ├── main.tf
        ├── variables.tf
        └── outputs.tf
```

---

## Provider Configuration

**File:** `providers.tf`

| Setting              | Value                           |
|----------------------|---------------------------------|
| Terraform version    | `>= 1.6.0`                     |
| Snowflake provider   | `Snowflake-Labs/snowflake ~> 2.0` |
| Authentication       | Configurable via `snowflake_authenticator` variable (default: `SNOWFLAKE_JWT`) |

The provider authenticates to Snowflake using the account, user, role, and authenticator variables defined at the root level.

---

## Backend Configuration

**File:** `backend.tf`

The backend is configured for **AWS S3** with **DynamoDB** state locking (currently commented out as a template). Before enabling:

1. Create an S3 bucket with versioning enabled for state storage.
2. Create a DynamoDB table with a `LockID` (String) partition key.
3. Ensure the executing IAM principal has read/write permissions on both resources.
4. Uncomment the backend block and run `terraform init` with `-backend-config` flags.

---

## Modules

### Warehouse Module

**Path:** `modules/warehouse/`

**Purpose:** Provisions Snowflake virtual warehouses – the compute layer of Snowflake. Warehouses provide the CPU and memory needed to execute queries and DML operations.

**Resource:** `snowflake_warehouse.this`

**Lifecycle:** `prevent_destroy = true` – Warehouses cannot be accidentally destroyed via Terraform to protect running workloads and their configurations.

#### Inputs

| Variable            | Type     | Default | Description                                      |
|---------------------|----------|---------|--------------------------------------------------|
| `name`              | `string` | —       | Name of the warehouse                            |
| `size`              | `string` | —       | Warehouse size (XSMALL, SMALL, MEDIUM, LARGE, etc.) |
| `auto_suspend`      | `number` | `300`   | Seconds of inactivity before auto-suspend        |
| `auto_resume`       | `bool`   | `true`  | Whether the warehouse auto-resumes on query      |
| `min_cluster_count` | `number` | `1`     | Minimum number of clusters (multi-cluster)       |
| `max_cluster_count` | `number` | `1`     | Maximum number of clusters (multi-cluster)       |
| `comment`           | `string` | `""`    | Optional descriptive comment                     |

#### Outputs

| Output            | Description                              |
|-------------------|------------------------------------------|
| `warehouse_names` | List of created warehouse names          |
| `warehouses`      | Map of warehouse details keyed by name   |

---

### Database Module

**Path:** `modules/database/`

**Purpose:** Provisions Snowflake databases and their associated schemas. Databases are the primary containers for all data objects (tables, views, stages, etc.) in Snowflake.

**Resources:**
- `snowflake_database.this` – Creates databases
- `snowflake_schema.this` – Creates schemas within databases

**Lifecycle:** `prevent_destroy = true` on **both** databases and schemas – Prevents accidental deletion of databases and schemas which would result in permanent data loss.

#### Inputs

| Variable                      | Type     | Default | Description                                       |
|-------------------------------|----------|---------|---------------------------------------------------|
| `name`                        | `string` | —       | Name of the database                              |
| `comment`                     | `string` | `""`    | Optional descriptive comment                      |
| `data_retention_time_in_days` | `number` | `1`     | Time Travel retention period in days              |
| `schemas`                     | `list`   | `[]`    | List of schemas to create within the database     |
| `schemas[].name`              | `string` | —       | Name of the schema                                |
| `schemas[].comment`           | `string` | `""`    | Optional descriptive comment for the schema       |

#### Outputs

| Output           | Description                                           |
|------------------|-------------------------------------------------------|
| `database_names` | List of created database names                        |
| `databases`      | Map of database details keyed by name                 |
| `schema_names`   | List of fully qualified schema names (DATABASE.SCHEMA)|

---

### Role Module

**Path:** `modules/role/`

**Purpose:** Provisions Snowflake account-level roles. Roles are the foundation of Snowflake's Role-Based Access Control (RBAC) model. They define what privileges a user or service can exercise.

**Resource:** `snowflake_account_role.this`

**Lifecycle:** `prevent_destroy = true` – Roles are critical security infrastructure; accidental deletion would revoke all associated privileges and break access for dependent users and services.

#### Inputs

| Variable  | Type     | Default | Description                     |
|-----------|----------|---------|---------------------------------|
| `name`    | `string` | —       | Name of the role                |
| `comment` | `string` | `""`    | Optional descriptive comment    |

#### Outputs

| Output       | Description                          |
|--------------|--------------------------------------|
| `role_names` | List of created role names           |
| `roles`      | Map of role details keyed by name    |

---

### User Module

**Path:** `modules/user/`

**Purpose:** Provisions Snowflake user accounts. Users represent individual people or service accounts that authenticate and interact with Snowflake. Each user can be assigned a default warehouse and role.

**Resource:** `snowflake_user.this`

**Lifecycle:** `prevent_destroy = true` – Users are identity resources; accidental deletion would lock out users from the platform and disrupt active workloads.

#### Inputs

| Variable               | Type     | Default | Description                                       |
|------------------------|----------|---------|---------------------------------------------------|
| `name`                 | `string` | —       | Display name of the user                          |
| `login_name`           | `string` | —       | Login identifier for authentication               |
| `email`                | `string` | `""`    | Email address of the user                         |
| `default_warehouse`    | `string` | `""`    | Default warehouse assigned to the user            |
| `default_role`         | `string` | `""`    | Default role assigned to the user on login        |
| `must_change_password` | `bool`   | `true`  | Whether user must change password on first login  |
| `comment`              | `string` | `""`    | Optional descriptive comment                      |

#### Outputs

| Output       | Description                          |
|--------------|--------------------------------------|
| `user_names` | List of created user names           |
| `users`      | Map of user details keyed by name    |

---

### Grants Module

**Path:** `modules/grants/`

**Purpose:** Manages all privilege grants and role hierarchy relationships in Snowflake. This module centralizes access control by granting specific privileges on warehouses, databases, and schemas to account roles, as well as establishing the role hierarchy (granting child roles to parent roles). Uses the Snowflake provider v2.x `snowflake_grant_privileges_to_account_role` resource.

**Resources:**
- `snowflake_grant_privileges_to_account_role.warehouse` – Grants warehouse-level privileges (e.g., USAGE, OPERATE, MONITOR)
- `snowflake_grant_privileges_to_account_role.database` – Grants database-level privileges (e.g., USAGE, CREATE SCHEMA, MONITOR)
- `snowflake_grant_privileges_to_account_role.schema` – Grants schema-level privileges (e.g., USAGE, CREATE TABLE, CREATE VIEW)
- `snowflake_grant_account_role.hierarchy` – Establishes role hierarchy by granting a child role to a parent role

**Lifecycle:** No `prevent_destroy` policy – Grants are additive permission assignments and can be safely re-applied if removed. They do not contain data or stateful configuration.

#### Inputs

| Variable           | Type   | Default | Description                                              |
|--------------------|--------|---------|----------------------------------------------------------|
| `warehouse_grants` | `list` | `[]`    | Warehouse privilege grants (role, warehouse, privileges) |
| `database_grants`  | `list` | `[]`    | Database privilege grants (role, database, privileges)   |
| `schema_grants`    | `list` | `[]`    | Schema privilege grants (role, database, schema, privileges) |
| `role_grants`      | `list` | `[]`    | Role hierarchy grants (child role → parent role)         |

#### Outputs

| Output                    | Description                                |
|---------------------------|--------------------------------------------|
| `warehouse_grant_ids`     | Map of warehouse grant resource IDs        |
| `database_grant_ids`      | Map of database grant resource IDs         |
| `schema_grant_ids`        | Map of schema grant resource IDs           |
| `role_hierarchy_grant_ids`| Map of role hierarchy grant resource IDs   |

---

## Lifecycle Policies

The following resources have `prevent_destroy = true` to protect critical infrastructure from accidental deletion:

| Resource                    | Module    | Reason                                                           |
|-----------------------------|-----------|------------------------------------------------------------------|
| `snowflake_warehouse.this`  | Warehouse | Protects compute resources and their configurations              |
| `snowflake_database.this`   | Database  | Prevents permanent data loss from accidental database deletion   |
| `snowflake_schema.this`     | Database  | Prevents data loss from accidental schema deletion               |
| `snowflake_account_role.this`| Role     | Protects RBAC structure; deletion would revoke all privileges    |
| `snowflake_user.this`       | User      | Protects user identities; deletion would lock out users          |

> **Note:** To intentionally destroy a protected resource, you must first remove or set `prevent_destroy = false` in the corresponding module, apply the change, and then run `terraform destroy` or remove the resource from configuration.

---

## Environments

The project supports three environments, each with its own variable file:

| Environment | File                          | Description                              |
|-------------|-------------------------------|------------------------------------------|
| Production  | `environments/prod.tfvars`    | Live production Snowflake environment    |
| QA          | `environments/qa.tfvars`      | Quality assurance / testing environment  |
| Staging     | `environments/stage.tfvars`   | Pre-production staging environment       |

Select an environment at plan/apply time:

```bash
terraform plan  -var-file=environments/prod.tfvars
terraform apply -var-file=environments/prod.tfvars
```

---

## Dependency Graph

Modules are applied in the following order based on explicit `depends_on` declarations:

```
1. Warehouses  ──┐
2. Databases   ──┤
3. Roles       ──┤
                 ├──► 4. Users (depends on Warehouses, Roles)
                 │
                 └──► 5. Grants (depends on Warehouses, Databases, Roles, Users)
```

- **Warehouses, Databases, and Roles** are provisioned first (no inter-dependencies, can run in parallel).
- **Users** depend on Warehouses and Roles (for `default_warehouse` and `default_role` assignments).
- **Grants** depend on all other modules since they reference warehouses, databases, schemas, roles, and users.

---

## Usage

### Initialize

```bash
terraform init
```

### Plan

```bash
terraform plan -var-file=environments/<env>.tfvars
```

### Apply

```bash
terraform apply -var-file=environments/<env>.tfvars
```

### Destroy (with caution)

Due to `prevent_destroy` lifecycle policies on critical resources, a full `terraform destroy` will fail by design. To destroy protected resources:

1. Temporarily set `prevent_destroy = false` in the relevant module.
2. Run `terraform apply` to update the lifecycle configuration.
3. Run `terraform destroy -var-file=environments/<env>.tfvars`.
4. Restore `prevent_destroy = true` and commit the change.
