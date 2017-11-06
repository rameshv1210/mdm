DROP PROCEDURE IF EXISTS `mdm_device`.`saveAndroidApplicationList`;
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `mdm_device`.`saveAndroidApplicationList`(IN `userId` BIGINT(20), IN `deviceUuid` VARCHAR(255), IN `appCount` INT(3), IN `isActive` TEXT,
						IN `packageApi` TEXT, IN `uss` TEXT, IN `isSystemApp` TEXT, IN `version` TEXT, IN `name` TEXT)
BEGIN
	SELECT company_guid INTO @companyId FROM user.user WHERE id = userId;
	
	SET @i = 1;
	WHILE (@i <= appCount) DO
	
		SET @ia =(SELECT split_str(isActive,',',@i));
		SET @pa =(SELECT split_str(packageApi,',',@i));
		SET @uss =(SELECT split_str(uss,',',@i));
		SET @isa =(SELECT split_str(isSystemApp,',',@i));
		SET @v =(SELECT split_str(`version`,',',@i));
		SET @nm =(SELECT split_str(`name`,',',@i));
		
		SET @query = CONCAT('SELECT COUNT(*) INTO @count FROM `android_application_list', @companyId , '` WHERE device_uuid = "', deviceUuid, '" AND package_api = "', @pa , '"');
		PREPARE stmt FROM @query;
		EXECUTE stmt;
		
		if (@count > 0) then
			SET @query = CONCAT('UPDATE `android_application_list', @companyId , '` 
				SET is_active = ', @ia , ', 
				uss = "', @uss , '", 
				is_system_app = ', @isa , ', 
				version = "', @v , '", 
				name = "', @nm , '",
				updated_timestamp = NOW() 
				WHERE device_uuid = "', deviceUuid, '" AND package_api = "', @pa , '"');
			PREPARE stmt FROM @query;
			EXECUTE stmt;
		else
			SET @query = CONCAT('INSERT INTO `android_application_list', @companyId , '` (device_uuid, is_active, package_api, uss, is_system_app, version, name, created_timestamp) 
				VALUES ("', deviceUuid, '",', @ia , ',"', @pa , '","', @uss , '",', @isa , ',"', @v , '","', @nm , '", NOW())');
			PREPARE stmt FROM @query;
			EXECUTE stmt;
		end if;
		
		SET @i = @i + 1;
	END WHILE;
END$$
DELIMITER ;
