DROP PROCEDURE IF EXISTS `mdm_device`.`findCompanyIdByUserId`;
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `mdm_device`.`findCompanyIdByUserId`(IN  `userId` BIGINT(20))
BEGIN
	SELECT company_guid FROM user.user WHERE id = userId;
END$$
DELIMITER ;
