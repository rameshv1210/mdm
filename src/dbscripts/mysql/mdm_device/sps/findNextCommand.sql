DROP PROCEDURE IF EXISTS `mdm_device`.`findNextCommand`;
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `mdm_device`.`findNextCommand`(IN  `userId` BIGINT(20), IN  `deviceUuid` VARCHAR(255))
BEGIN
	SELECT company_guid INTO @companyId FROM user.user WHERE id = userId;
	
	SET @query = CONCAT('SELECT * FROM `command', @companyId , '` WHERE device_uuid = "', deviceUuid ,'" AND is_acknowledged = FALSE ORDER BY created_timestamp ASC LIMIT 1');
	PREPARE stmt FROM @query;
	EXECUTE stmt;
END$$
DELIMITER ;
