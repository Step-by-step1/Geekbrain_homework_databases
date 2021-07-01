USE shop;
DROP FUNCTION IF EXISTS FIBONACCI;

DELIMITER //

CREATE FUNCTION FIBONACCI(num INT)
	RETURNS INT DETERMINISTIC
	BEGIN
		DECLARE a, b, c, counter INT;
		SET counter = 1;
		SET a = 0;
		SET b = 1;
		IF num = 0 THEN SET c = 0;
		ELSE
			WHILE counter < num DO
				SET c = a + b;
				SET a = b;
				SET b = c;
				SET counter = counter + 1;
			END WHILE;
		END IF;
		RETURN c;			
	END
//
DELIMITER ;
SELECT FIBONACCI(10);


