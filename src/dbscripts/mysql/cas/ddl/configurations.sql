DROP TABLE IF EXISTS `cas`.`configurations`;
CREATE TABLE `configurations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `lockouttime` int(11) DEFAULT '0',
  `wrong_password_attampt` int(11) DEFAULT '0',
  `validateIP` smallint(1) DEFAULT '1',
  `ip_ranges` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
