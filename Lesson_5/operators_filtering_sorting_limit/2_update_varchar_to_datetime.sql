CREATE DATABASE IF NOT EXISTS shop;
USE shop;
DROP TABLE IF EXISTS users;
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT 'Имя покупателя',
  birthday_at DATE COMMENT 'Дата рождения',
  created_at VARCHAR(255),
  updated_at VARCHAR(255)
) COMMENT = 'Покупатели';

INSERT INTO users (name, birthday_at, created_at, updated_at) VALUES
  ('Геннадий', '1990-10-05', '20.10.2017 8:10', '21.10.2017 9:10'),
  ('Наталья', '1984-11-12', '22.10.2017 8:11', '23.10.2017 9:11'),
  ('Александр', '1985-05-20', '24.10.2017 8:12', '25.10.2017 9:12'),
  ('Сергей', '1988-02-14', '25.10.2017 8:13', '26.10.2017 9:13'),
  ('Иван', '1998-01-12', '27.10.2017 8:14', '28.10.2017 9:14'),
  ('Мария', '1992-08-29', '29.10.2017 8:15', '30.10.2017 9:15');
  
SELECT * FROM users;



UPDATE users
SET created_at = CONCAT(SUBSTRING(created_at, 7, 4), '-', SUBSTRING(created_at, 4, 2), '-', SUBSTRING(created_at, 1, 2), ' ', SUBSTRING(created_at, -5, 5)),
	updated_at = CONCAT(SUBSTRING(updated_at, 7, 4), '-', SUBSTRING(updated_at, 4, 2), '-', SUBSTRING(updated_at, 1, 2), ' ', SUBSTRING(updated_at, -5, 5));
ALTER TABLE users
	MODIFY created_at DATETIME,
	MODIFY updated_at DATETIME;
SELECT * FROM users;
DESCRIBE users;

	





