USE wiki;
-- Представление, показывающее статьи с правами редактирования тольео для админов
CREATE VIEW articles_by_admins AS
	SELECT * FROM articles WHERE published_by IN (SELECT id FROM admins) AND access_type = (SELECT id FROM access_types WHERE access_type = 'admins');

-- Представление, показывающее сколько вопросов было задано и сколько ответов было дано по топикам.
CREATE VIEW reference_desk_topics_status AS
	SELECT t3.id, t3.topic, t3.questions, t4.answers FROM 
		(SELECT t1.id, t1.topic, t2.questions FROM reference_desk_topics t1 
		JOIN (SELECT topic_id, COUNT(topic_id) questions FROM reference_desk_questions GROUP BY topic_id) t2 
		ON t1.id = t2.topic_id) t3 
		JOIN (SELECT topic_id, COUNT(topic_id) answers FROM reference_desk_answers GROUP BY topic_id) t4 
		ON t3.id = t4.topic_id ORDER BY id;
SELECT * FROM reference_desk_topics_status;
