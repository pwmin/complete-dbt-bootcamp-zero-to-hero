SELECT
    *
FROM
    {{ ref('dim_listings_cleansed') }}
WHERE
    minimum_nights < 1
-- We might want to limit the results for scalability (i.e., when we want just a sample, not millions of rows).
-- LIMIT
--     10
