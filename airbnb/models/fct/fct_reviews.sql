{{
    config(
        materialized='incremental',
        on_schema_change='fail'
    )
}}

WITH src_reviews AS (
    SELECT
        *
    FROM
        {{ ref('src_reviews') }}
)
SELECT
    {{
        dbt_utils.generate_surrogate_key(
            [
                'listing_id',
                'review_date',
                'reviewer_name',
                'review_text'
            ]
        )
    }} AS review_id,
    *
FROM
    src_reviews
WHERE
    review_text IS NOT NULL
    -- This is some Jinja to let dbt know how tell which records are new.
    {% if is_incremental() %}
        AND review_date > (SELECT MAX(review_date) FROM {{ this }}) -- `this` refers to the current model, `fct_reviews`.
    {% endif %}
