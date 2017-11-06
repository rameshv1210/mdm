DROP TABLE IF EXISTS `user`.`company_key_security`;
CREATE TABLE `user`.`company_key_security` (
  `id` bigint(20) NOT NULL,
  `publicKey` text,
  `privateKey` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
