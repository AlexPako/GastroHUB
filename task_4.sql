-- пиццерия с наибольшим количеством пицц в меню

WITH pizza_items AS (
    SELECT
        r.name AS cafe_name,
        p.key AS pizza_name
    FROM cafe.restaurants r,
    json_each_text((r.menu -> 'Пицца')::json) AS p
    WHERE r.type = 'pizzeria'
),
counts AS (
    SELECT
        cafe_name,
        COUNT(*) AS pizza_count,
        DENSE_RANK() OVER (ORDER BY COUNT(*) DESC) AS rnk
    FROM pizza_items
    GROUP BY cafe_name
)
SELECT
    cafe_name,
    pizza_count
FROM counts
WHERE rnk = 1;
