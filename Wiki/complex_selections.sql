USE wiki;

-- Выборка 20-ти статей с наибольшим числом ревизий
SELECT  t2.title article, t1.revisions FROM 
	(SELECT article_id, COUNT(article_id) - 1 revisions FROM history GROUP BY article_id ORDER BY COUNT(article_id) DESC) t1
	JOIN articles t2 ON t1.article_id = t2.id LIMIT 20;

-- Выборка, показывающая активность пользователей в области публикаций и ревизий статей
SELECT t3.name users_name, t2.publications FROM 
	(SELECT published_by, COUNT(published_by) publications FROM 
		(SELECT id, published_by FROM articles UNION SELECT article_id, amended_by FROM history) t1 
		GROUP BY published_by) t2 
	JOIN users t3 ON t2.published_by = t3.id ORDER BY publications DESC;

-- Выборка 20-ти наиболее обсуждаемых статей
SELECT t2.title article, t1.`references` FROM 
	(SELECT article_id, COUNT(article_id) `references` FROM talk GROUP BY article_id) t1
	JOIN articles t2 ON t1.article_id = t2.id ORDER BY `references` DESC LIMIT 20;

-- Ранжировка топиков по обсуждаемости
SELECT t3.topic, t2.`references` FROM (SELECT topic_id, COUNT(topic_id) `references` FROM 
	(SELECT id, topic_id FROM reference_desk_questions UNION SELECT id, topic_id FROM reference_desk_answers) t1
	GROUP BY topic_id) t2 JOIN reference_desk_topics t3 ON t2.topic_id = t3.id ORDER BY `references` DESC;

-- Ранжировка пользователей по "болтливости" в teahouse_forum_talk
SELECT t2.name users_name, t1.messages FROM 
	(SELECT written_by, COUNT(written_by) messages FROM teahouse_forum_talk GROUP BY written_by) t1
	JOIN users t2 ON t1.written_by = t2.id ORDER BY messages DESC;

