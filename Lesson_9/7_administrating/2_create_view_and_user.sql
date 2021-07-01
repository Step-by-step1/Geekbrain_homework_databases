DROP DATABASE IF EXISTS task_2;
CREATE DATABASE task_2;
USE task_2;
DROP TABLE IF EXISTS accounts;
CREATE TABLE accounts (
id SERIAL PRIMARY KEY,
name VARCHAR(30),
`password` VARCHAR(30))
;
INSERT INTO accounts (name, `password`) 
 VALUES ('user1', '123'),
		('user2', '456'),
		('user3', '789'),
		('user4', 'abc'),
		('user5', 'def')
;
SELECT * FROM accounts;
DROP VIEW IF EXISTS username;
CREATE VIEW username AS SELECT id, name FROM accounts;
SELECT * FROM username;
DROP USER IF EXISTS user_read;
CREATE USER user_read;
GRANT SELECT ON username TO user_read;
