SELECT
    *
FROM
    {{ ref('dim_listings_cleansed') }} l
INNER JOIN -- Using an inner join because the `listing_id` relationship is already covered by a data test.
    {{ ref('fct_reviews') }} r
ON
    l.listing_id = r.listing_id
    AND l.created_at > r.review_date -- Should I move this down to a `WHERE` clause? It'd arguably be better for semantics and understandability, but make no difference thanks to the `INNER JOIN`.
