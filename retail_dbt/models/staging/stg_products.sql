SELECT DISTINCT
    TRIM(product_id) AS product_id,
    TRIM(product_name) AS product_name,
    TRIM(category) AS category,
    CAST(unit_price AS NUMBER(10, 2)) AS unit_price
FROM {{ source('raw_retail', 'products') }}
WHERE product_id IS NOT NULL
  AND unit_price > 0
