SELECT
    *
FROM
    {{ ref('dim_listings_cleansed') }}
WHERE
    minimum_nights < 1
LIMIT
    10 -- For scalability; we just want a sample, not millions of records.
