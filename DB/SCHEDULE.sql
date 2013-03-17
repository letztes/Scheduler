CREATE TABLE `SCHEDULE` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(10) unsigned NOT NULL,
  `task_id` int(10) unsigned NOT NULL,
  `interval_type` enum('day','week','month','year') NOT NULL,
  `interval_value` tinyint(4) NOT NULL,
  `date_insert` datetime NOT NULL,
  `date_update` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  KEY `task_id` (`task_id`),
  CONSTRAINT `SCHEDULE_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `USERS` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `SCHEDULE_ibfk_2` FOREIGN KEY (`task_id`) REFERENCES `TASKS` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8
