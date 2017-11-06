DROP PROCEDURE IF EXISTS `mdm_device`.`findByCommandUuid`;
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `mdm_device`.`findByCommandUuid`(IN  `userId` BIGINT(20), IN  `commandUuid` VARCHAR(50))
BEGIN
	SELECT company_guid INTO @companyId FROM user.user WHERE id = userId;
	
	SET @query = CONCAT('SELECT * FROM `command', @companyId , '` WHERE is_acknowledged = FALSE AND command_uuid = "', commandUuid ,'"');
	PREPARE stmt FROM @query;
	EXECUTE stmt;
END$$
DELIMITER ;
