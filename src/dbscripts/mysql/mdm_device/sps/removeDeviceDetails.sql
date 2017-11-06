DROP PROCEDURE IF EXISTS `mdm_device`.`removeDeviceDetails`;
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `mdm_device`.`removeDeviceDetails`(IN  `deviceUUID` VARCHAR( 255 ), IN  `deviceType` VARCHAR( 10 ), IN  `userId` BIGINT( 20 ))
BEGIN
	SELECT company_guid INTO @companyId FROM user.user WHERE id = userId;
	
	SET @query = CONCAT('UPDATE `device', @companyId , '` SET is_deleted = TRUE WHERE device_uuid = "', deviceUUID ,'" AND device_type = "', deviceType ,'";');
	PREPARE stmt FROM @query;
	EXECUTE stmt;
END$$
DELIMITER ;
