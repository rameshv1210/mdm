DROP TABLE IF EXISTS `cas`.`healthcheck`;
CREATE TABLE `healthcheck` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `health` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
