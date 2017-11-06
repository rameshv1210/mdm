DROP PROCEDURE IF EXISTS `user`.`Lock_User_byId`;
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `user`.`Lock_User_byId`( IN  `in_email` VARCHAR( 100 ) , IN  `in_locked_time` INT( 4 ) )
    NO SQL
BEGIN UPDATE user SET LockoutDate = NOW( ) + INTERVAL in_locked_time MINUTE ,
LastLockOutDate = NOW( ) + INTERVAL in_locked_time MINUTE WHERE email = in_email;
END$$
DELIMITER ;
