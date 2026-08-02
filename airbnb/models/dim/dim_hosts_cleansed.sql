{{
    config(
        materialized='view'
    )
}}

WITH src_hosts AS (
    SELECT
        *
    FROM
        {{ ref('src_hosts') }}
)
SELECT
    host_id,
    /*
    Interesting; I was gonna use `COALESCE()`.
    Ah, `NVL()` is a legacy, Oracle-specific function limited to two arguments,
    whereas `COALESCE()` is a modern, ANSI-standard function.
    */
    NVL(host_name, 'Anonymous') AS host_name, 
    is_superhost,
    created_at,
    updated_at
FROM
    src_hosts
