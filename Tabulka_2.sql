/*
 * Příprava sekundární tabulky
 */


CREATE TABLE t_tadeas_stanovsky_project_sql_secondary_final AS 
SELECT c.*,
	   e."year",
	   e.gdp,
	   e.gini,
	   e.taxes,
	   e.fertility,
	   e.mortaliy_under5
FROM countries c
LEFT JOIN economies e
	 ON c.country = e.country;