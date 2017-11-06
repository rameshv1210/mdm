DROP PROCEDURE IF EXISTS `user`.`Ab_Update_Users_Password`;
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `user`.`Ab_Update_Users_Password`( IN  `in_email` VARCHAR( 100 ) , IN  `in_password` text , IN  `in_PasswordSalt` VARCHAR( 100 ) )
    NO SQL
BEGIN UPDATE user SET PASSWORD = in_password,
PasswordSalt = in_PasswordSalt WHERE email = in_email;
END$$
DELIMITER ;
