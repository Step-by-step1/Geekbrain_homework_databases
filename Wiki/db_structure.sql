DROP DATABASE IF EXISTS wiki;
CREATE DATABASE wiki;
USE wiki;
CREATE TABLE users (
id SERIAL PRIMARY KEY,
name VARCHAR(40) NOT NULL,
`password` VARCHAR(40) NOT NULL,
email VARCHAR(40)
);
CREATE TABLE admins (
id SERIAL PRIMARY KEY,
user_id BIGINT UNSIGNED NOT NULL,
name VARCHAR(40) NOT NULL,
`password` VARCHAR(40) NOT NULL,
email VARCHAR(40),
CONSTRAINT fk_user_id_admins FOREIGN KEY (user_id) REFERENCES users (id)
);
CREATE TABLE media_types (
id SERIAL PRIMARY KEY,
media_type CHAR(10) NOT NULL
);
CREATE TABLE languages (
id SERIAL PRIMARY KEY,
`language` CHAR(10) NOT NULL
);
CREATE TABLE access_types (
id INT UNSIGNED NOT NULL PRIMARY KEY,
access_type CHAR(12) NOT NULL
);
CREATE TABLE media (
id SERIAL PRIMARY KEY,
name VARCHAR(40) NOT NULL,
media_type BIGINT UNSIGNED NOT NULL,
created_by BIGINT UNSIGNED NOT NULL,
created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
CONSTRAINT fk_media_type_media FOREIGN KEY (media_type) REFERENCES media_types (id),
CONSTRAINT fk_user_id_media FOREIGN KEY (created_by) REFERENCES users (id)
);
CREATE TABLE articles (
id SERIAL PRIMARY KEY,
title VARCHAR(255) NOT NULL,
contents TEXT NOT NULL,
published_by BIGINT UNSIGNED,
published_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
latest_amendment_by BIGINT UNSIGNED,
latest_amendment_at DATETIME,
access_type INT UNSIGNED NOT NULL,
CONSTRAINT fk_published_by_articles FOREIGN KEY (published_by) REFERENCES users(id),
CONSTRAINT fk_access_type_articles FOREIGN KEY (access_type) REFERENCES access_types (id),
CONSTRAINT fk_amended_by_articles FOREIGN KEY (latest_amendment_by) REFERENCES users(id)
);
CREATE TABLE history (
id SERIAL PRIMARY KEY,
article_id BIGINT UNSIGNED NOT NULL,
contents TEXT NOT NULL,
amended_by BIGINT UNSIGNED,
amended_at DATETIME,
CONSTRAINT fk_article_id_history FOREIGN KEY (article_id) REFERENCES articles (id),
CONSTRAINT fk_amended_by_history FOREIGN KEY (amended_by) REFERENCES users (id)
);
CREATE TABLE talk (
id SERIAL PRIMARY KEY,
article_id BIGINT UNSIGNED NOT NULL,
contents TEXT NOT NULL,
published_by BIGINT UNSIGNED NOT NULL,
published_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
CONSTRAINT fk_published_by_talk FOREIGN KEY (published_by) REFERENCES users (id),
CONSTRAINT fk_article_id_talk FOREIGN KEY (article_id) REFERENCES articles (id)
);
CREATE TABLE teahouse_forum_topics (
id SERIAL PRIMARY KEY,
topic VARCHAR(255) NOT NULL,
opened_by BIGINT UNSIGNED NOT NULL,
opened_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
CONSTRAINT fk_opened_by_teahouse_forum_topics FOREIGN KEY (opened_by) REFERENCES users (id)
);

CREATE TABLE teahouse_forum_talk (
id SERIAL PRIMARY KEY,
topic_id BIGINT UNSIGNED NOT NULL,
contents TEXT NOT NULL,
written_by BIGINT UNSIGNED NOT NULL,
written_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
CONSTRAINT fk_topic_id_teahouse_forum_talk FOREIGN KEY (topic_id) REFERENCES teahouse_forum_topics (id),
CONSTRAINT fk_written_by_teahouse_forum_talk FOREIGN KEY (written_by) REFERENCES users (id)
);
CREATE TABLE reference_desk_topics (
id SERIAL PRIMARY KEY,
topic VARCHAR(255) NOT NULL
);
CREATE TABLE reference_desk_questions (
id SERIAL PRIMARY KEY,
question TEXT NOT NULL,
topic_id BIGINT UNSIGNED NOT NULL,
question_by BIGINT UNSIGNED NOT NULL,
created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
CONSTRAINT fk_topic_id_reference_desk_questions FOREIGN KEY (topic_id) REFERENCES reference_desk_topics (id),
CONSTRAINT fk_question_by_reference_desk_questions FOREIGN KEY (question_by) REFERENCES users (id)
);
CREATE TABLE reference_desk_answers (
id SERIAL PRIMARY KEY,
answer TEXT NOT NULL,
topic_id BIGINT UNSIGNED NOT NULL,
question_id BIGINT UNSIGNED NOT NULL,
answer_by BIGINT UNSIGNED NOT NULL,
created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
CONSTRAINT fk_topic_id_reference_desk_answers FOREIGN KEY (topic_id) REFERENCES reference_desk_topics (id),
CONSTRAINT fk_question_id_reference_desk_questions FOREIGN KEY (question_id) REFERENCES reference_desk_questions (id),
CONSTRAINT fk_answer_by_reference_desk_answers FOREIGN KEY (answer_by) REFERENCES users (id)
);




