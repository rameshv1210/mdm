DROP PROCEDURE IF EXISTS `mdm_device`.`saveAndroidDeviceLocation`;
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `mdm_device`.`saveAndroidDeviceLocation`(IN `userId` BIGINT(20), IN `deviceUuid` VARCHAR(255), IN `longitude` VARCHAR(30), IN `latitude` VARCHAR(30))
BEGIN
	SELECT company_guid INTO @companyId FROM user.user WHERE id = userId;
	
	SET @query = CONCAT('SELECT COUNT(*) INTO @count FROM `android_device_info', @companyId , '` WHERE device_uuid = "', deviceUuid ,'";');
	PREPARE stmt FROM @query;
	EXECUTE stmt;
	
	IF (@count > 0) THEN
		SET @query = CONCAT('UPDATE `android_device_info', @companyId , '` SET latitude = "', latitude , '", longitude = "', longitude , '", 
			updated_timestamp = NOW() WHERE device_uuid = "', deviceUuid ,'";');
		PREPARE stmt FROM @query;
		EXECUTE stmt;
	ELSE
		SET @query = CONCAT('INSERT INTO `android_device_info', @companyId , '` (device_uuid, latitude, longitude, created_timestamp) 
				VALUES ("', deviceUuid, '","', latitude , '","', longitude , '", NOW())');
		PREPARE stmt FROM @query;
		EXECUTE stmt;
	END IF;
	
END$$
DELIMITER ;
