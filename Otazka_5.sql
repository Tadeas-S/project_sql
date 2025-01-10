/*Úkol 5: Má výška HDP vliv na změny ve mzdách a cenách potravin? Neboli, pokud HDP vzroste výrazněji v jednom roce,
 * projeví se to na cenách potravin či mzdách ve stejném nebo následujícím roce výraznějším růstem?
*/


--tvorba view "economies_gdp"--

CREATE VIEW gdp_percent_change AS 
WITH gdp_difference AS (
SELECT
	YEAR,
	gdp
FROM t_tadeas_stanovsky_project_sql_secondary_final ttspssf 
WHERE country = 'Czech Republic'
	 AND "year" BETWEEN 2006 AND 2018
)
SELECT
    actual."year" AS actual_year,
    actual.gdp AS actual_gdp,
    previous.gdp AS previous_gdp,
    CASE
        WHEN previous.gdp IS NOT NULL THEN
            round((((actual.gdp - previous.gdp) / previous.gdp) * 100)::NUMERIC, 2)
        ELSE NULL
    END AS gdp_percent
FROM gdp_difference AS actual
LEFT JOIN gdp_difference AS previous
    ON actual.year = previous.year + 1
ORDER BY actual."year";

-- uprava dotazu ze 4. úkolu/otázky a vytvoření view--


CREATE VIEW gdp_payroll_price_change AS 
WITH price_pyaroll_ratio AS (
    SELECT
        YEAR,
        round(avg(price_value)::NUMERIC, 2) AS avg_price,
        round(avg(payroll_value)::NUMERIC, 2) AS avg_payroll_value
    FROM t_tadeas_stanovsky_project_sql_primary_final ttspspf 
    WHERE payroll_value_type_code = 5958
      AND industry_branch_code IS NOT NULL
    GROUP BY YEAR
)
SELECT 
    actual.year,
    actual.avg_payroll_value AS avg_payroll_value,
    previous.avg_payroll_value AS prev_avg_payroll_value,
    actual.avg_price AS avg_price_value,
    previous.avg_price AS prev_price_value,
    CASE
        WHEN previous.avg_price IS NOT NULL THEN
             round((((actual.avg_price - previous.avg_price) / previous.avg_price) * 100)::NUMERIC, 2)
        ELSE NULL
    END AS price_change_percent,
    CASE
        WHEN previous.avg_payroll_value IS NOT NULL THEN
            round((((actual.avg_payroll_value - previous.avg_payroll_value) / previous.avg_payroll_value) * 100)::NUMERIC, 2)
        ELSE NULL
    END AS payroll_change_percent
FROM price_pyaroll_ratio AS actual
LEFT JOIN price_pyaroll_ratio AS previous
    ON actual.year = previous.year + 1
ORDER BY price_change_percent DESC 
;

--závěrečný dotaz--

SELECT
	a."year",
    price_change_percent,
    payroll_change_percent,
    gdp_percent
FROM gdp_payroll_price_change a
LEFT JOIN gdp_percent_change b
	 ON a."year" = b.actual_year
WHERE YEAR != 2006
ORDER BY year
