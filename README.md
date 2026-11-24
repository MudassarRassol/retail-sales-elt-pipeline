# End-to-End Retail Sales ELT Data Pipeline (Azure + Snowflake + dbt)

## Architecture Overview
`UCI Online Retail Dataset (Python)` $\rightarrow$ `Azure Data Lake Storage Gen2 (Raw Zone)` $\rightarrow$ `Snowflake (RAW Schema via COPY INTO)` $\rightarrow$ `dbt Core (Staging Views + Star Schema Marts)` $\rightarrow$ `Snowflake (ANALYTICS Schema)`

## Tech Stack
- **Ingestion & Scripting:** Python (`pandas`, `azure-storage-blob`)
- **Cloud Data Lake:** Microsoft Azure ADLS Gen2 (Date-partitioned folders)
- **Cloud Data Warehouse:** Snowflake (`RETAIL_DB` with `RAW` and `ANALYTICS` schemas)
- **Transformation & Testing:** dbt Core (`dbt-snowflake`)

## Data Modeling (Star Schema)
- **Staging Layer (Views):** `stg_customers`, `stg_products`, `stg_sales` (deduplication, whitespace trimming, filtering cancelled/negative orders)
- **Marts Layer (Tables):**
  - `dim_customers`: Unique customer master dimension
  - `dim_products`: Cleaned product catalog with validated pricing
  - `fact_sales`: Transactional sales fact table with calculated `total_amount`
- **Data Quality Tests:** `unique`, `not_null`, and `relationships` (referential integrity) checks configured in `schema.yml`.
