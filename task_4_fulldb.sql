-- 2 Сначала создаем пустую таблицу, добавляем в нее таблицы с лайками
-- #####################################################################################
-- Создание БД для социальной сети ВКонтакте
-- https://vk.com/geekbrainsru

-- Создаём БД

DROP DATABASE IF EXISTS vk;
CREATE DATABASE vk;

-- Делаем её текущей
USE vk;

-- Создаём таблицу пользователей
CREATE TABLE users (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "Идентификатор строки", 
  first_name VARCHAR(100) NOT NULL COMMENT "Имя пользователя",
  last_name VARCHAR(100) NOT NULL COMMENT "Фамилия пользователя",
  email VARCHAR(100) NOT NULL UNIQUE COMMENT "Почта",
  phone VARCHAR(100) NOT NULL UNIQUE COMMENT "Телефон",
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",  
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки"
) COMMENT "Пользователи";  
-- SERIAL = BIGINT UNSIGNED NOT NULL AUTO_INCREMENT UNIQUE

-- Таблица профилей
CREATE TABLE profiles (
  user_id INT UNSIGNED NOT NULL PRIMARY KEY COMMENT "Ссылка на пользователя", 
  gender CHAR(1) NOT NULL COMMENT "Пол",
  birthday DATE COMMENT "Дата рождения",
  photo_id INT UNSIGNED COMMENT "Ссылка на основную фотографию пользователя",
  status VARCHAR(30) COMMENT "Текущий статус",
  city VARCHAR(130) COMMENT "Город проживания",
  country VARCHAR(130) COMMENT "Страна проживания",
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",  
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки",
  FOREIGN KEY (user_id) REFERENCES users(id) ON UPDATE CASCADE ON DELETE CASCADE
) COMMENT "Профили"; 

-- ALTER TABLE profiles ADD CONSTRAINT fk_user_id
--    FOREIGN KEY (user_id) REFERENCES users(id)
--    ON UPDATE CASCADE ON DELETE CASCADE;


-- Таблица лайков пользователей
CREATE TABLE users_likes (
  id INT UNSIGNED NOT NULL PRIMARY KEY COMMENT "Ссылка на пользователя",
  count_likes INT UNSIGNED COMMENT "Количвество лайков пользователей",
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",  
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки",
  FOREIGN KEY (id) REFERENCES users(id)
) COMMENT "Количество лайков медиафайлов";


-- Таблица сообщений
CREATE TABLE messages (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "Идентификатор строки", 
  from_user_id INT UNSIGNED NOT NULL COMMENT "Ссылка на отправителя сообщения",
  to_user_id INT UNSIGNED NOT NULL COMMENT "Ссылка на получателя сообщения",
  body TEXT NOT NULL COMMENT "Текст сообщения",
  is_important BOOLEAN COMMENT "Признак важности",
  is_delivered BOOLEAN COMMENT "Признак доставки",
  created_at DATETIME DEFAULT NOW() COMMENT "Время создания строки",
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки",
  FOREIGN KEY (from_user_id) REFERENCES users(id),
  FOREIGN KEY (to_user_id) REFERENCES users(id)
) COMMENT "Сообщения";


-- Таблица лайков сообщений
CREATE TABLE messages_likes (
  id INT UNSIGNED NOT NULL PRIMARY KEY COMMENT "Ссылка на сообщение",
  count_likes INT UNSIGNED COMMENT "Количество лайков сообщения",
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",  
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки",
  FOREIGN KEY (id) REFERENCES messages(id)
) COMMENT "Количество лайков медиафайлов";

-- Таблица статусов дружеских отношений
CREATE TABLE friendship_statuses (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "Идентификатор строки",
  name VARCHAR(150) NOT NULL UNIQUE COMMENT "Название статуса",
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",  
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки"
) COMMENT "Статусы дружбы";

-- Таблица дружбы
CREATE TABLE friendship (
  user_id INT UNSIGNED NOT NULL COMMENT "Ссылка на инициатора дружеских отношений",
  friend_id INT UNSIGNED NOT NULL COMMENT "Ссылка на получателя приглашения дружить",
  status_id INT UNSIGNED NOT NULL COMMENT "Ссылка на статус (текущее состояние) отношений",
  requested_at DATETIME DEFAULT NOW() COMMENT "Время отправления приглашения дружить",
  confirmed_at DATETIME COMMENT "Время подтверждения приглашения",
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",  
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки",  
  PRIMARY KEY (user_id, friend_id) COMMENT "Составной первичный ключ",
  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (friend_id) REFERENCES users(id),
  FOREIGN KEY (status_id) REFERENCES friendship_statuses(id)
) COMMENT "Таблица дружбы";

-- Таблица групп
CREATE TABLE communities (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "Идентификатор сроки",
  name VARCHAR(150) NOT NULL UNIQUE COMMENT "Название группы",
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",  
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки"  
) COMMENT "Группы";

-- Таблица связи пользователей и групп
CREATE TABLE communities_users (
  community_id INT UNSIGNED NOT NULL COMMENT "Ссылка на группу",
  user_id INT UNSIGNED NOT NULL COMMENT "Ссылка на пользователя",
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки", 
  PRIMARY KEY (community_id, user_id) COMMENT "Составной первичный ключ",
  FOREIGN KEY (community_id) REFERENCES communities(id),
  FOREIGN KEY (user_id) REFERENCES users(id)
) COMMENT "Участники групп, связь между пользователями и группами";

-- Таблица типов медиафайлов
CREATE TABLE media_types (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "Идентификатор строки",
  name VARCHAR(255) NOT NULL UNIQUE COMMENT "Название типа",
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",  
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки"
) COMMENT "Типы медиафайлов";


-- Таблица медиафайлов
CREATE TABLE media (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "Идентификатор строки",
  user_id INT UNSIGNED NOT NULL COMMENT "Ссылка на пользователя, который загрузил файл",
  filename VARCHAR(255) NOT NULL COMMENT "Путь к файлу",
  size INT NOT NULL COMMENT "Размер файла",
  metadata JSON COMMENT "Метаданные файла",
  media_type_id INT UNSIGNED NOT NULL COMMENT "Ссылка на тип контента",
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки",
  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (media_type_id) REFERENCES media_types(id)
) COMMENT "Медиафайлы";


-- Таблица лайков медиафайлов
CREATE TABLE media_likes (
  media_id INT UNSIGNED NOT NULL COMMENT "Ссылка на медиафайл",
  user_id INT UNSIGNED NOT NULL COMMENT "Ссылка на пользователя, который лайкнул",
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки",
  PRIMARY KEY (media_id, user_id) COMMENT "Составной первичный ключ"
) COMMENT "Таблица лайков медиафайлов пользователями";

-- SELECT COUNT(*) FROM media_likes WHERE media_id=55;


-- #####################################################################################











-- 3 Далее приведена таблица с заполнеными с помощью filldb.info данными и упорядоченная правильно
-- #####################################################################################

-- Создаём БД

DROP DATABASE IF EXISTS vk;
CREATE DATABASE vk;

-- Делаем её текущей
USE vk;

#
# TABLE STRUCTURE FOR: users
#

DROP TABLE IF EXISTS `users`;

CREATE TABLE `users` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Идентификатор строки',
  `first_name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Имя пользователя',
  `last_name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Фамилия пользователя',
  `email` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Почта',
  `phone` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Телефон',
  `created_at` datetime DEFAULT current_timestamp() COMMENT 'Время создания строки',
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT 'Время обновления строки',
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`),
  UNIQUE KEY `phone` (`phone`)
) ENGINE=InnoDB AUTO_INCREMENT=101 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Пользователи';

INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (1, 'Leann', 'Wilderman', 'mark81@example.com', '313-714-7769x3001', '1999-04-26 20:12:24', '1992-03-17 16:24:15');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (2, 'Thelma', 'Altenwerth', 'swill@example.net', '(706)546-0088x999', '1974-06-05 20:18:18', '1978-04-05 20:19:07');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (3, 'Owen', 'Rempel', 'hailee.lockman@example.net', '1-887-170-7406x030', '1993-06-12 06:36:36', '2016-02-15 18:02:54');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (4, 'Sebastian', 'Runolfsdottir', 'kailyn.walter@example.com', '1-989-136-4554x83317', '1980-12-12 01:14:30', '2014-01-12 10:54:45');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (5, 'John', 'Runolfsdottir', 'ykiehn@example.org', '161-206-9158', '1989-07-24 22:25:26', '1987-05-11 09:20:09');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (6, 'Virgil', 'Shields', 'chasity20@example.com', '397-193-1604x08127', '1972-08-09 15:16:50', '2001-05-21 17:11:48');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (7, 'Rachel', 'McKenzie', 'gibson.tyrique@example.com', '(227)774-9821x61297', '2015-01-11 10:48:38', '1985-05-31 17:29:57');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (8, 'Jerod', 'Krajcik', 'jakubowski.georgiana@example.com', '(160)432-5504', '2014-07-04 08:03:42', '1999-01-19 21:44:31');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (9, 'Emmalee', 'Howell', 'pablo.brown@example.org', '(635)835-2379', '1978-02-06 03:51:20', '2017-07-14 02:25:40');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (10, 'Sincere', 'Runolfsdottir', 'destini17@example.net', '1-620-243-5142x9406', '2001-05-08 23:27:12', '1987-08-25 23:04:27');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (11, 'Rocky', 'Block', 'maddison.jaskolski@example.net', '1-930-870-8123', '2008-03-16 10:34:21', '1999-05-25 12:36:46');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (12, 'Everette', 'Dickinson', 'tkozey@example.com', '00322853808', '2006-08-21 08:46:34', '1978-04-02 12:52:28');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (13, 'Fabian', 'Cartwright', 'pfannerstill.enos@example.com', '276-600-1460', '1986-05-21 08:59:02', '1989-05-27 08:52:04');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (14, 'Camden', 'Gutmann', 'bcruickshank@example.org', '695.169.9906x65227', '2019-04-05 17:33:39', '1988-01-07 12:20:54');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (15, 'Yazmin', 'Waters', 'braun.kirstin@example.com', '(076)581-9182', '1991-01-26 19:44:35', '2012-06-28 05:17:23');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (16, 'Lenore', 'Dietrich', 'bwelch@example.org', '174-933-9777', '1985-01-04 03:34:33', '2020-06-04 19:25:04');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (17, 'Abraham', 'Bayer', 'abagail.hodkiewicz@example.net', '(531)306-1525x8110', '2019-09-24 06:46:53', '1998-05-12 17:19:02');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (18, 'Kristina', 'D\'Amore', 'murray.carlos@example.net', '267.625.9356', '1997-05-30 18:58:31', '1989-12-12 23:44:36');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (19, 'Maximus', 'Brown', 'agaylord@example.net', '(114)614-1917', '2001-07-26 21:06:35', '2013-03-03 00:26:02');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (20, 'Kellen', 'Franecki', 'armstrong.providenci@example.com', '031-187-3511x1998', '1977-07-28 15:48:30', '2014-06-24 01:03:31');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (21, 'Tyrese', 'Connelly', 'gilberto.moen@example.net', '531.455.7720x18479', '1975-02-28 14:51:41', '2000-07-18 02:25:42');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (22, 'Lennie', 'Nienow', 'maynard72@example.net', '1-441-398-4218x82445', '1995-01-10 16:26:17', '2019-11-16 11:04:10');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (23, 'Bernadine', 'Hoppe', 'keebler.giovanna@example.net', '1-769-540-6760', '1970-06-15 06:16:10', '2020-03-16 04:23:36');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (24, 'Sigurd', 'Fahey', 'leuschke.daron@example.net', '(819)178-9412', '1994-06-28 05:21:42', '2018-02-15 04:08:07');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (25, 'Abelardo', 'Kutch', 'darrel.bernhard@example.org', '741.469.0121', '1977-12-11 17:02:02', '2008-08-03 03:27:12');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (26, 'Arthur', 'Welch', 'hettinger.henry@example.net', '(917)819-3166', '1987-04-13 22:10:36', '2014-12-23 01:46:24');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (27, 'Estevan', 'Wisozk', 'glenna83@example.com', '(454)918-7582x482', '1994-11-12 06:20:05', '2001-04-18 10:52:37');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (28, 'Skye', 'Altenwerth', 'wbartell@example.org', '629-906-5396', '1992-04-01 20:00:25', '1991-07-11 08:30:50');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (29, 'Kenyon', 'Hessel', 'sammie.o\'keefe@example.com', '582-257-0975x85953', '1996-06-12 23:00:39', '1984-08-19 13:47:30');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (30, 'Russel', 'Jacobson', 'claudia86@example.net', '1-292-235-8203x1486', '1975-11-22 16:10:28', '1982-01-11 07:03:41');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (31, 'Crystel', 'Cremin', 'grace08@example.com', '353-909-7111x21999', '1995-04-30 10:08:14', '2019-01-09 22:28:04');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (32, 'Era', 'Fay', 'kiehn.rickie@example.net', '1-645-420-3081x0770', '1975-04-01 04:41:07', '2004-09-13 16:38:09');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (33, 'Jon', 'Schaden', 'brendon.fritsch@example.org', '1-061-035-9944x42007', '2003-05-13 15:10:01', '1976-12-25 22:59:29');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (34, 'Lue', 'Spinka', 'jocelyn.wintheiser@example.org', '(990)035-1077x363', '1996-10-09 07:39:23', '2015-08-03 12:01:28');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (35, 'Armani', 'Bogan', 'heathcote.denis@example.org', '101-677-9114', '1979-10-07 17:36:36', '1991-09-09 01:56:57');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (36, 'Linnie', 'Wintheiser', 'okeebler@example.org', '690-331-3835x907', '1975-12-24 19:38:00', '2015-05-15 23:30:39');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (37, 'Pablo', 'Roberts', 'harber.pamela@example.org', '123-270-3079x9104', '1998-01-28 15:18:42', '1978-08-22 12:11:39');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (38, 'Tyshawn', 'Jacobson', 'parker55@example.com', '1-511-165-6613', '2013-03-06 18:45:05', '2015-11-26 06:35:56');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (39, 'Mariane', 'Hauck', 'tatyana.davis@example.net', '1-786-683-0185', '2019-05-03 02:07:29', '1973-09-11 18:55:49');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (40, 'Columbus', 'Jaskolski', 'catharine.fadel@example.com', '+24(1)5330832079', '1993-05-17 07:59:25', '2005-02-28 14:32:02');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (41, 'Brody', 'Hickle', 'ismitham@example.org', '1-916-748-5050x5688', '1975-06-04 00:09:11', '1990-05-22 04:58:28');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (42, 'Jon', 'Goodwin', 'claudie88@example.org', '568.080.0733x91340', '2000-04-20 07:53:36', '1990-12-09 11:26:04');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (43, 'Ahmed', 'Turcotte', 'claudie.monahan@example.org', '193.450.1454', '2020-11-07 23:01:03', '2007-01-02 04:18:20');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (44, 'Abdullah', 'Klocko', 'lottie.mosciski@example.org', '1-429-754-2475', '1978-11-01 16:44:47', '1994-05-04 13:18:29');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (45, 'Dock', 'Reilly', 'jacinthe85@example.net', '587-795-4216', '1996-02-13 10:56:56', '2003-08-24 04:51:08');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (46, 'Antonette', 'Abshire', 'lucienne.pfeffer@example.com', '188.880.8652x3776', '1973-02-08 18:56:16', '1989-03-21 21:40:06');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (47, 'Dulce', 'Rau', 'mo\'hara@example.com', '1-871-254-3149', '2000-04-19 12:15:42', '1979-01-24 21:08:52');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (48, 'Dannie', 'Connelly', 'jay19@example.net', '296.670.8649x3208', '1970-04-14 02:25:02', '2003-11-30 13:32:02');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (49, 'Ewell', 'Renner', 'xwalsh@example.com', '155.225.6205', '1975-08-20 01:55:23', '2008-09-16 13:11:42');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (50, 'Jennifer', 'Collier', 'dmurphy@example.org', '08675538082', '2019-07-22 14:19:15', '1993-08-21 20:38:55');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (51, 'Oswald', 'Waters', 'xjerde@example.com', '978.662.2431', '1992-10-04 01:49:08', '1981-07-03 03:42:21');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (52, 'Edward', 'Hansen', 'rae.mueller@example.com', '316.217.9460x4095', '1988-03-21 22:47:52', '1981-09-26 23:18:56');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (53, 'Sydnee', 'Jenkins', 'keaton.johnson@example.com', '1-496-279-3588x633', '1996-06-06 09:43:23', '1970-05-27 03:14:57');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (54, 'Elsa', 'Schultz', 'xreichel@example.org', '943-914-0534', '1977-08-11 12:30:09', '2011-04-23 04:46:27');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (55, 'Anibal', 'Schiller', 'ebradtke@example.com', '294.194.7942', '1972-02-10 16:15:58', '2010-03-28 06:40:00');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (56, 'Tevin', 'Collier', 'maggie.bechtelar@example.org', '+72(5)9072330472', '2017-05-15 00:18:11', '2020-11-25 10:07:49');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (57, 'Kurtis', 'Upton', 'jacinto76@example.net', '1-415-783-7076x579', '2012-04-24 23:45:38', '1985-01-12 20:45:59');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (58, 'Ashleigh', 'Raynor', 'kabernathy@example.com', '02687167045', '2013-04-13 13:46:48', '1978-05-22 23:23:32');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (59, 'Pattie', 'Weimann', 'yost.chanel@example.net', '657.600.9111', '2000-01-10 10:57:31', '2013-09-21 07:15:42');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (60, 'Shyann', 'Little', 'vstoltenberg@example.net', '967-310-4465', '2002-10-24 03:14:01', '1981-09-21 09:10:59');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (61, 'Caesar', 'Heidenreich', 'yazmin.koch@example.com', '007-687-7942x685', '2015-10-11 22:14:41', '2019-11-28 18:56:24');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (62, 'Stan', 'Keebler', 'casey25@example.com', '959-786-5425x457', '2008-08-28 18:34:56', '2000-10-04 08:26:08');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (63, 'Larry', 'McDermott', 'giuseppe96@example.com', '969-532-0898x58078', '1999-04-19 12:42:26', '1993-09-20 06:28:31');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (64, 'Jonathan', 'Bahringer', 'price.rachel@example.org', '1-150-957-8852', '2000-01-03 17:34:34', '1980-08-21 08:31:28');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (65, 'Valentin', 'Ratke', 'dooley.saul@example.org', '041-743-1116x87825', '1979-05-18 10:50:49', '2004-09-08 12:50:08');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (66, 'Jacinthe', 'Batz', 'fhessel@example.com', '879-308-7293x38833', '2010-08-29 09:17:15', '1975-02-09 22:12:08');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (67, 'Rita', 'Von', 'kklein@example.com', '786-315-6017x84014', '2015-07-23 18:59:48', '1975-03-24 09:13:47');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (68, 'Baby', 'Hettinger', 'cydney.walter@example.com', '502.905.3696', '2020-10-26 11:40:56', '2002-07-19 11:09:10');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (69, 'Ansel', 'Mann', 'elmore.hudson@example.net', '00291951638', '1982-11-11 18:46:49', '1980-03-24 00:54:27');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (70, 'Tania', 'Hickle', 'aliya.raynor@example.net', '353.102.7624x182', '1971-03-02 01:16:21', '2005-06-02 05:07:02');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (71, 'Delaney', 'Schumm', 'manuel.ullrich@example.net', '986.229.3805x199', '2010-12-02 06:58:53', '2005-04-09 04:26:11');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (72, 'Amie', 'Cremin', 'blick.brielle@example.com', '392.805.8654x6925', '1995-07-27 12:51:26', '1999-12-24 16:10:13');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (73, 'Roselyn', 'Little', 'kessler.jermaine@example.org', '011.594.5442', '2014-07-19 14:20:42', '1997-06-03 19:16:15');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (74, 'Carolyn', 'Dickens', 'erik18@example.com', '(894)945-6956x77980', '1982-10-12 07:43:33', '1988-10-06 08:37:49');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (75, 'Margot', 'Schuster', 'kreiger.jayme@example.org', '635.293.5864x8149', '1982-12-03 13:41:51', '1987-06-10 20:39:21');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (76, 'Clyde', 'Moen', 'damaris.morissette@example.com', '+08(3)1072002533', '2011-04-26 04:32:41', '1998-03-13 23:44:42');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (77, 'Yesenia', 'McKenzie', 'bo58@example.net', '298-275-2498', '1995-02-24 01:00:58', '2007-11-28 16:19:32');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (78, 'Charlie', 'Schultz', 'aglae94@example.org', '02109698021', '1979-02-24 02:03:49', '1998-11-24 14:30:25');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (79, 'Ivah', 'Brekke', 'rosemary09@example.com', '(221)684-2160x43261', '1982-01-03 17:16:42', '1978-07-02 06:36:59');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (80, 'Palma', 'Grant', 'fcorkery@example.com', '178-152-9377', '1992-05-21 12:24:30', '2009-02-05 21:20:03');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (81, 'Marie', 'Mayer', 'alvena.feeney@example.net', '1-750-440-0109x440', '1997-08-29 16:53:09', '1980-04-11 13:24:18');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (82, 'Zion', 'Corwin', 'barrows.davin@example.org', '817-518-8353x255', '1986-12-08 06:47:48', '1992-08-14 03:55:23');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (83, 'Gladyce', 'West', 'alexys.koss@example.org', '(731)171-8149', '2013-10-23 15:18:50', '1992-09-19 16:20:51');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (84, 'Tre', 'Greenholt', 'nicolas96@example.com', '095.689.9811', '1989-11-15 01:46:16', '2005-02-27 21:06:36');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (85, 'Nelson', 'Lynch', 'hickle.aditya@example.com', '(102)775-2939x7814', '1973-08-29 11:46:29', '1999-08-12 10:43:57');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (86, 'Nathanael', 'Lehner', 'clementine07@example.org', '849.433.8086', '1975-06-28 19:00:32', '1999-09-30 07:19:02');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (87, 'Jamel', 'Bednar', 'ernest.johnston@example.com', '269.055.6226x591', '2021-02-11 05:18:25', '1990-05-04 16:54:03');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (88, 'Eli', 'Osinski', 'andy.koch@example.com', '762-137-0105x4846', '2015-12-05 07:18:22', '2011-06-24 05:20:44');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (89, 'Maeve', 'Brekke', 'art.bins@example.com', '1-641-525-1753x665', '1996-05-19 06:20:13', '2009-08-26 08:09:57');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (90, 'Hailey', 'Renner', 'jovanny.casper@example.org', '104-361-0683', '2005-10-27 08:43:09', '2019-11-09 02:10:26');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (91, 'Marcus', 'Kshlerin', 'karelle.farrell@example.org', '(779)562-7207', '1971-09-15 14:30:32', '1973-03-29 08:43:12');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (92, 'Jazmyne', 'Kuphal', 'eddie56@example.com', '1-880-881-1544', '2010-09-10 13:32:32', '1984-07-11 06:56:36');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (93, 'Melba', 'Rowe', 'bridgette.grimes@example.net', '1-805-755-7121', '1983-03-08 07:44:54', '1971-07-14 06:28:58');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (94, 'Kallie', 'Buckridge', 'agislason@example.org', '1-658-767-2263x739', '2004-05-27 00:31:01', '1985-09-14 09:49:21');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (95, 'Pauline', 'Crooks', 'prosacco.ettie@example.net', '1-624-972-0249x65609', '1978-11-06 20:58:57', '1988-12-08 22:00:51');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (96, 'Carson', 'Gaylord', 'kasandra.weimann@example.com', '(289)228-1699', '2006-02-26 21:38:45', '2015-12-17 12:24:33');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (97, 'Deven', 'Runte', 'coy57@example.net', '(390)382-3515x9034', '2012-06-13 16:20:44', '2017-07-24 23:32:39');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (98, 'Lacey', 'Heidenreich', 'sandrine89@example.com', '(357)513-9554x66322', '2000-02-24 11:04:22', '1994-07-15 21:45:51');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (99, 'Simone', 'Wehner', 'vern.gerlach@example.net', '1-662-077-6983x49027', '1978-05-20 08:50:50', '2007-04-03 08:46:46');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (100, 'Alize', 'Reichert', 'nola.murphy@example.com', '1-788-135-5760', '1981-05-21 16:07:48', '1989-07-18 10:13:25');


#
# TABLE STRUCTURE FOR: profiles
#

DROP TABLE IF EXISTS `profiles`;

CREATE TABLE `profiles` (
  `user_id` int(10) unsigned NOT NULL COMMENT 'Ссылка на пользователя',
  `gender` char(1) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Пол',
  `birthday` date DEFAULT NULL COMMENT 'Дата рождения',
  `photo_id` int(10) unsigned DEFAULT NULL COMMENT 'Ссылка на основную фотографию пользователя',
  `status` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Текущий статус',
  `city` varchar(130) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Город проживания',
  `country` varchar(130) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Страна проживания',
  `created_at` datetime DEFAULT current_timestamp() COMMENT 'Время создания строки',
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT 'Время обновления строки',
  PRIMARY KEY (`user_id`),
  CONSTRAINT `profiles_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Профили';

INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `status`, `city`, `country`, `created_at`, `updated_at`) VALUES (1, 'P', '1988-05-21', 0, 'Et ut delectus est aperiam. At', 'Spencermouth', '', '1995-08-15 20:33:22', '2000-03-16 23:23:56');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `status`, `city`, `country`, `created_at`, `updated_at`) VALUES (2, 'P', '1974-08-15', 3, 'Velit et impedit fugit ut earu', 'South Beatrice', '72415', '1987-04-30 11:22:41', '1997-11-23 08:42:42');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `status`, `city`, `country`, `created_at`, `updated_at`) VALUES (3, 'P', '1998-04-18', 8, 'Autem illo accusamus aut maior', 'Goldnermouth', '739', '2004-09-17 00:49:52', '2002-10-26 12:35:58');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `status`, `city`, `country`, `created_at`, `updated_at`) VALUES (4, 'D', '1987-07-09', 6, 'Nam deserunt eveniet nisi faci', 'Port Dora', '581', '2014-06-27 08:47:24', '2006-11-27 11:43:56');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `status`, `city`, `country`, `created_at`, `updated_at`) VALUES (5, 'D', '1989-12-16', 8, 'Eos pariatur expedita temporib', 'Hageneschester', '4', '2016-12-09 09:44:45', '1972-08-24 17:52:07');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `status`, `city`, `country`, `created_at`, `updated_at`) VALUES (6, 'P', '1983-10-13', 9, 'Facere sint ducimus est reicie', 'West Rosellaland', '33770754', '2000-05-02 09:52:01', '2016-10-30 11:16:36');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `status`, `city`, `country`, `created_at`, `updated_at`) VALUES (7, 'M', '2019-04-21', 7, 'Et pariatur id et placeat iste', 'Lakinton', '3995779', '1983-02-17 08:31:29', '1981-02-03 02:22:14');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `status`, `city`, `country`, `created_at`, `updated_at`) VALUES (8, 'M', '2003-09-04', 5, 'Deleniti deserunt corporis dol', 'Lake Vincenzaland', '87', '1983-05-02 14:08:43', '1990-12-17 13:19:24');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `status`, `city`, `country`, `created_at`, `updated_at`) VALUES (9, 'M', '2017-05-25', 5, 'Quisquam sit sed dolorem exerc', 'North Kurt', '329262890', '1977-11-13 16:57:27', '1996-03-16 13:18:39');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `status`, `city`, `country`, `created_at`, `updated_at`) VALUES (10, 'D', '1970-11-12', 2, 'Praesentium cum aut possimus c', 'Lacymouth', '924649009', '2021-02-16 14:54:56', '1977-10-31 11:36:05');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `status`, `city`, `country`, `created_at`, `updated_at`) VALUES (11, 'P', '2005-03-17', 2, 'Natus sequi expedita et quas o', 'Helgafurt', '24779', '1972-02-13 14:52:40', '2006-05-25 23:42:47');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `status`, `city`, `country`, `created_at`, `updated_at`) VALUES (12, 'M', '1988-12-14', 4, 'Pariatur deserunt modi exceptu', 'North Brianside', '6496983', '1994-04-17 14:57:54', '2000-06-27 16:49:23');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `status`, `city`, `country`, `created_at`, `updated_at`) VALUES (13, 'P', '2018-01-05', 2, 'Unde dolor et dolorem maxime l', 'Champlinstad', '8869', '1984-01-01 00:25:31', '2017-11-01 01:05:40');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `status`, `city`, `country`, `created_at`, `updated_at`) VALUES (14, 'P', '1997-04-25', 2, 'Recusandae est laudantium et a', 'Ronnymouth', '43433984', '1985-03-29 03:27:29', '1972-08-02 08:14:22');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `status`, `city`, `country`, `created_at`, `updated_at`) VALUES (15, 'M', '1994-01-08', 2, 'Praesentium est cupiditate vol', 'Port Herthashire', '3985', '2011-03-15 07:57:44', '1993-03-20 10:45:26');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `status`, `city`, `country`, `created_at`, `updated_at`) VALUES (16, 'P', '2016-04-05', 5, 'Adipisci reiciendis sed a rem ', 'South Francesco', '4195', '2014-02-06 05:13:17', '2003-09-13 09:31:00');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `status`, `city`, `country`, `created_at`, `updated_at`) VALUES (17, 'M', '1989-11-18', 1, 'Est commodi sequi modi eos eiu', 'South Hollisfort', '258', '2010-04-17 14:29:42', '1998-09-19 15:56:30');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `status`, `city`, `country`, `created_at`, `updated_at`) VALUES (18, 'P', '1971-03-23', 2, 'Sit ut vel at omnis. Debitis r', 'Gorczanyview', '79479', '1995-09-06 21:34:01', '1988-06-21 14:08:18');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `status`, `city`, `country`, `created_at`, `updated_at`) VALUES (19, 'M', '2011-11-22', 8, 'Tempora exercitationem volupta', 'Port Hans', '950392168', '1991-08-25 09:24:39', '1972-06-22 16:47:19');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `status`, `city`, `country`, `created_at`, `updated_at`) VALUES (20, 'D', '2017-09-19', 0, 'Et similique ut dignissimos qu', 'Davisburgh', '1600110', '2007-03-12 01:11:40', '1997-04-18 12:16:23');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `status`, `city`, `country`, `created_at`, `updated_at`) VALUES (21, 'M', '1983-11-07', 7, 'Et et aut nulla aut est quibus', 'Cruickshankburgh', '', '2019-04-30 00:45:39', '2015-04-12 07:15:33');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `status`, `city`, `country`, `created_at`, `updated_at`) VALUES (22, 'M', '1999-07-09', 1, 'Accusantium consequatur conseq', 'Lake Iciebury', '38748678', '1976-07-06 08:06:42', '2013-08-18 01:31:12');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `status`, `city`, `country`, `created_at`, `updated_at`) VALUES (23, 'M', '1971-10-26', 3, 'Aliquid error totam sed eos au', 'Shieldstown', '671', '2005-03-03 02:59:06', '1992-05-13 07:23:12');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `status`, `city`, `country`, `created_at`, `updated_at`) VALUES (24, 'D', '1981-05-13', 7, 'Aut quod repellat magnam amet ', 'Lefflerberg', '6390062', '1975-10-21 06:21:38', '1990-12-01 02:56:46');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `status`, `city`, `country`, `created_at`, `updated_at`) VALUES (25, 'P', '1977-04-06', 9, 'Impedit sit et aut adipisci. Q', 'Lake Jamiltown', '4', '1970-05-14 01:09:34', '1994-04-26 11:37:33');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `status`, `city`, `country`, `created_at`, `updated_at`) VALUES (26, 'M', '2012-04-28', 0, 'Neque sed cum aut accusamus qu', 'New Kayli', '499', '1980-10-30 09:51:18', '1994-12-12 11:15:19');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `status`, `city`, `country`, `created_at`, `updated_at`) VALUES (27, 'M', '1972-12-26', 6, 'Sint aut magnam provident. Cor', 'East Nathanial', '619', '1990-09-02 08:01:59', '2015-11-27 16:19:49');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `status`, `city`, `country`, `created_at`, `updated_at`) VALUES (28, 'P', '1971-08-23', 4, 'Consequatur ut doloremque dolo', 'Bruentown', '8421484', '2016-11-25 06:42:33', '2010-04-14 09:38:28');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `status`, `city`, `country`, `created_at`, `updated_at`) VALUES (29, 'M', '1995-10-30', 9, 'Ratione sint sunt vel quis omn', 'Port Easter', '', '1997-04-28 21:51:32', '1990-10-01 23:24:24');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `status`, `city`, `country`, `created_at`, `updated_at`) VALUES (30, 'D', '1974-11-14', 5, 'Officiis pariatur harum quis o', 'Elbertstad', '260928736', '2003-01-29 02:43:41', '1996-08-18 10:24:07');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `status`, `city`, `country`, `created_at`, `updated_at`) VALUES (31, 'M', '1985-11-22', 3, 'Autem nulla quisquam voluptate', 'West Glennaburgh', '82205663', '1991-01-15 22:46:28', '2010-10-14 22:54:32');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `status`, `city`, `country`, `created_at`, `updated_at`) VALUES (32, 'M', '1973-04-10', 1, 'Corporis hic repudiandae qui n', 'Lake Hannaton', '262175803', '1983-01-08 00:55:48', '2011-07-08 08:56:01');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `status`, `city`, `country`, `created_at`, `updated_at`) VALUES (33, 'M', '1988-12-27', 9, 'Laudantium optio omnis iure fu', 'Kutchfort', '468830706', '1997-06-04 00:55:49', '1978-11-28 10:56:28');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `status`, `city`, `country`, `created_at`, `updated_at`) VALUES (34, 'D', '1981-04-23', 5, 'Quia et dolores iste ad. Digni', 'Port Winnifred', '107104278', '1978-02-19 01:39:14', '2014-09-08 10:09:08');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `status`, `city`, `country`, `created_at`, `updated_at`) VALUES (35, 'D', '1985-01-27', 1, 'Nostrum blanditiis ipsum moles', 'Ansleyhaven', '', '1997-10-31 12:25:44', '2003-07-06 10:46:55');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `status`, `city`, `country`, `created_at`, `updated_at`) VALUES (36, 'D', '1997-02-28', 0, 'Deserunt officia perspiciatis ', 'Antonettafort', '444', '1979-04-09 15:19:09', '1982-04-13 07:43:52');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `status`, `city`, `country`, `created_at`, `updated_at`) VALUES (37, 'M', '1991-04-01', 0, 'Delectus qui debitis iure quos', 'Cormierstad', '365160819', '1976-09-27 16:06:47', '1975-12-20 18:33:01');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `status`, `city`, `country`, `created_at`, `updated_at`) VALUES (38, 'D', '2013-11-14', 0, 'Nobis dolorum sequi veritatis ', 'North Dejaport', '71', '1971-01-06 13:27:20', '1974-12-30 02:00:44');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `status`, `city`, `country`, `created_at`, `updated_at`) VALUES (39, 'D', '1987-10-11', 5, 'Eveniet voluptas optio asperna', 'Felipahaven', '6212', '1973-10-19 14:04:06', '2015-05-19 17:20:29');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `status`, `city`, `country`, `created_at`, `updated_at`) VALUES (40, 'M', '1997-05-14', 3, 'Cumque modi ad omnis minima ev', 'South Jimmieshire', '4', '2017-07-27 08:29:43', '2014-04-25 06:09:25');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `status`, `city`, `country`, `created_at`, `updated_at`) VALUES (41, 'P', '1981-10-12', 9, 'Laudantium et ab ea fugiat vol', 'Andersonbury', '1529222', '1988-08-01 05:07:14', '1976-09-24 00:18:06');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `status`, `city`, `country`, `created_at`, `updated_at`) VALUES (42, 'M', '1987-04-13', 8, 'Voluptatem earum at molestias ', 'South Orie', '619', '1984-11-03 17:39:58', '2004-04-03 12:50:16');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `status`, `city`, `country`, `created_at`, `updated_at`) VALUES (43, 'D', '1988-05-30', 0, 'Aliquid nihil deserunt quos ut', 'Torreyview', '', '2015-04-03 11:16:18', '1992-11-20 07:49:21');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `status`, `city`, `country`, `created_at`, `updated_at`) VALUES (44, 'M', '1998-03-14', 2, 'Quae consequatur corrupti poss', 'Lake Monserratestad', '360', '2011-06-03 17:28:17', '2004-11-01 01:26:07');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `status`, `city`, `country`, `created_at`, `updated_at`) VALUES (45, 'D', '1974-05-08', 2, 'Iure adipisci et molestias et ', 'Pfeffertown', '158154', '1986-02-08 03:03:06', '1990-03-12 21:57:47');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `status`, `city`, `country`, `created_at`, `updated_at`) VALUES (46, 'M', '2014-06-01', 2, 'Facere doloremque doloremque a', 'Budbury', '10', '1972-04-12 05:55:19', '2006-05-10 08:31:44');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `status`, `city`, `country`, `created_at`, `updated_at`) VALUES (47, 'P', '1996-02-16', 0, 'Cupiditate aperiam dolorem vol', 'Jonestown', '897', '1997-01-30 01:41:45', '2009-01-19 07:28:47');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `status`, `city`, `country`, `created_at`, `updated_at`) VALUES (48, 'M', '2006-06-26', 7, 'Veritatis debitis qui qui enim', 'Botsfordshire', '', '1989-09-03 01:37:04', '1992-12-13 18:27:51');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `status`, `city`, `country`, `created_at`, `updated_at`) VALUES (49, 'M', '1988-05-08', 9, 'Vitae itaque distinctio aspern', 'Batzside', '8', '2014-05-25 16:21:40', '1972-05-16 23:29:24');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `status`, `city`, `country`, `created_at`, `updated_at`) VALUES (50, 'D', '2019-05-17', 3, 'Qui distinctio dolorem rerum b', 'Marlenefurt', '2117431', '1973-02-02 08:41:21', '1998-05-04 09:54:24');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `status`, `city`, `country`, `created_at`, `updated_at`) VALUES (51, 'P', '1979-09-25', 1, 'Quisquam vitae consequatur con', 'Stephaniebury', '21359', '1991-04-07 08:51:39', '1981-05-05 00:39:50');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `status`, `city`, `country`, `created_at`, `updated_at`) VALUES (52, 'M', '2019-09-17', 8, 'Nobis unde tempore voluptas et', 'Kamrynshire', '45', '1974-11-21 08:45:17', '2016-01-30 11:13:33');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `status`, `city`, `country`, `created_at`, `updated_at`) VALUES (53, 'M', '1973-01-18', 3, 'Est error expedita omnis. Minu', 'Danikaville', '1', '1981-11-07 09:53:49', '2016-03-14 16:58:55');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `status`, `city`, `country`, `created_at`, `updated_at`) VALUES (54, 'D', '2015-07-13', 1, 'Quis eaque accusamus labore es', 'Port Emeliefort', '', '2020-07-01 13:01:53', '1993-02-12 21:14:22');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `status`, `city`, `country`, `created_at`, `updated_at`) VALUES (55, 'M', '1995-03-17', 5, 'Itaque voluptatem est sint eli', 'Pasqualeshire', '17', '1984-10-16 18:18:45', '2020-10-09 11:20:28');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `status`, `city`, `country`, `created_at`, `updated_at`) VALUES (56, 'M', '2009-04-02', 9, 'Dolor numquam cumque voluptas ', 'East Judge', '1983', '1997-08-22 02:45:31', '1999-03-19 03:15:01');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `status`, `city`, `country`, `created_at`, `updated_at`) VALUES (57, 'D', '1986-10-16', 7, 'Exercitationem eius ut ab ut e', 'Bergstromport', '833941082', '1996-08-09 13:16:11', '1984-08-31 11:46:24');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `status`, `city`, `country`, `created_at`, `updated_at`) VALUES (58, 'P', '2008-08-26', 4, 'Dolores hic quis labore volupt', 'Daphnechester', '221546008', '2002-07-07 13:24:39', '1977-01-09 04:22:04');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `status`, `city`, `country`, `created_at`, `updated_at`) VALUES (59, 'M', '1996-04-22', 3, 'Et nesciunt facilis in dolor s', 'Lake Enolaton', '756292', '2015-03-28 04:45:10', '1978-04-19 16:49:51');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `status`, `city`, `country`, `created_at`, `updated_at`) VALUES (60, 'M', '2004-03-27', 7, 'Recusandae accusamus suscipit ', 'South Serenitychester', '9762', '2015-03-01 19:46:31', '2012-09-12 15:02:16');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `status`, `city`, `country`, `created_at`, `updated_at`) VALUES (61, 'M', '1974-07-19', 5, 'Ipsam quia officiis quam velit', 'Aufderharland', '34459215', '1985-07-10 08:13:00', '2014-08-15 22:55:20');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `status`, `city`, `country`, `created_at`, `updated_at`) VALUES (62, 'P', '1997-06-06', 4, 'Assumenda pariatur est fugiat ', 'Ninaborough', '16282374', '2018-07-06 08:33:24', '1989-04-03 14:49:32');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `status`, `city`, `country`, `created_at`, `updated_at`) VALUES (63, 'M', '2007-08-12', 9, 'Ducimus sint vel quas culpa. Q', 'Lake Darrion', '477162477', '1971-08-08 21:23:26', '2012-09-24 03:59:20');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `status`, `city`, `country`, `created_at`, `updated_at`) VALUES (64, 'M', '2019-08-07', 7, 'Aliquid odit esse sint. Unde q', 'Lake Francis', '210', '2020-08-22 22:48:12', '2014-06-05 07:23:31');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `status`, `city`, `country`, `created_at`, `updated_at`) VALUES (65, 'D', '1994-02-07', 4, 'Minima incidunt sit eos dolore', 'Leonardochester', '74838', '2013-01-14 03:35:19', '1984-02-05 20:08:49');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `status`, `city`, `country`, `created_at`, `updated_at`) VALUES (66, 'M', '2014-02-17', 2, 'Quod aliquam rerum et reiciend', 'East Wiltonchester', '396', '1983-01-02 16:46:51', '2018-05-02 10:07:03');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `status`, `city`, `country`, `created_at`, `updated_at`) VALUES (67, 'M', '1982-07-17', 8, 'Saepe at et dolores optio quam', 'Lornabury', '13350855', '1971-02-28 16:13:57', '1987-07-07 18:21:06');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `status`, `city`, `country`, `created_at`, `updated_at`) VALUES (68, 'M', '2002-04-05', 3, 'Temporibus quia voluptas nostr', 'McDermottview', '6', '2014-02-23 12:42:13', '2019-03-11 07:41:41');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `status`, `city`, `country`, `created_at`, `updated_at`) VALUES (69, 'M', '1993-05-29', 8, 'Earum quasi non inventore. Fac', 'McCluremouth', '40354575', '1996-08-04 11:22:13', '1997-05-16 17:13:23');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `status`, `city`, `country`, `created_at`, `updated_at`) VALUES (70, 'M', '1994-07-24', 5, 'Libero tenetur enim et vel. Qu', 'Shannonbury', '4', '1972-06-18 19:55:13', '1991-01-25 04:34:40');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `status`, `city`, `country`, `created_at`, `updated_at`) VALUES (71, 'M', '1987-05-18', 3, 'Tenetur odio quo ut fuga eius.', 'Hodkiewiczstad', '74742623', '1993-06-11 00:49:01', '2000-03-16 13:30:39');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `status`, `city`, `country`, `created_at`, `updated_at`) VALUES (72, 'P', '2019-08-21', 6, 'Vel ullam aut voluptas sit rer', 'Russelside', '6624648', '2013-05-20 08:34:41', '1989-02-14 06:38:49');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `status`, `city`, `country`, `created_at`, `updated_at`) VALUES (73, 'D', '1995-09-29', 5, 'Iste vel et occaecati ut volup', 'Bergnaumbury', '248757178', '1982-01-01 02:06:08', '1981-07-20 03:37:22');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `status`, `city`, `country`, `created_at`, `updated_at`) VALUES (74, 'D', '1980-12-04', 3, 'Enim et nihil nobis veritatis.', 'Verliemouth', '200109', '2010-05-09 19:54:58', '2002-09-03 04:35:57');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `status`, `city`, `country`, `created_at`, `updated_at`) VALUES (75, 'D', '2009-06-12', 5, 'Cupiditate deserunt facilis cu', 'Port Mittie', '2631', '2017-11-21 13:32:43', '1977-11-05 17:27:25');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `status`, `city`, `country`, `created_at`, `updated_at`) VALUES (76, 'M', '1970-02-05', 6, 'Sequi non ut officiis iure est', 'East Llewellynfurt', '2275583', '2010-03-30 18:28:39', '1984-01-15 21:56:30');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `status`, `city`, `country`, `created_at`, `updated_at`) VALUES (77, 'P', '1982-04-28', 8, 'Repellat provident alias accus', 'Jamesonberg', '490086', '2014-09-09 23:40:05', '2001-05-29 14:14:22');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `status`, `city`, `country`, `created_at`, `updated_at`) VALUES (78, 'D', '1995-06-06', 4, 'Doloribus iure nostrum accusam', 'Damianside', '560', '1992-04-15 03:01:57', '1995-02-07 12:35:21');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `status`, `city`, `country`, `created_at`, `updated_at`) VALUES (79, 'P', '2007-06-20', 5, 'Facilis voluptatem architecto ', 'Port Noelville', '22', '1973-04-07 21:33:29', '1975-03-10 02:37:05');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `status`, `city`, `country`, `created_at`, `updated_at`) VALUES (80, 'D', '2001-06-19', 3, 'Magnam sed fugit laudantium ut', 'West Loyce', '1', '2009-12-01 05:41:11', '1988-01-15 18:27:01');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `status`, `city`, `country`, `created_at`, `updated_at`) VALUES (81, 'D', '1998-12-27', 1, 'Qui dolorem accusamus in totam', 'West Kaliborough', '15334651', '2020-03-08 19:39:23', '1998-01-03 00:25:30');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `status`, `city`, `country`, `created_at`, `updated_at`) VALUES (82, 'M', '1979-03-16', 1, 'Eius alias non et culpa. Qui n', 'West Ariannaberg', '955', '2009-06-04 02:16:51', '2004-06-28 08:01:05');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `status`, `city`, `country`, `created_at`, `updated_at`) VALUES (83, 'M', '2007-11-01', 0, 'Suscipit laborum optio repelle', 'North Gabrielle', '683', '2006-09-25 23:29:50', '2004-03-01 04:28:53');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `status`, `city`, `country`, `created_at`, `updated_at`) VALUES (84, 'P', '2000-10-22', 4, 'Animi enim pariatur sed et. Mi', 'Omerview', '9444657', '1986-03-14 18:28:14', '1986-03-29 08:46:30');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `status`, `city`, `country`, `created_at`, `updated_at`) VALUES (85, 'M', '1976-03-28', 8, 'Non placeat aut sunt error con', 'Isabelchester', '2', '1996-07-31 22:53:50', '1993-10-02 22:32:37');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `status`, `city`, `country`, `created_at`, `updated_at`) VALUES (86, 'D', '2012-12-03', 3, 'Ipsa harum illo et distinctio.', 'Reynoldville', '817658449', '2010-08-15 16:24:44', '1975-04-25 01:56:42');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `status`, `city`, `country`, `created_at`, `updated_at`) VALUES (87, 'M', '2004-06-30', 6, 'Quia excepturi velit iusto con', 'Romaineview', '591', '1990-04-13 12:07:24', '1977-06-10 23:35:41');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `status`, `city`, `country`, `created_at`, `updated_at`) VALUES (88, 'P', '1996-08-03', 9, 'Natus perspiciatis minima elig', 'Kristaborough', '83491', '2015-12-06 20:56:24', '1983-07-09 13:26:33');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `status`, `city`, `country`, `created_at`, `updated_at`) VALUES (89, 'M', '2009-09-06', 7, 'Accusamus error quisquam occae', 'Sheridanbury', '827290612', '2016-01-26 10:00:56', '2005-09-03 13:18:54');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `status`, `city`, `country`, `created_at`, `updated_at`) VALUES (90, 'M', '2003-11-01', 9, 'Hic nesciunt explicabo assumen', 'Fadelbury', '298', '2012-10-14 04:23:49', '1980-06-03 15:59:47');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `status`, `city`, `country`, `created_at`, `updated_at`) VALUES (91, 'D', '1980-10-19', 8, 'Quo velit praesentium consecte', 'Wymanland', '20038079', '1977-01-05 03:11:30', '1998-02-01 14:09:03');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `status`, `city`, `country`, `created_at`, `updated_at`) VALUES (92, 'M', '2018-01-08', 3, 'Occaecati fugiat omnis volupta', 'Kleintown', '97536702', '2012-02-09 15:40:30', '2007-03-28 12:01:22');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `status`, `city`, `country`, `created_at`, `updated_at`) VALUES (93, 'D', '1970-10-29', 6, 'Quaerat nulla magnam rem qui a', 'Rauberg', '82', '2018-04-30 08:09:32', '1990-07-07 01:40:05');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `status`, `city`, `country`, `created_at`, `updated_at`) VALUES (94, 'P', '1981-01-05', 3, 'Blanditiis nulla placeat offic', 'Simeonbury', '6', '2006-07-02 23:39:45', '1994-08-20 08:42:19');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `status`, `city`, `country`, `created_at`, `updated_at`) VALUES (95, 'D', '1982-02-25', 0, 'Quis est aut pariatur pariatur', 'South Rhiannon', '304', '1987-07-16 05:16:02', '2009-01-25 10:19:56');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `status`, `city`, `country`, `created_at`, `updated_at`) VALUES (96, 'M', '1979-10-03', 7, 'Qui cumque inventore ut cupidi', 'Karlimouth', '9895949', '2018-02-19 19:31:35', '2001-02-26 19:11:56');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `status`, `city`, `country`, `created_at`, `updated_at`) VALUES (97, 'M', '2009-08-01', 0, 'Dolore id ratione est est. Dis', 'Brownburgh', '649403167', '2000-10-24 23:45:06', '2010-03-30 15:33:19');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `status`, `city`, `country`, `created_at`, `updated_at`) VALUES (98, 'D', '1980-01-10', 3, 'Tenetur nesciunt velit consequ', 'North Arthur', '33', '2006-12-11 11:54:15', '1989-08-25 07:10:27');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `status`, `city`, `country`, `created_at`, `updated_at`) VALUES (99, 'P', '2012-08-31', 8, 'Molestiae non voluptatem culpa', 'East Emmybury', '404667', '1986-12-11 20:44:06', '1986-08-18 05:41:46');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `status`, `city`, `country`, `created_at`, `updated_at`) VALUES (100, 'D', '2019-08-14', 4, 'Cum et omnis neque est facere ', 'New Stanville', '573379', '1991-04-27 06:58:05', '2012-10-27 10:44:10');




#
# TABLE STRUCTURE FOR: users_likes
#

DROP TABLE IF EXISTS `users_likes`;

CREATE TABLE `users_likes` (
  `id` int(10) unsigned NOT NULL COMMENT 'Ссылка на пользователя',
  `count_likes` int(10) unsigned DEFAULT NULL COMMENT 'Количвество лайков пользователей',
  `created_at` datetime DEFAULT current_timestamp() COMMENT 'Время создания строки',
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT 'Время обновления строки',
  PRIMARY KEY (`id`),
  CONSTRAINT `users_likes_ibfk_1` FOREIGN KEY (`id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=101 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Количество лайков медиафайлов';

INSERT INTO `users_likes` (`id`, `count_likes`, `created_at`, `updated_at`) VALUES (1, 5, '1989-11-11 21:59:39', '1980-04-26 17:04:54');
INSERT INTO `users_likes` (`id`, `count_likes`, `created_at`, `updated_at`) VALUES (2, 59375820, '2020-12-09 10:30:50', '1987-09-07 08:45:34');
INSERT INTO `users_likes` (`id`, `count_likes`, `created_at`, `updated_at`) VALUES (3, 9439, '1992-10-24 01:50:55', '1991-12-21 12:36:15');
INSERT INTO `users_likes` (`id`, `count_likes`, `created_at`, `updated_at`) VALUES (4, 9422, '1985-01-22 14:42:10', '1991-05-07 21:28:06');
INSERT INTO `users_likes` (`id`, `count_likes`, `created_at`, `updated_at`) VALUES (5, 0, '2008-03-06 22:43:31', '1992-04-09 18:20:00');
INSERT INTO `users_likes` (`id`, `count_likes`, `created_at`, `updated_at`) VALUES (6, 271, '2020-03-04 11:40:08', '1988-12-11 00:47:07');
INSERT INTO `users_likes` (`id`, `count_likes`, `created_at`, `updated_at`) VALUES (7, 102005164, '1997-04-10 05:51:42', '1991-08-07 18:28:47');
INSERT INTO `users_likes` (`id`, `count_likes`, `created_at`, `updated_at`) VALUES (8, 872662805, '1995-05-14 01:31:48', '1976-06-07 09:59:27');
INSERT INTO `users_likes` (`id`, `count_likes`, `created_at`, `updated_at`) VALUES (9, 2525, '1974-04-16 17:42:07', '1995-09-16 23:01:43');
INSERT INTO `users_likes` (`id`, `count_likes`, `created_at`, `updated_at`) VALUES (10, 1, '1993-12-17 19:55:39', '1983-11-10 01:33:15');
INSERT INTO `users_likes` (`id`, `count_likes`, `created_at`, `updated_at`) VALUES (11, 635564767, '1973-07-15 01:59:20', '2015-05-10 13:45:18');
INSERT INTO `users_likes` (`id`, `count_likes`, `created_at`, `updated_at`) VALUES (12, 80, '1980-06-29 21:16:12', '1996-09-16 16:48:50');
INSERT INTO `users_likes` (`id`, `count_likes`, `created_at`, `updated_at`) VALUES (13, 848657565, '1989-01-12 23:13:58', '1974-03-04 05:09:08');
INSERT INTO `users_likes` (`id`, `count_likes`, `created_at`, `updated_at`) VALUES (14, 3, '1999-10-28 18:41:28', '2014-02-11 00:16:17');
INSERT INTO `users_likes` (`id`, `count_likes`, `created_at`, `updated_at`) VALUES (15, 76427641, '2019-08-17 03:02:36', '2020-02-03 13:13:29');
INSERT INTO `users_likes` (`id`, `count_likes`, `created_at`, `updated_at`) VALUES (16, 766, '2002-10-04 18:09:31', '2001-09-19 16:17:44');
INSERT INTO `users_likes` (`id`, `count_likes`, `created_at`, `updated_at`) VALUES (17, 3793, '1998-11-16 11:55:26', '1970-08-19 06:40:29');
INSERT INTO `users_likes` (`id`, `count_likes`, `created_at`, `updated_at`) VALUES (18, 112, '1978-10-29 23:59:32', '2012-11-08 17:39:28');
INSERT INTO `users_likes` (`id`, `count_likes`, `created_at`, `updated_at`) VALUES (19, 709658349, '2011-05-26 11:14:07', '1988-06-01 11:38:02');
INSERT INTO `users_likes` (`id`, `count_likes`, `created_at`, `updated_at`) VALUES (20, 453075, '2005-06-05 08:42:56', '2003-04-23 18:18:33');
INSERT INTO `users_likes` (`id`, `count_likes`, `created_at`, `updated_at`) VALUES (21, 951645, '1971-03-04 22:23:28', '1972-03-01 05:22:05');
INSERT INTO `users_likes` (`id`, `count_likes`, `created_at`, `updated_at`) VALUES (22, 90, '2001-09-18 03:43:16', '2010-05-09 08:00:43');
INSERT INTO `users_likes` (`id`, `count_likes`, `created_at`, `updated_at`) VALUES (23, 829109, '1985-03-20 15:28:56', '2001-02-26 04:10:56');
INSERT INTO `users_likes` (`id`, `count_likes`, `created_at`, `updated_at`) VALUES (24, 60429, '2019-01-31 11:34:46', '2016-03-18 17:20:31');
INSERT INTO `users_likes` (`id`, `count_likes`, `created_at`, `updated_at`) VALUES (25, 22303533, '2007-07-07 23:35:35', '1982-01-13 10:20:23');
INSERT INTO `users_likes` (`id`, `count_likes`, `created_at`, `updated_at`) VALUES (26, 7, '2019-07-18 11:31:15', '2012-09-03 11:52:51');
INSERT INTO `users_likes` (`id`, `count_likes`, `created_at`, `updated_at`) VALUES (27, 5461, '1997-06-05 16:30:52', '2013-06-04 19:40:58');
INSERT INTO `users_likes` (`id`, `count_likes`, `created_at`, `updated_at`) VALUES (28, 7287404, '2005-04-17 02:50:36', '1994-06-04 11:20:09');
INSERT INTO `users_likes` (`id`, `count_likes`, `created_at`, `updated_at`) VALUES (29, 89, '2016-12-29 14:44:58', '1977-09-04 10:18:27');
INSERT INTO `users_likes` (`id`, `count_likes`, `created_at`, `updated_at`) VALUES (30, 62567243, '1978-05-21 18:24:32', '2007-02-01 10:06:23');
INSERT INTO `users_likes` (`id`, `count_likes`, `created_at`, `updated_at`) VALUES (31, 48827132, '2017-12-04 20:31:24', '1994-09-30 16:58:59');
INSERT INTO `users_likes` (`id`, `count_likes`, `created_at`, `updated_at`) VALUES (32, 4664, '2015-06-08 05:37:12', '1979-06-24 11:38:31');
INSERT INTO `users_likes` (`id`, `count_likes`, `created_at`, `updated_at`) VALUES (33, 84335541, '1986-10-22 00:09:23', '1993-03-06 07:45:31');
INSERT INTO `users_likes` (`id`, `count_likes`, `created_at`, `updated_at`) VALUES (34, 90842, '1993-06-29 01:03:10', '2012-06-15 19:33:06');
INSERT INTO `users_likes` (`id`, `count_likes`, `created_at`, `updated_at`) VALUES (35, 172, '1985-04-04 06:05:43', '1996-06-05 06:50:19');
INSERT INTO `users_likes` (`id`, `count_likes`, `created_at`, `updated_at`) VALUES (36, 881, '1971-06-05 02:30:55', '1984-02-07 16:16:33');
INSERT INTO `users_likes` (`id`, `count_likes`, `created_at`, `updated_at`) VALUES (37, 588676774, '1987-04-23 08:08:59', '1982-12-17 13:38:00');
INSERT INTO `users_likes` (`id`, `count_likes`, `created_at`, `updated_at`) VALUES (38, 6204870, '1988-12-03 19:32:50', '1976-03-14 20:32:05');
INSERT INTO `users_likes` (`id`, `count_likes`, `created_at`, `updated_at`) VALUES (39, 78, '1988-08-27 13:48:03', '1975-04-25 06:55:29');
INSERT INTO `users_likes` (`id`, `count_likes`, `created_at`, `updated_at`) VALUES (40, 39367, '2019-04-28 08:10:09', '1994-04-10 19:58:36');
INSERT INTO `users_likes` (`id`, `count_likes`, `created_at`, `updated_at`) VALUES (41, 205307325, '1998-06-24 09:35:02', '1992-11-30 05:14:27');
INSERT INTO `users_likes` (`id`, `count_likes`, `created_at`, `updated_at`) VALUES (42, 8718272, '2015-07-27 04:38:11', '1989-06-14 04:42:51');
INSERT INTO `users_likes` (`id`, `count_likes`, `created_at`, `updated_at`) VALUES (43, 90, '2013-10-04 00:37:10', '1982-04-05 04:47:15');
INSERT INTO `users_likes` (`id`, `count_likes`, `created_at`, `updated_at`) VALUES (44, 90003186, '1994-11-20 03:38:04', '1983-09-16 17:57:28');
INSERT INTO `users_likes` (`id`, `count_likes`, `created_at`, `updated_at`) VALUES (45, 524, '1987-11-19 16:30:46', '2000-01-12 01:41:40');
INSERT INTO `users_likes` (`id`, `count_likes`, `created_at`, `updated_at`) VALUES (46, 0, '1977-03-01 17:32:15', '1977-12-05 09:03:15');
INSERT INTO `users_likes` (`id`, `count_likes`, `created_at`, `updated_at`) VALUES (47, 49323641, '1997-08-25 01:51:28', '1976-02-02 09:13:43');
INSERT INTO `users_likes` (`id`, `count_likes`, `created_at`, `updated_at`) VALUES (48, 1, '1974-09-26 16:07:08', '2009-09-22 05:44:57');
INSERT INTO `users_likes` (`id`, `count_likes`, `created_at`, `updated_at`) VALUES (49, 916213269, '2018-11-04 23:20:11', '1972-08-19 23:21:18');
INSERT INTO `users_likes` (`id`, `count_likes`, `created_at`, `updated_at`) VALUES (50, 57921, '1985-03-04 19:33:35', '2019-11-16 15:26:53');
INSERT INTO `users_likes` (`id`, `count_likes`, `created_at`, `updated_at`) VALUES (51, 0, '1970-05-21 08:34:19', '1986-02-24 07:44:19');
INSERT INTO `users_likes` (`id`, `count_likes`, `created_at`, `updated_at`) VALUES (52, 2, '1977-09-24 00:28:04', '1994-01-04 20:35:46');
INSERT INTO `users_likes` (`id`, `count_likes`, `created_at`, `updated_at`) VALUES (53, 6, '2010-08-24 07:18:28', '2002-08-28 03:44:57');
INSERT INTO `users_likes` (`id`, `count_likes`, `created_at`, `updated_at`) VALUES (54, 727372, '1996-10-05 00:50:50', '2018-01-24 19:42:05');
INSERT INTO `users_likes` (`id`, `count_likes`, `created_at`, `updated_at`) VALUES (55, 2683, '1980-08-22 05:34:12', '1993-06-12 08:40:41');
INSERT INTO `users_likes` (`id`, `count_likes`, `created_at`, `updated_at`) VALUES (56, 5033914, '2003-01-24 05:59:59', '1991-11-27 06:39:31');
INSERT INTO `users_likes` (`id`, `count_likes`, `created_at`, `updated_at`) VALUES (57, 348599, '1981-08-10 05:17:47', '1998-10-06 11:55:55');
INSERT INTO `users_likes` (`id`, `count_likes`, `created_at`, `updated_at`) VALUES (58, 8063841, '2000-03-25 12:47:30', '1988-08-08 09:55:26');
INSERT INTO `users_likes` (`id`, `count_likes`, `created_at`, `updated_at`) VALUES (59, 71870403, '1981-10-28 17:11:49', '1984-03-09 13:05:53');
INSERT INTO `users_likes` (`id`, `count_likes`, `created_at`, `updated_at`) VALUES (60, 2282, '1985-05-16 02:06:13', '1999-05-31 17:47:12');
INSERT INTO `users_likes` (`id`, `count_likes`, `created_at`, `updated_at`) VALUES (61, 43675, '1985-08-22 12:49:42', '2019-04-13 21:57:03');
INSERT INTO `users_likes` (`id`, `count_likes`, `created_at`, `updated_at`) VALUES (62, 28066115, '2019-04-01 00:17:21', '2008-02-26 10:48:36');
INSERT INTO `users_likes` (`id`, `count_likes`, `created_at`, `updated_at`) VALUES (63, 19770446, '2021-04-30 18:50:36', '1987-10-29 17:07:44');
INSERT INTO `users_likes` (`id`, `count_likes`, `created_at`, `updated_at`) VALUES (64, 719005, '2017-10-11 02:16:10', '1975-06-09 18:50:38');
INSERT INTO `users_likes` (`id`, `count_likes`, `created_at`, `updated_at`) VALUES (65, 31, '2020-12-24 20:39:17', '2000-08-10 17:24:19');
INSERT INTO `users_likes` (`id`, `count_likes`, `created_at`, `updated_at`) VALUES (66, 557439642, '2011-06-04 05:25:29', '2020-07-15 06:08:52');
INSERT INTO `users_likes` (`id`, `count_likes`, `created_at`, `updated_at`) VALUES (67, 29, '1986-12-30 22:42:15', '2011-11-27 19:48:40');
INSERT INTO `users_likes` (`id`, `count_likes`, `created_at`, `updated_at`) VALUES (68, 3387100, '1997-08-06 01:48:07', '2010-02-04 06:23:05');
INSERT INTO `users_likes` (`id`, `count_likes`, `created_at`, `updated_at`) VALUES (69, 3, '1975-11-03 06:54:12', '1989-09-11 23:24:19');
INSERT INTO `users_likes` (`id`, `count_likes`, `created_at`, `updated_at`) VALUES (70, 8022, '2021-05-03 03:50:38', '1999-03-21 14:54:56');
INSERT INTO `users_likes` (`id`, `count_likes`, `created_at`, `updated_at`) VALUES (71, 39266424, '1986-04-03 01:28:56', '1976-02-02 14:01:44');
INSERT INTO `users_likes` (`id`, `count_likes`, `created_at`, `updated_at`) VALUES (72, 0, '1997-02-24 23:44:43', '1970-01-20 09:10:59');
INSERT INTO `users_likes` (`id`, `count_likes`, `created_at`, `updated_at`) VALUES (73, 4803, '2001-04-11 01:19:48', '1989-07-25 04:13:18');
INSERT INTO `users_likes` (`id`, `count_likes`, `created_at`, `updated_at`) VALUES (74, 774961, '2007-08-03 01:59:17', '2018-11-15 06:24:00');
INSERT INTO `users_likes` (`id`, `count_likes`, `created_at`, `updated_at`) VALUES (75, 515, '2003-11-24 18:52:14', '1997-08-11 22:01:55');
INSERT INTO `users_likes` (`id`, `count_likes`, `created_at`, `updated_at`) VALUES (76, 561798, '2004-03-10 08:05:25', '1989-04-12 02:30:12');
INSERT INTO `users_likes` (`id`, `count_likes`, `created_at`, `updated_at`) VALUES (77, 908, '1989-08-14 01:44:21', '1970-04-29 22:32:28');
INSERT INTO `users_likes` (`id`, `count_likes`, `created_at`, `updated_at`) VALUES (78, 366517, '1970-05-23 22:26:10', '1985-04-25 02:42:14');
INSERT INTO `users_likes` (`id`, `count_likes`, `created_at`, `updated_at`) VALUES (79, 21373, '2010-12-18 02:33:57', '2001-02-14 06:17:19');
INSERT INTO `users_likes` (`id`, `count_likes`, `created_at`, `updated_at`) VALUES (80, 7, '1977-11-24 23:45:37', '2010-11-02 03:05:14');
INSERT INTO `users_likes` (`id`, `count_likes`, `created_at`, `updated_at`) VALUES (81, 3269, '2009-12-26 07:44:10', '1986-07-26 18:42:39');
INSERT INTO `users_likes` (`id`, `count_likes`, `created_at`, `updated_at`) VALUES (82, 54, '1970-09-02 23:47:06', '1975-08-21 05:58:00');
INSERT INTO `users_likes` (`id`, `count_likes`, `created_at`, `updated_at`) VALUES (83, 5805023, '2003-03-15 21:51:41', '1978-09-02 09:02:53');
INSERT INTO `users_likes` (`id`, `count_likes`, `created_at`, `updated_at`) VALUES (84, 228874066, '1986-09-14 11:32:02', '1973-09-12 14:54:23');
INSERT INTO `users_likes` (`id`, `count_likes`, `created_at`, `updated_at`) VALUES (85, 440191, '1998-04-08 13:40:54', '2013-11-05 14:20:38');
INSERT INTO `users_likes` (`id`, `count_likes`, `created_at`, `updated_at`) VALUES (86, 4893, '1986-03-16 18:24:08', '2006-04-02 21:11:41');
INSERT INTO `users_likes` (`id`, `count_likes`, `created_at`, `updated_at`) VALUES (87, 5059438, '1987-02-06 20:49:43', '1982-07-03 07:46:56');
INSERT INTO `users_likes` (`id`, `count_likes`, `created_at`, `updated_at`) VALUES (88, 24808, '1975-06-05 16:44:58', '1996-11-27 09:41:32');
INSERT INTO `users_likes` (`id`, `count_likes`, `created_at`, `updated_at`) VALUES (89, 8637, '1982-11-26 11:11:12', '2018-11-04 07:19:04');
INSERT INTO `users_likes` (`id`, `count_likes`, `created_at`, `updated_at`) VALUES (90, 567706487, '1982-01-31 17:01:02', '1987-01-03 22:00:57');
INSERT INTO `users_likes` (`id`, `count_likes`, `created_at`, `updated_at`) VALUES (91, 1, '2012-11-06 21:35:34', '1986-12-13 04:02:34');
INSERT INTO `users_likes` (`id`, `count_likes`, `created_at`, `updated_at`) VALUES (92, 72868, '1971-04-13 12:11:56', '1990-09-21 06:58:55');
INSERT INTO `users_likes` (`id`, `count_likes`, `created_at`, `updated_at`) VALUES (93, 45442, '1998-10-13 05:55:51', '1981-01-05 09:51:25');
INSERT INTO `users_likes` (`id`, `count_likes`, `created_at`, `updated_at`) VALUES (94, 4, '2017-09-01 15:58:15', '1991-12-16 22:24:30');
INSERT INTO `users_likes` (`id`, `count_likes`, `created_at`, `updated_at`) VALUES (95, 6713, '1977-10-24 03:08:47', '2009-10-29 16:09:12');
INSERT INTO `users_likes` (`id`, `count_likes`, `created_at`, `updated_at`) VALUES (96, 719, '1978-07-02 01:45:27', '2007-04-14 06:40:52');
INSERT INTO `users_likes` (`id`, `count_likes`, `created_at`, `updated_at`) VALUES (97, 783022, '1976-10-17 05:31:10', '1992-03-06 19:15:14');
INSERT INTO `users_likes` (`id`, `count_likes`, `created_at`, `updated_at`) VALUES (98, 492, '1979-07-10 17:30:00', '2002-05-28 04:01:09');
INSERT INTO `users_likes` (`id`, `count_likes`, `created_at`, `updated_at`) VALUES (99, 293076993, '1985-04-23 09:09:27', '1980-02-29 23:20:11');
INSERT INTO `users_likes` (`id`, `count_likes`, `created_at`, `updated_at`) VALUES (100, 3621, '2010-08-26 08:31:28', '1983-08-13 04:47:07');



#
# TABLE STRUCTURE FOR: messages
#

DROP TABLE IF EXISTS `messages`;

CREATE TABLE `messages` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Идентификатор строки',
  `from_user_id` int(10) unsigned NOT NULL COMMENT 'Ссылка на отправителя сообщения',
  `to_user_id` int(10) unsigned NOT NULL COMMENT 'Ссылка на получателя сообщения',
  `body` text COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Текст сообщения',
  `is_important` tinyint(1) DEFAULT NULL COMMENT 'Признак важности',
  `is_delivered` tinyint(1) DEFAULT NULL COMMENT 'Признак доставки',
  `created_at` datetime DEFAULT current_timestamp() COMMENT 'Время создания строки',
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT 'Время обновления строки',
  PRIMARY KEY (`id`),
  KEY `from_user_id` (`from_user_id`),
  KEY `to_user_id` (`to_user_id`),
  CONSTRAINT `messages_ibfk_1` FOREIGN KEY (`from_user_id`) REFERENCES `users` (`id`),
  CONSTRAINT `messages_ibfk_2` FOREIGN KEY (`to_user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=151 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Сообщения';

INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (1, 1, 1, 'Sit autem ab totam laborum recusandae. Voluptas iusto voluptate a accusantium ducimus magni mollitia sed. In dicta et nostrum eos.', 1, 1, '1984-12-29 08:57:56', '1994-03-27 04:43:13');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (2, 2, 2, 'Delectus aut ratione repellendus qui voluptas impedit. Voluptatum veniam voluptatem possimus rerum doloribus fugit. Qui voluptatum molestiae sit amet.', 1, 0, '1985-02-24 06:57:39', '2016-08-15 10:20:01');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (3, 3, 3, 'Repudiandae ex dolores aliquam nihil odio dignissimos. Asperiores nostrum suscipit iusto laudantium incidunt ullam. Nam quo aliquid aut exercitationem eos praesentium perferendis. Repellendus optio aut consequatur optio voluptas. Soluta nostrum omnis quo ea libero.', 0, 1, '1991-08-15 05:13:46', '1990-12-29 16:31:11');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (4, 4, 4, 'Saepe odit illo autem quasi alias alias fuga. Pariatur velit consequatur aperiam. Qui eum et ratione enim et in quia. Atque ut odio omnis ipsa.', 0, 1, '2002-07-25 11:25:38', '2005-12-10 14:12:23');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (5, 5, 5, 'Ut dolores illo voluptate aut doloremque. Nam suscipit aspernatur doloribus. Quaerat rerum itaque ut exercitationem. Sit et corrupti natus voluptas.', 0, 0, '1977-09-16 02:44:43', '2013-08-02 08:21:32');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (6, 6, 6, 'Quo et ut quam sit eos. Facere placeat eveniet rem omnis. Ad consequatur dignissimos dolores excepturi. Consectetur ut eius provident ea vel vel provident.', 0, 1, '2015-09-10 12:22:20', '1992-08-12 02:08:04');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (7, 7, 7, 'Voluptates illum sit et quisquam. A placeat autem explicabo nam odio nam inventore. Dolore voluptas minus qui dignissimos facilis nihil quod sunt.', 1, 1, '1973-06-19 18:43:01', '1998-05-11 23:26:20');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (8, 8, 8, 'Aliquid aut veritatis qui eveniet perferendis. Omnis pariatur quas non. Ducimus voluptas voluptatibus magnam est.', 0, 0, '1985-03-17 07:54:54', '1985-04-30 22:56:05');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (9, 9, 9, 'Facere omnis ab eveniet velit veritatis quibusdam quaerat qui. Error adipisci delectus sed animi. Voluptas et minus voluptatem. Beatae velit impedit numquam eos qui.', 0, 0, '2018-10-19 11:26:21', '1997-12-15 16:16:45');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (10, 10, 10, 'Deserunt doloribus qui voluptate quam. Quia odit mollitia cum. Aut aut molestiae voluptatem maiores impedit.', 0, 1, '2001-05-17 09:49:28', '2021-02-05 14:01:17');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (11, 11, 11, 'Eum porro est sunt. Molestias veniam sit necessitatibus alias nostrum. Et a sunt tempora eum blanditiis et enim id.', 0, 0, '2014-03-21 17:41:00', '2002-07-29 01:11:15');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (12, 12, 12, 'Earum tenetur possimus eius labore vel sunt esse. Dolorem repellendus et quia. Ab eaque odit quisquam. Dolores quo asperiores voluptas quae dolorem iusto.', 0, 0, '2001-04-14 19:51:08', '2015-02-25 13:20:54');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (13, 13, 13, 'Temporibus voluptas aliquid unde autem expedita cupiditate. Pariatur dolorem aut fuga esse. Fuga qui enim eos nesciunt rem porro aut sed. Porro mollitia commodi sint eius.', 1, 1, '2017-02-27 22:36:19', '2015-03-23 10:13:47');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (14, 14, 14, 'Voluptas eum placeat neque nihil omnis. Qui porro et id et placeat quas sunt suscipit. Perferendis et exercitationem blanditiis accusantium hic ex.', 1, 1, '1996-12-18 01:08:54', '1988-12-08 14:13:41');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (15, 15, 15, 'Velit nostrum eum pariatur delectus. Aliquam quo ab delectus aperiam sunt et. Quo natus velit cum ratione rerum ut beatae.', 1, 0, '2014-12-30 14:42:34', '2020-07-17 19:39:40');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (16, 16, 16, 'Ducimus provident est ullam. Aut nemo fuga temporibus nihil tempore et autem. Minima dolores amet molestiae.', 1, 1, '2005-07-20 23:59:09', '2012-10-12 17:45:29');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (17, 17, 17, 'Ipsum possimus molestias aliquam tempora quos. Sunt exercitationem ea suscipit provident consequatur et. Explicabo neque quia beatae iusto a maxime in. Doloribus a dolorem corrupti.', 0, 1, '1989-09-19 11:27:10', '2003-10-29 02:12:37');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (18, 18, 18, 'Excepturi id repellendus aliquid provident. Fuga aut officiis dignissimos maxime sed. Autem dolores aliquid eum nostrum alias. Recusandae occaecati aut molestiae deserunt.', 1, 0, '1984-03-31 01:48:32', '1985-03-22 16:23:10');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (19, 19, 19, 'Odit sapiente labore enim consequatur possimus asperiores modi id. Eius in id et.', 1, 1, '1978-01-29 11:18:00', '2003-09-18 17:58:43');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (20, 20, 20, 'Accusamus ea nisi est ullam quidem et. Cupiditate qui est voluptatem nulla incidunt consequatur suscipit blanditiis. Pariatur minus officiis magni cum quis minima.', 1, 0, '1974-07-16 09:20:38', '2021-03-28 19:10:47');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (21, 21, 21, 'Consequuntur magnam qui qui laboriosam minima dolorum odio. Architecto sit minus facere hic nesciunt.', 0, 0, '2014-11-29 09:06:38', '1994-01-31 14:30:50');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (22, 22, 22, 'Consequuntur modi ullam minus rem perspiciatis dolore est. Magni ea voluptatum sint exercitationem. Quis alias dolorem velit molestiae accusamus nulla.', 0, 0, '1987-01-05 02:25:39', '2000-12-16 23:27:44');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (23, 23, 23, 'Animi quod ratione accusantium maxime perferendis. Accusamus quae soluta illum rerum est necessitatibus sapiente porro. Alias quia quos alias ratione ab.', 1, 1, '2006-11-18 10:24:46', '2008-06-04 12:15:27');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (24, 24, 24, 'Autem vel accusamus eum. Voluptatem ratione voluptatum voluptatem adipisci suscipit similique quis. Dignissimos enim dolorem eaque error. Vel necessitatibus dolorem veniam consequuntur ipsum. Inventore qui assumenda quae libero est.', 1, 1, '2006-01-15 19:56:06', '1972-01-28 14:48:39');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (25, 25, 25, 'Quis autem autem nemo molestias recusandae sit in. Accusamus repellendus doloremque voluptatem qui temporibus expedita. Aut aut illo dolorum tenetur aliquam. Corporis quia ut est aut et ea.', 0, 1, '1977-12-07 08:24:09', '2002-09-09 09:03:13');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (26, 26, 26, 'Quia rerum consequatur a sed illum beatae amet voluptatem. Ut quam ex pariatur ab non dolorem qui praesentium. Rem corporis nostrum voluptatem eius aut rerum dolores.', 0, 1, '2000-10-02 05:15:05', '1986-05-08 21:40:12');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (27, 27, 27, 'Aut blanditiis minus et fugiat veniam. Dignissimos sint doloremque autem nemo est aliquam occaecati qui. At rerum qui inventore sunt. Aliquam nostrum aliquid veniam omnis.', 1, 0, '2004-05-22 21:28:16', '2012-04-21 17:06:45');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (28, 28, 28, 'Voluptatem sequi illo nulla at repellendus illum. Distinctio et amet maxime harum et aut.', 0, 0, '1970-03-11 15:50:42', '1977-04-27 09:19:02');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (29, 29, 29, 'Aut sapiente ipsam rerum consequuntur quasi. Praesentium minus repellendus nesciunt corrupti sed. Corporis in eius beatae ut aut rem. Sint dolore aut consequatur ut sint at soluta mollitia.', 0, 1, '2009-03-20 08:24:20', '1977-02-16 08:23:17');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (30, 30, 30, 'Dolorem dolor ut quia et quo necessitatibus voluptas. Est eos aut optio magnam autem ea. Dicta qui dolores molestiae ducimus. Facere porro quae perferendis sed delectus debitis cupiditate.', 0, 0, '1995-07-30 19:49:25', '1981-10-19 20:33:38');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (31, 31, 31, 'Animi dignissimos consequatur quam ullam. Est et officia quasi molestias nemo voluptatibus. Quam quia magni quae facere itaque est.', 1, 0, '1997-01-10 20:05:58', '1979-08-17 00:31:54');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (32, 32, 32, 'Et voluptatem voluptatibus quibusdam blanditiis. Dolorum et optio ratione eos in nisi laudantium.', 1, 1, '2002-07-07 00:50:53', '1983-11-27 19:08:55');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (33, 33, 33, 'Maiores ab dolorum cupiditate. Illo cupiditate delectus ipsum recusandae dolores doloremque vitae. Similique qui nostrum perferendis molestiae cumque molestiae.', 1, 1, '2002-09-30 09:17:01', '1990-12-18 08:20:41');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (34, 34, 34, 'Perspiciatis necessitatibus voluptas beatae quo et. Nesciunt quas esse at culpa adipisci quia sint. Veritatis aliquid quis quia rerum dolores quibusdam illum. Repellat ducimus ipsam est accusantium ut.', 0, 1, '1979-03-19 16:42:55', '1990-09-17 15:44:29');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (35, 35, 35, 'Nisi porro non error quos illum ipsum. Accusantium fugiat eaque quae voluptatibus corrupti. Harum vero adipisci et.', 0, 1, '1989-03-25 13:13:30', '1974-01-12 13:45:18');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (36, 36, 36, 'Illo perferendis labore et laudantium repudiandae. Ea perferendis et accusantium numquam eum illo. Consectetur dolor eum quo quo autem nobis.', 0, 0, '1999-10-02 01:04:22', '2007-07-19 04:18:31');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (37, 37, 37, 'Corporis ut excepturi sit maxime. Libero in ut fugiat corporis nesciunt nobis voluptates. Id impedit voluptas voluptas nesciunt et porro et. Quaerat hic facere reiciendis ullam.', 1, 1, '2013-08-04 20:10:23', '1997-07-01 15:22:41');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (38, 38, 38, 'Et qui laudantium ullam saepe dolorem occaecati et. Quia aut ex unde dignissimos in facere qui autem. Occaecati qui veritatis deserunt est et accusantium.', 0, 1, '1982-09-16 09:10:30', '1983-09-20 21:19:11');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (39, 39, 39, 'Aut id itaque cupiditate sed qui enim. Voluptas distinctio commodi corrupti tempore cupiditate. Vero eum nobis quidem debitis. Ex eaque officiis est quia aut in.', 0, 1, '1995-10-08 17:51:24', '1973-07-24 03:12:12');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (40, 40, 40, 'Consequatur esse quo aut aut non illum. Nihil voluptatem officia dolor rerum aspernatur culpa eveniet. Doloribus dolor aliquam soluta iusto eum adipisci.', 1, 1, '1989-04-04 20:58:06', '1991-12-02 00:57:28');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (41, 41, 41, 'Dolor iste aut quo quae molestiae atque reiciendis alias. Exercitationem recusandae officiis aspernatur vel doloremque aut. Aliquid repellat corrupti velit natus reprehenderit consequatur ut.', 0, 1, '2011-02-15 16:16:02', '1984-05-30 09:10:32');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (42, 42, 42, 'Soluta consequuntur eum quod iure quibusdam iste eum. Dignissimos mollitia quasi sequi qui quasi aliquid quisquam.', 0, 0, '1971-02-02 17:40:05', '1972-10-06 14:40:23');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (43, 43, 43, 'Dolorum quas deleniti aut aut. Impedit enim non quibusdam id. Non voluptate sed quasi nisi vel excepturi rerum.', 0, 0, '1994-02-02 20:30:23', '1996-01-27 23:11:49');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (44, 44, 44, 'Ipsam sit sit animi et est. Facere voluptatem voluptatem dolores illum rerum illo. Cupiditate rerum accusamus ut voluptatibus id quia.', 0, 0, '1996-07-14 02:47:54', '2008-12-01 01:05:25');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (45, 45, 45, 'Numquam ab omnis ducimus nisi aut. Est ducimus ratione odio non quidem. Voluptatum mollitia numquam quidem aut nam voluptatem.', 1, 1, '1972-03-28 22:33:28', '2011-12-30 21:44:49');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (46, 46, 46, 'Ut quibusdam eligendi non quibusdam commodi. Accusantium quis consequatur architecto quia. Vero animi dolores voluptatem qui voluptatum harum.', 1, 0, '2021-03-25 19:09:27', '2003-03-17 12:10:44');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (47, 47, 47, 'Ipsam delectus quia nesciunt id. Quo dicta officia aliquid quae. Praesentium sed perferendis ducimus deserunt temporibus.', 0, 1, '2001-07-27 23:32:08', '2020-10-16 11:16:37');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (48, 48, 48, 'Eligendi quod iusto doloribus perferendis. Ducimus eos quae earum consequatur fugit ut odio. Voluptas repellat et doloribus et et impedit quo neque. Autem doloribus nostrum est aut maiores omnis facere.', 1, 1, '2018-04-07 17:30:59', '2009-08-17 03:11:31');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (49, 49, 49, 'Corporis est error assumenda commodi suscipit. Ut odio soluta hic et blanditiis esse. Molestiae molestiae aut optio maiores in fugit dolores.', 1, 1, '2009-02-02 13:08:09', '1996-04-01 05:30:23');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (50, 50, 50, 'Iusto neque a quae ipsum nobis autem itaque. Qui id aut necessitatibus. Impedit reiciendis autem velit quod odit laudantium omnis. Quis possimus doloribus ab accusamus.', 1, 1, '2006-02-13 06:00:16', '2014-01-18 11:10:28');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (51, 51, 51, 'Suscipit illo perferendis qui eius hic est inventore sunt. Ut saepe recusandae voluptas suscipit quasi aperiam qui. Hic qui rerum tempore provident.', 1, 0, '1970-06-05 13:03:37', '2018-01-29 18:00:35');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (52, 52, 52, 'Distinctio omnis cum rem suscipit natus. Voluptate ex recusandae unde sunt rerum et. Dolor possimus voluptatibus aspernatur doloremque dolor eos.', 1, 0, '1996-04-07 09:27:13', '1989-11-28 03:09:16');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (53, 53, 53, 'Ut officia hic debitis esse ratione eius id. Optio ab dolor totam ut. Et harum nemo eaque fugit ullam ab quis dignissimos. Deserunt et consequuntur ab sunt nam.', 0, 0, '2012-10-27 03:04:26', '2000-05-27 03:02:28');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (54, 54, 54, 'Deserunt quas quos at tempora. Doloremque voluptatum inventore tenetur nam reprehenderit. Minus expedita suscipit iusto quia voluptas doloribus et dolores.', 1, 0, '1982-10-13 00:33:20', '2005-12-30 09:33:14');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (55, 55, 55, 'Dolore voluptatem voluptate quae dignissimos non rem. Debitis molestiae molestiae at debitis et dolores. Qui ratione maiores aut. Provident enim dolor autem ullam.', 0, 1, '1974-12-08 06:26:26', '2020-12-16 17:27:52');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (56, 56, 56, 'Placeat dolorem ut alias. Dolorem aut et impedit ea omnis debitis. Amet eos est animi. Qui corporis et veniam. Et laudantium iure non fugit aliquam quisquam autem voluptatem.', 1, 0, '2012-11-26 05:11:47', '2013-05-15 17:16:21');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (57, 57, 57, 'Minima nobis at incidunt accusantium. Molestias dolor sint odit sint vel non. Repudiandae eum est a dolor recusandae quo velit omnis.', 1, 0, '1973-01-29 03:36:41', '1979-10-02 02:14:26');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (58, 58, 58, 'Hic est aut esse rerum et vero. Consequuntur est dolorem dolore.', 0, 1, '2009-09-20 09:43:09', '2003-07-21 08:50:59');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (59, 59, 59, 'Non natus sit eos placeat nostrum ab dicta. Officiis a quas sed aspernatur occaecati molestias dolor quibusdam. Quia at ab eligendi quis modi vero.', 0, 0, '2021-05-08 09:46:34', '2014-11-22 18:16:36');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (60, 60, 60, 'Ut aut saepe nemo voluptatem sunt. Hic ad adipisci perspiciatis voluptatem unde nobis et. Beatae accusantium autem sit deserunt molestiae quaerat. Eligendi voluptate dicta dolorem neque eius.', 0, 0, '2015-09-12 07:21:54', '2018-05-28 08:06:11');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (61, 61, 61, 'Similique dolor qui voluptas recusandae minima. Dolores vitae quis consequatur dolores libero tempore consequatur. Eligendi pariatur corrupti et ducimus qui possimus ipsum tempore. Sequi facilis eum odio nulla quis.', 0, 1, '2010-06-10 19:37:29', '1993-11-23 04:22:47');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (62, 62, 62, 'Sit nihil occaecati unde ad fugiat eum cupiditate quidem. Dignissimos aut non saepe illo odio quae saepe. Porro dolorem dolores ipsam.', 1, 1, '2012-02-06 21:23:34', '1980-08-31 16:51:16');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (63, 63, 63, 'Consequatur vitae dolor est consequatur sint cum dolorem. Nihil esse qui ipsam ut. Repellendus amet illum autem ea. Eos accusantium non et nisi qui illum. Sed odit sit hic.', 1, 0, '1991-09-19 07:37:37', '1996-02-27 19:28:40');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (64, 64, 64, 'Delectus nihil ut exercitationem laborum ex fugit omnis hic. Quis temporibus est reiciendis. Et atque fugiat reiciendis voluptas ratione eos aut tenetur.', 1, 1, '1992-02-23 07:25:41', '1992-01-30 01:02:59');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (65, 65, 65, 'Numquam nam quibusdam consequuntur fuga. Similique dolorem fuga perspiciatis officia. Consectetur perferendis dolor autem.', 1, 0, '2012-11-10 05:22:36', '1979-12-26 14:43:31');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (66, 66, 66, 'Magnam ipsam reiciendis voluptatem repellendus fuga accusamus. Quam ipsum est delectus ea. Autem voluptas voluptatem autem sit illo qui.', 0, 0, '1985-05-20 08:07:00', '1984-06-26 06:17:27');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (67, 67, 67, 'Sint cum voluptates repudiandae ut. Provident eaque nam voluptatibus nobis. Aperiam perspiciatis veritatis aut nemo aut similique odio. Iusto dolores quas placeat laboriosam repellendus modi necessitatibus.', 0, 0, '1979-12-21 00:01:55', '2000-11-02 12:47:47');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (68, 68, 68, 'Numquam quia nobis aut quos ut. Tempore quia inventore quisquam molestias temporibus voluptas. Ipsam repellendus nesciunt quaerat. Earum aut occaecati nesciunt consequatur quibusdam voluptates ut. Eos dolores ullam asperiores fuga qui corrupti veritatis.', 0, 0, '1987-03-15 07:23:07', '1982-09-19 11:36:10');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (69, 69, 69, 'Ut numquam voluptas atque ducimus rerum ut et. Asperiores non id eaque qui deserunt. Ab dolores doloribus sed in. Adipisci nam consequatur doloremque illum impedit. Et aspernatur est asperiores illum eveniet et quasi ullam.', 0, 0, '1988-04-04 11:02:37', '2001-01-20 05:58:47');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (70, 70, 70, 'Corporis aliquid praesentium aut in similique repellat nobis. Doloribus soluta sunt expedita. Velit sed neque quam et voluptates.', 1, 0, '1973-11-28 00:56:32', '2015-12-24 00:14:45');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (71, 71, 71, 'Ratione ea earum molestias nobis facilis magni totam. Exercitationem quis ipsam quisquam rem. Sed maiores corporis libero ut non vel.', 1, 0, '1999-03-05 21:06:50', '2004-08-04 17:22:00');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (72, 72, 72, 'Aliquid vel quo ut architecto. Repellat non quod voluptate aut.', 1, 0, '1996-07-13 21:15:46', '1994-09-29 07:26:35');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (73, 73, 73, 'Atque sed perferendis aspernatur harum quis. Nihil ad provident iure dicta sit quibusdam possimus. Corporis qui occaecati tempore et cum.', 1, 0, '2003-05-24 18:03:35', '2002-01-29 11:53:39');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (74, 74, 74, 'Enim doloremque cumque corporis a. Error quos rerum ea et sequi. Dolorum similique quae nam aperiam rem rerum et. Minus at quod consequatur.', 1, 1, '1985-06-10 22:46:06', '1997-09-01 00:40:12');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (75, 75, 75, 'Nobis quisquam saepe quo doloremque enim consequatur ut. Aut dolorum temporibus beatae.', 1, 1, '2018-12-21 02:21:45', '2011-07-15 09:50:17');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (76, 76, 76, 'Nam mollitia odit incidunt. Sit earum et reiciendis. Magni qui quasi voluptas quasi autem cum sit. Laudantium quia nam voluptatem fugiat sunt eligendi ea.', 0, 1, '1973-12-03 21:35:05', '1974-11-29 18:26:43');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (77, 77, 77, 'Rerum ut deserunt quam consequatur ut qui enim. Est et quasi est corrupti rerum. Tempore eligendi amet quia est aut adipisci dolorem minus. Qui asperiores ut repellendus dolores maxime accusamus voluptas.', 1, 1, '1996-01-25 02:52:30', '2005-11-28 03:59:14');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (78, 78, 78, 'Qui velit dolor tempore ut nostrum facere molestias quam. Deserunt facilis qui quas dolorem non vero recusandae aperiam. Doloremque consequatur vel molestiae corrupti architecto. Doloremque ab sunt fugit et repellendus voluptas. Architecto ipsam alias est sit.', 1, 0, '1971-05-11 03:50:31', '2010-08-04 13:52:29');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (79, 79, 79, 'Labore doloremque cupiditate nesciunt quo. Provident enim sunt omnis adipisci facere. Possimus ipsam recusandae sed id debitis nulla corporis.', 0, 0, '1998-07-30 16:03:41', '1979-01-06 23:17:14');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (80, 80, 80, 'Dolorem labore eum commodi. Autem officiis eius quaerat nemo quis numquam fugit. Ut est quo rem saepe.', 0, 1, '1978-02-01 01:05:59', '1995-03-16 14:27:23');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (81, 81, 81, 'Non tenetur aut voluptatem tempora. Aliquam labore vero aut qui nemo alias. Delectus vero asperiores quaerat corporis vel.', 1, 0, '1979-01-18 18:36:24', '1989-09-27 22:58:43');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (82, 82, 82, 'Itaque maiores natus expedita fuga deserunt et eius. Assumenda consequatur voluptatibus vitae quidem ut quia. Iure consequatur eum tempore ea distinctio.', 0, 0, '2010-05-16 07:49:37', '1997-04-24 20:20:33');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (83, 83, 83, 'Porro illo alias ipsum ut. Ipsam cupiditate doloremque ullam eveniet. Vel hic explicabo commodi libero. Ut fuga est rem officiis et fugiat.', 0, 1, '2020-08-11 01:10:37', '1985-12-31 21:34:15');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (84, 84, 84, 'Qui provident expedita ut quaerat dolorem itaque hic. Doloribus qui quas nihil minima. Aspernatur earum eos architecto sint aut laboriosam. Quos tenetur beatae voluptate voluptas esse eaque neque.', 1, 1, '2011-01-06 09:12:20', '1995-01-31 04:24:18');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (85, 85, 85, 'Perferendis earum qui itaque quam explicabo ratione. Impedit libero fugiat quae. Nobis quidem minima eius minus non ea voluptas. Maiores voluptates eligendi quibusdam veritatis repudiandae vero.', 1, 0, '2017-02-26 06:52:57', '1999-12-22 08:18:21');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (86, 86, 86, 'Eveniet fugit pariatur et mollitia aspernatur minus. Vel voluptatem eveniet iusto vel nemo est eligendi. Dolorum molestiae eum in ut. Nihil numquam sed odio saepe excepturi explicabo. Maiores corporis sit soluta laborum veritatis.', 0, 0, '2013-11-22 12:12:14', '1977-01-01 21:00:02');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (87, 87, 87, 'Expedita eum nemo sint. Deleniti voluptas et voluptatem. Placeat quia autem eius et.', 1, 1, '2004-11-26 01:24:05', '1972-07-26 00:13:22');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (88, 88, 88, 'Tempora numquam sequi praesentium laborum nemo. Rerum enim et nulla aspernatur sit praesentium magni exercitationem. Ut laboriosam veniam recusandae voluptatibus. Nulla laudantium id ipsum quo ad molestias animi.', 0, 1, '1972-12-03 21:36:30', '1988-12-13 14:16:33');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (89, 89, 89, 'Autem veritatis laborum repellat amet. Quis veniam et possimus nobis natus occaecati sunt repellendus. Blanditiis occaecati aspernatur consequatur sed.', 1, 1, '2012-06-07 11:53:42', '2019-11-18 05:14:00');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (90, 90, 90, 'Quia voluptas et quo culpa tenetur dolores. Consequatur recusandae asperiores fugit repellendus fugiat. Exercitationem vitae deleniti dignissimos officiis voluptatem. Natus similique sed autem rerum eos.', 1, 0, '2001-04-12 03:51:45', '2006-03-30 19:32:28');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (91, 91, 91, 'Vero quos rerum voluptate ut aperiam doloribus ea et. Et qui et qui dolorem sed nihil. Deserunt mollitia explicabo cum qui quia et ipsam. Dolor et magnam voluptatem velit possimus.', 0, 1, '2010-01-15 19:38:52', '1977-10-09 03:44:55');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (92, 92, 92, 'Nam totam est est suscipit quia consequatur. Explicabo et quia et ratione voluptates voluptatem optio. Quasi quam non consectetur animi quos eos repudiandae.', 1, 1, '1979-06-14 16:56:33', '2003-10-14 03:09:55');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (93, 93, 93, 'Sed iste quibusdam molestiae quia tenetur quo. Nam illum unde sunt praesentium ut facilis eum molestiae. Enim ipsa unde consequatur ipsum praesentium.', 1, 1, '1991-07-21 06:25:15', '2015-07-01 02:52:52');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (94, 94, 94, 'Consequatur totam minima in dolores assumenda. Quo reiciendis odio ab qui optio ipsa at. Voluptate rem est et voluptas ab officiis.', 1, 1, '2009-08-04 22:03:41', '2006-01-30 21:36:00');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (95, 95, 95, 'Sapiente culpa aliquid eveniet qui vero dicta reiciendis. Repudiandae dolor assumenda quibusdam voluptatem eos.', 1, 1, '1972-01-24 07:23:51', '1985-06-30 05:01:44');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (96, 96, 96, 'Harum qui accusantium et est eum qui mollitia. Minima quibusdam aut omnis quo excepturi voluptas itaque aut. Quae et animi quibusdam aut et quibusdam qui eveniet.', 0, 1, '1979-08-18 23:43:30', '2015-05-18 03:30:09');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (97, 97, 97, 'Et voluptate ex quae maxime odit saepe. Perspiciatis voluptas dolorem necessitatibus asperiores. Quas dolorem cum possimus dolorum suscipit. Quia incidunt quos in officiis nam eveniet nemo hic.', 1, 0, '1990-12-30 22:27:01', '1982-01-07 00:02:07');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (98, 98, 98, 'Qui fugiat at quia. Voluptate quos tempora esse sint blanditiis. Incidunt perspiciatis necessitatibus ullam necessitatibus. Doloremque sed modi dolorem quis. Qui voluptate numquam suscipit amet.', 0, 0, '1984-11-09 20:13:41', '1987-05-22 08:28:15');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (99, 99, 99, 'Qui saepe ut ut fuga aut voluptatibus quis. Aperiam aut consequatur quia asperiores sit similique tempore. Facere dolorem voluptates esse ipsam sit.', 1, 0, '1981-02-10 13:39:28', '1982-06-15 05:20:07');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (100, 100, 100, 'Molestias porro asperiores ab dolore. Rerum facilis sint labore laudantium soluta labore. Sint saepe id ut et. Voluptas quia corporis deserunt esse et in.', 1, 1, '1985-12-18 14:19:59', '1991-10-04 18:56:37');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (101, 1, 1, 'Non aut in perspiciatis impedit quis voluptatem. Fuga voluptas et debitis totam eius nihil.', 0, 0, '1984-02-07 18:37:03', '1982-03-21 09:18:50');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (102, 2, 2, 'Assumenda rerum animi reiciendis officiis ea. Quidem in rerum animi et delectus. Ipsum laboriosam quia doloremque maxime labore tempore iure impedit. Enim ipsam cumque sit rem.', 0, 0, '1993-05-30 01:28:24', '2006-06-21 23:14:39');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (103, 3, 3, 'Sed in ad reprehenderit ducimus. A animi et aliquam et. Ipsa nihil dolores aperiam est aut doloribus et. Ut non pariatur quasi autem.', 1, 1, '1985-12-05 08:47:49', '1995-08-12 22:17:28');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (104, 4, 4, 'Eius deleniti non delectus autem qui aperiam. Exercitationem et dignissimos consectetur vel inventore accusamus harum. Dolores totam animi veniam ipsam. Quo repudiandae sunt vitae temporibus aliquid quis maxime.', 0, 0, '1998-01-01 20:19:57', '1997-08-10 06:21:17');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (105, 5, 5, 'Sunt vero modi ad odio rem. Quia error inventore quod eos nostrum reprehenderit dolore iste. Aliquam cum ipsam enim qui doloribus. Dolor possimus eaque quo autem sit aut non. Doloribus perferendis ut iusto voluptatibus.', 1, 1, '2015-01-02 22:55:28', '2013-07-12 13:39:20');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (106, 6, 6, 'Tempora voluptatem aut aut eos. Porro officiis magnam sint doloremque inventore. Iste molestias molestiae quia et dignissimos numquam officiis. Laboriosam perferendis animi molestiae.', 1, 1, '1986-08-12 20:43:05', '1978-07-07 14:49:26');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (107, 7, 7, 'Enim placeat inventore quos quibusdam in quo. Consequatur accusantium minima est ratione eligendi est. A similique voluptate blanditiis perspiciatis dolor. Facilis adipisci totam est facilis.', 1, 1, '1979-08-26 21:30:22', '1998-05-25 09:02:26');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (108, 8, 8, 'Consequatur maiores velit consectetur. Cumque voluptatum libero blanditiis error ut cumque. Laborum earum dolor voluptas.', 0, 0, '2017-10-27 00:59:54', '2016-01-29 12:25:12');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (109, 9, 9, 'Voluptatem accusantium impedit et aperiam dolorem. Atque necessitatibus eos suscipit et fugiat tenetur minima aliquam. Amet esse culpa consequatur eum aut.', 0, 0, '1994-08-27 04:27:48', '2009-05-22 05:05:14');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (110, 10, 10, 'Asperiores magnam aut expedita consequuntur. Mollitia optio quasi similique maxime autem corporis. Sequi eaque dolor omnis nihil eius omnis explicabo eos.', 1, 1, '1999-07-09 16:32:06', '1970-01-09 00:50:03');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (111, 11, 11, 'Ea eligendi dicta et sed. Officia iusto vitae doloribus voluptas quis similique commodi possimus. Deserunt optio placeat nobis dolor rerum. Iste omnis et dignissimos dolor.', 0, 0, '2014-08-22 12:35:11', '1970-06-07 02:56:19');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (112, 12, 12, 'Unde aut ut quisquam minima et aut in. Itaque dicta nemo et. Sed ut et aperiam rerum vel asperiores velit et. Ut minus asperiores sit amet.', 0, 1, '2009-12-09 19:18:00', '2000-01-22 07:46:42');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (113, 13, 13, 'Vitae est eos et voluptatem est autem adipisci. Et suscipit ut cupiditate sint vitae consequatur. Tenetur soluta magni cumque. Est ipsum a aut. Doloremque minima soluta qui a id nobis.', 1, 1, '2016-01-27 04:44:44', '1977-01-18 16:38:04');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (114, 14, 14, 'Facilis officia temporibus dolorum veniam et ratione. Maiores consequatur ad numquam ipsum. Debitis blanditiis quia libero quibusdam dignissimos sequi quae. Ad libero eos quod.', 0, 1, '1973-12-21 09:21:23', '2019-11-05 09:41:04');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (115, 15, 15, 'Excepturi deleniti voluptas esse ut dolorem. Sequi rem placeat dolorem doloremque quis nemo. Qui sint officia tempora rem similique. Quam accusantium doloribus repellat sunt.', 1, 0, '1975-10-19 06:47:43', '1984-09-27 16:29:12');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (116, 16, 16, 'Veritatis non omnis nobis fugiat. Quo unde iure dolore. Cumque eum ea molestias. Vel voluptatem doloribus reiciendis voluptas cupiditate illo.', 0, 1, '2007-12-18 05:26:15', '1986-10-29 22:42:17');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (117, 17, 17, 'Et et voluptatem corrupti esse ea molestiae. Voluptatem deleniti aut odio. Sed ratione consequatur incidunt ex.', 0, 1, '1989-07-05 08:28:22', '1994-05-24 03:50:03');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (118, 18, 18, 'Voluptate illo eos animi ea sed debitis consequatur enim. Quae quia reprehenderit provident saepe. Consequatur commodi et voluptas cum.', 1, 1, '2009-10-29 15:23:02', '1985-07-15 17:57:41');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (119, 19, 19, 'Omnis nihil qui quis tenetur sed odio aut ad. Optio nulla eum quas quia vitae esse harum. Nisi aut sit non odio.', 1, 0, '1983-07-06 16:08:47', '2018-07-12 17:19:11');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (120, 20, 20, 'Soluta recusandae enim et. Et magnam dolorum dolore quisquam ullam itaque explicabo. Quia expedita nemo nihil quo ea. Aut et tenetur illum architecto ut nesciunt.', 0, 1, '2015-06-11 10:21:24', '1980-08-06 23:25:31');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (121, 21, 21, 'Aut voluptas quae hic cupiditate officiis nemo. Nulla ea tempora ratione nihil. Minima recusandae et quis nemo.', 1, 0, '1979-07-20 12:13:14', '1974-03-29 03:58:08');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (122, 22, 22, 'Quo est magnam officiis non sit dolore aliquid dicta. Et minima dolorem corrupti enim eaque. Reprehenderit iste facilis voluptas quia qui quo sint. Earum culpa odit culpa nulla eum est. Mollitia hic sequi omnis consequatur est animi.', 1, 0, '1976-12-12 02:20:31', '2000-04-20 06:18:18');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (123, 23, 23, 'Id delectus laboriosam non sapiente asperiores sit. Ut velit sit dolor maiores blanditiis repellat.', 1, 0, '1970-11-11 01:40:22', '2011-06-24 14:19:18');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (124, 24, 24, 'Sed dignissimos dolor et deleniti maiores est enim ut. Saepe animi ut iusto esse recusandae eos molestiae. Qui quo tenetur laudantium distinctio dolor. Et non et ut.', 0, 0, '1987-03-05 16:26:05', '2015-07-14 04:44:48');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (125, 25, 25, 'Pariatur eos suscipit et sed. Magnam laudantium voluptatem incidunt dolor adipisci reprehenderit. Aut nam dolores id at. Possimus libero sint nostrum dignissimos est accusantium molestias.', 1, 1, '1977-01-11 01:34:50', '2012-09-04 09:44:45');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (126, 26, 26, 'Qui ea aperiam est perferendis. Debitis ducimus quaerat ea expedita quae. Voluptas doloribus impedit non ea. Doloribus consequuntur explicabo expedita alias qui aperiam.', 0, 0, '1973-06-16 13:49:54', '1979-08-14 16:14:19');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (127, 27, 27, 'Facere quo quasi ipsam sunt pariatur. Eius porro quibusdam necessitatibus iusto fuga suscipit. Veniam nulla aut veritatis saepe voluptatem. Reprehenderit voluptatibus voluptatem earum magnam dolorum aperiam.', 1, 0, '2003-09-17 03:57:16', '2007-06-05 23:24:24');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (128, 28, 28, 'Adipisci quis cumque omnis et assumenda amet ut. Illum optio neque sit vel. Ut sint doloremque ab et vero dolor doloremque aliquid.', 1, 1, '1980-02-15 16:39:45', '1983-01-24 08:27:26');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (129, 29, 29, 'Ex at voluptas similique nisi et quasi. Officia rem et repudiandae voluptates veniam est ut. Rerum non occaecati nihil fugit natus rem.', 1, 0, '1987-01-09 06:50:46', '1986-12-18 09:28:45');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (130, 30, 30, 'Delectus ut et sit et aliquid. Et beatae aut sed quasi blanditiis est. Ratione fugiat atque corporis nostrum qui.', 1, 0, '1977-05-24 13:04:07', '1972-09-29 00:21:10');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (131, 31, 31, 'Voluptatem error quis tempora sit soluta. Alias non dolorem modi illum aut. Vel ratione magni qui optio incidunt nihil nobis. Quod ad molestiae est quas tempore.', 0, 0, '1985-07-11 17:12:57', '1980-10-23 03:40:22');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (132, 32, 32, 'Odio nemo in corporis distinctio sint delectus. Sed saepe est consectetur aspernatur. Maiores facilis minus iusto et laboriosam.', 1, 0, '2006-08-22 15:17:31', '2014-05-23 20:55:05');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (133, 33, 33, 'Et neque similique amet architecto qui. Sed saepe voluptatem perspiciatis optio cupiditate error. Ea est et unde officiis dolor architecto ducimus. Laborum et unde cupiditate rerum rerum tenetur.', 0, 1, '1984-04-09 21:08:42', '1972-05-25 15:09:37');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (134, 34, 34, 'Laboriosam eum quibusdam ipsa dolorum molestiae quisquam id. Dolore dolores inventore dolore alias qui. Eum voluptatum optio provident quisquam. Et quam quis sapiente architecto.', 0, 0, '2003-04-06 04:47:33', '1976-08-03 06:33:23');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (135, 35, 35, 'Officia ut et in tempora ratione aperiam. Iste animi cumque aspernatur incidunt. Quasi quisquam debitis perspiciatis possimus dolorem. Animi perspiciatis qui magnam ab velit ut similique.', 0, 1, '1977-05-28 14:55:22', '1970-02-16 17:00:56');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (136, 36, 36, 'Qui distinctio deleniti porro quibusdam. Neque eius maiores qui reiciendis tempore dolores. Occaecati ullam iusto rerum similique quis est.', 1, 1, '2005-10-30 19:56:44', '1996-11-11 00:58:17');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (137, 37, 37, 'Unde enim ut libero eligendi. Blanditiis perferendis adipisci non ex corrupti. Voluptas et assumenda dolores maiores placeat praesentium atque.', 1, 0, '2017-02-10 18:13:45', '2014-04-15 09:25:08');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (138, 38, 38, 'Ullam sed qui tempora error dolor odit earum. Totam aut repudiandae qui repudiandae consectetur rem in nihil.', 1, 1, '2003-03-10 15:36:29', '2012-05-03 07:13:33');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (139, 39, 39, 'Esse voluptatem rerum facere facilis quis cum. Minima occaecati enim eum culpa eum fugiat adipisci ut. Incidunt similique saepe labore illum magnam eligendi. Illo illum modi ratione reiciendis id in asperiores provident.', 0, 1, '1993-10-09 17:00:41', '1998-01-31 02:17:53');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (140, 40, 40, 'Reiciendis recusandae est ut sint. Quaerat deleniti vero mollitia alias molestias magnam autem sint. Porro incidunt maxime atque blanditiis tempore. Consequatur neque totam voluptatibus consequatur perspiciatis.', 0, 0, '1993-02-06 11:42:51', '2020-05-04 09:26:30');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (141, 41, 41, 'Nostrum et minima esse consequatur. Aut repellat amet est sint molestiae earum dolorem. Fugiat dolor non earum tenetur quidem voluptatem veniam.', 1, 0, '1993-12-02 11:17:44', '1970-05-28 03:16:16');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (142, 42, 42, 'Id laboriosam placeat quod laborum eum rerum ut voluptatem. Quis eveniet delectus recusandae doloribus. Iusto ex est autem dolor qui mollitia. Natus sed molestiae eligendi nostrum consequatur consequatur.', 1, 0, '1977-10-06 23:52:05', '2002-12-04 23:07:21');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (143, 43, 43, 'Voluptate omnis inventore rem saepe molestias. Officia ut illo quis rerum ut sed beatae. Ut aut esse error dignissimos tempora consectetur. Consectetur et inventore molestiae.', 0, 0, '1981-11-06 11:19:48', '2013-06-08 21:45:40');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (144, 44, 44, 'Ut quod error magni non tenetur. Sint voluptate eum tempore itaque quia et quaerat nesciunt. Ullam et eum est molestiae. Totam voluptas qui nesciunt molestias temporibus vel. Aut iusto est qui ut.', 1, 0, '1977-11-25 18:50:36', '2005-04-12 08:15:34');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (145, 45, 45, 'Voluptas ut et eos debitis. Asperiores maxime deserunt possimus tempore quibusdam eum inventore. Fugiat exercitationem recusandae molestiae perspiciatis maxime molestias et.', 1, 0, '1978-03-27 02:14:58', '2003-05-07 16:12:31');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (146, 46, 46, 'Consequuntur libero aut numquam atque. Amet sed vero ab voluptatem. Voluptatibus dolore cupiditate itaque fugit iste incidunt nihil facere. Et tenetur quasi aut saepe asperiores magni.', 0, 0, '1979-08-08 18:43:52', '1977-08-20 19:03:56');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (147, 47, 47, 'Minus qui dolorem animi veritatis. Repellendus ut aut id quia quasi nam. Quod ipsam earum incidunt sit. Autem et voluptatem quia quidem odit autem.', 1, 0, '1977-01-07 00:03:53', '2011-05-25 11:56:46');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (148, 48, 48, 'Consectetur illo earum ut harum quis. Minima adipisci provident necessitatibus id alias. Ipsa occaecati totam maiores unde id. Id iusto a dolore eligendi.', 0, 1, '1995-09-15 10:33:25', '1976-02-28 01:11:32');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (149, 49, 49, 'Sint ut voluptates quisquam officia. Et cum delectus dignissimos sit perferendis dolorem recusandae minima.', 1, 0, '2009-05-26 15:13:56', '1974-02-04 16:17:55');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`, `updated_at`) VALUES (150, 50, 50, 'Rerum voluptatem commodi animi vitae minus quam. Fugit culpa non laudantium repudiandae labore reiciendis. Maiores aut culpa ex. Aut nesciunt et vel quas sed.', 1, 0, '1993-08-10 12:04:18', '2021-03-07 18:56:55');


#
# TABLE STRUCTURE FOR: messages_likes
#

DROP TABLE IF EXISTS `messages_likes`;

CREATE TABLE `messages_likes` (
  `id` int(10) unsigned NOT NULL COMMENT 'Ссылка на сообщение',
  `count_likes` int(10) unsigned DEFAULT NULL COMMENT 'Количество лайков сообщения',
  `created_at` datetime DEFAULT current_timestamp() COMMENT 'Время создания строки',
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT 'Время обновления строки',
  PRIMARY KEY (`id`),
  CONSTRAINT `messages_likes_ibfk_1` FOREIGN KEY (`id`) REFERENCES `messages` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=101 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Количество лайков медиафайлов';

INSERT INTO `messages_likes` (`id`, `count_likes`, `created_at`, `updated_at`) VALUES (1, 8174, '2005-09-28 17:57:44', '2002-09-18 10:19:14');
INSERT INTO `messages_likes` (`id`, `count_likes`, `created_at`, `updated_at`) VALUES (2, 7, '1995-05-10 13:19:54', '2010-02-14 18:16:22');
INSERT INTO `messages_likes` (`id`, `count_likes`, `created_at`, `updated_at`) VALUES (3, 7836693, '2009-11-17 07:51:31', '2001-04-08 04:24:14');
INSERT INTO `messages_likes` (`id`, `count_likes`, `created_at`, `updated_at`) VALUES (4, 10559782, '1972-04-06 08:20:06', '1979-09-09 21:31:28');
INSERT INTO `messages_likes` (`id`, `count_likes`, `created_at`, `updated_at`) VALUES (5, 786992943, '2009-06-14 20:55:48', '1977-10-04 04:28:11');
INSERT INTO `messages_likes` (`id`, `count_likes`, `created_at`, `updated_at`) VALUES (6, 89315, '2012-04-27 16:50:52', '1996-07-17 22:13:11');
INSERT INTO `messages_likes` (`id`, `count_likes`, `created_at`, `updated_at`) VALUES (7, 83544072, '2018-12-22 03:45:57', '2019-04-22 23:15:31');
INSERT INTO `messages_likes` (`id`, `count_likes`, `created_at`, `updated_at`) VALUES (8, 88, '2016-07-08 12:32:27', '1995-06-03 02:47:38');
INSERT INTO `messages_likes` (`id`, `count_likes`, `created_at`, `updated_at`) VALUES (9, 27461133, '1982-07-09 13:33:16', '2001-08-27 09:21:52');
INSERT INTO `messages_likes` (`id`, `count_likes`, `created_at`, `updated_at`) VALUES (10, 76458, '1978-01-28 18:15:55', '2000-02-19 08:07:45');
INSERT INTO `messages_likes` (`id`, `count_likes`, `created_at`, `updated_at`) VALUES (11, 0, '2002-04-10 20:48:42', '1998-07-16 01:06:39');
INSERT INTO `messages_likes` (`id`, `count_likes`, `created_at`, `updated_at`) VALUES (12, 836397, '1992-11-12 06:27:06', '1971-05-15 13:17:28');
INSERT INTO `messages_likes` (`id`, `count_likes`, `created_at`, `updated_at`) VALUES (13, 224782, '2007-10-31 21:09:20', '1983-10-24 04:36:37');
INSERT INTO `messages_likes` (`id`, `count_likes`, `created_at`, `updated_at`) VALUES (14, 53610, '2019-01-08 15:58:57', '1997-10-28 12:57:46');
INSERT INTO `messages_likes` (`id`, `count_likes`, `created_at`, `updated_at`) VALUES (15, 1, '1976-01-10 19:46:57', '2006-01-13 02:20:49');
INSERT INTO `messages_likes` (`id`, `count_likes`, `created_at`, `updated_at`) VALUES (16, 156, '2017-03-11 01:36:01', '2011-12-23 11:44:06');
INSERT INTO `messages_likes` (`id`, `count_likes`, `created_at`, `updated_at`) VALUES (17, 61804, '1998-01-22 08:04:59', '1972-01-30 05:39:28');
INSERT INTO `messages_likes` (`id`, `count_likes`, `created_at`, `updated_at`) VALUES (18, 4645, '2015-03-15 03:59:29', '1999-09-22 14:16:59');
INSERT INTO `messages_likes` (`id`, `count_likes`, `created_at`, `updated_at`) VALUES (19, 799519077, '2013-03-03 03:46:14', '1994-05-07 05:45:23');
INSERT INTO `messages_likes` (`id`, `count_likes`, `created_at`, `updated_at`) VALUES (20, 9, '2001-09-26 22:58:30', '2021-02-03 06:54:20');
INSERT INTO `messages_likes` (`id`, `count_likes`, `created_at`, `updated_at`) VALUES (21, 251, '2019-07-16 23:05:29', '2005-04-12 07:09:38');
INSERT INTO `messages_likes` (`id`, `count_likes`, `created_at`, `updated_at`) VALUES (22, 288503, '2010-10-11 00:23:58', '2007-04-28 10:06:30');
INSERT INTO `messages_likes` (`id`, `count_likes`, `created_at`, `updated_at`) VALUES (23, 888, '2009-11-21 09:22:23', '1991-06-13 03:12:42');
INSERT INTO `messages_likes` (`id`, `count_likes`, `created_at`, `updated_at`) VALUES (24, 971347308, '2019-01-19 14:22:08', '1991-04-25 06:09:20');
INSERT INTO `messages_likes` (`id`, `count_likes`, `created_at`, `updated_at`) VALUES (25, 38144, '2015-10-22 12:23:26', '1980-01-21 07:26:40');
INSERT INTO `messages_likes` (`id`, `count_likes`, `created_at`, `updated_at`) VALUES (26, 2239, '1985-04-24 22:42:35', '1981-03-24 02:55:37');
INSERT INTO `messages_likes` (`id`, `count_likes`, `created_at`, `updated_at`) VALUES (27, 0, '2018-08-16 12:23:08', '1990-08-07 12:46:50');
INSERT INTO `messages_likes` (`id`, `count_likes`, `created_at`, `updated_at`) VALUES (28, 420, '1999-04-12 13:46:41', '1971-05-12 09:30:37');
INSERT INTO `messages_likes` (`id`, `count_likes`, `created_at`, `updated_at`) VALUES (29, 7582078, '1988-12-28 22:58:02', '2009-09-30 07:05:47');
INSERT INTO `messages_likes` (`id`, `count_likes`, `created_at`, `updated_at`) VALUES (30, 428392, '2020-09-23 08:15:41', '1992-03-13 08:03:44');
INSERT INTO `messages_likes` (`id`, `count_likes`, `created_at`, `updated_at`) VALUES (31, 62831723, '1989-08-15 07:23:03', '1989-12-05 10:00:08');
INSERT INTO `messages_likes` (`id`, `count_likes`, `created_at`, `updated_at`) VALUES (32, 7, '1993-03-21 14:50:52', '2007-07-30 03:17:06');
INSERT INTO `messages_likes` (`id`, `count_likes`, `created_at`, `updated_at`) VALUES (33, 2231849, '1995-03-10 06:00:32', '1996-05-07 05:46:06');
INSERT INTO `messages_likes` (`id`, `count_likes`, `created_at`, `updated_at`) VALUES (34, 696503, '1973-01-03 11:00:35', '1982-07-01 10:14:22');
INSERT INTO `messages_likes` (`id`, `count_likes`, `created_at`, `updated_at`) VALUES (35, 3287, '1983-06-16 19:31:06', '2018-06-17 05:29:16');
INSERT INTO `messages_likes` (`id`, `count_likes`, `created_at`, `updated_at`) VALUES (36, 7, '1976-01-07 09:57:20', '2019-06-28 10:54:56');
INSERT INTO `messages_likes` (`id`, `count_likes`, `created_at`, `updated_at`) VALUES (37, 58, '2015-01-18 06:47:54', '1989-09-05 18:59:13');
INSERT INTO `messages_likes` (`id`, `count_likes`, `created_at`, `updated_at`) VALUES (38, 9756286, '1997-07-05 21:29:43', '1985-12-05 21:12:31');
INSERT INTO `messages_likes` (`id`, `count_likes`, `created_at`, `updated_at`) VALUES (39, 4, '2005-06-16 04:28:07', '2009-09-12 03:41:57');
INSERT INTO `messages_likes` (`id`, `count_likes`, `created_at`, `updated_at`) VALUES (40, 8, '1997-10-04 02:27:56', '2014-05-12 14:50:29');
INSERT INTO `messages_likes` (`id`, `count_likes`, `created_at`, `updated_at`) VALUES (41, 1603, '2017-10-22 01:20:20', '2002-12-21 01:33:33');
INSERT INTO `messages_likes` (`id`, `count_likes`, `created_at`, `updated_at`) VALUES (42, 0, '2004-10-30 06:26:29', '1992-01-28 14:47:52');
INSERT INTO `messages_likes` (`id`, `count_likes`, `created_at`, `updated_at`) VALUES (43, 0, '2021-04-20 17:53:27', '1995-04-20 12:32:06');
INSERT INTO `messages_likes` (`id`, `count_likes`, `created_at`, `updated_at`) VALUES (44, 70729415, '2001-03-14 15:25:31', '1973-12-08 19:39:31');
INSERT INTO `messages_likes` (`id`, `count_likes`, `created_at`, `updated_at`) VALUES (45, 358172, '2014-03-02 23:42:17', '2008-08-05 00:27:41');
INSERT INTO `messages_likes` (`id`, `count_likes`, `created_at`, `updated_at`) VALUES (46, 18348452, '1973-10-13 00:22:40', '2003-12-30 01:45:10');
INSERT INTO `messages_likes` (`id`, `count_likes`, `created_at`, `updated_at`) VALUES (47, 18848808, '1988-07-27 02:12:57', '2010-12-08 16:25:11');
INSERT INTO `messages_likes` (`id`, `count_likes`, `created_at`, `updated_at`) VALUES (48, 90432263, '1978-05-23 19:39:54', '1970-06-07 20:13:29');
INSERT INTO `messages_likes` (`id`, `count_likes`, `created_at`, `updated_at`) VALUES (49, 0, '1983-11-19 21:29:57', '1984-02-04 03:18:48');
INSERT INTO `messages_likes` (`id`, `count_likes`, `created_at`, `updated_at`) VALUES (50, 39023, '2003-07-12 01:42:19', '1972-01-07 08:45:47');
INSERT INTO `messages_likes` (`id`, `count_likes`, `created_at`, `updated_at`) VALUES (51, 13, '1996-04-19 12:53:10', '2002-10-23 00:36:05');
INSERT INTO `messages_likes` (`id`, `count_likes`, `created_at`, `updated_at`) VALUES (52, 60, '1987-11-12 12:39:45', '2010-08-27 19:08:37');
INSERT INTO `messages_likes` (`id`, `count_likes`, `created_at`, `updated_at`) VALUES (53, 946, '1970-11-30 04:35:24', '1980-08-20 13:57:12');
INSERT INTO `messages_likes` (`id`, `count_likes`, `created_at`, `updated_at`) VALUES (54, 9406, '1992-02-22 05:39:12', '2001-10-14 01:09:54');
INSERT INTO `messages_likes` (`id`, `count_likes`, `created_at`, `updated_at`) VALUES (55, 7686879, '2009-08-01 20:23:19', '1970-02-04 20:24:58');
INSERT INTO `messages_likes` (`id`, `count_likes`, `created_at`, `updated_at`) VALUES (56, 44405351, '1973-10-18 04:10:33', '1989-05-18 20:00:36');
INSERT INTO `messages_likes` (`id`, `count_likes`, `created_at`, `updated_at`) VALUES (57, 19, '1996-07-30 15:32:06', '1977-11-17 21:47:41');
INSERT INTO `messages_likes` (`id`, `count_likes`, `created_at`, `updated_at`) VALUES (58, 51, '1998-12-11 21:51:27', '1981-11-09 07:53:54');
INSERT INTO `messages_likes` (`id`, `count_likes`, `created_at`, `updated_at`) VALUES (59, 447754730, '2019-11-13 06:25:30', '2010-11-06 23:35:04');
INSERT INTO `messages_likes` (`id`, `count_likes`, `created_at`, `updated_at`) VALUES (60, 9788172, '2019-08-13 06:38:40', '1981-04-02 23:38:09');
INSERT INTO `messages_likes` (`id`, `count_likes`, `created_at`, `updated_at`) VALUES (61, 174, '1996-10-26 04:06:33', '1970-02-11 09:27:12');
INSERT INTO `messages_likes` (`id`, `count_likes`, `created_at`, `updated_at`) VALUES (62, 6, '1993-08-10 17:40:44', '1994-06-20 15:49:05');
INSERT INTO `messages_likes` (`id`, `count_likes`, `created_at`, `updated_at`) VALUES (63, 8, '2016-05-21 07:00:50', '1999-08-26 17:31:55');
INSERT INTO `messages_likes` (`id`, `count_likes`, `created_at`, `updated_at`) VALUES (64, 217227, '1982-07-30 04:28:39', '2004-02-09 18:53:45');
INSERT INTO `messages_likes` (`id`, `count_likes`, `created_at`, `updated_at`) VALUES (65, 341, '2011-12-14 23:05:17', '1977-11-05 15:49:37');
INSERT INTO `messages_likes` (`id`, `count_likes`, `created_at`, `updated_at`) VALUES (66, 0, '1974-10-31 08:19:36', '1999-03-21 14:09:36');
INSERT INTO `messages_likes` (`id`, `count_likes`, `created_at`, `updated_at`) VALUES (67, 7152743, '1971-06-10 19:29:29', '2011-06-25 09:27:22');
INSERT INTO `messages_likes` (`id`, `count_likes`, `created_at`, `updated_at`) VALUES (68, 93019283, '1985-11-11 06:01:06', '1970-01-05 19:30:05');
INSERT INTO `messages_likes` (`id`, `count_likes`, `created_at`, `updated_at`) VALUES (69, 5, '2009-01-16 16:39:11', '1999-09-29 08:32:59');
INSERT INTO `messages_likes` (`id`, `count_likes`, `created_at`, `updated_at`) VALUES (70, 70690131, '1993-09-10 09:35:12', '1978-02-24 09:27:40');
INSERT INTO `messages_likes` (`id`, `count_likes`, `created_at`, `updated_at`) VALUES (71, 9982231, '2015-07-11 05:12:15', '1978-07-26 19:00:40');
INSERT INTO `messages_likes` (`id`, `count_likes`, `created_at`, `updated_at`) VALUES (72, 5, '1992-10-22 21:45:08', '2002-02-02 10:21:24');
INSERT INTO `messages_likes` (`id`, `count_likes`, `created_at`, `updated_at`) VALUES (73, 726041883, '1970-03-18 04:06:54', '1984-08-22 18:18:58');
INSERT INTO `messages_likes` (`id`, `count_likes`, `created_at`, `updated_at`) VALUES (74, 630518, '2014-08-22 00:03:09', '2002-03-05 10:03:55');
INSERT INTO `messages_likes` (`id`, `count_likes`, `created_at`, `updated_at`) VALUES (75, 49, '1976-07-11 03:30:08', '1984-10-20 16:11:33');
INSERT INTO `messages_likes` (`id`, `count_likes`, `created_at`, `updated_at`) VALUES (76, 84045, '2014-05-23 09:21:08', '1975-06-10 10:01:58');
INSERT INTO `messages_likes` (`id`, `count_likes`, `created_at`, `updated_at`) VALUES (77, 44545, '1974-08-30 02:11:46', '1995-07-27 20:12:09');
INSERT INTO `messages_likes` (`id`, `count_likes`, `created_at`, `updated_at`) VALUES (78, 110, '2014-09-25 22:46:36', '2001-05-20 20:29:51');
INSERT INTO `messages_likes` (`id`, `count_likes`, `created_at`, `updated_at`) VALUES (79, 79393586, '1985-12-26 02:29:43', '2010-06-01 08:08:24');
INSERT INTO `messages_likes` (`id`, `count_likes`, `created_at`, `updated_at`) VALUES (80, 432469883, '2003-07-23 22:43:30', '2016-02-04 05:33:35');
INSERT INTO `messages_likes` (`id`, `count_likes`, `created_at`, `updated_at`) VALUES (81, 57, '1980-07-01 23:07:50', '1980-02-08 09:39:32');
INSERT INTO `messages_likes` (`id`, `count_likes`, `created_at`, `updated_at`) VALUES (82, 76674, '2019-11-25 03:55:11', '2006-07-16 07:04:01');
INSERT INTO `messages_likes` (`id`, `count_likes`, `created_at`, `updated_at`) VALUES (83, 314, '1996-07-15 10:34:22', '1996-10-28 03:14:24');
INSERT INTO `messages_likes` (`id`, `count_likes`, `created_at`, `updated_at`) VALUES (84, 894, '1976-09-14 00:00:25', '2009-04-28 06:07:24');
INSERT INTO `messages_likes` (`id`, `count_likes`, `created_at`, `updated_at`) VALUES (85, 7569, '2010-12-27 09:46:00', '2014-11-03 12:12:33');
INSERT INTO `messages_likes` (`id`, `count_likes`, `created_at`, `updated_at`) VALUES (86, 5, '1974-06-30 14:01:11', '2016-01-22 10:57:25');
INSERT INTO `messages_likes` (`id`, `count_likes`, `created_at`, `updated_at`) VALUES (87, 36182, '1992-12-05 13:53:51', '1984-05-23 08:10:29');
INSERT INTO `messages_likes` (`id`, `count_likes`, `created_at`, `updated_at`) VALUES (88, 3, '1972-02-15 13:17:15', '2017-08-12 05:59:20');
INSERT INTO `messages_likes` (`id`, `count_likes`, `created_at`, `updated_at`) VALUES (89, 0, '1996-03-15 03:42:55', '2007-06-06 04:39:25');
INSERT INTO `messages_likes` (`id`, `count_likes`, `created_at`, `updated_at`) VALUES (90, 28739654, '1970-12-05 13:45:24', '1970-05-02 07:35:46');
INSERT INTO `messages_likes` (`id`, `count_likes`, `created_at`, `updated_at`) VALUES (91, 907675, '1983-02-27 00:33:25', '2006-06-22 12:54:21');
INSERT INTO `messages_likes` (`id`, `count_likes`, `created_at`, `updated_at`) VALUES (92, 0, '2017-10-10 14:35:07', '1974-01-19 16:13:37');
INSERT INTO `messages_likes` (`id`, `count_likes`, `created_at`, `updated_at`) VALUES (93, 0, '1974-05-22 07:42:47', '2019-01-10 16:06:00');
INSERT INTO `messages_likes` (`id`, `count_likes`, `created_at`, `updated_at`) VALUES (94, 32971016, '1975-02-03 00:19:37', '2011-02-11 13:15:07');
INSERT INTO `messages_likes` (`id`, `count_likes`, `created_at`, `updated_at`) VALUES (95, 3642820, '1990-03-26 05:55:03', '1997-12-10 18:26:26');
INSERT INTO `messages_likes` (`id`, `count_likes`, `created_at`, `updated_at`) VALUES (96, 910140723, '2019-05-19 19:49:41', '1999-06-20 02:43:12');
INSERT INTO `messages_likes` (`id`, `count_likes`, `created_at`, `updated_at`) VALUES (97, 7433544, '1984-08-12 05:34:54', '2011-11-25 03:11:08');
INSERT INTO `messages_likes` (`id`, `count_likes`, `created_at`, `updated_at`) VALUES (98, 10556597, '1974-05-10 09:13:23', '2014-10-10 01:19:20');
INSERT INTO `messages_likes` (`id`, `count_likes`, `created_at`, `updated_at`) VALUES (99, 90995, '2003-10-03 08:48:51', '2018-03-02 13:24:31');
INSERT INTO `messages_likes` (`id`, `count_likes`, `created_at`, `updated_at`) VALUES (100, 859, '1982-09-30 15:01:49', '1997-11-22 03:52:38');



#
# TABLE STRUCTURE FOR: friendship_statuses
#

DROP TABLE IF EXISTS `friendship_statuses`;

CREATE TABLE `friendship_statuses` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Идентификатор строки',
  `name` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Название статуса',
  `created_at` datetime DEFAULT current_timestamp() COMMENT 'Время создания строки',
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT 'Время обновления строки',
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Статусы дружбы';

INSERT INTO `friendship_statuses` (`id`, `name`, `created_at`, `updated_at`) VALUES (1, 'mollitia', '2008-03-29 09:44:54', '2020-04-11 02:48:22');
INSERT INTO `friendship_statuses` (`id`, `name`, `created_at`, `updated_at`) VALUES (2, 'numquam', '1999-02-12 22:53:44', '1999-06-09 15:04:56');
INSERT INTO `friendship_statuses` (`id`, `name`, `created_at`, `updated_at`) VALUES (3, 'vero', '2003-05-19 10:41:33', '2013-09-19 09:46:01');
INSERT INTO `friendship_statuses` (`id`, `name`, `created_at`, `updated_at`) VALUES (4, 'et', '2002-12-31 09:51:11', '1979-04-28 14:05:40');
INSERT INTO `friendship_statuses` (`id`, `name`, `created_at`, `updated_at`) VALUES (5, 'beatae', '1980-03-29 08:39:39', '1985-12-02 08:13:01');
INSERT INTO `friendship_statuses` (`id`, `name`, `created_at`, `updated_at`) VALUES (6, 'doloremque', '2014-02-25 22:34:00', '1993-04-27 23:38:04');
INSERT INTO `friendship_statuses` (`id`, `name`, `created_at`, `updated_at`) VALUES (7, 'dolores', '2008-03-30 23:01:23', '1972-02-15 01:21:23');
INSERT INTO `friendship_statuses` (`id`, `name`, `created_at`, `updated_at`) VALUES (8, 'quos', '2008-05-14 05:03:49', '1995-11-09 21:26:15');
INSERT INTO `friendship_statuses` (`id`, `name`, `created_at`, `updated_at`) VALUES (9, 'dolorum', '1999-09-10 11:11:48', '1991-08-16 06:20:37');
INSERT INTO `friendship_statuses` (`id`, `name`, `created_at`, `updated_at`) VALUES (10, 'adipisci', '1995-12-20 05:33:51', '1981-06-12 13:00:52');



#
# TABLE STRUCTURE FOR: friendship
#

DROP TABLE IF EXISTS `friendship`;

CREATE TABLE `friendship` (
  `user_id` int(10) unsigned NOT NULL COMMENT 'Ссылка на инициатора дружеских отношений',
  `friend_id` int(10) unsigned NOT NULL COMMENT 'Ссылка на получателя приглашения дружить',
  `status_id` int(10) unsigned NOT NULL COMMENT 'Ссылка на статус (текущее состояние) отношений',
  `requested_at` datetime DEFAULT current_timestamp() COMMENT 'Время отправления приглашения дружить',
  `confirmed_at` datetime DEFAULT NULL COMMENT 'Время подтверждения приглашения',
  `created_at` datetime DEFAULT current_timestamp() COMMENT 'Время создания строки',
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT 'Время обновления строки',
  PRIMARY KEY (`user_id`,`friend_id`) COMMENT 'Составной первичный ключ',
  KEY `friend_id` (`friend_id`),
  KEY `status_id` (`status_id`),
  CONSTRAINT `friendship_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  CONSTRAINT `friendship_ibfk_2` FOREIGN KEY (`friend_id`) REFERENCES `users` (`id`),
  CONSTRAINT `friendship_ibfk_3` FOREIGN KEY (`status_id`) REFERENCES `friendship_statuses` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Таблица дружбы';

INSERT INTO `friendship` (`user_id`, `friend_id`, `status_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (1, 1, 1, '2009-05-01 04:55:21', '1995-05-04 00:26:05', '1974-09-22 15:05:52', '2002-02-09 04:05:07');
INSERT INTO `friendship` (`user_id`, `friend_id`, `status_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (2, 2, 2, '2018-05-30 18:15:27', '1975-05-01 03:19:59', '1998-07-23 14:09:54', '1972-04-02 17:35:34');
INSERT INTO `friendship` (`user_id`, `friend_id`, `status_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (3, 3, 3, '2015-04-28 18:56:56', '2000-04-24 22:45:21', '1997-05-17 04:13:58', '2006-05-29 01:30:14');
INSERT INTO `friendship` (`user_id`, `friend_id`, `status_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (4, 4, 4, '2010-08-07 07:16:43', '2002-12-27 00:58:34', '1990-07-05 05:16:51', '1987-06-03 13:11:57');
INSERT INTO `friendship` (`user_id`, `friend_id`, `status_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (5, 5, 5, '1978-02-22 05:59:01', '1980-10-08 08:27:03', '2003-11-04 09:09:42', '1979-03-02 16:01:10');
INSERT INTO `friendship` (`user_id`, `friend_id`, `status_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (6, 6, 6, '2009-01-27 08:37:41', '2009-08-11 12:07:14', '1974-03-01 22:46:05', '1991-11-17 21:04:23');
INSERT INTO `friendship` (`user_id`, `friend_id`, `status_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (7, 7, 7, '1997-09-24 04:11:29', '2008-01-26 19:44:34', '1971-01-02 20:07:27', '1983-02-13 07:26:11');
INSERT INTO `friendship` (`user_id`, `friend_id`, `status_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (8, 8, 8, '2015-04-28 15:15:10', '2012-09-03 13:17:07', '1973-03-04 23:34:28', '1988-10-13 03:26:14');
INSERT INTO `friendship` (`user_id`, `friend_id`, `status_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (9, 9, 9, '2010-07-05 08:56:16', '2018-10-27 05:54:18', '2018-04-05 23:17:58', '2020-11-15 08:47:37');
INSERT INTO `friendship` (`user_id`, `friend_id`, `status_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (10, 10, 10, '2017-10-17 02:47:09', '2004-01-26 05:38:23', '2010-07-23 20:27:24', '1989-04-04 08:44:23');
INSERT INTO `friendship` (`user_id`, `friend_id`, `status_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (11, 11, 1, '1980-08-06 17:35:29', '1976-06-28 23:31:13', '2006-05-06 07:28:39', '2010-09-06 09:06:54');
INSERT INTO `friendship` (`user_id`, `friend_id`, `status_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (12, 12, 2, '2019-12-07 14:17:26', '2019-04-03 20:33:20', '1992-09-04 02:46:30', '2005-10-30 00:35:04');
INSERT INTO `friendship` (`user_id`, `friend_id`, `status_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (13, 13, 3, '1985-08-30 06:08:27', '1988-08-18 15:35:30', '2007-01-31 02:02:28', '2003-03-17 05:25:46');
INSERT INTO `friendship` (`user_id`, `friend_id`, `status_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (14, 14, 4, '1999-02-19 11:17:51', '1993-04-05 14:28:07', '1971-08-31 08:19:45', '1981-11-13 00:29:52');
INSERT INTO `friendship` (`user_id`, `friend_id`, `status_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (15, 15, 5, '2000-06-23 16:42:19', '2005-12-31 09:16:54', '1971-09-09 13:07:47', '1997-02-18 14:05:58');
INSERT INTO `friendship` (`user_id`, `friend_id`, `status_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (16, 16, 6, '2007-08-29 08:37:18', '2016-10-10 22:21:10', '2017-06-13 02:23:17', '2018-10-23 14:08:40');
INSERT INTO `friendship` (`user_id`, `friend_id`, `status_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (17, 17, 7, '1971-02-15 22:25:46', '1981-04-07 10:42:53', '1983-12-07 07:42:23', '1980-09-25 17:56:36');
INSERT INTO `friendship` (`user_id`, `friend_id`, `status_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (18, 18, 8, '2007-09-07 01:20:37', '1971-01-11 18:47:24', '1990-07-30 03:39:26', '2021-04-27 20:07:13');
INSERT INTO `friendship` (`user_id`, `friend_id`, `status_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (19, 19, 9, '1986-06-23 05:08:40', '2010-11-08 04:56:34', '1973-04-09 09:54:43', '1974-02-24 18:39:50');
INSERT INTO `friendship` (`user_id`, `friend_id`, `status_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (20, 20, 10, '1998-10-30 08:43:11', '1977-04-13 12:47:50', '1987-11-20 06:58:56', '2009-12-24 08:51:54');
INSERT INTO `friendship` (`user_id`, `friend_id`, `status_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (21, 21, 1, '2004-02-08 17:26:38', '1974-10-10 11:03:46', '1975-02-18 10:18:19', '2013-10-06 10:50:35');
INSERT INTO `friendship` (`user_id`, `friend_id`, `status_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (22, 22, 2, '1975-02-26 20:44:45', '2015-12-06 01:28:10', '1978-03-19 17:56:10', '1980-08-21 07:39:26');
INSERT INTO `friendship` (`user_id`, `friend_id`, `status_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (23, 23, 3, '2012-01-19 16:56:00', '2007-09-02 07:57:45', '2003-08-22 16:31:20', '1998-12-11 19:34:27');
INSERT INTO `friendship` (`user_id`, `friend_id`, `status_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (24, 24, 4, '2005-12-20 14:50:02', '2009-08-11 00:28:36', '2006-04-07 09:42:19', '2020-05-10 19:58:14');
INSERT INTO `friendship` (`user_id`, `friend_id`, `status_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (25, 25, 5, '2008-02-03 08:17:17', '1981-10-05 03:45:07', '1992-10-19 20:11:54', '1985-01-11 11:46:51');
INSERT INTO `friendship` (`user_id`, `friend_id`, `status_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (26, 26, 6, '1974-10-25 15:44:07', '1980-10-13 15:36:27', '1998-08-06 16:25:56', '2010-10-15 20:23:41');
INSERT INTO `friendship` (`user_id`, `friend_id`, `status_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (27, 27, 7, '2013-08-06 03:08:27', '2017-12-16 08:35:39', '1997-03-08 12:51:27', '1976-07-25 12:25:35');
INSERT INTO `friendship` (`user_id`, `friend_id`, `status_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (28, 28, 8, '2012-06-18 01:31:58', '2020-08-16 00:10:44', '1986-09-03 16:21:04', '1971-04-05 03:51:35');
INSERT INTO `friendship` (`user_id`, `friend_id`, `status_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (29, 29, 9, '2006-01-24 23:08:15', '1988-12-09 17:33:58', '2016-06-09 06:26:53', '2020-07-26 05:51:27');
INSERT INTO `friendship` (`user_id`, `friend_id`, `status_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (30, 30, 10, '1972-12-17 10:56:21', '2002-09-14 03:21:05', '1983-05-14 09:05:58', '1993-10-29 07:09:25');
INSERT INTO `friendship` (`user_id`, `friend_id`, `status_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (31, 31, 1, '1990-12-22 20:43:34', '2020-09-04 12:40:45', '2007-04-02 11:41:25', '1976-10-30 00:07:47');
INSERT INTO `friendship` (`user_id`, `friend_id`, `status_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (32, 32, 2, '2002-10-18 16:17:48', '2009-04-27 15:44:12', '1995-05-25 12:48:45', '2013-08-18 09:35:17');
INSERT INTO `friendship` (`user_id`, `friend_id`, `status_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (33, 33, 3, '1999-05-24 13:49:26', '2007-01-26 17:20:24', '2019-07-19 14:09:21', '2007-05-19 05:01:30');
INSERT INTO `friendship` (`user_id`, `friend_id`, `status_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (34, 34, 4, '1973-07-30 20:17:03', '1979-11-05 01:22:39', '1996-03-26 07:18:39', '1981-12-23 19:37:26');
INSERT INTO `friendship` (`user_id`, `friend_id`, `status_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (35, 35, 5, '1995-06-09 14:11:37', '1985-03-05 12:50:34', '1973-01-31 10:57:58', '2013-02-20 02:07:59');
INSERT INTO `friendship` (`user_id`, `friend_id`, `status_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (36, 36, 6, '1995-09-17 23:40:19', '2013-03-02 21:59:35', '2007-03-27 05:21:54', '2000-12-14 12:16:32');
INSERT INTO `friendship` (`user_id`, `friend_id`, `status_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (37, 37, 7, '2001-08-01 11:45:15', '2006-07-12 23:27:35', '1998-04-18 00:27:32', '1983-03-21 23:22:39');
INSERT INTO `friendship` (`user_id`, `friend_id`, `status_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (38, 38, 8, '1970-01-08 03:49:11', '2014-11-15 09:53:27', '1980-12-01 17:02:02', '1993-01-04 01:41:05');
INSERT INTO `friendship` (`user_id`, `friend_id`, `status_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (39, 39, 9, '2014-10-09 23:42:19', '1981-07-07 04:03:24', '1992-04-22 09:07:06', '1973-05-16 15:14:57');
INSERT INTO `friendship` (`user_id`, `friend_id`, `status_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (40, 40, 10, '2019-02-03 07:02:32', '2018-12-27 15:18:52', '1991-12-28 12:08:27', '1986-12-11 07:26:02');
INSERT INTO `friendship` (`user_id`, `friend_id`, `status_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (41, 41, 1, '2016-03-26 16:17:36', '2007-06-30 18:17:37', '1982-07-29 11:53:04', '1982-10-15 23:08:53');
INSERT INTO `friendship` (`user_id`, `friend_id`, `status_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (42, 42, 2, '1991-07-20 00:02:54', '2002-06-12 23:26:41', '1997-07-15 10:18:36', '2015-02-20 02:57:16');
INSERT INTO `friendship` (`user_id`, `friend_id`, `status_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (43, 43, 3, '1997-06-17 04:07:10', '1993-08-17 07:38:53', '2009-09-16 13:37:53', '1986-12-04 09:11:10');
INSERT INTO `friendship` (`user_id`, `friend_id`, `status_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (44, 44, 4, '1991-08-04 16:59:38', '2001-02-20 14:58:29', '2006-04-27 00:18:35', '1988-09-20 14:25:22');
INSERT INTO `friendship` (`user_id`, `friend_id`, `status_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (45, 45, 5, '1995-01-16 19:29:27', '1985-08-24 18:52:02', '2013-04-30 17:14:55', '1988-12-19 09:45:08');
INSERT INTO `friendship` (`user_id`, `friend_id`, `status_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (46, 46, 6, '1981-03-28 10:33:18', '2018-12-29 03:15:06', '1991-09-26 13:35:01', '2011-06-04 02:42:05');
INSERT INTO `friendship` (`user_id`, `friend_id`, `status_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (47, 47, 7, '1993-11-13 02:55:16', '1986-06-09 17:55:00', '1984-06-21 21:25:00', '1990-05-09 23:14:05');
INSERT INTO `friendship` (`user_id`, `friend_id`, `status_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (48, 48, 8, '2018-05-14 07:45:32', '1987-09-17 07:28:24', '2015-07-10 00:39:52', '2010-09-30 07:42:59');
INSERT INTO `friendship` (`user_id`, `friend_id`, `status_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (49, 49, 9, '2004-11-02 15:56:41', '2019-06-16 17:06:11', '1999-09-08 12:25:31', '2011-08-05 12:28:25');
INSERT INTO `friendship` (`user_id`, `friend_id`, `status_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (50, 50, 10, '1971-10-01 15:56:36', '1970-04-18 13:41:59', '1986-06-08 20:59:21', '1985-05-29 03:16:22');
INSERT INTO `friendship` (`user_id`, `friend_id`, `status_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (51, 51, 1, '2009-07-16 13:49:48', '1993-05-01 06:42:53', '2003-04-12 19:06:05', '1991-11-22 16:11:57');
INSERT INTO `friendship` (`user_id`, `friend_id`, `status_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (52, 52, 2, '1993-05-09 19:06:05', '1982-11-27 17:25:19', '1998-05-23 02:21:21', '1988-06-27 04:38:42');
INSERT INTO `friendship` (`user_id`, `friend_id`, `status_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (53, 53, 3, '1980-02-13 13:29:39', '1980-03-24 14:25:34', '1992-08-01 09:00:04', '1999-12-05 23:49:01');
INSERT INTO `friendship` (`user_id`, `friend_id`, `status_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (54, 54, 4, '2018-04-13 14:29:46', '1997-12-19 02:07:04', '1991-05-08 23:56:48', '1971-09-10 18:03:08');
INSERT INTO `friendship` (`user_id`, `friend_id`, `status_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (55, 55, 5, '1973-03-08 16:43:04', '2000-05-25 20:23:24', '1987-03-21 09:19:37', '2017-03-21 20:34:31');
INSERT INTO `friendship` (`user_id`, `friend_id`, `status_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (56, 56, 6, '2007-09-05 09:15:21', '2008-12-21 12:33:42', '2006-10-01 16:16:01', '1972-10-29 21:31:26');
INSERT INTO `friendship` (`user_id`, `friend_id`, `status_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (57, 57, 7, '1995-09-04 21:33:45', '1983-12-31 02:05:26', '2013-03-10 17:48:42', '2012-12-25 21:56:29');
INSERT INTO `friendship` (`user_id`, `friend_id`, `status_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (58, 58, 8, '2003-04-16 08:32:15', '1973-09-03 03:07:52', '2019-04-22 23:26:20', '2006-04-11 07:44:25');
INSERT INTO `friendship` (`user_id`, `friend_id`, `status_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (59, 59, 9, '2002-03-29 07:25:59', '1987-09-20 06:55:28', '1987-06-11 18:40:43', '2000-07-27 03:10:51');
INSERT INTO `friendship` (`user_id`, `friend_id`, `status_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (60, 60, 10, '2008-02-16 03:47:11', '1985-07-27 03:11:29', '2008-11-03 20:41:19', '1998-09-13 17:06:06');
INSERT INTO `friendship` (`user_id`, `friend_id`, `status_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (61, 61, 1, '2006-06-26 21:31:25', '1997-11-09 12:34:07', '2013-03-25 03:25:16', '1994-07-16 21:28:19');
INSERT INTO `friendship` (`user_id`, `friend_id`, `status_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (62, 62, 2, '1998-07-27 19:41:26', '1993-08-27 05:09:05', '1975-06-23 23:16:40', '1977-05-27 01:19:00');
INSERT INTO `friendship` (`user_id`, `friend_id`, `status_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (63, 63, 3, '2002-10-31 17:09:55', '2019-11-19 14:30:42', '1970-01-05 13:40:57', '1996-04-25 02:03:06');
INSERT INTO `friendship` (`user_id`, `friend_id`, `status_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (64, 64, 4, '1973-11-11 23:02:57', '2001-05-08 07:19:27', '2006-02-22 11:17:56', '1983-11-03 22:12:00');
INSERT INTO `friendship` (`user_id`, `friend_id`, `status_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (65, 65, 5, '1975-03-16 08:29:36', '1987-06-14 16:25:28', '1980-05-14 10:01:30', '2006-05-24 20:39:01');
INSERT INTO `friendship` (`user_id`, `friend_id`, `status_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (66, 66, 6, '1977-01-16 05:30:54', '1973-03-03 23:53:46', '2016-12-10 00:03:02', '2003-10-02 01:49:38');
INSERT INTO `friendship` (`user_id`, `friend_id`, `status_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (67, 67, 7, '1991-07-16 20:11:46', '1999-05-02 08:07:19', '1984-06-15 06:49:33', '1970-05-21 18:51:27');
INSERT INTO `friendship` (`user_id`, `friend_id`, `status_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (68, 68, 8, '1995-10-06 21:29:44', '2018-08-08 07:56:16', '2004-07-30 15:34:36', '1975-01-23 22:53:45');
INSERT INTO `friendship` (`user_id`, `friend_id`, `status_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (69, 69, 9, '1998-01-05 07:50:56', '1995-08-06 05:59:37', '2011-07-29 22:14:28', '1980-06-28 21:47:03');
INSERT INTO `friendship` (`user_id`, `friend_id`, `status_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (70, 70, 10, '1977-06-27 04:03:54', '2008-03-16 23:51:41', '1980-11-04 03:59:59', '2010-04-18 03:29:07');
INSERT INTO `friendship` (`user_id`, `friend_id`, `status_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (71, 71, 1, '1986-07-24 05:00:48', '1993-10-19 01:30:47', '2018-04-25 20:07:28', '2011-05-25 17:02:34');
INSERT INTO `friendship` (`user_id`, `friend_id`, `status_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (72, 72, 2, '1987-07-13 17:27:25', '2015-04-01 05:22:35', '1982-07-29 19:27:46', '2015-03-10 06:24:13');
INSERT INTO `friendship` (`user_id`, `friend_id`, `status_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (73, 73, 3, '1979-07-03 22:14:21', '1989-07-29 02:05:24', '1979-01-04 06:59:03', '1970-06-25 16:40:24');
INSERT INTO `friendship` (`user_id`, `friend_id`, `status_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (74, 74, 4, '1990-02-19 06:18:18', '2013-12-18 22:01:30', '2011-01-16 10:12:37', '1978-10-18 18:30:43');
INSERT INTO `friendship` (`user_id`, `friend_id`, `status_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (75, 75, 5, '1983-07-25 10:58:14', '1971-10-28 23:03:08', '2011-02-21 14:46:24', '2018-08-16 12:25:12');
INSERT INTO `friendship` (`user_id`, `friend_id`, `status_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (76, 76, 6, '1997-08-21 15:31:33', '2017-09-01 01:12:42', '1994-12-25 22:11:07', '1975-03-08 20:11:16');
INSERT INTO `friendship` (`user_id`, `friend_id`, `status_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (77, 77, 7, '1977-11-30 07:33:18', '2014-12-01 18:10:33', '2014-11-16 18:06:34', '1993-01-20 06:39:39');
INSERT INTO `friendship` (`user_id`, `friend_id`, `status_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (78, 78, 8, '1974-05-30 20:13:58', '2019-08-16 01:36:19', '1983-11-19 06:48:05', '1977-11-22 19:27:35');
INSERT INTO `friendship` (`user_id`, `friend_id`, `status_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (79, 79, 9, '1997-01-08 18:03:27', '1972-10-16 19:57:52', '2014-07-14 14:51:25', '1992-12-22 02:14:41');
INSERT INTO `friendship` (`user_id`, `friend_id`, `status_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (80, 80, 10, '1975-12-28 17:49:53', '2004-08-20 08:18:51', '2010-07-15 10:52:22', '1973-01-26 10:35:13');
INSERT INTO `friendship` (`user_id`, `friend_id`, `status_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (81, 81, 1, '1981-04-08 01:28:11', '1981-08-22 01:17:54', '2008-02-14 00:57:10', '1981-06-05 09:32:46');
INSERT INTO `friendship` (`user_id`, `friend_id`, `status_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (82, 82, 2, '2008-12-20 04:11:41', '1980-02-18 18:30:17', '1971-03-20 11:36:34', '2018-02-18 11:18:08');
INSERT INTO `friendship` (`user_id`, `friend_id`, `status_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (83, 83, 3, '1979-04-15 12:50:23', '2015-05-23 18:31:24', '1974-04-05 06:15:34', '1982-10-16 09:18:23');
INSERT INTO `friendship` (`user_id`, `friend_id`, `status_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (84, 84, 4, '1998-08-16 11:21:08', '1987-10-28 10:54:31', '1991-12-02 07:09:49', '1993-03-06 21:25:13');
INSERT INTO `friendship` (`user_id`, `friend_id`, `status_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (85, 85, 5, '1987-01-07 04:03:54', '2001-06-02 04:36:36', '1976-09-06 12:17:12', '1977-12-10 21:33:42');
INSERT INTO `friendship` (`user_id`, `friend_id`, `status_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (86, 86, 6, '1976-09-19 05:04:27', '2016-12-29 10:51:12', '2000-02-25 09:59:01', '1983-07-21 19:11:00');
INSERT INTO `friendship` (`user_id`, `friend_id`, `status_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (87, 87, 7, '2002-05-09 03:29:05', '2001-01-17 16:25:43', '2013-08-17 06:36:25', '2002-04-18 12:32:02');
INSERT INTO `friendship` (`user_id`, `friend_id`, `status_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (88, 88, 8, '2007-07-19 06:04:44', '2007-10-14 19:52:53', '1983-10-12 05:45:51', '1986-08-13 12:57:21');
INSERT INTO `friendship` (`user_id`, `friend_id`, `status_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (89, 89, 9, '1996-04-02 17:58:17', '2015-06-17 08:13:23', '1999-06-14 19:34:33', '1997-10-03 01:09:38');
INSERT INTO `friendship` (`user_id`, `friend_id`, `status_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (90, 90, 10, '2009-10-28 03:01:16', '1987-10-28 09:39:04', '2005-12-23 11:09:33', '1976-10-30 00:31:40');
INSERT INTO `friendship` (`user_id`, `friend_id`, `status_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (91, 91, 1, '1973-11-09 11:33:07', '1991-05-28 10:03:10', '1976-10-26 12:51:18', '1985-05-15 17:11:59');
INSERT INTO `friendship` (`user_id`, `friend_id`, `status_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (92, 92, 2, '2009-09-16 03:59:12', '1990-09-22 15:52:38', '1989-12-22 14:40:33', '1981-02-07 22:17:36');
INSERT INTO `friendship` (`user_id`, `friend_id`, `status_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (93, 93, 3, '2018-10-22 03:31:21', '1984-02-26 15:11:32', '1970-06-23 22:40:29', '2002-12-05 22:36:51');
INSERT INTO `friendship` (`user_id`, `friend_id`, `status_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (94, 94, 4, '1987-12-08 07:02:49', '1971-03-21 12:37:45', '2016-03-06 16:35:12', '1983-02-09 12:31:45');
INSERT INTO `friendship` (`user_id`, `friend_id`, `status_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (95, 95, 5, '1999-01-11 17:01:35', '1979-06-12 10:14:04', '2003-01-04 14:48:42', '1998-04-24 13:40:41');
INSERT INTO `friendship` (`user_id`, `friend_id`, `status_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (96, 96, 6, '2002-07-02 22:38:54', '1981-12-01 22:47:58', '1988-03-18 20:34:15', '2009-03-19 16:05:14');
INSERT INTO `friendship` (`user_id`, `friend_id`, `status_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (97, 97, 7, '2012-12-01 20:10:21', '1988-06-10 18:20:12', '2016-05-13 03:26:07', '1993-03-11 14:47:35');
INSERT INTO `friendship` (`user_id`, `friend_id`, `status_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (98, 98, 8, '2007-09-13 09:04:19', '2015-01-31 17:09:02', '2010-05-30 15:13:59', '2019-02-24 07:35:38');
INSERT INTO `friendship` (`user_id`, `friend_id`, `status_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (99, 99, 9, '1979-01-19 06:30:19', '1980-08-31 21:44:47', '1987-08-02 09:52:34', '1987-06-20 13:05:02');
INSERT INTO `friendship` (`user_id`, `friend_id`, `status_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (100, 100, 10, '1975-06-22 00:48:53', '1972-11-02 01:32:02', '1987-01-04 10:51:31', '1986-04-27 22:06:45');




#
# TABLE STRUCTURE FOR: communities
#

DROP TABLE IF EXISTS `communities`;

CREATE TABLE `communities` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Идентификатор сроки',
  `name` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Название группы',
  `created_at` datetime DEFAULT current_timestamp() COMMENT 'Время создания строки',
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT 'Время обновления строки',
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=101 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Группы';

INSERT INTO `communities` (`id`, `name`, `created_at`, `updated_at`) VALUES (1, 'vel', '2004-05-15 04:49:05', '2013-10-28 20:35:38');
INSERT INTO `communities` (`id`, `name`, `created_at`, `updated_at`) VALUES (2, 'voluptate', '1984-10-06 21:23:00', '2011-08-20 08:50:59');
INSERT INTO `communities` (`id`, `name`, `created_at`, `updated_at`) VALUES (3, 'omnis', '2011-03-06 05:51:21', '1999-12-13 03:35:04');
INSERT INTO `communities` (`id`, `name`, `created_at`, `updated_at`) VALUES (4, 'hic', '1998-09-10 06:21:33', '2012-01-29 18:09:27');
INSERT INTO `communities` (`id`, `name`, `created_at`, `updated_at`) VALUES (5, 'est', '2002-12-05 18:24:30', '1970-04-04 01:38:35');
INSERT INTO `communities` (`id`, `name`, `created_at`, `updated_at`) VALUES (6, 'aut', '2017-03-28 08:12:27', '1995-06-14 15:59:29');
INSERT INTO `communities` (`id`, `name`, `created_at`, `updated_at`) VALUES (7, 'voluptatem', '2016-09-30 15:14:16', '2002-08-12 00:50:23');
INSERT INTO `communities` (`id`, `name`, `created_at`, `updated_at`) VALUES (8, 'beatae', '2014-07-09 03:54:40', '1996-12-26 03:37:30');
INSERT INTO `communities` (`id`, `name`, `created_at`, `updated_at`) VALUES (9, 'unde', '1985-05-12 10:14:48', '2005-02-24 17:07:43');
INSERT INTO `communities` (`id`, `name`, `created_at`, `updated_at`) VALUES (10, 'qui', '2015-05-25 13:57:44', '2004-08-17 13:25:43');
INSERT INTO `communities` (`id`, `name`, `created_at`, `updated_at`) VALUES (11, 'iste', '1984-07-13 14:45:09', '2002-06-29 17:12:19');
INSERT INTO `communities` (`id`, `name`, `created_at`, `updated_at`) VALUES (12, 'labore', '2012-12-29 05:55:10', '1973-04-29 19:28:17');
INSERT INTO `communities` (`id`, `name`, `created_at`, `updated_at`) VALUES (13, 'aliquam', '2004-07-27 08:42:05', '1995-02-22 10:55:55');
INSERT INTO `communities` (`id`, `name`, `created_at`, `updated_at`) VALUES (14, 'consequatur', '2002-04-03 16:15:35', '1998-10-07 23:41:28');
INSERT INTO `communities` (`id`, `name`, `created_at`, `updated_at`) VALUES (15, 'esse', '2002-10-23 20:09:28', '2000-03-13 15:35:22');
INSERT INTO `communities` (`id`, `name`, `created_at`, `updated_at`) VALUES (16, 'dolor', '1991-04-27 16:22:16', '2013-04-12 22:37:14');
INSERT INTO `communities` (`id`, `name`, `created_at`, `updated_at`) VALUES (17, 'repellendus', '1986-02-07 18:07:21', '2017-07-12 09:23:55');
INSERT INTO `communities` (`id`, `name`, `created_at`, `updated_at`) VALUES (18, 'nihil', '2010-06-16 16:10:48', '1979-08-01 09:35:34');
INSERT INTO `communities` (`id`, `name`, `created_at`, `updated_at`) VALUES (19, 'in', '2005-12-03 08:36:56', '1988-10-02 03:37:03');
INSERT INTO `communities` (`id`, `name`, `created_at`, `updated_at`) VALUES (20, 'voluptatum', '1994-01-28 10:38:39', '2009-04-03 19:27:48');
INSERT INTO `communities` (`id`, `name`, `created_at`, `updated_at`) VALUES (21, 'non', '2003-05-24 05:45:57', '1970-04-28 04:20:23');
INSERT INTO `communities` (`id`, `name`, `created_at`, `updated_at`) VALUES (22, 'ut', '1998-04-19 12:27:25', '1984-04-11 15:01:07');
INSERT INTO `communities` (`id`, `name`, `created_at`, `updated_at`) VALUES (23, 'dolorem', '1998-01-07 00:23:52', '2010-01-22 21:09:56');
INSERT INTO `communities` (`id`, `name`, `created_at`, `updated_at`) VALUES (24, 'fugit', '1999-01-04 19:30:29', '1985-10-31 17:33:45');
INSERT INTO `communities` (`id`, `name`, `created_at`, `updated_at`) VALUES (25, 'quas', '1984-09-14 03:34:51', '2011-03-04 23:30:27');
INSERT INTO `communities` (`id`, `name`, `created_at`, `updated_at`) VALUES (26, 'officia', '1990-06-23 12:56:00', '2014-05-06 04:11:28');
INSERT INTO `communities` (`id`, `name`, `created_at`, `updated_at`) VALUES (27, 'expedita', '1991-06-07 08:33:16', '1985-02-16 08:36:14');
INSERT INTO `communities` (`id`, `name`, `created_at`, `updated_at`) VALUES (28, 'optio', '1991-06-12 06:28:20', '2019-09-11 12:32:40');
INSERT INTO `communities` (`id`, `name`, `created_at`, `updated_at`) VALUES (29, 'vitae', '1976-11-29 21:28:00', '2017-07-15 20:07:32');
INSERT INTO `communities` (`id`, `name`, `created_at`, `updated_at`) VALUES (30, 'possimus', '2009-05-15 09:19:28', '1987-04-22 07:06:22');
INSERT INTO `communities` (`id`, `name`, `created_at`, `updated_at`) VALUES (31, 'necessitatibus', '1978-09-19 07:00:57', '1995-06-10 16:16:43');
INSERT INTO `communities` (`id`, `name`, `created_at`, `updated_at`) VALUES (32, 'quo', '1973-02-24 19:24:08', '1976-11-06 09:06:11');
INSERT INTO `communities` (`id`, `name`, `created_at`, `updated_at`) VALUES (33, 'perferendis', '2009-07-24 03:38:13', '1984-07-21 16:47:27');
INSERT INTO `communities` (`id`, `name`, `created_at`, `updated_at`) VALUES (34, 'et', '1973-03-05 04:30:09', '2016-01-15 07:40:54');
INSERT INTO `communities` (`id`, `name`, `created_at`, `updated_at`) VALUES (35, 'architecto', '1977-07-18 23:12:11', '2020-06-26 18:34:31');
INSERT INTO `communities` (`id`, `name`, `created_at`, `updated_at`) VALUES (36, 'a', '2001-09-06 05:32:16', '2003-06-28 04:47:20');
INSERT INTO `communities` (`id`, `name`, `created_at`, `updated_at`) VALUES (37, 'eum', '1999-07-12 18:13:56', '2015-12-11 12:23:59');
INSERT INTO `communities` (`id`, `name`, `created_at`, `updated_at`) VALUES (38, 'fuga', '2013-02-06 22:52:31', '2019-12-14 00:16:39');
INSERT INTO `communities` (`id`, `name`, `created_at`, `updated_at`) VALUES (39, 'sunt', '2007-03-19 22:05:51', '1988-08-12 09:29:17');
INSERT INTO `communities` (`id`, `name`, `created_at`, `updated_at`) VALUES (40, 'fugiat', '1997-02-16 09:58:02', '1980-05-09 05:33:11');
INSERT INTO `communities` (`id`, `name`, `created_at`, `updated_at`) VALUES (41, 'vero', '2010-10-17 02:12:55', '2021-03-09 23:44:17');
INSERT INTO `communities` (`id`, `name`, `created_at`, `updated_at`) VALUES (42, 'nulla', '2009-12-16 23:37:38', '1973-03-17 06:27:00');
INSERT INTO `communities` (`id`, `name`, `created_at`, `updated_at`) VALUES (43, 'ipsa', '2015-04-08 00:44:57', '2013-03-06 07:46:13');
INSERT INTO `communities` (`id`, `name`, `created_at`, `updated_at`) VALUES (44, 'minima', '1994-11-25 22:43:26', '2019-03-27 15:39:03');
INSERT INTO `communities` (`id`, `name`, `created_at`, `updated_at`) VALUES (45, 'nemo', '1984-09-29 23:32:21', '2004-07-14 19:33:17');
INSERT INTO `communities` (`id`, `name`, `created_at`, `updated_at`) VALUES (46, 'veniam', '2002-05-30 14:26:57', '1989-09-08 21:48:06');
INSERT INTO `communities` (`id`, `name`, `created_at`, `updated_at`) VALUES (47, 'aperiam', '1997-05-23 07:11:10', '2004-02-21 20:19:09');
INSERT INTO `communities` (`id`, `name`, `created_at`, `updated_at`) VALUES (48, 'blanditiis', '1997-07-28 18:04:09', '1978-04-22 04:10:04');
INSERT INTO `communities` (`id`, `name`, `created_at`, `updated_at`) VALUES (49, 'molestiae', '1971-03-10 01:41:28', '2003-09-01 19:14:27');
INSERT INTO `communities` (`id`, `name`, `created_at`, `updated_at`) VALUES (50, 'corporis', '1996-06-21 22:21:38', '1989-08-13 03:21:57');
INSERT INTO `communities` (`id`, `name`, `created_at`, `updated_at`) VALUES (51, 'eligendi', '1970-07-14 00:22:13', '1989-06-16 02:48:26');
INSERT INTO `communities` (`id`, `name`, `created_at`, `updated_at`) VALUES (52, 'minus', '1977-01-29 23:14:47', '1973-04-13 14:00:35');
INSERT INTO `communities` (`id`, `name`, `created_at`, `updated_at`) VALUES (53, 'laboriosam', '1981-07-29 11:39:47', '1972-07-15 16:17:26');
INSERT INTO `communities` (`id`, `name`, `created_at`, `updated_at`) VALUES (54, 'incidunt', '1981-03-14 11:22:27', '1977-09-07 15:50:52');
INSERT INTO `communities` (`id`, `name`, `created_at`, `updated_at`) VALUES (55, 'quia', '1978-11-10 20:09:15', '2005-02-13 02:28:47');
INSERT INTO `communities` (`id`, `name`, `created_at`, `updated_at`) VALUES (56, 'porro', '1993-02-10 11:31:27', '1997-12-17 03:44:30');
INSERT INTO `communities` (`id`, `name`, `created_at`, `updated_at`) VALUES (57, 'mollitia', '1993-08-02 01:31:28', '1987-06-15 20:34:18');
INSERT INTO `communities` (`id`, `name`, `created_at`, `updated_at`) VALUES (58, 'quam', '2003-09-23 23:27:45', '1973-01-11 19:09:48');
INSERT INTO `communities` (`id`, `name`, `created_at`, `updated_at`) VALUES (59, 'cupiditate', '2010-09-20 19:26:03', '2000-03-03 21:40:43');
INSERT INTO `communities` (`id`, `name`, `created_at`, `updated_at`) VALUES (60, 'quaerat', '1974-01-20 17:42:28', '1981-08-03 20:03:59');
INSERT INTO `communities` (`id`, `name`, `created_at`, `updated_at`) VALUES (61, 'modi', '1973-08-24 08:17:36', '1984-11-05 14:05:34');
INSERT INTO `communities` (`id`, `name`, `created_at`, `updated_at`) VALUES (62, 'rem', '2006-02-10 07:45:26', '2016-10-20 09:53:58');
INSERT INTO `communities` (`id`, `name`, `created_at`, `updated_at`) VALUES (63, 'eius', '2015-08-17 07:57:54', '1998-01-09 23:28:03');
INSERT INTO `communities` (`id`, `name`, `created_at`, `updated_at`) VALUES (64, 'numquam', '2000-01-17 04:59:01', '2020-08-21 02:31:47');
INSERT INTO `communities` (`id`, `name`, `created_at`, `updated_at`) VALUES (65, 'quis', '2013-05-14 15:26:19', '2009-09-02 21:51:16');
INSERT INTO `communities` (`id`, `name`, `created_at`, `updated_at`) VALUES (66, 'reprehenderit', '1992-05-14 21:23:05', '1971-03-19 11:46:06');
INSERT INTO `communities` (`id`, `name`, `created_at`, `updated_at`) VALUES (67, 'deserunt', '2001-02-23 21:00:01', '1973-12-31 02:15:03');
INSERT INTO `communities` (`id`, `name`, `created_at`, `updated_at`) VALUES (68, 'dolores', '1997-04-27 16:15:18', '2001-01-11 09:54:31');
INSERT INTO `communities` (`id`, `name`, `created_at`, `updated_at`) VALUES (69, 'magnam', '2006-03-19 09:17:33', '1974-09-17 15:31:24');
INSERT INTO `communities` (`id`, `name`, `created_at`, `updated_at`) VALUES (70, 'quasi', '2020-12-18 19:27:06', '2008-10-20 17:22:45');
INSERT INTO `communities` (`id`, `name`, `created_at`, `updated_at`) VALUES (71, 'asperiores', '1998-11-23 11:27:11', '1996-07-26 03:23:15');
INSERT INTO `communities` (`id`, `name`, `created_at`, `updated_at`) VALUES (72, 'assumenda', '1982-11-09 17:26:02', '2002-07-24 04:59:44');
INSERT INTO `communities` (`id`, `name`, `created_at`, `updated_at`) VALUES (73, 'voluptas', '1976-04-25 20:20:56', '2019-01-30 03:18:18');
INSERT INTO `communities` (`id`, `name`, `created_at`, `updated_at`) VALUES (74, 'odit', '1990-10-03 06:24:33', '1970-05-15 22:12:09');
INSERT INTO `communities` (`id`, `name`, `created_at`, `updated_at`) VALUES (75, 'ullam', '1976-03-29 07:16:18', '2017-12-07 18:50:07');
INSERT INTO `communities` (`id`, `name`, `created_at`, `updated_at`) VALUES (76, 'sit', '1989-05-12 04:55:38', '2008-05-04 17:34:03');
INSERT INTO `communities` (`id`, `name`, `created_at`, `updated_at`) VALUES (77, 'rerum', '1983-02-09 01:18:22', '1984-11-28 16:04:09');
INSERT INTO `communities` (`id`, `name`, `created_at`, `updated_at`) VALUES (78, 'earum', '2020-04-30 00:14:33', '1988-04-05 07:45:47');
INSERT INTO `communities` (`id`, `name`, `created_at`, `updated_at`) VALUES (79, 'ab', '2020-10-05 21:20:47', '2007-10-07 01:36:50');
INSERT INTO `communities` (`id`, `name`, `created_at`, `updated_at`) VALUES (80, 'adipisci', '2016-08-25 02:39:09', '2005-09-13 08:21:03');
INSERT INTO `communities` (`id`, `name`, `created_at`, `updated_at`) VALUES (81, 'ad', '2016-02-03 08:28:33', '2000-09-19 08:39:47');
INSERT INTO `communities` (`id`, `name`, `created_at`, `updated_at`) VALUES (82, 'nam', '1992-09-23 06:10:58', '2015-05-29 05:35:14');
INSERT INTO `communities` (`id`, `name`, `created_at`, `updated_at`) VALUES (83, 'dolore', '1989-04-03 13:24:17', '1974-09-16 08:54:31');
INSERT INTO `communities` (`id`, `name`, `created_at`, `updated_at`) VALUES (84, 'recusandae', '1981-04-07 22:04:14', '1988-08-16 00:16:52');
INSERT INTO `communities` (`id`, `name`, `created_at`, `updated_at`) VALUES (85, 'deleniti', '1985-02-15 00:41:18', '1980-12-24 00:40:35');
INSERT INTO `communities` (`id`, `name`, `created_at`, `updated_at`) VALUES (86, 'ducimus', '1979-12-24 17:05:50', '2005-01-11 15:01:15');
INSERT INTO `communities` (`id`, `name`, `created_at`, `updated_at`) VALUES (87, 'id', '1996-11-22 02:06:19', '2004-07-08 02:14:41');
INSERT INTO `communities` (`id`, `name`, `created_at`, `updated_at`) VALUES (88, 'praesentium', '1985-04-26 00:49:52', '2014-06-01 04:12:10');
INSERT INTO `communities` (`id`, `name`, `created_at`, `updated_at`) VALUES (89, 'distinctio', '1998-03-21 00:21:02', '1987-07-01 01:56:48');
INSERT INTO `communities` (`id`, `name`, `created_at`, `updated_at`) VALUES (90, 'debitis', '1998-05-28 13:39:19', '2020-12-13 22:28:26');
INSERT INTO `communities` (`id`, `name`, `created_at`, `updated_at`) VALUES (91, 'autem', '1993-08-13 22:39:55', '2000-05-24 23:54:49');
INSERT INTO `communities` (`id`, `name`, `created_at`, `updated_at`) VALUES (92, 'at', '2009-04-25 14:55:43', '1975-10-18 21:37:00');
INSERT INTO `communities` (`id`, `name`, `created_at`, `updated_at`) VALUES (93, 'amet', '1979-02-09 12:42:40', '1989-10-25 13:29:17');
INSERT INTO `communities` (`id`, `name`, `created_at`, `updated_at`) VALUES (94, 'perspiciatis', '2012-04-24 15:35:55', '1978-01-13 00:30:02');
INSERT INTO `communities` (`id`, `name`, `created_at`, `updated_at`) VALUES (95, 'libero', '1997-06-26 13:48:07', '1981-05-01 06:29:44');
INSERT INTO `communities` (`id`, `name`, `created_at`, `updated_at`) VALUES (96, 'sed', '2013-01-01 01:15:50', '1995-12-08 09:00:06');
INSERT INTO `communities` (`id`, `name`, `created_at`, `updated_at`) VALUES (97, 'natus', '2006-02-19 20:53:50', '1994-12-05 06:16:53');
INSERT INTO `communities` (`id`, `name`, `created_at`, `updated_at`) VALUES (98, 'dolorum', '1982-08-19 07:58:28', '2005-09-09 06:53:34');
INSERT INTO `communities` (`id`, `name`, `created_at`, `updated_at`) VALUES (99, 'illo', '1974-08-22 16:43:14', '1983-10-01 20:30:51');
INSERT INTO `communities` (`id`, `name`, `created_at`, `updated_at`) VALUES (100, 'accusamus', '2001-04-09 15:21:51', '2006-06-16 13:02:56');


#
# TABLE STRUCTURE FOR: communities_users
#

DROP TABLE IF EXISTS `communities_users`;

CREATE TABLE `communities_users` (
  `community_id` int(10) unsigned NOT NULL COMMENT 'Ссылка на группу',
  `user_id` int(10) unsigned NOT NULL COMMENT 'Ссылка на пользователя',
  `created_at` datetime DEFAULT current_timestamp() COMMENT 'Время создания строки',
  PRIMARY KEY (`community_id`,`user_id`) COMMENT 'Составной первичный ключ',
  KEY `user_id` (`user_id`),
  CONSTRAINT `communities_users_ibfk_1` FOREIGN KEY (`community_id`) REFERENCES `communities` (`id`),
  CONSTRAINT `communities_users_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Участники групп, связь между пользователями и группами';

INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (1, 1, '1995-05-02 00:34:11');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (2, 2, '2004-05-28 17:38:23');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (3, 3, '1975-12-01 03:21:41');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (4, 4, '1970-07-22 02:38:04');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (5, 5, '1987-07-29 12:25:29');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (6, 6, '2009-11-24 11:41:32');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (7, 7, '2005-12-30 13:40:24');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (8, 8, '2009-01-20 11:18:12');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (9, 9, '2011-08-08 11:41:03');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (10, 10, '1987-01-17 04:02:48');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (11, 11, '1982-01-02 19:35:44');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (12, 12, '1970-06-16 09:10:29');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (13, 13, '2011-03-21 09:06:27');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (14, 14, '1989-10-14 10:57:30');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (15, 15, '2012-03-14 14:28:32');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (16, 16, '1990-08-10 10:38:18');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (17, 17, '1987-07-22 13:21:38');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (18, 18, '1984-09-21 16:23:05');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (19, 19, '1981-05-11 16:49:08');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (20, 20, '2016-07-19 13:11:18');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (21, 21, '2009-04-25 12:39:23');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (22, 22, '1980-12-03 01:34:44');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (23, 23, '2005-12-29 06:24:25');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (24, 24, '1998-11-17 14:44:48');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (25, 25, '2004-03-28 11:54:51');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (26, 26, '1974-06-01 16:58:32');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (27, 27, '2008-04-02 14:17:07');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (28, 28, '2001-01-18 05:38:10');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (29, 29, '2001-05-10 08:53:23');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (30, 30, '2005-12-25 07:33:57');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (31, 31, '2010-06-17 02:55:07');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (32, 32, '1983-07-01 13:45:11');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (33, 33, '1999-05-09 23:23:45');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (34, 34, '2015-09-24 08:43:33');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (35, 35, '1984-08-23 22:50:58');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (36, 36, '1975-12-28 08:14:53');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (37, 37, '1985-07-25 23:23:54');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (38, 38, '2004-01-06 19:17:54');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (39, 39, '2006-03-11 21:52:19');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (40, 40, '2000-11-10 11:08:39');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (41, 41, '2017-08-08 12:53:33');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (42, 42, '1976-07-07 01:40:31');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (43, 43, '2013-03-12 05:11:49');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (44, 44, '2016-03-26 01:09:55');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (45, 45, '1998-09-24 00:47:01');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (46, 46, '2010-08-31 14:53:47');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (47, 47, '2003-07-19 12:51:36');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (48, 48, '1982-06-05 01:24:39');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (49, 49, '1971-03-23 03:41:50');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (50, 50, '1973-07-18 02:21:39');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (51, 51, '1992-03-12 16:53:36');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (52, 52, '2020-02-20 04:40:49');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (53, 53, '2009-10-02 22:28:50');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (54, 54, '2002-07-29 08:29:11');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (55, 55, '1994-06-18 01:32:31');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (56, 56, '1987-02-07 21:28:59');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (57, 57, '1996-01-04 02:38:43');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (58, 58, '1974-06-09 17:24:55');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (59, 59, '2002-05-21 15:17:15');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (60, 60, '2013-10-26 08:12:46');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (61, 61, '1995-03-02 16:26:42');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (62, 62, '1997-10-24 13:47:27');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (63, 63, '1984-03-01 03:56:06');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (64, 64, '1989-02-27 04:31:52');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (65, 65, '1995-05-24 11:42:58');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (66, 66, '2018-09-20 13:05:33');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (67, 67, '1972-09-02 15:37:03');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (68, 68, '1998-02-08 06:52:29');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (69, 69, '1972-03-09 15:08:23');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (70, 70, '2014-11-04 23:42:00');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (71, 71, '1986-07-06 08:55:09');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (72, 72, '2005-05-14 07:03:02');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (73, 73, '2012-05-07 12:17:16');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (74, 74, '2013-03-28 15:00:50');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (75, 75, '1994-06-17 14:16:32');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (76, 76, '1992-11-19 19:54:14');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (77, 77, '1973-05-25 16:03:57');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (78, 78, '1984-05-01 21:38:03');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (79, 79, '1996-08-14 01:55:53');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (80, 80, '1985-01-22 03:51:13');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (81, 81, '2017-07-20 22:24:58');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (82, 82, '1997-02-28 12:36:03');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (83, 83, '1990-07-10 12:46:08');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (84, 84, '1973-09-11 06:46:31');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (85, 85, '1987-05-26 14:23:09');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (86, 86, '1992-12-06 07:47:15');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (87, 87, '1986-05-09 01:05:30');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (88, 88, '1991-05-21 17:14:14');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (89, 89, '2014-10-13 22:18:14');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (90, 90, '1996-04-09 04:59:01');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (91, 91, '1998-11-19 15:12:09');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (92, 92, '1974-04-26 04:18:38');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (93, 93, '2003-08-25 09:44:09');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (94, 94, '2016-07-20 14:50:15');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (95, 95, '1992-01-01 04:06:28');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (96, 96, '1980-12-06 07:00:45');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (97, 97, '1980-08-08 06:34:12');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (98, 98, '1974-09-20 21:43:07');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (99, 99, '1982-12-28 18:35:21');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (100, 100, '1978-06-11 12:38:37');



#
# TABLE STRUCTURE FOR: media_types
#

DROP TABLE IF EXISTS `media_types`;

CREATE TABLE `media_types` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Идентификатор строки',
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Название типа',
  `created_at` datetime DEFAULT current_timestamp() COMMENT 'Время создания строки',
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT 'Время обновления строки',
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Типы медиафайлов';

INSERT INTO `media_types` (`id`, `name`, `created_at`, `updated_at`) VALUES (1, 'atque', '1999-04-22 06:50:06', '2019-07-20 02:04:21');
INSERT INTO `media_types` (`id`, `name`, `created_at`, `updated_at`) VALUES (2, 'officia', '2017-03-09 22:43:07', '1980-10-31 14:15:35');
INSERT INTO `media_types` (`id`, `name`, `created_at`, `updated_at`) VALUES (3, 'natus', '2008-09-02 12:52:42', '1976-09-18 02:56:49');
INSERT INTO `media_types` (`id`, `name`, `created_at`, `updated_at`) VALUES (4, 'necessitatibus', '2012-03-28 18:13:39', '2011-02-05 03:04:07');
INSERT INTO `media_types` (`id`, `name`, `created_at`, `updated_at`) VALUES (5, 'et', '2020-03-30 10:20:11', '1999-08-09 02:12:57');
INSERT INTO `media_types` (`id`, `name`, `created_at`, `updated_at`) VALUES (6, 'asperiores', '2015-09-27 09:44:26', '1975-01-31 00:36:12');
INSERT INTO `media_types` (`id`, `name`, `created_at`, `updated_at`) VALUES (7, 'alias', '2007-12-14 09:07:00', '1981-03-04 18:26:13');
INSERT INTO `media_types` (`id`, `name`, `created_at`, `updated_at`) VALUES (8, 'sit', '2004-05-03 19:15:55', '2000-04-20 00:20:31');
INSERT INTO `media_types` (`id`, `name`, `created_at`, `updated_at`) VALUES (9, 'sint', '1970-08-17 19:19:12', '2000-05-13 08:34:30');
INSERT INTO `media_types` (`id`, `name`, `created_at`, `updated_at`) VALUES (10, 'eius', '2004-09-06 16:11:18', '2018-09-02 18:03:06');





#
# TABLE STRUCTURE FOR: media
#

DROP TABLE IF EXISTS `media`;

CREATE TABLE `media` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Идентификатор строки',
  `user_id` int(10) unsigned NOT NULL COMMENT 'Ссылка на пользователя, который загрузил файл',
  `filename` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Путь к файлу',
  `size` int(11) NOT NULL COMMENT 'Размер файла',
  `metadata` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT 'Метаданные файла' CHECK (json_valid(`metadata`)),
  `media_type_id` int(10) unsigned NOT NULL COMMENT 'Ссылка на тип контента',
  `created_at` datetime DEFAULT current_timestamp() COMMENT 'Время создания строки',
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT 'Время обновления строки',
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  KEY `media_type_id` (`media_type_id`),
  CONSTRAINT `media_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  CONSTRAINT `media_ibfk_2` FOREIGN KEY (`media_type_id`) REFERENCES `media_types` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=101 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Медиафайлы';

INSERT INTO `media` (`id`, `user_id`, `filename`, `size`, `metadata`, `media_type_id`, `created_at`, `updated_at`) VALUES (1, 1, 'architecto', 7, NULL, 1, '2001-05-23 18:49:26', '1970-09-03 17:31:47');
INSERT INTO `media` (`id`, `user_id`, `filename`, `size`, `metadata`, `media_type_id`, `created_at`, `updated_at`) VALUES (2, 2, 'voluptatem', 52, NULL, 2, '1973-01-15 03:10:37', '1980-10-10 18:37:02');
INSERT INTO `media` (`id`, `user_id`, `filename`, `size`, `metadata`, `media_type_id`, `created_at`, `updated_at`) VALUES (3, 3, 'ut', 0, NULL, 3, '2019-05-15 06:15:36', '2013-04-29 13:33:23');
INSERT INTO `media` (`id`, `user_id`, `filename`, `size`, `metadata`, `media_type_id`, `created_at`, `updated_at`) VALUES (4, 4, 'ut', 0, NULL, 4, '1989-08-14 09:16:31', '2006-07-25 19:06:20');
INSERT INTO `media` (`id`, `user_id`, `filename`, `size`, `metadata`, `media_type_id`, `created_at`, `updated_at`) VALUES (5, 5, 'perspiciatis', 486222, NULL, 5, '1983-02-27 09:08:04', '2003-11-26 13:32:28');
INSERT INTO `media` (`id`, `user_id`, `filename`, `size`, `metadata`, `media_type_id`, `created_at`, `updated_at`) VALUES (6, 6, 'consequatur', 96001713, NULL, 6, '2001-12-30 16:07:27', '1994-03-31 18:23:45');
INSERT INTO `media` (`id`, `user_id`, `filename`, `size`, `metadata`, `media_type_id`, `created_at`, `updated_at`) VALUES (7, 7, 'nesciunt', 0, NULL, 7, '1988-05-18 22:57:44', '1974-02-09 07:34:16');
INSERT INTO `media` (`id`, `user_id`, `filename`, `size`, `metadata`, `media_type_id`, `created_at`, `updated_at`) VALUES (8, 8, 'voluptas', 62982, NULL, 8, '2013-08-30 20:03:07', '1994-08-15 00:06:07');
INSERT INTO `media` (`id`, `user_id`, `filename`, `size`, `metadata`, `media_type_id`, `created_at`, `updated_at`) VALUES (9, 9, 'consequuntur', 3957, NULL, 9, '2002-09-22 07:16:22', '1988-07-02 05:01:24');
INSERT INTO `media` (`id`, `user_id`, `filename`, `size`, `metadata`, `media_type_id`, `created_at`, `updated_at`) VALUES (10, 10, 'autem', 410, NULL, 10, '1992-01-26 09:30:14', '1989-10-05 14:17:15');
INSERT INTO `media` (`id`, `user_id`, `filename`, `size`, `metadata`, `media_type_id`, `created_at`, `updated_at`) VALUES (11, 11, 'optio', 1965, NULL, 1, '1980-03-23 15:01:32', '2000-04-24 12:12:49');
INSERT INTO `media` (`id`, `user_id`, `filename`, `size`, `metadata`, `media_type_id`, `created_at`, `updated_at`) VALUES (12, 12, 'provident', 13018, NULL, 2, '1971-12-25 00:54:40', '1977-05-06 08:02:54');
INSERT INTO `media` (`id`, `user_id`, `filename`, `size`, `metadata`, `media_type_id`, `created_at`, `updated_at`) VALUES (13, 13, 'laudantium', 885832, NULL, 3, '2003-08-28 16:41:43', '2021-01-28 22:45:43');
INSERT INTO `media` (`id`, `user_id`, `filename`, `size`, `metadata`, `media_type_id`, `created_at`, `updated_at`) VALUES (14, 14, 'ad', 5507773, NULL, 4, '2017-07-25 04:12:12', '2007-01-10 12:58:23');
INSERT INTO `media` (`id`, `user_id`, `filename`, `size`, `metadata`, `media_type_id`, `created_at`, `updated_at`) VALUES (15, 15, 'asperiores', 0, NULL, 5, '1995-02-07 18:20:24', '2016-03-05 14:18:23');
INSERT INTO `media` (`id`, `user_id`, `filename`, `size`, `metadata`, `media_type_id`, `created_at`, `updated_at`) VALUES (16, 16, 'ea', 6494, NULL, 6, '1998-11-08 10:32:21', '1980-04-11 00:36:33');
INSERT INTO `media` (`id`, `user_id`, `filename`, `size`, `metadata`, `media_type_id`, `created_at`, `updated_at`) VALUES (17, 17, 'ut', 0, NULL, 7, '2020-12-09 12:47:11', '1989-03-03 05:09:09');
INSERT INTO `media` (`id`, `user_id`, `filename`, `size`, `metadata`, `media_type_id`, `created_at`, `updated_at`) VALUES (18, 18, 'autem', 1, NULL, 8, '1979-10-05 21:36:51', '2018-03-17 15:17:58');
INSERT INTO `media` (`id`, `user_id`, `filename`, `size`, `metadata`, `media_type_id`, `created_at`, `updated_at`) VALUES (19, 19, 'omnis', 517, NULL, 9, '2001-10-09 13:52:02', '2002-05-10 18:36:20');
INSERT INTO `media` (`id`, `user_id`, `filename`, `size`, `metadata`, `media_type_id`, `created_at`, `updated_at`) VALUES (20, 20, 'quasi', 28263, NULL, 10, '1974-07-25 13:14:09', '2012-07-11 12:10:21');
INSERT INTO `media` (`id`, `user_id`, `filename`, `size`, `metadata`, `media_type_id`, `created_at`, `updated_at`) VALUES (21, 21, 'numquam', 65404641, NULL, 1, '2015-02-09 17:13:48', '1986-05-12 11:53:07');
INSERT INTO `media` (`id`, `user_id`, `filename`, `size`, `metadata`, `media_type_id`, `created_at`, `updated_at`) VALUES (22, 22, 'voluptatem', 0, NULL, 2, '2000-08-24 21:42:16', '1999-09-10 00:55:06');
INSERT INTO `media` (`id`, `user_id`, `filename`, `size`, `metadata`, `media_type_id`, `created_at`, `updated_at`) VALUES (23, 23, 'aliquam', 5786, NULL, 3, '2007-09-14 08:28:01', '2012-01-02 05:57:56');
INSERT INTO `media` (`id`, `user_id`, `filename`, `size`, `metadata`, `media_type_id`, `created_at`, `updated_at`) VALUES (24, 24, 'ratione', 854634795, NULL, 4, '1998-11-11 13:42:27', '2012-08-03 20:28:01');
INSERT INTO `media` (`id`, `user_id`, `filename`, `size`, `metadata`, `media_type_id`, `created_at`, `updated_at`) VALUES (25, 25, 'saepe', 98, NULL, 5, '1993-01-18 10:54:11', '1983-04-25 03:18:15');
INSERT INTO `media` (`id`, `user_id`, `filename`, `size`, `metadata`, `media_type_id`, `created_at`, `updated_at`) VALUES (26, 26, 'enim', 0, NULL, 6, '1980-07-11 20:24:44', '2010-04-28 20:39:55');
INSERT INTO `media` (`id`, `user_id`, `filename`, `size`, `metadata`, `media_type_id`, `created_at`, `updated_at`) VALUES (27, 27, 'asperiores', 29246654, NULL, 7, '1976-01-21 02:06:45', '1975-06-01 11:43:52');
INSERT INTO `media` (`id`, `user_id`, `filename`, `size`, `metadata`, `media_type_id`, `created_at`, `updated_at`) VALUES (28, 28, 'sed', 6126714, NULL, 8, '1985-10-13 11:15:02', '2009-04-22 04:01:20');
INSERT INTO `media` (`id`, `user_id`, `filename`, `size`, `metadata`, `media_type_id`, `created_at`, `updated_at`) VALUES (29, 29, 'quia', 9740052, NULL, 9, '1983-04-17 11:09:09', '1993-05-07 04:40:50');
INSERT INTO `media` (`id`, `user_id`, `filename`, `size`, `metadata`, `media_type_id`, `created_at`, `updated_at`) VALUES (30, 30, 'est', 8, NULL, 10, '1995-06-13 12:08:29', '2020-09-18 15:40:26');
INSERT INTO `media` (`id`, `user_id`, `filename`, `size`, `metadata`, `media_type_id`, `created_at`, `updated_at`) VALUES (31, 31, 'minus', 381437, NULL, 1, '2007-10-08 18:06:52', '1982-07-20 12:50:10');
INSERT INTO `media` (`id`, `user_id`, `filename`, `size`, `metadata`, `media_type_id`, `created_at`, `updated_at`) VALUES (32, 32, 'debitis', 1405, NULL, 2, '1995-02-10 23:29:27', '2005-12-21 12:47:18');
INSERT INTO `media` (`id`, `user_id`, `filename`, `size`, `metadata`, `media_type_id`, `created_at`, `updated_at`) VALUES (33, 33, 'adipisci', 73255545, NULL, 3, '1986-03-17 10:07:49', '1981-12-29 09:32:59');
INSERT INTO `media` (`id`, `user_id`, `filename`, `size`, `metadata`, `media_type_id`, `created_at`, `updated_at`) VALUES (34, 34, 'doloribus', 8423763, NULL, 4, '2014-06-12 21:12:18', '1992-06-28 06:28:31');
INSERT INTO `media` (`id`, `user_id`, `filename`, `size`, `metadata`, `media_type_id`, `created_at`, `updated_at`) VALUES (35, 35, 'impedit', 969, NULL, 5, '2000-03-15 13:23:28', '1986-01-22 11:04:29');
INSERT INTO `media` (`id`, `user_id`, `filename`, `size`, `metadata`, `media_type_id`, `created_at`, `updated_at`) VALUES (36, 36, 'totam', 904370181, NULL, 6, '1980-06-08 02:00:16', '1977-07-01 18:10:04');
INSERT INTO `media` (`id`, `user_id`, `filename`, `size`, `metadata`, `media_type_id`, `created_at`, `updated_at`) VALUES (37, 37, 'et', 3241542, NULL, 7, '2017-10-12 23:55:50', '1976-06-30 07:04:18');
INSERT INTO `media` (`id`, `user_id`, `filename`, `size`, `metadata`, `media_type_id`, `created_at`, `updated_at`) VALUES (38, 38, 'dolores', 0, NULL, 8, '1976-07-10 19:08:28', '1998-08-23 08:11:54');
INSERT INTO `media` (`id`, `user_id`, `filename`, `size`, `metadata`, `media_type_id`, `created_at`, `updated_at`) VALUES (39, 39, 'modi', 642, NULL, 9, '2013-07-10 22:39:37', '1971-05-19 16:20:06');
INSERT INTO `media` (`id`, `user_id`, `filename`, `size`, `metadata`, `media_type_id`, `created_at`, `updated_at`) VALUES (40, 40, 'quo', 30470, NULL, 10, '1970-11-18 23:20:36', '1977-07-31 11:02:08');
INSERT INTO `media` (`id`, `user_id`, `filename`, `size`, `metadata`, `media_type_id`, `created_at`, `updated_at`) VALUES (41, 41, 'sed', 629434065, NULL, 1, '2016-06-17 14:59:13', '2012-02-22 13:30:51');
INSERT INTO `media` (`id`, `user_id`, `filename`, `size`, `metadata`, `media_type_id`, `created_at`, `updated_at`) VALUES (42, 42, 'deleniti', 8821, NULL, 2, '1991-12-24 02:42:30', '1978-06-26 01:49:40');
INSERT INTO `media` (`id`, `user_id`, `filename`, `size`, `metadata`, `media_type_id`, `created_at`, `updated_at`) VALUES (43, 43, 'distinctio', 93, NULL, 3, '2017-01-10 04:25:18', '1974-08-31 08:45:46');
INSERT INTO `media` (`id`, `user_id`, `filename`, `size`, `metadata`, `media_type_id`, `created_at`, `updated_at`) VALUES (44, 44, 'omnis', 0, NULL, 4, '2008-10-25 00:28:24', '2001-12-23 18:46:32');
INSERT INTO `media` (`id`, `user_id`, `filename`, `size`, `metadata`, `media_type_id`, `created_at`, `updated_at`) VALUES (45, 45, 'architecto', 99070874, NULL, 5, '2014-09-12 05:02:06', '1982-02-03 19:33:57');
INSERT INTO `media` (`id`, `user_id`, `filename`, `size`, `metadata`, `media_type_id`, `created_at`, `updated_at`) VALUES (46, 46, 'occaecati', 500478, NULL, 6, '2004-05-24 13:26:13', '2021-04-09 20:38:20');
INSERT INTO `media` (`id`, `user_id`, `filename`, `size`, `metadata`, `media_type_id`, `created_at`, `updated_at`) VALUES (47, 47, 'et', 37, NULL, 7, '2009-01-15 06:20:32', '2000-03-29 15:26:24');
INSERT INTO `media` (`id`, `user_id`, `filename`, `size`, `metadata`, `media_type_id`, `created_at`, `updated_at`) VALUES (48, 48, 'voluptas', 1631, NULL, 8, '1975-09-07 14:11:00', '1999-04-16 01:25:19');
INSERT INTO `media` (`id`, `user_id`, `filename`, `size`, `metadata`, `media_type_id`, `created_at`, `updated_at`) VALUES (49, 49, 'qui', 9956339, NULL, 9, '1980-10-25 14:26:57', '1988-06-06 00:31:45');
INSERT INTO `media` (`id`, `user_id`, `filename`, `size`, `metadata`, `media_type_id`, `created_at`, `updated_at`) VALUES (50, 50, 'recusandae', 1633, NULL, 10, '1993-12-08 12:54:51', '1988-06-05 16:00:44');
INSERT INTO `media` (`id`, `user_id`, `filename`, `size`, `metadata`, `media_type_id`, `created_at`, `updated_at`) VALUES (51, 51, 'tempore', 99481, NULL, 1, '2008-12-24 04:20:06', '2015-09-05 05:34:30');
INSERT INTO `media` (`id`, `user_id`, `filename`, `size`, `metadata`, `media_type_id`, `created_at`, `updated_at`) VALUES (52, 52, 'ab', 792070429, NULL, 2, '1987-12-30 14:56:03', '2008-09-04 13:42:22');
INSERT INTO `media` (`id`, `user_id`, `filename`, `size`, `metadata`, `media_type_id`, `created_at`, `updated_at`) VALUES (53, 53, 'voluptates', 72, NULL, 3, '2015-05-16 00:21:21', '1980-03-02 12:03:56');
INSERT INTO `media` (`id`, `user_id`, `filename`, `size`, `metadata`, `media_type_id`, `created_at`, `updated_at`) VALUES (54, 54, 'in', 87724068, NULL, 4, '1987-07-31 09:43:07', '2013-06-13 20:30:12');
INSERT INTO `media` (`id`, `user_id`, `filename`, `size`, `metadata`, `media_type_id`, `created_at`, `updated_at`) VALUES (55, 55, 'assumenda', 581, NULL, 5, '2009-06-20 09:30:57', '2008-08-06 01:58:10');
INSERT INTO `media` (`id`, `user_id`, `filename`, `size`, `metadata`, `media_type_id`, `created_at`, `updated_at`) VALUES (56, 56, 'illo', 982829, NULL, 6, '1984-02-09 23:12:12', '1990-05-11 10:06:21');
INSERT INTO `media` (`id`, `user_id`, `filename`, `size`, `metadata`, `media_type_id`, `created_at`, `updated_at`) VALUES (57, 57, 'quaerat', 806900, NULL, 7, '1994-03-18 05:17:53', '2011-11-02 06:56:36');
INSERT INTO `media` (`id`, `user_id`, `filename`, `size`, `metadata`, `media_type_id`, `created_at`, `updated_at`) VALUES (58, 58, 'nihil', 2, NULL, 8, '2004-02-06 08:16:14', '2002-02-07 12:52:30');
INSERT INTO `media` (`id`, `user_id`, `filename`, `size`, `metadata`, `media_type_id`, `created_at`, `updated_at`) VALUES (59, 59, 'ut', 888, NULL, 9, '2001-06-02 12:00:26', '2010-12-19 12:13:26');
INSERT INTO `media` (`id`, `user_id`, `filename`, `size`, `metadata`, `media_type_id`, `created_at`, `updated_at`) VALUES (60, 60, 'quod', 628354, NULL, 10, '1985-01-11 09:00:21', '1991-08-15 18:33:40');
INSERT INTO `media` (`id`, `user_id`, `filename`, `size`, `metadata`, `media_type_id`, `created_at`, `updated_at`) VALUES (61, 61, 'ea', 715395420, NULL, 1, '1982-02-07 21:19:26', '2013-05-03 07:32:51');
INSERT INTO `media` (`id`, `user_id`, `filename`, `size`, `metadata`, `media_type_id`, `created_at`, `updated_at`) VALUES (62, 62, 'qui', 1265855, NULL, 2, '1971-09-29 14:50:52', '2015-03-05 07:41:54');
INSERT INTO `media` (`id`, `user_id`, `filename`, `size`, `metadata`, `media_type_id`, `created_at`, `updated_at`) VALUES (63, 63, 'officia', 2022, NULL, 3, '2018-04-23 22:57:51', '1986-10-26 03:43:10');
INSERT INTO `media` (`id`, `user_id`, `filename`, `size`, `metadata`, `media_type_id`, `created_at`, `updated_at`) VALUES (64, 64, 'nisi', 3516445, NULL, 4, '1995-05-12 12:24:36', '1973-12-13 11:27:07');
INSERT INTO `media` (`id`, `user_id`, `filename`, `size`, `metadata`, `media_type_id`, `created_at`, `updated_at`) VALUES (65, 65, 'repudiandae', 0, NULL, 5, '2020-12-10 13:33:14', '2018-04-28 23:09:34');
INSERT INTO `media` (`id`, `user_id`, `filename`, `size`, `metadata`, `media_type_id`, `created_at`, `updated_at`) VALUES (66, 66, 'doloremque', 9992870, NULL, 6, '1985-10-01 06:17:57', '1972-06-29 06:50:29');
INSERT INTO `media` (`id`, `user_id`, `filename`, `size`, `metadata`, `media_type_id`, `created_at`, `updated_at`) VALUES (67, 67, 'consequatur', 37191, NULL, 7, '1978-01-25 06:16:56', '2021-04-30 20:22:49');
INSERT INTO `media` (`id`, `user_id`, `filename`, `size`, `metadata`, `media_type_id`, `created_at`, `updated_at`) VALUES (68, 68, 'ad', 0, NULL, 8, '1974-10-21 01:39:57', '1994-06-13 19:30:36');
INSERT INTO `media` (`id`, `user_id`, `filename`, `size`, `metadata`, `media_type_id`, `created_at`, `updated_at`) VALUES (69, 69, 'perferendis', 0, NULL, 9, '1978-12-15 05:55:29', '2021-03-19 18:57:41');
INSERT INTO `media` (`id`, `user_id`, `filename`, `size`, `metadata`, `media_type_id`, `created_at`, `updated_at`) VALUES (70, 70, 'sunt', 3453, NULL, 10, '2011-05-15 03:11:56', '1977-06-12 02:48:45');
INSERT INTO `media` (`id`, `user_id`, `filename`, `size`, `metadata`, `media_type_id`, `created_at`, `updated_at`) VALUES (71, 71, 'vel', 719379303, NULL, 1, '1987-10-07 19:50:11', '1974-04-28 08:05:57');
INSERT INTO `media` (`id`, `user_id`, `filename`, `size`, `metadata`, `media_type_id`, `created_at`, `updated_at`) VALUES (72, 72, 'velit', 596385, NULL, 2, '1998-05-26 18:04:24', '2007-12-23 12:59:43');
INSERT INTO `media` (`id`, `user_id`, `filename`, `size`, `metadata`, `media_type_id`, `created_at`, `updated_at`) VALUES (73, 73, 'eum', 92307, NULL, 3, '2007-04-03 16:56:27', '1972-12-25 18:09:53');
INSERT INTO `media` (`id`, `user_id`, `filename`, `size`, `metadata`, `media_type_id`, `created_at`, `updated_at`) VALUES (74, 74, 'debitis', 14584, NULL, 4, '1982-04-09 00:14:38', '1998-03-22 22:43:47');
INSERT INTO `media` (`id`, `user_id`, `filename`, `size`, `metadata`, `media_type_id`, `created_at`, `updated_at`) VALUES (75, 75, 'autem', 17373, NULL, 5, '1994-06-14 23:50:05', '1986-06-17 19:22:55');
INSERT INTO `media` (`id`, `user_id`, `filename`, `size`, `metadata`, `media_type_id`, `created_at`, `updated_at`) VALUES (76, 76, 'omnis', 8288, NULL, 6, '2009-04-06 13:48:33', '1975-03-31 10:23:44');
INSERT INTO `media` (`id`, `user_id`, `filename`, `size`, `metadata`, `media_type_id`, `created_at`, `updated_at`) VALUES (77, 77, 'voluptates', 124185, NULL, 7, '1983-04-09 14:08:53', '1980-03-06 16:16:49');
INSERT INTO `media` (`id`, `user_id`, `filename`, `size`, `metadata`, `media_type_id`, `created_at`, `updated_at`) VALUES (78, 78, 'et', 972169591, NULL, 8, '2020-05-03 21:07:25', '2019-04-23 12:32:56');
INSERT INTO `media` (`id`, `user_id`, `filename`, `size`, `metadata`, `media_type_id`, `created_at`, `updated_at`) VALUES (79, 79, 'debitis', 30875, NULL, 9, '1977-05-27 06:22:30', '1977-12-16 06:56:20');
INSERT INTO `media` (`id`, `user_id`, `filename`, `size`, `metadata`, `media_type_id`, `created_at`, `updated_at`) VALUES (80, 80, 'earum', 788, NULL, 10, '2007-02-04 02:51:46', '2018-03-25 15:55:26');
INSERT INTO `media` (`id`, `user_id`, `filename`, `size`, `metadata`, `media_type_id`, `created_at`, `updated_at`) VALUES (81, 81, 'omnis', 647, NULL, 1, '2000-04-28 19:27:29', '2001-06-02 10:01:44');
INSERT INTO `media` (`id`, `user_id`, `filename`, `size`, `metadata`, `media_type_id`, `created_at`, `updated_at`) VALUES (82, 82, 'hic', 996551, NULL, 2, '1974-08-06 02:30:27', '2018-02-13 21:31:41');
INSERT INTO `media` (`id`, `user_id`, `filename`, `size`, `metadata`, `media_type_id`, `created_at`, `updated_at`) VALUES (83, 83, 'eveniet', 941, NULL, 3, '2018-08-01 05:13:03', '2003-01-08 02:25:29');
INSERT INTO `media` (`id`, `user_id`, `filename`, `size`, `metadata`, `media_type_id`, `created_at`, `updated_at`) VALUES (84, 84, 'tempora', 20058925, NULL, 4, '2012-11-13 03:34:35', '1996-01-15 20:15:14');
INSERT INTO `media` (`id`, `user_id`, `filename`, `size`, `metadata`, `media_type_id`, `created_at`, `updated_at`) VALUES (85, 85, 'error', 656176833, NULL, 5, '1984-03-13 14:48:02', '2011-09-18 12:27:42');
INSERT INTO `media` (`id`, `user_id`, `filename`, `size`, `metadata`, `media_type_id`, `created_at`, `updated_at`) VALUES (86, 86, 'molestias', 82, NULL, 6, '2000-04-09 02:52:59', '1999-12-02 09:58:48');
INSERT INTO `media` (`id`, `user_id`, `filename`, `size`, `metadata`, `media_type_id`, `created_at`, `updated_at`) VALUES (87, 87, 'iure', 34039797, NULL, 7, '1992-02-05 13:30:51', '1986-12-27 11:27:21');
INSERT INTO `media` (`id`, `user_id`, `filename`, `size`, `metadata`, `media_type_id`, `created_at`, `updated_at`) VALUES (88, 88, 'ducimus', 548, NULL, 8, '1981-11-29 15:36:40', '2010-03-09 03:42:36');
INSERT INTO `media` (`id`, `user_id`, `filename`, `size`, `metadata`, `media_type_id`, `created_at`, `updated_at`) VALUES (89, 89, 'asperiores', 44841, NULL, 9, '1982-12-29 08:59:30', '1982-05-19 08:33:18');
INSERT INTO `media` (`id`, `user_id`, `filename`, `size`, `metadata`, `media_type_id`, `created_at`, `updated_at`) VALUES (90, 90, 'temporibus', 8828, NULL, 10, '2006-06-05 15:35:45', '2009-05-10 04:34:08');
INSERT INTO `media` (`id`, `user_id`, `filename`, `size`, `metadata`, `media_type_id`, `created_at`, `updated_at`) VALUES (91, 91, 'rem', 0, NULL, 1, '2015-08-26 09:24:38', '1972-11-12 17:03:54');
INSERT INTO `media` (`id`, `user_id`, `filename`, `size`, `metadata`, `media_type_id`, `created_at`, `updated_at`) VALUES (92, 92, 'labore', 8256828, NULL, 2, '1985-05-19 17:59:55', '1981-02-18 12:44:03');
INSERT INTO `media` (`id`, `user_id`, `filename`, `size`, `metadata`, `media_type_id`, `created_at`, `updated_at`) VALUES (93, 93, 'omnis', 0, NULL, 3, '1988-05-24 17:59:03', '1994-12-05 02:47:51');
INSERT INTO `media` (`id`, `user_id`, `filename`, `size`, `metadata`, `media_type_id`, `created_at`, `updated_at`) VALUES (94, 94, 'et', 675, NULL, 4, '1999-07-19 07:41:20', '2015-06-12 08:52:55');
INSERT INTO `media` (`id`, `user_id`, `filename`, `size`, `metadata`, `media_type_id`, `created_at`, `updated_at`) VALUES (95, 95, 'fuga', 470704969, NULL, 5, '2000-01-14 01:06:25', '2020-11-08 18:31:29');
INSERT INTO `media` (`id`, `user_id`, `filename`, `size`, `metadata`, `media_type_id`, `created_at`, `updated_at`) VALUES (96, 96, 'numquam', 26385968, NULL, 6, '2012-12-02 03:19:26', '1996-03-04 16:48:33');
INSERT INTO `media` (`id`, `user_id`, `filename`, `size`, `metadata`, `media_type_id`, `created_at`, `updated_at`) VALUES (97, 97, 'eligendi', 238470250, NULL, 7, '1981-09-28 02:08:59', '1982-01-25 14:27:18');
INSERT INTO `media` (`id`, `user_id`, `filename`, `size`, `metadata`, `media_type_id`, `created_at`, `updated_at`) VALUES (98, 98, 'modi', 821773, NULL, 8, '1979-08-05 05:47:26', '2001-08-16 04:21:22');
INSERT INTO `media` (`id`, `user_id`, `filename`, `size`, `metadata`, `media_type_id`, `created_at`, `updated_at`) VALUES (99, 99, 'explicabo', 2114392, NULL, 9, '1995-07-11 21:49:17', '2003-12-25 15:59:50');
INSERT INTO `media` (`id`, `user_id`, `filename`, `size`, `metadata`, `media_type_id`, `created_at`, `updated_at`) VALUES (100, 100, 'esse', 568566505, NULL, 10, '2020-02-11 22:12:03', '2013-03-21 13:20:42');


-- MariaDB dump 10.17  Distrib 10.4.15-MariaDB, for Linux (x86_64)
--
-- Host: mysql.hostinger.ro    Database: u574849695_25
-- ------------------------------------------------------
-- Server version	10.4.15-MariaDB-cll-lve

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `media_likes`
--

DROP TABLE IF EXISTS `media_likes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `media_likes` (
  `media_id` int(10) unsigned NOT NULL COMMENT 'Ссылка на медиафайл',
  `user_id` int(10) unsigned NOT NULL COMMENT 'Ссылка на пользователя, который лайкнул',
  `created_at` datetime DEFAULT current_timestamp() COMMENT 'Время создания строки',
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT 'Время обновления строки',
  PRIMARY KEY (`media_id`,`user_id`) COMMENT 'Составной первичный ключ'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Количество лайков медиафайлов';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `media_likes`
--

LOCK TABLES `media_likes` WRITE;
/*!40000 ALTER TABLE `media_likes` DISABLE KEYS */;
INSERT INTO `media_likes` VALUES (1,87,'1975-06-17 05:29:33','2000-12-15 19:57:04'),(1,98,'2002-03-05 02:48:29','2019-03-20 07:39:28'),(3,81,'2005-12-11 17:41:56','1980-12-19 17:22:03'),(4,25,'1972-08-17 08:23:56','1992-10-16 19:30:48'),(5,25,'1975-09-06 09:26:08','1988-12-26 21:15:08'),(5,80,'1998-01-19 03:44:14','2015-05-24 04:12:33'),(6,61,'1994-07-15 22:06:16','2011-02-07 01:02:01'),(6,89,'1989-11-01 10:43:58','1992-01-06 11:03:37'),(7,40,'1975-10-23 00:15:52','1985-09-18 19:44:37'),(7,57,'1983-07-14 06:14:02','1984-06-18 06:15:13'),(8,30,'2019-01-11 05:38:22','1984-10-14 17:27:28'),(8,47,'2014-01-13 10:38:54','2007-12-02 17:57:25'),(8,53,'1982-01-31 01:19:24','1986-02-06 07:02:05'),(8,79,'2003-09-19 13:13:28','1998-06-13 03:52:39'),(8,81,'2004-02-09 12:07:18','1972-07-24 14:37:26'),(9,23,'1987-05-05 06:48:06','1982-09-27 10:45:21'),(10,41,'2014-07-21 17:01:50','1986-05-27 09:41:20'),(11,87,'1971-02-26 07:12:28','2003-12-17 15:17:43'),(12,23,'2019-04-08 02:18:12','2012-06-30 02:36:25'),(12,27,'1988-02-10 02:25:45','1979-08-22 18:12:47'),(12,74,'2009-03-16 20:36:59','1981-09-18 23:48:15'),(13,13,'1991-04-28 18:29:42','1986-10-30 01:52:23'),(13,28,'1985-08-12 23:03:51','2013-11-30 22:20:54'),(13,43,'1991-09-05 11:44:20','1987-07-12 17:34:50'),(13,85,'1994-10-27 21:04:55','1991-02-22 08:48:19'),(15,20,'1984-09-11 15:24:49','2002-03-06 13:00:56'),(15,55,'2011-05-17 06:03:42','2014-05-25 06:07:49'),(16,18,'2018-04-14 10:30:49','2018-04-09 18:17:23'),(16,20,'1994-02-11 07:01:17','2013-07-01 23:53:23'),(16,37,'2003-05-11 00:46:55','2021-02-28 16:19:16'),(16,49,'1975-09-08 17:33:40','1970-10-22 09:53:33'),(17,1,'1997-10-24 09:29:14','1972-02-23 23:52:18'),(18,40,'1999-10-16 21:02:42','1981-12-06 12:47:26'),(18,41,'2002-11-16 23:39:16','2020-03-13 17:17:06'),(19,15,'2005-04-05 18:21:31','2002-08-28 20:50:35'),(19,18,'2004-07-31 23:48:17','1989-11-11 18:30:12'),(19,26,'1974-04-11 08:54:22','1981-07-28 03:00:48'),(19,32,'2017-11-27 15:39:35','1972-01-20 19:04:22'),(20,19,'1985-01-19 16:53:45','1992-04-24 06:08:03'),(20,71,'1980-03-06 05:10:56','1988-05-18 18:35:08'),(21,10,'1984-01-20 06:14:41','2013-11-04 14:06:36'),(22,22,'2002-09-18 04:12:43','2011-02-10 01:55:59'),(22,32,'1981-01-15 21:29:56','1998-03-01 14:20:54'),(23,65,'1984-05-10 08:15:12','2004-12-10 11:26:39'),(24,18,'2007-10-06 21:12:03','1991-01-01 11:22:19'),(24,29,'2011-01-27 08:32:56','1978-11-06 13:04:42'),(25,39,'1988-07-19 22:35:08','1998-04-28 04:12:38'),(25,40,'2012-03-24 23:19:26','1986-12-08 00:27:53'),(25,58,'1971-03-10 22:37:26','2014-01-06 23:07:21'),(26,70,'2021-02-07 00:30:31','1998-10-30 21:33:42'),(27,77,'2015-09-09 09:29:36','1985-01-28 13:03:02'),(29,7,'2002-06-23 10:19:48','1982-06-19 07:16:44'),(29,24,'2019-05-13 11:05:35','2013-08-05 10:57:49'),(29,51,'2009-08-04 21:33:35','1993-02-24 12:07:07'),(30,45,'1980-07-10 17:24:31','1970-07-08 15:49:14'),(30,63,'2009-06-08 21:37:34','2009-08-21 21:58:11'),(30,96,'2003-05-15 17:43:46','1971-02-27 16:44:08'),(31,64,'1973-06-30 01:59:46','1998-02-25 11:35:19'),(31,70,'1988-07-31 11:53:05','1994-03-29 21:00:55'),(32,10,'2013-03-17 17:39:03','1986-05-07 07:37:30'),(32,78,'2002-09-03 05:14:25','1986-12-21 03:22:36'),(33,1,'2009-11-15 03:56:33','1997-09-03 14:18:58'),(33,10,'2004-10-26 03:27:16','1975-10-25 22:18:12'),(33,39,'1984-07-01 17:26:29','2005-03-30 03:52:06'),(34,41,'1993-10-10 15:41:25','1992-06-27 06:32:14'),(34,44,'2019-05-26 11:18:27','1983-01-27 23:24:28'),(34,56,'1996-02-18 14:37:35','2019-07-02 13:46:09'),(34,66,'1973-11-08 16:18:20','2018-10-26 06:37:11'),(34,71,'1983-09-20 03:50:41','1998-10-09 16:31:08'),(36,25,'1984-03-24 01:31:20','2006-10-16 03:16:22'),(37,83,'1998-07-31 13:05:03','1975-04-14 20:10:46'),(38,46,'1980-01-16 13:06:36','1989-03-14 20:26:25'),(39,55,'1988-01-18 07:24:54','2005-01-10 11:59:05'),(39,56,'1995-04-02 20:59:54','2002-02-18 22:06:36'),(40,54,'1978-01-12 19:28:51','1992-12-03 16:48:03'),(40,85,'1982-03-10 04:42:55','1988-01-25 18:39:21'),(41,17,'2006-12-23 20:59:01','1990-06-08 14:31:43'),(41,78,'1991-02-05 16:01:11','1992-08-19 14:34:21'),(42,12,'2012-10-21 05:19:52','1987-10-18 05:49:54'),(42,20,'2011-03-03 22:37:57','2004-02-26 12:46:50'),(42,59,'1990-06-13 10:59:10','2016-09-15 03:23:13'),(42,75,'1986-05-26 21:54:00','1987-05-03 12:12:09'),(43,2,'1971-07-17 09:33:34','1990-10-28 22:00:27'),(43,10,'2001-07-08 12:15:15','1983-11-20 13:19:02'),(43,22,'1981-08-04 09:42:01','1981-02-25 12:53:08'),(43,39,'1977-02-14 11:59:01','2009-04-29 02:35:58'),(43,76,'1986-06-14 04:57:00','1975-01-22 20:52:34'),(45,17,'2014-08-19 18:41:07','2006-01-13 11:00:52'),(45,24,'2011-09-12 06:00:02','2015-02-12 04:01:52'),(45,63,'1977-12-05 18:16:43','1986-08-23 22:11:23'),(46,78,'1974-07-09 05:28:56','1981-07-07 10:41:44'),(47,58,'1999-01-07 04:19:20','2009-07-04 05:40:42'),(47,69,'1990-08-14 23:57:40','2008-06-10 22:33:50'),(48,94,'1997-03-11 00:37:21','2015-03-19 08:55:14'),(49,2,'1982-01-19 23:06:51','2006-01-30 19:50:08'),(49,71,'2008-07-15 19:32:45','2001-09-13 21:02:48'),(51,19,'1975-05-23 08:02:29','2016-10-22 14:43:01'),(51,47,'1995-10-24 02:50:08','1996-11-26 06:12:03'),(51,64,'1970-03-23 07:30:18','2013-09-26 00:35:50'),(51,69,'2013-02-03 13:15:50','1975-06-07 08:09:59'),(51,95,'1991-03-07 23:46:46','1994-09-15 18:11:24'),(51,97,'1994-06-22 09:30:41','2013-08-25 12:49:41'),(52,38,'1992-02-11 13:19:33','2001-09-13 05:31:04'),(53,38,'1978-09-11 03:12:54','2019-03-09 22:28:49'),(54,5,'1970-01-19 10:11:43','2014-01-06 01:02:15'),(54,24,'1995-10-16 01:34:36','1983-12-17 15:40:09'),(54,58,'2010-06-25 06:27:07','1986-04-25 17:40:44'),(54,82,'1995-04-26 00:52:03','1985-05-26 21:14:15'),(55,16,'1979-11-05 11:09:02','2003-07-23 16:11:42'),(55,29,'1988-01-22 01:39:28','1988-09-02 06:09:17'),(55,44,'1980-11-28 12:58:55','2002-11-04 22:40:56'),(55,46,'1999-10-03 15:06:49','2014-12-09 20:53:14'),(55,90,'1997-03-12 12:25:57','1999-08-20 16:34:44'),(56,5,'2009-04-07 09:39:48','1978-06-08 06:17:14'),(56,16,'2002-05-23 01:46:16','2011-07-15 15:53:58'),(56,77,'2001-06-04 08:57:26','2013-07-26 11:31:53'),(57,23,'1975-02-27 12:04:51','2018-11-09 02:41:47'),(58,4,'1985-11-08 01:06:15','1979-09-12 11:00:09'),(58,17,'1984-04-03 08:41:12','1980-06-22 21:45:48'),(58,55,'1970-03-26 20:54:34','1983-01-16 22:29:18'),(58,67,'2018-06-23 19:24:19','2012-07-21 07:53:33'),(59,19,'2004-06-12 11:00:26','1997-04-20 08:36:51'),(59,35,'1987-10-23 13:56:27','1999-08-30 13:20:59'),(59,95,'2021-04-08 10:23:54','2013-11-17 11:58:15'),(60,5,'2011-05-05 18:03:38','1993-05-20 11:34:37'),(60,10,'2016-05-24 11:40:54','1977-12-31 00:45:36'),(60,75,'2016-02-08 08:02:05','1982-12-10 14:07:32'),(60,84,'1984-06-07 20:20:23','2017-06-07 04:10:04'),(62,40,'1972-10-27 03:08:06','2012-02-07 21:25:41'),(63,35,'1984-11-04 17:58:57','2012-10-20 22:18:36'),(63,56,'2017-03-05 06:08:29','2017-04-23 20:40:55'),(64,76,'1992-06-15 21:01:35','1981-05-08 21:52:22'),(64,79,'1970-08-10 22:22:31','2017-03-06 10:21:59'),(65,28,'2005-06-15 21:10:49','1990-08-13 10:48:38'),(66,87,'1976-01-03 10:10:51','1988-04-24 10:55:22'),(67,1,'2004-04-19 14:17:16','1980-01-20 08:19:27'),(67,66,'1999-12-05 23:01:01','1994-05-07 23:06:38'),(68,12,'2000-10-22 06:08:35','1986-07-27 16:05:21'),(68,34,'2001-11-09 13:05:01','1975-10-24 00:52:47'),(68,84,'1976-09-03 11:04:33','2004-04-24 04:15:46'),(69,94,'2009-08-16 21:36:13','1987-02-18 23:47:36'),(70,39,'1999-04-14 19:38:49','2019-09-22 10:46:26'),(71,45,'2019-05-29 22:42:10','1990-04-14 17:06:47'),(72,7,'1996-06-10 11:38:59','1989-03-07 19:20:54'),(72,26,'2000-04-15 03:30:08','1980-11-05 06:01:39'),(72,79,'1987-02-23 04:12:11','2011-08-26 22:46:13'),(72,80,'1989-02-13 16:02:55','1970-07-10 13:35:17'),(73,3,'1970-06-08 03:39:38','2004-07-16 04:23:16'),(73,38,'2009-08-06 17:30:49','1980-04-06 22:13:34'),(74,44,'2001-09-16 06:16:13','2005-08-08 15:04:08'),(74,53,'2001-07-09 04:26:49','1994-05-10 17:53:13'),(74,65,'1987-05-04 00:04:16','2011-12-18 23:28:20'),(74,69,'1972-11-25 09:40:02','1995-05-08 02:48:17'),(74,72,'1996-04-18 11:24:30','1998-10-04 13:09:27'),(75,46,'2012-03-04 11:03:17','2006-05-04 00:02:50'),(75,59,'1976-09-18 07:51:51','2009-06-05 18:13:31'),(75,88,'1976-09-25 23:22:45','1990-12-14 09:30:54'),(76,21,'1994-03-22 11:43:27','2009-10-08 17:05:50'),(76,55,'2009-07-06 06:30:51','1972-05-15 16:14:05'),(76,75,'1997-04-07 01:36:34','1974-11-10 01:24:27'),(77,25,'1983-04-17 10:38:38','2000-06-08 02:36:19'),(77,47,'1993-05-14 04:02:07','2013-02-23 00:37:30'),(78,41,'2014-06-21 08:40:46','1994-03-17 23:41:28'),(78,52,'1994-07-03 09:59:00','1989-02-14 15:01:51'),(78,76,'2010-11-10 06:00:14','1990-10-05 06:39:38'),(79,4,'1979-11-16 04:21:00','1976-11-14 23:51:00'),(79,71,'1984-09-02 13:55:41','2000-05-17 10:23:58'),(81,86,'2008-12-29 13:43:48','1989-04-28 18:57:24'),(82,7,'2013-05-04 11:18:02','2014-08-06 23:11:52'),(82,52,'1983-07-30 10:09:24','2004-06-01 09:39:06'),(82,71,'1995-07-25 16:48:52','2020-06-27 01:42:30'),(82,76,'2005-08-11 15:28:33','1970-09-23 09:12:01'),(82,98,'2019-09-25 15:46:58','1992-09-17 18:22:17'),(83,15,'1980-11-20 13:06:31','1994-10-04 13:35:05'),(83,39,'2011-02-12 00:41:55','1997-08-01 07:19:16'),(86,35,'1988-12-30 11:12:48','1974-09-05 07:53:29'),(86,46,'1980-02-26 23:19:49','1999-08-30 14:27:14'),(86,75,'2013-01-13 15:19:57','1973-07-12 14:38:35'),(87,44,'2009-05-10 07:35:45','1982-08-06 07:27:30'),(87,65,'1999-06-12 22:59:15','1997-01-06 08:38:20'),(87,67,'2012-01-08 14:32:12','1975-03-13 10:15:15'),(88,3,'2001-02-24 15:37:28','2003-09-30 03:14:12'),(89,6,'2011-08-18 19:46:20','1987-07-15 00:52:34'),(90,9,'2005-11-22 11:11:40','2008-04-04 21:02:26'),(91,26,'2012-11-24 06:27:05','2017-11-24 15:59:23'),(91,70,'1982-10-09 10:18:58','1983-03-05 21:27:26'),(91,97,'1991-07-28 01:38:35','1979-09-26 06:14:03'),(92,12,'1989-12-01 15:38:06','2005-04-13 04:37:35'),(92,53,'2007-01-04 17:37:07','1986-08-28 06:41:56'),(93,66,'2011-06-25 00:53:13','1994-05-16 18:55:41'),(94,65,'1982-02-25 08:25:35','1988-10-05 12:09:29'),(95,23,'1980-08-17 10:30:58','2006-09-01 01:03:30'),(95,36,'2001-11-13 07:39:21','1985-07-18 11:13:05'),(95,42,'2020-01-01 16:44:29','2018-12-04 22:18:47'),(95,49,'1971-02-21 23:43:42','2006-02-02 19:06:55'),(95,62,'2004-12-31 23:18:02','1982-09-19 17:40:11'),(96,72,'1999-06-27 00:28:52','1989-08-23 20:58:40'),(97,60,'1976-04-10 14:46:23','1970-06-21 05:50:04'),(97,97,'2001-08-16 21:34:44','2019-04-15 19:38:42'),(99,24,'2015-12-07 22:54:14','2011-07-14 17:01:15');
/*!40000 ALTER TABLE `media_likes` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2021-05-23 19:50:12




-- #####################################################################################





