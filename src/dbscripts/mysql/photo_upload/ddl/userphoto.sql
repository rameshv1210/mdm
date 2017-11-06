DROP TABLE IF EXISTS `photo_upload`.`userphoto`;
CREATE TABLE `photo_upload`.`userphoto` (
  `id` bigint(20) NOT NULL,
  `photoURL` varchar(200) DEFAULT NULL,
  `updateDate` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
