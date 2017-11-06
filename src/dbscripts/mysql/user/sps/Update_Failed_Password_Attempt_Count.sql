DROP PROCEDURE IF EXISTS `user`.`Update_Failed_Password_Attempt_Count`;
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `user`.`Update_Failed_Password_Attempt_Count`( IN  `in_email` VARCHAR( 100 ) , IN  `attempt_count` INT( 2 ) )
    NO SQL
BEGIN UPDATE user SET FailedPasswordAttemptCount = attempt_count WHERE email = in_email;
END$$
DELIMITER ;
