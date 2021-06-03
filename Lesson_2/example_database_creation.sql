CREATE DATABASE IF NOT EXISTS example;
USE example;
CREATE TABLE IF NOT EXISTS users(id int, name varchar(255));
INSERT INTO users VALUES(1, 'first'), (2, 'second');