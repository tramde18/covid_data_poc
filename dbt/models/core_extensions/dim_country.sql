{{ config(
    materialized='table',
) }}

WITH DISTINCT_COUNTRY AS
(
    SELECT DISTINCT
        ISO3,
        COUNTRY_REGION
    FROM {{ source('core', 'covid_data') }}
)
SELECT 
    ROW_NUMBER() OVER (ORDER BY COUNTRY_REGION, ISO3) AS ID,
    ISO3,
    COUNTRY_REGION
FROM DISTINCT_COUNTRY    

