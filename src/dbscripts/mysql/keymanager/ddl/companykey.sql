DROP TABLE IF EXISTS `keymanager`.`companykey`;
CREATE TABLE `keymanager`.`companykey` (
  `id` bigint(20) NOT NULL,
  `publicKey` text NOT NULL,
  `privateKey` text NOT NULL,
  `insertDate` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
