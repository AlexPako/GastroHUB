-- повышаем цены на капучино на 20% во всех кофейнях
-- FOR UPDATE блокирует строки которые обновляем, чтобы никто не мешал

BEGIN;

SELECT restaurant_uuid
FROM cafe.restaurants
WHERE type = 'coffee_shop'
    AND (menu -> 'Кофе') ? 'Капучино'
FOR UPDATE;

WITH updated_prices AS (
    SELECT
        restaurant_uuid,
        jsonb_set(
            menu,
            '{Кофе, Капучино}',
            to_jsonb(ROUND((menu -> 'Кофе' ->> 'Капучино')::numeric * 1.2))
        ) AS new_menu
    FROM cafe.restaurants
    WHERE type = 'coffee_shop'
        AND (menu -> 'Кофе') ? 'Капучино'
)
UPDATE cafe.restaurants
SET menu = updated_prices.new_menu
FROM updated_prices
WHERE cafe.restaurants.restaurant_uuid = updated_prices.restaurant_uuid;

COMMIT;
