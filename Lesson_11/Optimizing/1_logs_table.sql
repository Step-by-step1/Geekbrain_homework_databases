USE shop;
CREATE TABLE IF NOT EXISTS logs (
created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
table_name CHAR(8) NOT NULL,
primary_key BIGINT UNSIGNED NOT NULL,
name VARCHAR(255) NOT NULL) ENGINE=Archive;

DROP TRIGGER IF EXISTS users_insertion;
DROP TRIGGER IF EXISTS catalogs_insertion;
DROP TRIGGER IF EXISTS products_insertion;
DELIMITER //
CREATE TRIGGER users_insertion AFTER INSERT ON users
FOR EACH ROW
BEGIN
	INSERT INTO logs(table_name, primary_key, name) VALUES 
		('users', NEW.id, NEW.name);
END//
CREATE TRIGGER catalogs_insertion AFTER INSERT ON catalogs
FOR EACH ROW
BEGIN
	INSERT INTO logs(table_name, primary_key, name) VALUES 
		('catalogs', NEW.id, NEW.name);
END//
CREATE TRIGGER products_insertion AFTER INSERT ON products
FOR EACH ROW
BEGIN
	INSERT INTO logs(table_name, primary_key, name) VALUES 
		('products', NEW.id, NEW.name);
END//
DELIMITER ;
INSERT INTO users (name, birthday_at) VALUES
  ('Степан', '1990-12-31');
INSERT INTO products
  (name, price, catalog_id)
VALUES
  ('Intel Core i7-8110', 9000.00, 1);
INSERT INTO catalogs VALUES
  (NULL, 'Охлаждение');
SELECT * FROM logs;

