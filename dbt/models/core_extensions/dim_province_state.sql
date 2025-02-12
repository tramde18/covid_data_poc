{{ config(
    materialized='table',
) }}

WITH DISTINCT_PROVINCE AS
(
    SELECT DISTINCT
        PROVINCE_STATE,
        COUNTRY_REGION,
        ISO3,
        LAT,
        LONG_
    FROM {{ source('core', 'covid_data') }}
)
SELECT
    ROW_NUMBER() OVER (ORDER BY PROVINCE_STATE) AS ID,
    dp.PROVINCE_STATE,
    dp.LAT,
    dp.LONG_,
    dc.ID AS COUNTRY_ID
FROM DISTINCT_PROVINCE dp
LEFT JOIN {{ ref('dim_country') }} dc
    ON dp.COUNTRY_REGION = dc.COUNTRY_REGION and dp.ISO3 = dc.ISO3
