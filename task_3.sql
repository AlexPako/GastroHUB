-- топ-3 заведения где больше всего менялись менеджеры

SELECT
    r.name AS cafe_name,
    COUNT(*) AS manager_changes
FROM cafe.restaurant_manager_work_dates wd
JOIN cafe.restaurants r ON r.restaurant_uuid = wd.restaurant_uuid
GROUP BY r.name
ORDER BY manager_changes DESC
LIMIT 3;
