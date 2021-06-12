CREATE DATABASE IF NOT EXISTS shop;
USE shop;
DROP TABLE IF EXISTS storehouses_products;
DROP TABLE IF EXISTS storehouses_products;
CREATE TABLE storehouses_products (
  id SERIAL PRIMARY KEY,
  storehouse_id INT UNSIGNED,
  product_id INT UNSIGNED,
  value INT UNSIGNED COMMENT 'Запас товарной позиции на складе',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = 'Запасы на складе';
INSERT INTO storehouses_products
  (storehouse_id, product_id, value)
VALUES
  (1, 11, 1),
  (2, 12, 29),
  (3, 13, 6),
  (4, 14, 0),
  (5, 15, 51),
  (6, 16, 14),
  (7, 17, 7),
  (8, 18, 0),
  (9, 19, 7),
  (1, 20, 44),
  (2, 21, 17),
  (3, 22, 0),
  (4, 23, 10),
  (5, 24, 8),
  (6, 25, 3);
  
SELECT * FROM storehouses_products;

SELECT * FROM storehouses_products ORDER BY value = 0, value ASC;

