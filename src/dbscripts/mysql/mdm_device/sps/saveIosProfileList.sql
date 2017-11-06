DROP PROCEDURE IF EXISTS `mdm_device`.`saveIosProfileList`;
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `mdm_device`.`saveIosProfileList`(IN `userId` bigint(20), IN `deviceUuid` VARCHAR(255), IN `profileCount` int(3), IN `payloadIdentifier` TEXT,
						IN `payloadOrganization` TEXT, IN `payloadVersion` TEXT, IN `payloadDescription` TEXT)
BEGIN
	SELECT company_guid INTO @companyId FROM user.user WHERE id = userId;
	
	SET @i = 1;
	WHILE (@i <= profileCount) DO
	
		SET @pi =(SELECT split_str(payloadIdentifier,',',@i));
		SET @po =(SELECT split_str(payloadOrganization,',',@i));
		SET @pv =(SELECT split_str(payloadVersion,',',@i));
		SET @pd =(SELECT split_str(payloadDescription,',',@i));
		
		SET @query = CONCAT('SELECT COUNT(*) INTO @count FROM `ios_profile_list', @companyId , '` 
			WHERE device_uuid = "', deviceUuid, '" AND payload_identifier = "', @pi ,'"');
		PREPARE stmt FROM @query;
		EXECUTE stmt;
		
		IF (@count > 0) THEN
			SET @query = CONCAT('UPDATE `ios_profile_list', @companyId , '` 
				SET payload_organization = "', @po ,'", 
				payload_version = "', @pv ,'", 
				payload_description = "', @pd ,'", 
				updated_timestamp = NOW() 
				WHERE device_uuid = "', deviceUuid, '" AND payload_identifier = "', @pi ,'"');
			PREPARE stmt FROM @query;
			EXECUTE stmt;
		ELSE
			SET @query = CONCAT('INSERT INTO `ios_profile_list', @companyId , '` (device_uuid, payload_identifier, payload_organization, payload_version, payload_description, created_timestamp) 
				VALUES ("', deviceUuid, '","', @pi , '","', @po , '","', @pv , '","', @pd , '", NOW())');
			PREPARE stmt FROM @query;
			EXECUTE stmt;
		end if;
		
		SET @i = @i + 1;
	END WHILE;
END$$
DELIMITER ;
