CREATE TABLE `LOG` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(10) unsigned NOT NULL,
  `task_id` int(10) unsigned NOT NULL,
  `dt_done` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `user_id_and_2` (`user_id`, `task_id`, `dt_done`),
  CONSTRAINT `LOG_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `USERS` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `LOG_ibfk_2` FOREIGN KEY (`task_id`) REFERENCES `TASKS` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8
