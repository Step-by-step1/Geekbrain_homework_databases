USE shop;

CREATE VIEW products_vs_catalogs AS SELECT products.name AS product_name, catalogs.name AS catalog_name FROM
	products JOIN catalogs ON catalogs.id = products.catalog_id;
	
SELECT * FROM products_vs_catalogs;