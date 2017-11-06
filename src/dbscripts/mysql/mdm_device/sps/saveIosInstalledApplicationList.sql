DROP PROCEDURE IF EXISTS `mdm_device`.`saveIosInstalledApplicationList`;
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `mdm_device`.`saveIosInstalledApplicationList`(IN `userId` BIGINT(20), IN `deviceUuid` VARCHAR(255), IN `profileCount` INT(3), IN `bundleSize` TEXT,
						IN `dynamicSize` TEXT, IN `identifier` TEXT, IN `isValidated` TEXT, IN `name` TEXT, IN `version` TEXT)
BEGIN
	SELECT company_guid INTO @companyId FROM user.user WHERE id = userId;
	
	SET @i = 1;
	WHILE (@i <= profileCount) DO
	
		SET @bs =(SELECT split_str(bundleSize,',',@i));
		SET @ds =(SELECT split_str(dynamicSize,',',@i));
		SET @iden =(SELECT split_str(identifier,',',@i));
		SET @isv =(SELECT split_str(isValidated,',',@i));
		SET @nm =(SELECT split_str(`name`,',',@i));
		SET @v =(SELECT split_str(`version`,',',@i));
		
		SET @query = CONCAT('SELECT COUNT(*) INTO @count FROM `ios_application_list', @companyId , '` WHERE device_uuid = "', deviceUuid, '" AND identifier = "', @iden , '"');
		PREPARE stmt FROM @query;
		EXECUTE stmt;
		
		IF (@count > 0) THEN
			SET @query = CONCAT('UPDATE `ios_application_list', @companyId , '` 
				SET bundle_size = ', @bs , ', 
				dynamic_size = "', @ds , '", 
				is_validated = ', @isv , ', 
				version = "', @v , '", 
				name = "', @nm , '",
				updated_timestamp = NOW() 
				WHERE device_uuid = "', deviceUuid, '" AND identifier = "', @iden , '"');
			PREPARE stmt FROM @query;
			EXECUTE stmt;
		ELSE
			SET @query = CONCAT('INSERT INTO `ios_application_list', @companyId , '` (device_uuid, bundle_size, dynamic_size, identifier, is_validated, name, version, created_timestamp) 
				VALUES ("', deviceUuid, '",', @bs , ',', @ds , ',"', @iden , '",', @isv , ',"', @nm , '","', @v , '", NOW())');
			PREPARE stmt FROM @query;
			EXECUTE stmt;
		END IF;
		
		SET @i = @i + 1;
	END WHILE;
END$$
DELIMITER ;
