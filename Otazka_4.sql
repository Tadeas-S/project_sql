--Otázka 4: Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?

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
WHERE actual."year" != 2006
ORDER BY price_change_percent ASC
LIMIT 1;