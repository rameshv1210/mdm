DROP PROCEDURE IF EXISTS `mdm_device`.`updateCommandStatus`;
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `mdm_device`.`updateCommandStatus`(IN  `userId` BIGINT(20), IN  `deviceUuid` varchar(255), IN  `commandUuid` VARCHAR(50))
BEGIN
	SELECT company_guid INTO @companyId FROM user.user WHERE id = userId;
	
	SET @query = CONCAT('UPDATE `command', @companyId , '` SET is_acknowledged = TRUE WHERE device_uuid = "', deviceUuid ,'" AND command_uuid = "', commandUuid , '";');
	PREPARE stmt FROM @query;
	EXECUTE stmt;
	
	SET @query = CONCAT('SELECT * FROM `command', @companyId , '` WHERE device_uuid = "', deviceUuid ,'" AND is_acknowledged = FALSE ORDER BY created_timestamp ASC LIMIT 1');
	PREPARE stmt FROM @query;
	EXECUTE stmt;
END$$
DELIMITER ;
