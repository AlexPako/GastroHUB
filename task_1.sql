-- топ-3 заведения по среднему чеку внутри каждого типа

CREATE VIEW cafe.v_top3_restaurants_by_type AS
WITH avg_check AS (
    SELECT
        r.name AS cafe_name,
        r.type::varchar AS cafe_type,
        ROUND(AVG(s.avg_check), 2) AS avg_check
    FROM cafe.sales s
    JOIN cafe.restaurants r ON s.restaurant_uuid = r.restaurant_uuid
    GROUP BY r.name, r.type
),
with_rank AS (
    SELECT
        cafe_name,
        cafe_type,
        avg_check,
        ROW_NUMBER() OVER (PARTITION BY cafe_type ORDER BY avg_check DESC) AS place
    FROM avg_check
)
SELECT
    cafe_name,
    cafe_type,
    avg_check
FROM with_rank
WHERE place <= 3
ORDER BY cafe_type, avg_check DESC;
