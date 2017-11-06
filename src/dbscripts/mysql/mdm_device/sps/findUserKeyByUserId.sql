DROP PROCEDURE IF EXISTS `mdm_device`.`findUserKeyByUserId`;
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `mdm_device`.`findUserKeyByUserId`(IN  `userId` varchar(50))
BEGIN
	SELECT privateKey, keyPassword FROM user.user WHERE id = userId;
END$$
DELIMITER ;
