SELECT DISTINCT
    TRIM(customer_id) AS customer_id,
    TRIM(customer_name) AS customer_name,
    TRIM(country) AS country
FROM {{ source('raw_retail', 'customers') }}
WHERE customer_id IS NOT NULL
