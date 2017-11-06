DROP PROCEDURE IF EXISTS `user`.`update_reset_token`;
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `user`.`update_reset_token`(IN `emailID` VARCHAR(255))
BEGIN
	update user_reset_password set token = "" where user_id = (SELECT id FROM `user` WHERE email = emailID);
	select "success" as result;
END$$
DELIMITER ;
