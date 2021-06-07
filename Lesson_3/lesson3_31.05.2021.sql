DROP DATABASE IF EXISTS vk;
CREATE DATABASE IF NOT EXISTS vk;

-- используем БД vk
USE vk;

CREATE TABLE users(
	id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
	first_name VARCHAR(150) NOT NULL COMMENT "Имя", 
	last_name VARCHAR(150) NOT NULL,
	email VARCHAR(150) NOT NULL UNIQUE,
	phone CHAR(11) NOT NULL,
	password_hash CHAR(80) DEFAULT NULL,
	created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP, -- NOW()
	INDEX users_email_idx (email),
	UNIQUE INDEX users_phone_unique_idx (phone)
);

-- 1:1 связь
CREATE TABLE profiles (
	user_id SERIAL PRIMARY KEY, -- ? BIGINT UNSIGNED PRIMARY KEY
	gender ENUM('f', 'm', 'x'),
	birthday DATE NOT NULL,
	photo_id BIGINT UNSIGNED,
	city VARCHAR(130),
	country VARCHAR(130),
	FOREIGN KEY (user_id) REFERENCES users(id)	
);

CREATE TABLE media (
	id SERIAL PRIMARY KEY,
	user_id BIGINT UNSIGNED NOT NULL,
	media_types_id BIGINT UNSIGNED NOT NULL,
	file_name VARCHAR(200),
	file_size BIGINT UNSIGNED,
	created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
	INDEX media_media_types_idx (media_types_id),
  	INDEX media_users_idx (user_id)
);

CREATE TABLE media_types (
	id SERIAL PRIMARY KEY,
	name VARCHAR(200) NOT NULL UNIQUE
);

-- добавляем внешний ключ
ALTER TABLE media ADD FOREIGN KEY (media_types_id) REFERENCES media_types(id);

-- добавляем внешний ключ с именем ограничения
ALTER TABLE media ADD CONSTRAINT fk_media_users FOREIGN KEY (user_id) REFERENCES users(id);

CREATE TABLE messages (
	id SERIAL PRIMARY KEY,
	from_user_id BIGINT UNSIGNED NOT NULL,
	to_user_id BIGINT UNSIGNED NOT NULL,
	txt TEXT NOT NULL,
	is_delivered BOOL DEFAULT false,
	created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	KEY (from_user_id),
	KEY (to_user_id),
	CONSTRAINT fk_messages_users_1 FOREIGN KEY (from_user_id) REFERENCES users (id),
	CONSTRAINT fk_messages_users_2 FOREIGN KEY (to_user_id) REFERENCES users (id)
);

CREATE TABLE friend_requests (
  from_user_id BIGINT UNSIGNED NOT NULL,
  to_user_id BIGINT UNSIGNED NOT NULL,
  accepted BOOLEAN DEFAULT False,
  PRIMARY KEY (from_user_id, to_user_id),
  KEY (from_user_id),
  KEY (to_user_id),
  CONSTRAINT fk_friend_requests_users_1 FOREIGN KEY (from_user_id) REFERENCES users (id),
  CONSTRAINT fk_friend_requests_users_2 FOREIGN KEY (to_user_id) REFERENCES users (id)
);

CREATE TABLE communities (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(145) NOT NULL,
  description VARCHAR(245) DEFAULT NULL
);

-- Таблица связи пользователей и сообществ
CREATE TABLE communities_users (
	community_id BIGINT UNSIGNED NOT NULL,
	user_id BIGINT UNSIGNED NOT NULL,
	PRIMARY KEY (community_id, user_id),
	KEY (community_id),
  	KEY (user_id),
  	CONSTRAINT fk_communities_users_comm FOREIGN KEY (community_id) REFERENCES communities (id),
  	CONSTRAINT fk_communities_users_users FOREIGN KEY (user_id) REFERENCES users (id)
);

-- совершенствуем таблицу дружбы
-- добавляем ограничение, что отправитель запроса на дружбу 
-- не может быть одновременно и получателем
ALTER TABLE friend_requests 
ADD CONSTRAINT sender_not_reciever_check 
CHECK (from_user_id != to_user_id);

-- добавляем ограничение, что номер телефона должен состоять из 11
-- символов и только из цифр
ALTER TABLE users 
ADD CONSTRAINT phone_check
CHECK (REGEXP_LIKE(phone, '^[0-9]{11}$'));



-- Таблица для добавления публикаций. Включает текст(посты) и id медиафайлов, согласно таблице media


CREATE TABLE publish (
	id SERIAL PRIMARY KEY,
	published_by BIGINT UNSIGNED NOT NULL,
	published_at DATETIME DEFAULT CURRENT_TIMESTAMP,
	text_content TEXT,
	media_content_id BIGINT UNSIGNED,
	KEY (published_by),
	CONSTRAINT fk_media_id FOREIGN KEY (media_content_id) REFERENCES media (id),
	CONSTRAINT fk_user_id FOREIGN KEY (published_by) REFERENCES users (id)
	
);


-- Таблица для лайков профилей пользователей. Нельзя лайкать свой профиль и нельзя лайкать один профиль много раз

CREATE TABLE profile_likes (
	from_user_id BIGINT UNSIGNED NOT NULL,
	to_profile_id BIGINT UNSIGNED NOT NULL,
	CONSTRAINT fk_profile_like_from_user_id FOREIGN KEY (from_user_id) REFERENCES users (id),
	CONSTRAINT fk_profile_like_to_user_id FOREIGN KEY (to_profile_id) REFERENCES users (id),
	CONSTRAINT dont_like_yourself CHECK (from_user_id != to_profile_id),
	PRIMARY KEY (from_user_id, to_profile_id),
	liked_at DATETIME DEFAULT CURRENT_TIMESTAMP
);


-- Таблица для лайков публикаций. Нельзя лайкать одну публикацию несколько раз

CREATE TABLE publication_likes (
	from_user_id BIGINT UNSIGNED NOT NULL,
	to_publication_id BIGINT UNSIGNED NOT NULL,
	CONSTRAINT fk_publication_like_from_user_id FOREIGN KEY (from_user_id) REFERENCES users (id),
	CONSTRAINT fk_publication_id FOREIGN KEY (to_publication_id) REFERENCES publish (id),
	PRIMARY KEY (from_user_id, to_publication_id),
	liked_at DATETIME DEFAULT CURRENT_TIMESTAMP
	
);

-- Триггер для того, чтобы нельзя было лайкнуть свою публикацию.

DELIMITER $$

CREATE TRIGGER dont_like_yours
	BEFORE INSERT ON publication_likes FOR EACH ROW 
		BEGIN
			IF NEW.from_user_id = (SELECT published_by FROM publish WHERE id = NEW.to_publication_id)
			THEN
				SIGNAL SQLSTATE '45000'
				SET MESSAGE_TEXT = 'Cannot like your own publications';
			END IF;
		END;
$$

DELIMITER ;









