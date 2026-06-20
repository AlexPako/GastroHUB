-- заполняю таблицы данными из raw_data
-- важно: сначала рестораны и менеджеры, потом остальное, иначе ошибка с ключами

INSERT INTO cafe.restaurants (name, type, menu)
SELECT DISTINCT ON (s.cafe_name)
    s.cafe_name,
    s.type::cafe.restaurant_type,
    m.menu
FROM raw_data.sales s
LEFT JOIN raw_data.menu m ON s.cafe_name = m.cafe_name;

INSERT INTO cafe.managers (name, phone)
SELECT DISTINCT manager, manager_phone
FROM raw_data.sales;

INSERT INTO cafe.restaurant_manager_work_dates (restaurant_uuid, manager_uuid, start_date, end_date)
SELECT
    r.restaurant_uuid,
    m.manager_uuid,
    MIN(s.report_date),
    MAX(s.report_date)
FROM raw_data.sales s
JOIN cafe.restaurants r ON r.name = s.cafe_name
JOIN cafe.managers m ON m.name = s.manager
GROUP BY r.restaurant_uuid, m.manager_uuid;

INSERT INTO cafe.sales (sale_date, restaurant_uuid, avg_check)
SELECT
    s.report_date,
    r.restaurant_uuid,
    s.avg_check
FROM raw_data.sales s
JOIN cafe.restaurants r ON r.name = s.cafe_name;
