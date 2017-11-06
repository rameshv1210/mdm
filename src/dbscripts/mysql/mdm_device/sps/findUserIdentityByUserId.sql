DROP PROCEDURE IF EXISTS `mdm_device`.`findUserIdentityByUserId`;
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `mdm_device`.`findUserIdentityByUserId`(IN  `userId` BIGINT(20))
BEGIN
	select * from user_identity where user_id = userId;
END$$
DELIMITER ;
