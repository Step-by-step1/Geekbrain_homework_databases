CREATE DATABASE IF NOT EXISTS shop;
USE shop;
DROP TABLE IF EXISTS users;
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT 'Имя покупателя',
  birthday_at DATE COMMENT 'Дата рождения',
  created_at DATETIME,
  updated_at DATETIME
) COMMENT = 'Покупатели';

INSERT INTO users (name, birthday_at) VALUES
  ('Геннадий', '1990-10-05'),
  ('Наталья', '1984-11-12'),
  ('Александр', '1985-05-20'),
  ('Сергей', '1988-02-14'),
  ('Иван', '1998-01-12'),
  ('Мария', '1992-06-12');
 
SELECT DAYNAME(DATE(CONCAT('2021', SUBSTRING(birthday_at, 5, 6)))) FROM users;
  
SELECT COUNT(*) AS num, DAYNAME(DATE(CONCAT('2021',SUBSTRING(birthday_at, 5, 6)))) AS birthday FROM users GROUP BY birthday;