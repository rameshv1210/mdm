DROP PROCEDURE IF EXISTS `user`.`Ab_Auth_User_GET_byEMAIL`;
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `user`.`Ab_Auth_User_GET_byEMAIL`( IN  `in_email` VARCHAR( 50 ) )
    NO SQL
BEGIN SELECT * 
FROM user
WHERE email = in_email;
END$$
DELIMITER ;
