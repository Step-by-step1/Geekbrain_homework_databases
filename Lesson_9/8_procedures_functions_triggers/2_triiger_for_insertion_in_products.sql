USE shop;
DELIMITER //
CREATE TRIGGER check_products_insertion BEFORE INSERT ON products
	FOR EACH ROW BEGIN
		IF NEW.name IS NULL AND NEW.description IS NULL THEN
			SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'INSERT canceled';
		END IF;
	END
//

DELIMITER ;

INSERT INTO products (name, description, price, catalog_id) VALUES ('item1', 'description1', 123, 1);
	
INSERT INTO products (name, description, price, catalog_id) VALUES (NULL, 'description2', 456, 1);
INSERT INTO products (name, description, price, catalog_id) VALUES ('item3', NULL, 1234, 1);
INSERT INTO products (name, description, price, catalog_id) VALUES (NULL, NULL, 123, 1);

SELECT * FROM products;