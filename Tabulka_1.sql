/*
 * Příprava primární tabulky
 * 
 */

--Agregace dat z kvartálu na roky a čištění NULL hodnot--


CREATE TABLE czechia_payroll_per_year AS 
SELECT
	round(avg(value)::NUMERIC, 0) AS payroll_value,
	payroll_year,
	industry_branch_code,
	value_type_code,
	unit_code,
	calculation_code 
FROM czechia_payroll cp
WHERE industry_branch_code IS NOT NULL
GROUP BY payroll_year,industry_branch_code, value_type_code, unit_code, calculation_code 
ORDER BY payroll_year,industry_branch_code;


 --Integrace foreign tabulek do czechia_payroll--

CREATE TABLE czechia_payroll_integrated AS 
SELECT cpy.*,
       cpib.name AS industry_branch,
       cpu.name AS payroll_unit,
       cpvt.name AS payroll_value_type
FROM czechia_payroll_per_year cpy
LEFT JOIN czechia_payroll_industry_branch cpib 
    ON cpy.industry_branch_code = cpib.code 
LEFT JOIN czechia_payroll_unit cpu 
    ON cpy.unit_code = cpu.code 
LEFT JOIN czechia_payroll_value_type cpvt
    ON cpy.value_type_code = cpvt.code;
    
--Integrace foreign tabulek do czechia_price, typecast a redukce dat--

CREATE TABLE czechia_price_integrated AS
SELECT 
	 round(avg(cpr.value)::NUMERIC, 2) AS avg_price,
	 date_part('year', cpr.date_from) AS year,
	 cpc.code,
	 cpc.name,
	 cpc.price_value,
	 cpc.price_unit
FROM czechia_price cpr
LEFT JOIN czechia_price_category cpc
    ON cpr.category_code = cpc.code
WHERE region_code IS NULL
GROUP BY 
		date_part('year', cpr.date_from),
		cpc.name,
		cpc.price_value,
		cpc.price_unit,
		cpc.code
ORDER BY cpc.name, date_part('year', cpr.date_from)


--Finální tvorba primární tabulky--
    
CREATE TABLE t_tadeas_stanovsky_project_sql_primary_final AS 
SELECT  
		a.avg_price AS price_value,
		a."year",
		a.name AS price_name,
		a.price_value AS price_value_unit,
		a.price_unit,
		b.payroll_value,
		b.value_type_code AS payroll_value_type_code,
		b.unit_code AS payroll_unit_code,
		b.industry_branch_code,
		b.industry_branch,
		b.payroll_unit,
		b.payroll_value_type
FROM czechia_price_integrated a
JOIN czechia_payroll_integrated b
	ON a."year" = b.payroll_year


	