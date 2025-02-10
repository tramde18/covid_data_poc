{{ config(
    materialized='view'
) }}

WITH FrequencyData AS (
    SELECT
        Province_State,
        COUNT(*) AS frequency
    FROM {{ source('core_extensions', 'fact_covid_daily') }}
    GROUP BY
        Province_State
),
TotalCount AS (
    SELECT
        COUNT(*) AS total_count
    FROM {{ source('core_extensions', 'fact_covid_daily') }}
)

SELECT
    f.Province_State,
    f.frequency,
    ROUND((f.frequency * 100.0 / t.total_count), 2) AS frequency_percentage
FROM
    FrequencyData f,
    TotalCount t
ORDER BY
    f.frequency DESC
-- LIMIT 5