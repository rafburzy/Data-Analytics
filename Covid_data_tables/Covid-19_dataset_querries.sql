-- First query to see the columns and data
SELECT
    *
FROM 
    `bigquery-public-data.covid19_ecdc_eu.covid_19_geographic_distribution_worldwide` 
LIMIT 100

-- Query for cases in the world and in Poland, selection of columns and creation of calculated columns
SELECT
    countries_and_territories, date, daily_confirmed_cases, daily_deaths, confirmed_cases, deaths, pop_data_2019,
    (deaths / confirmed_cases) * 100 AS death_percentage,
    (confirmed_cases / pop_data_2019) * 100 AS percent_pop_sick  
FROM 
    `bigquery-public-data.covid19_ecdc_eu.covid_19_geographic_distribution_worldwide` 

WHERE 
    confirmed_cases != 0

-- Limiting just for Poland
SELECT
    countries_and_territories, date, daily_confirmed_cases, daily_deaths, confirmed_cases, deaths, pop_data_2019,
    (deaths / confirmed_cases) * 100 AS death_percentage,
    (confirmed_cases / pop_data_2019) * 100 AS percent_pop_sick  
FROM 
    `bigquery-public-data.covid19_ecdc_eu.covid_19_geographic_distribution_worldwide` 

WHERE 
    countries_and_territories = "Poland"

-- Summary data for all world 
SELECT
    countries_and_territories,
    MAX(confirmed_cases) AS max_confirmed_cases,
    MAX((confirmed_cases / pop_data_2019) * 100) AS max_percent_pop_sick,
    SUM(confirmed_cases) AS Total_cases,
    SUM(deaths) AS Total_deaths,
    (SUM(deaths) / SUM(confirmed_cases)) * 100 AS deaths_to_confirmed_ratio
FROM 
    `bigquery-public-data.covid19_ecdc_eu.covid_19_geographic_distribution_worldwide` 
GROUP BY
    countries_and_territories
ORDER BY
    Total_deaths DESC

-- and the same thing for Poland (basically one row table)
SELECT
    countries_and_territories,
    MAX(confirmed_cases) AS max_confirmed_cases,
    MAX((confirmed_cases / pop_data_2019) * 100) AS max_percent_pop_sick,
    SUM(confirmed_cases) AS Total_cases,
    SUM(deaths) AS Total_deaths,
    (SUM(deaths) / SUM(confirmed_cases)) * 100 AS deaths_to_confirmed_ratio
FROM 
    `bigquery-public-data.covid19_ecdc_eu.covid_19_geographic_distribution_worldwide` 
WHERE
    countries_and_territories = "Poland"
GROUP BY
    countries_and_territories
ORDER BY
    Total_deaths DESC

-- Query to obtain data for further analysis in R
SELECT
    countries_and_territories, date, daily_confirmed_cases, daily_deaths, confirmed_cases, deaths, pop_data_2019
FROM 
    `bigquery-public-data.covid19_ecdc_eu.covid_19_geographic_distribution_worldwide` 

WHERE 
    countries_and_territories = "Poland" OR countries_and_territories = "Germany" OR countries_and_territories = "Croatia" OR countries_and_territories = "Czechia"
