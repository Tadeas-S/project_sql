--Otázka 1: Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?


SELECT 
	round(avg(payroll_value)::NUMERIC, 0) AS avg_payroll_value,
	"year",
	industry_branch
FROM t_tadeas_stanovsky_project_sql_primary_final
WHERE payroll_value_type_code = 5958
	 AND industry_branch_code IS NOT NULL
GROUP BY "year", industry_branch
ORDER BY industry_branch, "year";