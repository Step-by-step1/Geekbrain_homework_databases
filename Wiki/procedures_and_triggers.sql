USE wiki;
DROP TRIGGER IF EXISTS tr_articles_update_access_type;
DROP PROCEDURE IF EXISTS pr_update_an_article;
DROP PROCEDURE IF EXISTS pr_create_an_article;
DROP PROCEDURE IF EXISTS pr_add_user;
DROP PROCEDURE IF EXISTS pr_talk_on_article;
DROP PROCEDURE IF EXISTS pr_open_teahouse_topic;
DROP PROCEDURE IF EXISTS pr_teahouse_forum_talk;
DROP PROCEDURE IF EXISTS pr_reference_desk_question;
DROP PROCEDURE IF EXISTS pr_reference_desk_answer;


DELIMITER //
-- Триггер для проверки права редактирования статьи
CREATE TRIGGER tr_articles_update_access_type BEFORE UPDATE ON articles
	FOR EACH ROW
	BEGIN
		IF (SELECT access_types.access_type FROM access_types WHERE id = OLD.access_type) = 'admins' AND
			(NOT EXISTS(SELECT * FROM admins WHERE user_id = NEW.latest_amendment_by) OR NEW.latest_amendment_by IS NULL) THEN 
				SIGNAL SQLSTATE '45000'
				SET MESSAGE_TEXT = 'Only admins can amend this article';
		ELSEIF (SELECT access_types.access_type FROM access_types WHERE id = OLD.access_type) = 'users' AND
			(NOT EXISTS(SELECT * FROM users WHERE id = NEW.latest_amendment_by) OR NEW.latest_amendment_by IS NULL) THEN 
				SIGNAL SQLSTATE '45000'
				SET MESSAGE_TEXT = 'Only registeres users can amend this article';
		END IF;
	END
//

-- Процедура для рецензирования статьи
CREATE PROCEDURE pr_update_an_article (IN id BIGINT, IN contents TEXT, IN amended_by BIGINT)
	BEGIN
		START TRANSACTION;
		INSERT INTO history (article_id, contents, amended_by, amended_at)
		SELECT ar.id, ar.contents, ar.latest_amendment_by, ar.latest_amendment_at FROM articles ar WHERE ar.id = id;
		UPDATE articles ar SET 
			ar.contents = contents, 
			ar.latest_amendment_by = amended_by, 
			ar.latest_amendment_at = CURRENT_TIMESTAMP 
			WHERE ar.id = id; 
		COMMIT;
	END
//

-- Прцедура для создания статьи
CREATE PROCEDURE pr_create_an_article (IN creator_id BIGINT, IN title VARCHAR(255), IN contents TEXT, IN access_type BIGINT)
	BEGIN
		START TRANSACTION;
		INSERT INTO articles (title, contents, published_by, access_type) VALUES (title, contents, creator_id, access_type);
		SET @last_article_id := LAST_INSERT_ID();
		INSERT INTO history (article_id, contents) VALUES (@last_article_id, contents);
	COMMIT;
	END
//

-- Тригер для проверки правильности задания прав редактирования при создании статьи
CREATE TRIGGER tr_articles_create_access_type BEFORE INSERT ON articles
FOR EACH ROW
	BEGIN
	IF NOT EXISTS(SELECT * FROM admins WHERE user_id = NEW.published_by) AND NEW.access_type = 3 THEN
		SIGNAL SQLSTATE '45000'	SET MESSAGE_TEXT = 'Articles created by registered users may still be amended by admins';
	ELSEIF NEW.published_by IS NULL AND NEW.access_type <> 1 THEN 
		SIGNAL SQLSTATE '45000'	SET MESSAGE_TEXT = 'Articles created by unregistered users are subject to unrestricted access';	
	END IF;
	END
//

-- Процедура для добавления пользователя
CREATE PROCEDURE pr_add_user (IN name VARCHAR(40), IN `password` VARCHAR(40), IN email VARCHAR(40), IN is_admin BOOL)
	BEGIN
		START TRANSACTION;
		INSERT INTO users (name, `password`, email) VALUES (name, `password`, email);
		IF is_admin = TRUE THEN
			SET @new_user_id := LAST_INSERT_ID(); 
			INSERT INTO admins (user_id, name, `password`, email) VALUES (@new_user_id, name, `password`, email);
		END IF;
	END
//

-- Процедура для форума по статьям
CREATE PROCEDURE pr_talk_on_article (IN user_id BIGINT, IN article_id BIGINT, IN contents TEXT)
	BEGIN 
		INSERT INTO talk (article_id, contents, published_by) VALUES (article_id, contents, user_id);
	END
//

-- Процедура для создания топика teahouse
CREATE PROCEDURE pr_open_teahouse_topic (IN topic VARCHAR(255), IN user_id BIGINT)
	BEGIN
		INSERT INTO teahouse_forum_topics (topic, opened_by) VALUES (topic, user_id);
	END
//

-- Процедура для форума teahouse
CREATE PROCEDURE pr_teahouse_forum_talk (IN topic_id BIGINT, IN contents TEXT, IN user_id BIGINT)
	BEGIN
		INSERT INTO teahouse_forum_talk (topic_id, contents, written_by) VALUES (topic_id, contents, user_id);
	END
//

-- Процедура для того, что бы задать вопрос в reference_desk
CREATE PROCEDURE pr_reference_desk_question (IN question TEXT, IN topic_id BIGINT, IN user_id BIGINT)
	BEGIN
		INSERT INTO reference_desk_questions (question, topic_id, question_by) VALUES (question, topic_id, user_id);
	END
//

-- Процедура для ответов в reference_desk
CREATE PROCEDURE pr_reference_desk_answer (IN answer TEXT, IN topic_id BIGINT, IN question_id BIGINT, IN user_id BIGINT)
	BEGIN
		INSERT INTO reference_desk_answers (answer, topic_id, question_id, answer_by) 
		VALUES (answer, topic_id, question_id, user_id);
	END
//

DELIMITER ;
