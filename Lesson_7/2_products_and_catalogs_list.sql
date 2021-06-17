USE shop;

INSERT INTO products VALUES
(DEFAULT, 'Intel Core i3-8100', 'x', 1500, 1, DEFAULT, DEFAULT),
(DEFAULT, 'Intel Core i5-7400', 'x', 1500, 1, DEFAULT, DEFAULT),
(DEFAULT, 'ASUS ROG MAXIMUS X HERO', 'x', 1500, 2, DEFAULT, DEFAULT),
(DEFAULT, 'Gigabyte H310M S2H', 'x', 1500, 2, DEFAULT, DEFAULT),
(DEFAULT, 'Radeon RX 580 8GB', 'x', 1500, 3, DEFAULT, DEFAULT);

SELECT * FROM products;

SELECT * FROM catalogs;

SELECT products.name AS product_name, catalogs.name AS catalog_name 
	FROM products JOIN catalogs ON products.catalog_id = catalogs.id;