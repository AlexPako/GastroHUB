-- самая дорогая пицца в каждой пиццерии

WITH pizzas AS (
    SELECT
        r.name AS cafe_name,
        'Пицца' AS dish_type,
        p.key AS pizza_name,
        p.value::int AS price
    FROM cafe.restaurants r,
    json_each_text((r.menu -> 'Пицца')::json) AS p
    WHERE r.type = 'pizzeria'
),
ranked AS (
    SELECT
        cafe_name,
        dish_type,
        pizza_name,
        price,
        ROW_NUMBER() OVER (PARTITION BY cafe_name ORDER BY price DESC) AS rn
    FROM pizzas
)
SELECT
    cafe_name,
    dish_type,
    pizza_name,
    price
FROM ranked
WHERE rn = 1
ORDER BY cafe_name;
