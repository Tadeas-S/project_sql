--Otázka 3: Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)?

WITH price_difference AS (
		SELECT
			YEAR,
			round(avg(price_value)::NUMERIC, 2) AS avg_price,
			price_name,
			price_unit
		FROM t_tadeas_stanovsky_project_sql_primary_final
		GROUP BY price_value, price_name, YEAR, price_unit
		ORDER BY price_name, year 
)
SELECT
	price_name,
	min(avg_price),
	max(avg_price),
	round(((max(avg_price) / min(avg_price)) * 100)::NUMERIC, 2)
FROM price_difference
GROUP BY price_name
ORDER BY round(((max(avg_price) / min(avg_price)) * 100)::NUMERIC, 2) ASC 
LIMIT 1;
