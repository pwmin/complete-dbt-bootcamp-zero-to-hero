{{
    config(
        materialized='view',
        event_time='created_at'
    )
}}

WITH src_listings AS (
    SELECT
        *
    FROM
        /*
        This is a Jinja template tag, and a way to reference the `src_listings` model.
        dbt will substitute this with the view name.

        Side note: Snowflake formats each double brace by inserting a space in between,
        which is incorrect syntax and results in dbt raising an error.
        */
        {{ ref('src_listings') }}
)
SELECT
    listing_id,
    listing_name,
    room_type,
    CASE
        WHEN minimum_nights = 0 THEN 1 -- Replace invalid values.
        ELSE minimum_nights
    END AS minimum_nights,
    host_id,
    REPLACE(price_str, '$')::NUMBER(10, 2) AS price,
    price_str,
    created_at,
    updated_at
FROM
    src_listings
