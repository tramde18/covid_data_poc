{{ config(
    materialized='view'
) }}


WITH daily_metrics AS (
    SELECT
        Province_State,
        Country_Region,
        Date,
        Confirmed,
        Deaths,
        LAG(Confirmed, 1) OVER (PARTITION BY Province_State, Country_Region ORDER BY Date) AS Prev_Confirmed,
        LAG(Deaths, 1) OVER (PARTITION BY Province_State, Country_Region ORDER BY Date) AS Prev_Deaths
    FROM {{ ref('fact_covid_daily') }}
    WHERE
        Date IS NOT NULL
)
SELECT
    Province_State,
    Country_Region,
    Date,
    Confirmed,
    Deaths,
    (Confirmed - Prev_Confirmed) AS Confirmed_Change,
    (Deaths - Prev_Deaths) AS Deaths_Change
FROM
    daily_metrics
WHERE
    Prev_Confirmed IS NOT NULL
    AND Prev_Deaths IS NOT NULL
ORDER BY
    Province_State, Country_Region, Date
