USE vk;

-- Выберем случайный id пользователя

SET @random_id:= (SELECT id FROM users ORDER BY RAND() LIMIT 1);
SELECT @random_id;

-- Покажем все запросы в друзья от пользователя и к нему

SELECT * FROM friend_requests WHERE from_user_id = @random_id OR to_user_id = @random_id;

-- Покажем только запросы, которые имеют статус 'accepted'

SELECT from_user_id AS friend_id FROM friend_requests
	WHERE to_user_id = @random_id AND request_type = (SELECT id FROM friend_requests_types WHERE name = 'accepted')
	UNION
SELECT to_user_id AS friend_id FROM friend_requests
	WHERE from_user_id = @random_id AND request_type = (SELECT id FROM friend_requests_types WHERE name = 'accepted');

-- Покажем все письма, посланные пользователю

SELECT * FROM messages WHERE to_user_id = @random_id;

-- Запрос на выбор друга пользователя, пославшего ему наибольшее количество сообщений

SELECT COUNT(*) AS num_messages, from_user_id FROM messages WHERE to_user_id = @random_id 
	AND from_user_id IN 
		(SELECT from_user_id AS friend_id FROM friend_requests
			WHERE to_user_id = @random_id AND request_type = (SELECT id FROM friend_requests_types WHERE name = 'accepted')
			UNION
		SELECT to_user_id AS friend_id FROM friend_requests
			WHERE from_user_id = @random_id AND request_type = (SELECT id FROM friend_requests_types WHERE name = 'accepted'))
	GROUP BY from_user_id ORDER BY num_messages DESC LIMIT 1;
		

