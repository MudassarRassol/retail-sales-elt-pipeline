SELECT
    TRIM(order_id) AS order_id,
    TRIM(customer_id) AS customer_id,
    TRIM(product_id) AS product_id,
    CAST(quantity AS INT) AS quantity,
    CAST(order_date AS DATE) AS order_date
FROM {{ source('raw_retail', 'sales') }}
WHERE order_id IS NOT NULL
  AND customer_id IS NOT NULL
  AND product_id IS NOT NULL
  AND quantity > 0
