CREATE USER shop_read;
CREATE USER shop;
GRANT SELECT ON shop.* TO shop_read;
GRANT ALL ON shop.* TO shop;