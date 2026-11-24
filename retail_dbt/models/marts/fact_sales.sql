{{
    config(
        materialized='incremental',
        unique_key=['order_id', 'product_id'],
        incremental_strategy='merge'
    )
}}

SELECT
    s.order_id,
    s.customer_id,
    s.product_id,
    s.order_date,
    s.quantity,
    p.unit_price,
    ROUND(s.quantity * p.unit_price, 2) AS total_amount
FROM {{ ref('stg_sales') }} s
INNER JOIN {{ ref('stg_products') }} p
    ON s.product_id = p.product_id
INNER JOIN {{ ref('stg_customers') }} c
    ON s.customer_id = c.customer_id

{% if is_incremental() %}
WHERE s.order_date >= (SELECT COALESCE(MAX(order_date), '1900-01-01') FROM {{ this }})
{% endif %}
