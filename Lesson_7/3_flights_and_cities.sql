DROP DATABASE IF EXISTS test;
CREATE DATABASE test;
USE test;

CREATE TABLE cities (
label CHAR(3),
city VARCHAR(255),
KEY label_index (label));

CREATE TABLE flights (
`id` BIGINT UNSIGNED NOT NULL PRIMARY KEY,
`from` CHAR(3),
`to` CHAR(3), 
CONSTRAINT `fk_from_city` FOREIGN KEY (`from`) REFERENCES cities (label),
CONSTRAINT `fk_to_city` FOREIGN KEY (`to`) REFERENCES cities (label)
);


INSERT INTO cities VALUES
('TYO', 'Токио'),
('VLO', 'Владивосток'),
('SIN', 'Сингапур'),
('SHA', 'Шанхай'),
('ICH', 'Инчхон'),
('LAX', 'Лос Анжелес'),
('SEA', 'Сиэтл'),
('PUS', 'Пусан');

SELECT * FROM cities;

INSERT INTO flights VALUES
(1287, 'TYO', 'VLO'),
(9937, 'ICH', 'SIN'),
(1589, 'SHA', 'PUS'),
(5457, 'LAX', 'SEA');

SELECT * FROM flights;


SELECT flights.id, cities.city AS `from`, _cities.city AS `to` 
	FROM flights 
	LEFT JOIN cities ON flights.`from` = cities.label 
	LEFT JOIN cities AS _cities ON flights.`to` = _cities.label;

