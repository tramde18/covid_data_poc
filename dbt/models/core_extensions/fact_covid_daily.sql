{{ config(
    materialized='table',
) }}


WITH agg_daily AS
(
    SELECT
        PROVINCE_STATE,
        COUNTRY_REGION,
        DATE,
        LAST_UPDATE,
        -- metrics
        CONFIRMED,
        DEATHS,
        RECOVERED,
        ACTIVE,
        FIPS,
        INCIDENT_RATE,
        TOTAL_TEST_RESULTS,
        PEOPLE_HOSPITALIZED,
        CASE_FATALITY_RATIO,
        TESTING_RATE,
        HOSPITALIZATION_RATE,
        PEOPLE_TESTED,
        MORTALITY_RATE,
        -- agg to daily (get latest events per day)
        ROW_NUMBER() OVER (PARTITION BY COUNTRY_REGION, PROVINCE_STATE, DATE ORDER BY LAST_UPDATE DESC) AS ROW_NUM
    FROM {{ source('core', 'covid_data') }}
)

SELECT
    PROVINCE_STATE,
    COUNTRY_REGION,
    DATE,
    CONFIRMED,
    DEATHS,
    RECOVERED,
    ACTIVE,
    FIPS,
    INCIDENT_RATE,
    TOTAL_TEST_RESULTS,
    PEOPLE_HOSPITALIZED,
    CASE_FATALITY_RATIO,
    TESTING_RATE,
    HOSPITALIZATION_RATE,
    PEOPLE_TESTED,
    MORTALITY_RATE
FROM agg_daily
WHERE ROW_NUM = 1
