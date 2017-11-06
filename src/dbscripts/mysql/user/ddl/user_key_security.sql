DROP TABLE IF EXISTS `user`.`user_key_security`;
CREATE TABLE `user`.`user_key_security` (
  `id` bigint(20) NOT NULL,
  `publicKey` text,
  `privateKey` text,
  `keyPassword` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
