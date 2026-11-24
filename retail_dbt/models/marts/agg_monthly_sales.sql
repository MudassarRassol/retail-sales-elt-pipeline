SELECT
    DATE_TRUNC('month', order_date) AS sales_month,
    COUNT(DISTINCT order_id) AS total_orders,
    COUNT(DISTINCT customer_id) AS unique_customers,
    SUM(quantity) AS total_units_sold,
    ROUND(SUM(total_amount), 2) AS monthly_revenue
FROM {{ ref('fact_sales') }}
GROUP BY 1
ORDER BY 1
