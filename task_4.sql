-- 4 Подобрать сервис-образец для курсовой работы

-- Сервис образец не подобрал, но на словах - это будет база данных для системы управления умным домом.
--    В этой базе будут например такие таблицы: 
-- 		- таблица списка устройств умного, где будут указаны тип устройства (выбор из таблицы), название, параметры для подключения, протоколы и т.д.
--		- таблица типа устройств
-- 		- таблица списка локаций (помещений), где указываем тип помещения (тоже таблица), название, доп параметры
--	 	- таблица типа помещений
--		- таблица работающих в данным момент устройств, где будет привязка к таблице типа устройства и помещения, статус, и т.д
-- 		- таблица протоколов связи с параметрами
--		- таблица планировщика, где будут добавляться сценарии работы. Параметры например: дата и время старта, периодичность, вкл\выкл, 
--          время выполнения, устройство, связанное устройство (датчик) и т.д.
-- 		- таблица медиафайлов, где будут храниться ссылки на медиа для отработки сценариев
-- 		- и другие)



-- Доработка базы данных vk с учетом связей между таблицами


USE vk;

-- Приводим в порядок временные метки
UPDATE users SET updated_at = NOW() WHERE updated_at < created_at;

-- Поправим столбец пола
CREATE TEMPORARY TABLE genders (name CHAR(1));

INSERT INTO genders VALUES ('M'), ('F'); 

-- Обновляем пол
UPDATE profiles 
  SET gender = (SELECT name FROM genders ORDER BY RAND() LIMIT 1);
  
DROP TABLE genders;
 
-- Таблица статусов пользователей
DROP TABLE IF EXISTS user_statuses;
CREATE TABLE user_statuses (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "Идентификатор строки", 
  name VARCHAR(100) NOT NULL COMMENT "Название статуса (уникально)",
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",  
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки"
) COMMENT "Справочник статусов";  
INSERT INTO user_statuses (name) VALUES
 ('single'),
 ('married');
SELECT * FROM user_statuses;

-- обновляем профили в соответствии с таблицей статусов
UPDATE profiles SET status = null;
ALTER TABLE profiles RENAME COLUMN status TO user_status_id; 
ALTER TABLE profiles MODIFY COLUMN user_status_id INT UNSIGNED; 
-- ALTER TABLE profiles ADD FOREIGN KEY (user_status_id) REFERENCES user_statuses(id);
-- Обновляем статус
UPDATE profiles 
  SET user_status_id = (SELECT id FROM user_statuses ORDER BY RAND() LIMIT 1);

 
-- Смотрим структуру таблицы сообщений
DESC messages;
ALTER TABLE messages ADD COLUMN media_id INT UNSIGNED AFTER body; 


-- Анализируем данные
SELECT * FROM messages LIMIT 10;

-- Обновляем значения ссылок на отправителя и получателя сообщения
UPDATE messages SET 
  from_user_id = FLOOR(1 + RAND() * 100),
  to_user_id = FLOOR(1 + RAND() * 100);

-- Добавляем ссылки на медиафайлы
UPDATE messages SET  media_id = FLOOR(1 + RAND() * 100);

-- Приводим в порядок временные метки
UPDATE messages SET updated_at = NOW() WHERE updated_at < created_at;  

-- Обновляем ссылку на пользователя - владельца
UPDATE media SET user_id = FLOOR(1 + RAND() * 100);

-- Создаём временную таблицу форматов медиафайлов
DROP TABLE IF EXISTS extensions;
CREATE TEMPORARY TABLE extensions (name VARCHAR(10));

-- Заполняем значениями
INSERT INTO extensions VALUES ('jpeg'), ('avi'), ('mpeg'), ('png');

-- Обновляем ссылку на файл
UPDATE media SET filename = CONCAT(
  'http://dropbox.net/vk/',
  filename,
  '.',
  (SELECT name FROM extensions ORDER BY RAND() LIMIT 1)
);

-- Обновляем размер файлов
UPDATE media SET size = FLOOR(10000 + (RAND() * 1000000)) WHERE size < 1000;

-- Заполняем метаданные
UPDATE media SET metadata = CONCAT('{"owner":"', 
  (SELECT CONCAT(first_name, ' ', last_name) FROM users WHERE id = user_id),
  '"}'); 
 
-- Возвращаем столбцу метеданных правильный тип
ALTER TABLE media MODIFY COLUMN metadata JSON;


-- Так как есть связь таблицы media с таблицей media_types,
-- то truncate использовать нельзя 
-- Обновляем данные для ссылки на тип
UPDATE media SET media_type_id = FLOOR(1 + RAND() * 3);

-- DELETE не сбрасывает счётчик автоинкрементирования,
DELETE FROM media_types WHERE id > 3;

-- Добавляем нужные типы
UPDATE media_types SET name = 'photo' WHERE id = 1;
UPDATE media_types SET name = 'video' WHERE id = 2;
UPDATE media_types SET name = 'audio' WHERE id = 3;


-- Обновляем ссылки на друзей
ALTER TABLE `friendship` DISABLE KEYS;
UPDATE friendship SET 
  user_id = FLOOR(1 + RAND() * 100),
  friend_id = FLOOR(1 + RAND() * 100);

-- Исправляем случай когда user_id = friend_id
UPDATE friendship SET friend_id = friend_id + 1 WHERE user_id = friend_id;
ALTER TABLE `friendship` ENABLE KEYS ;



-- Так как есть связь таблицы friendship с таблицей friendship_statuses,
-- то truncate использовать нельзя
 -- Обновляем ссылки на статус 
UPDATE friendship SET status_id = FLOOR(1 + RAND() * 3); 

-- Очищаем таблицу
DELETE FROM friendship_statuses WHERE id > 3;
 
-- Добавляем нужные типы
UPDATE friendship_statuses SET name = 'Requested' WHERE id = 1;
UPDATE friendship_statuses SET name = 'Confirmed' WHERE id = 2;
UPDATE friendship_statuses SET name = 'Rejected' WHERE id = 3;



-- Обновляем значения community_id
UPDATE communities_users SET community_id = FLOOR(1 + RAND() * 20);
DELETE FROM communities_users WHERE community_id > 100;

-- Удаляем часть групп
DELETE FROM communities WHERE id > 20;

-- Анализируем таблицу связи пользователей и групп
SELECT * FROM communities_users;

