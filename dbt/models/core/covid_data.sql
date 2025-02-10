{{ config(
    materialized='table',
) }}

WITH clean_data AS
(
SELECT 
    PROVINCE_STATE,
    COUNTRY_REGION,
    LAST_UPDATE,
    LAT,
    LONG_,
    COALESCE(CONFIRMED, LEAD(CONFIRMED) OVER (PARTITION BY COUNTRY_REGION, PROVINCE_STATE ORDER BY DATE)) AS CONFIRMED,
    COALESCE(DEATHS, LEAD(DEATHS) OVER (PARTITION BY COUNTRY_REGION, PROVINCE_STATE ORDER BY DATE)) AS DEATHS,
    COALESCE(RECOVERED, LEAD(RECOVERED) OVER (PARTITION BY COUNTRY_REGION, PROVINCE_STATE ORDER BY DATE)) AS RECOVERED,
    COALESCE(ACTIVE, LEAD(ACTIVE) OVER (PARTITION BY COUNTRY_REGION, PROVINCE_STATE ORDER BY DATE)) AS ACTIVE,
    FIPS,
    COALESCE(INCIDENT_RATE, LEAD(INCIDENT_RATE) OVER (PARTITION BY COUNTRY_REGION, PROVINCE_STATE ORDER BY DATE)) AS INCIDENT_RATE,
    TOTAL_TEST_RESULTS,
    PEOPLE_HOSPITALIZED,
    COALESCE(CASE_FATALITY_RATIO, LEAD(CASE_FATALITY_RATIO) OVER (PARTITION BY COUNTRY_REGION, PROVINCE_STATE ORDER BY DATE)) AS CASE_FATALITY_RATIO,
    UID,
    ISO3,
    COALESCE(TESTING_RATE, LEAD(TESTING_RATE) OVER (PARTITION BY COUNTRY_REGION, PROVINCE_STATE ORDER BY DATE)) AS TESTING_RATE,
    COALESCE(HOSPITALIZATION_RATE, LEAD(HOSPITALIZATION_RATE) OVER (PARTITION BY COUNTRY_REGION, PROVINCE_STATE ORDER BY DATE)) AS HOSPITALIZATION_RATE,
    DATE,
    COALESCE(PEOPLE_TESTED, LEAD(PEOPLE_TESTED) OVER (PARTITION BY COUNTRY_REGION, PROVINCE_STATE ORDER BY DATE)) AS PEOPLE_TESTED,
    COALESCE(MORTALITY_RATE, LEAD(MORTALITY_RATE) OVER (PARTITION BY COUNTRY_REGION, PROVINCE_STATE ORDER BY DATE)) AS MORTALITY_RATE
FROM {{ source('raw', 'covid_data') }}
)

SELECT
    PROVINCE_STATE,
    COUNTRY_REGION,
    UID,
    ISO3,
    DATE,
    LAST_UPDATE,
    LAT,
    LONG_,
    CONFIRMED,
    DEATHS,
    RECOVERED,
    ACTIVE,
    FIPS,
    TOTAL_TEST_RESULTS,
    PEOPLE_HOSPITALIZED,
    PEOPLE_TESTED,

    -- Recalculate Metrics for all NULL
    IFNULL(CASE_FATALITY_RATIO, 
        CASE
            WHEN DEATHS > 0 and CONFIRMED > 0 
                THEN (DEATHS / CONFIRMED) * 100
            ELSE 0
        END
    ) AS CASE_FATALITY_RATIO,

    IFNULL(TESTING_RATE, 
        CASE
            WHEN TOTAL_TEST_RESULTS > 0 and PEOPLE_TESTED > 0 
                THEN (TOTAL_TEST_RESULTS / PEOPLE_TESTED) * 100
            ELSE 0
        END
    ) AS TESTING_RATE,

    IFNULL(HOSPITALIZATION_RATE, 
        CASE
            WHEN PEOPLE_HOSPITALIZED > 0 and CONFIRMED > 0 
                THEN (PEOPLE_HOSPITALIZED / CONFIRMED) * 100
            ELSE 0
        END
    ) AS HOSPITALIZATION_RATE,

    
    INCIDENT_RATE,

    IFNULL(MORTALITY_RATE, 
        CASE
            WHEN DEATHS > 0 and CONFIRMED > 0 
                THEN (DEATHS / CONFIRMED) * 100
            ELSE 0
        END
    ) AS MORTALITY_RATE
    
FROM
(
SELECT 
    PROVINCE_STATE,
    COUNTRY_REGION,
    UID,
    ISO3,
    COALESCE(DATE, CAST(LAST_UPDATE AS DATE)) AS DATE,
    LAST_UPDATE,
    LAT,
    LONG_,
    COALESCE(CONFIRMED, 0) AS CONFIRMED,
    COALESCE(DEATHS, 0) AS DEATHS,
    COALESCE(RECOVERED, 0) AS RECOVERED,
    COALESCE(ACTIVE, 0) AS ACTIVE,
    COALESCE(FIPS, 0) AS FIPS,
    COALESCE(TOTAL_TEST_RESULTS, 0) AS TOTAL_TEST_RESULTS,
    COALESCE(PEOPLE_HOSPITALIZED, 0) AS PEOPLE_HOSPITALIZED,
    COALESCE(PEOPLE_TESTED, 0) AS PEOPLE_TESTED,
    CASE_FATALITY_RATIO,
    TESTING_RATE,
    HOSPITALIZATION_RATE,
    INCIDENT_RATE,
    MORTALITY_RATE
FROM clean_data
) tf