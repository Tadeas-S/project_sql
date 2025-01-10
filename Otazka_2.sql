--Otázka 2: Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?
SELECT round(avg(price_value)::NUMERIC, 2) AS avg_price,
	  "year",
	  price_name,
	  round(avg(payroll_value)::NUMERIC, 02) AS avg_payroll,
	  round(avg(payroll_value) / avg(price_value)::NUMERIC, 2) AS count_price_category_name,
	  price_unit 
FROM t_tadeas_stanovsky_project_sql_primary_final tt 
WHERE price_name IN ('Mléko polotučné pasterované', 'Chléb konzumní kmínový')
	  AND "year" IN (2006, 2018)
	  AND payroll_value_type_code = 5958