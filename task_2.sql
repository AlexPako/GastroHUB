-- средний чек по годам и как он меняется, 2023 не берём (данные неполные)

CREATE MATERIALIZED VIEW cafe.mv_avg_check_by_year AS
WITH by_year AS (
    SELECT
        EXTRACT(YEAR FROM s.sale_date)::int AS year,
        r.name AS cafe_name,
        r.type::varchar AS cafe_type,
        ROUND(AVG(s.avg_check), 2) AS avg_check
    FROM cafe.sales s
    JOIN cafe.restaurants r ON s.restaurant_uuid = r.restaurant_uuid
    WHERE EXTRACT(YEAR FROM s.sale_date) != 2023
    GROUP BY EXTRACT(YEAR FROM s.sale_date), r.name, r.type
)
SELECT
    year,
    cafe_name,
    cafe_type,
    avg_check AS current_avg_check,
    LAG(avg_check) OVER (PARTITION BY cafe_name ORDER BY year) AS prev_avg_check,
    ROUND(
        (avg_check - LAG(avg_check) OVER (PARTITION BY cafe_name ORDER BY year))
        / LAG(avg_check) OVER (PARTITION BY cafe_name ORDER BY year) * 100,
    2) AS avg_check_diff_pct
FROM by_year
ORDER BY cafe_name, year;
