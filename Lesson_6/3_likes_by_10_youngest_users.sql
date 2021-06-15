USE vk;

-- Покажем 10 самых молодых пользователей:

SELECT user_id FROM profiles ORDER BY TIMESTAMPDIFF(YEAR, birthday, NOW()) LIMIT 10;

-- Посчитаем количество лайков:

SELECT COUNT(*) FROM posts_likes WHERE user_id IN (SELECT * FROM (SELECT user_id FROM profiles ORDER BY TIMESTAMPDIFF(YEAR, birthday, NOW()) LIMIT 10) temp_table);