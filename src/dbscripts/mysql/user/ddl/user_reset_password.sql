DROP TABLE IF EXISTS `user`.`user_reset_password`;
CREATE TABLE `user`.`user_reset_password` (
  `user_id` bigint(20) NOT NULL,
  `token` varchar(255) NOT NULL,
  `expire_timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
