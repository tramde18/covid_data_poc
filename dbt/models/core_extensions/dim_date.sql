{{ config(
    materialized='table',
) }}

WITH RECURSIVE date_series AS (
    -- Start with the initial date '2020-01-01'
    SELECT '2020-01-01' AS full_date
    UNION ALL
    -- Add one day to the previous date
    SELECT DATE_ADD(full_date, INTERVAL 1 DAY)
    FROM date_series
    WHERE full_date < '2023-12-31'  -- End date
)
SELECT
    REPLACE(full_date, '-', '') AS date_id,                 -- Unique identifier for each date
    full_date,
    DAY(full_date) AS day,                                  -- Day of the month
    MONTH(full_date) AS month,                              -- Month of the year
    YEAR(full_date) AS year,                                -- Year
    QUARTER(full_date) AS quarter,                          -- Quarter (1-4)
    DAYNAME(full_date) AS day_of_week,                      -- Day of the week (e.g., 'Monday')
    DAYOFYEAR(full_date) AS day_of_year,                    -- Day of the year (1-365/366)
    WEEKOFYEAR(full_date) AS week_of_year,                  -- Week number of the year (1-52)
    IF(DAYOFWEEK(full_date) IN (1, 7), TRUE, FALSE) AS is_weekend,  -- TRUE if weekend (1 = Sunday, 7 = Saturday)
    FALSE AS is_holiday                                     -- Placeholder for holiday flag
FROM date_series

