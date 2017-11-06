DROP PROCEDURE IF EXISTS `cas`.`Ab_Configurations`;
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Ab_Configurations`( )
    NO SQL
BEGIN SELECT * 
FROM configurations
WHERE id =1;
END$$
DELIMITER ;
