USE vk;

-- Выведем id пользователей с определённым полом (не 'x'):

SELECT user_id, gender FROM profiles WHERE gender IN('m', 'f') ORDER BY gender;

-- Покажем все лайки пользователей из предыдущей выборки:

SELECT * FROM posts_likes WHERE user_id IN (SELECT user_id FROM profiles WHERE gender IN('m', 'f') ORDER BY gender);

-- Посчитаем количество лайков поставленных мужчинами и женщинами, отсортируем по убыванию и возьмём верхнее значение:

SELECT COUNT(*) AS likes, (SELECT gender FROM profiles WHERE posts_likes.user_id = profiles.user_id) AS gender 
	FROM posts_likes WHERE user_id IN (SELECT user_id FROM profiles WHERE gender IN ('m', 'f') ORDER BY gender) 
	GROUP BY  gender ORDER BY likes DESC LIMIT 1;