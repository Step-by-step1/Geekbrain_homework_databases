USE vk;

-- Выведем все действия пользователей как одну таблицу:

SELECT user_id AS u_id, COUNT(*) AS activity FROM communities_users GROUP BY u_id
UNION
SELECT from_user_id AS u_id, COUNT(*) AS activity FROM friend_requests GROUP BY u_id
UNION
SELECT from_user_id AS u_id, COUNT(*) AS activity FROM messages GROUP BY u_id
UNION
SELECT user_id as u_id, COUNT(*) AS activity FROM posts GROUP BY u_id
UNION
SELECT user_id as u_id, COUNT(*) AS activity FROM posts_likes GROUP BY u_id;

-- Просуммируем все действия для каждого пользователя, отсортируем по возрастанию и выведем первую строку:

SELECT u_id, SUM(activity) AS activities FROM (SELECT user_id AS u_id, COUNT(*) AS activity FROM communities_users GROUP BY u_id
UNION
SELECT from_user_id AS u_id, COUNT(*) AS activity FROM friend_requests GROUP BY u_id
UNION
SELECT from_user_id AS u_id, COUNT(*) AS activity FROM messages GROUP BY u_id
UNION
SELECT user_id as u_id, COUNT(*) AS activity FROM posts GROUP BY u_id
UNION
SELECT user_id as u_id, COUNT(*) AS activity FROM posts_likes GROUP BY u_id) AS my_table
GROUP BY u_id ORDER BY activities LIMIT 1;


