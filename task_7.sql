-- обновляем телефоны менеджеров: новый номер 8-800-2500-NNN, NNN от 100 по алфавиту
-- LOCK TABLE блокирует таблицу для изменений, но читать всё равно можно

BEGIN;

LOCK TABLE cafe.managers IN SHARE ROW EXCLUSIVE MODE;

ALTER TABLE cafe.managers ADD COLUMN phones varchar[];

WITH numbered AS (
    SELECT
        manager_uuid,
        phone,
        ROW_NUMBER() OVER (ORDER BY name) AS rn
    FROM cafe.managers
),
new_numbers AS (
    SELECT
        manager_uuid,
        phone AS old_phone,
        CONCAT('8-800-2500-', (99 + rn)::varchar) AS new_phone
    FROM numbered
)
UPDATE cafe.managers m
SET phones = ARRAY[n.new_phone, n.old_phone]
FROM new_numbers n
WHERE m.manager_uuid = n.manager_uuid;

ALTER TABLE cafe.managers DROP COLUMN phone;

COMMIT;
