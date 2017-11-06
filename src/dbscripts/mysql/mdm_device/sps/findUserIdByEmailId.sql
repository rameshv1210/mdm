DROP PROCEDURE IF EXISTS `mdm_device`.`findUserIdByEmailId`;
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `mdm_device`.`findUserIdByEmailId`(IN  `emailId` varchar(50))
BEGIN
	SELECT id FROM user.user WHERE email = emailId;
END$$
DELIMITER ;
