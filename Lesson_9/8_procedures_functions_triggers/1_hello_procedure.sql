USE shop;

DROP PROCEDURE IF EXISTS hello;

DELIMITER //
CREATE PROCEDURE hello()
	BEGIN
		DECLARE phrase VARCHAR(30);
		SELECT 
			CASE
				WHEN TIME(NOW()) >= '00:00:00' AND TIME(NOW()) <= '06:00:00' THEN 'Доброй ночи!'
				WHEN TIME(NOW()) > '06:00:00' AND TIME(NOW()) <= '12:00:00' THEN 'Доброе утро!'
				WHEN TIME(NOW()) > '12:00:00' AND TIME(NOW()) <= '18:00:00' THEN 'Добрый день!'
				ELSE 'Добрый вечер!'
			END;
		SELECT phrase;
	END
//

CALL hello();