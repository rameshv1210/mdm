DROP PROCEDURE IF EXISTS `cas`.`Ab_Health_Check`;
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Ab_Health_Check`( IN  `in_ip` VARCHAR( 100 ) )
    NO SQL
BEGIN SELECT * 
FROM healthcheck
WHERE 1 =1;
END$$
DELIMITER ;
