USE DATABASE RETAIL_DB;
USE SCHEMA ANALYTICS;

-- 1. Monthly Revenue Trend
SELECT
    DATE_TRUNC('month', order_date) AS sales_month,
    COUNT(DISTINCT order_id) AS total_orders,
    SUM(quantity) AS total_units_sold,
    ROUND(SUM(total_amount), 2) AS monthly_revenue
FROM FACT_SALES
GROUP BY 1
ORDER BY 1;

-- 2. Top 10 Best-Selling Products
SELECT
    p.product_id,
    p.product_name,
    SUM(f.quantity) AS units_sold,
    ROUND(SUM(f.total_amount), 2) AS total_revenue
FROM FACT_SALES f
JOIN DIM_PRODUCTS p ON f.product_id = p.product_id
GROUP BY 1, 2
ORDER BY total_revenue DESC
LIMIT 10;

-- 3. Country-Wise Sales Performance
SELECT
    c.country,
    COUNT(DISTINCT c.customer_id) AS unique_customers,
    COUNT(DISTINCT f.order_id) AS total_orders,
    ROUND(SUM(f.total_amount), 2) AS total_revenue
FROM FACT_SALES f
JOIN DIM_CUSTOMERS c ON f.customer_id = c.customer_id
GROUP BY 1
ORDER BY total_revenue DESC
LIMIT 10;
