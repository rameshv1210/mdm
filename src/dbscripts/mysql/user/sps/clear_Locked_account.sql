DROP PROCEDURE IF EXISTS `user`.`clear_Locked_account`;
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `user`.`clear_Locked_account`( IN  `in_email` VARCHAR( 100 ) )
    NO SQL
BEGIN UPDATE user SET LockoutDate =  null,
FailedPasswordAttemptCount =0 WHERE email = in_email;
END$$
DELIMITER ;
