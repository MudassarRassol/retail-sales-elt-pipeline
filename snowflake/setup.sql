-- 1. Database & Schemas Setup
CREATE DATABASE IF NOT EXISTS RETAIL_DB;
CREATE SCHEMA IF NOT EXISTS RETAIL_DB.RAW;
CREATE SCHEMA IF NOT EXISTS RETAIL_DB.ANALYTICS;

USE DATABASE RETAIL_DB;
USE SCHEMA RAW;

-- 2. Raw Landing Tables
CREATE OR REPLACE TABLE CUSTOMERS (
    customer_id VARCHAR(50),
    customer_name VARCHAR(255),
    country VARCHAR(100)
);

CREATE OR REPLACE TABLE PRODUCTS (
    product_id VARCHAR(50),
    product_name VARCHAR(255),
    category VARCHAR(100),
    unit_price FLOAT
);

CREATE OR REPLACE TABLE SALES (
    order_id VARCHAR(50),
    customer_id VARCHAR(50),
    product_id VARCHAR(50),
    quantity INT,
    order_date DATE
);

-- 3. CSV File Format & External Stage (Azure ADLS Gen2)
CREATE OR REPLACE FILE FORMAT retail_csv_format
    TYPE = 'CSV'
    FIELD_DELIMITER = ','
    SKIP_HEADER = 1
    FIELD_OPTIONALLY_ENCLOSED_BY = '"'
    NULL_IF = ('NULL', 'null', '');

-- Note: Replace <STORAGE_ACCOUNT> and <STORAGE_INTEGRATION> with your Azure details
CREATE OR REPLACE STAGE retail_adls_stage
    URL = 'azure://<STORAGE_ACCOUNT>.blob.core.windows.net/retail-data/raw/'
    STORAGE_INTEGRATION = azure_retail_integration
    FILE_FORMAT = retail_csv_format;

-- 4. Load Data via COPY INTO
COPY INTO CUSTOMERS FROM @retail_adls_stage/customers/ PATTERN = '.*customers\.csv';
COPY INTO PRODUCTS FROM @retail_adls_stage/products/ PATTERN = '.*products\.csv';
COPY INTO SALES FROM @retail_adls_stage/sales/ PATTERN = '.*sales\.csv';

-- 5. Row Count Validation
SELECT 'CUSTOMERS' AS table_name, COUNT(*) AS row_count FROM CUSTOMERS
UNION ALL
SELECT 'PRODUCTS', COUNT(*) FROM PRODUCTS
UNION ALL
SELECT 'SALES', COUNT(*) FROM SALES;
