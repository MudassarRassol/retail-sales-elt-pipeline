USE DATABASE RETAIL_DB;
USE SCHEMA ANALYTICS;

-- Query 1: Total Sales Revenue
SELECT
    ROUND(SUM(total_amount), 2) AS total_sales_revenue
FROM FACT_SALES;

-- Query 2: Top Five Selling Products
SELECT
    p.product_id,
    p.product_name,
    SUM(f.quantity) AS total_units_sold,
    ROUND(SUM(f.total_amount), 2) AS total_revenue
FROM FACT_SALES f
JOIN DIM_PRODUCTS p ON f.product_id = p.product_id
GROUP BY 1, 2
ORDER BY total_revenue DESC
LIMIT 5;

-- Query 3: Country with Highest Revenue
SELECT
    c.country,
    ROUND(SUM(f.total_amount), 2) AS total_revenue
FROM FACT_SALES f
JOIN DIM_CUSTOMERS c ON f.customer_id = c.customer_id
GROUP BY 1
ORDER BY total_revenue DESC
LIMIT 1;

-- Query 4: Monthly Sales Totals
SELECT
    sales_month,
    total_orders,
    total_units_sold,
    monthly_revenue
FROM AGG_MONTHLY_SALES
ORDER BY sales_month;

-- Query 5: Number of Unique Purchasing Customers
SELECT
    COUNT(DISTINCT customer_id) AS unique_purchasing_customers
FROM FACT_SALES;
