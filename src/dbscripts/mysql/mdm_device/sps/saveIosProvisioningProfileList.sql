DROP PROCEDURE IF EXISTS `mdm_device`.`saveIosProvisioningProfileList`;
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `mdm_device`.`saveIosProvisioningProfileList`(IN `userId` BIGINT(20), IN `deviceUuid` VARCHAR(255), IN `profileCount` INT(3), IN `name` text,
						IN `uuid` text, IN `expiryDate` text)
BEGIN
	SELECT company_guid INTO @companyId FROM user.user WHERE id = userId;
	
	SET @i = 1;
	WHILE (@i <= profileCount) DO
	
		SET @nm =(SELECT split_str(`name`,',',@i));
		SET @id =(SELECT split_str(`uuid`,',',@i));
		SET @date =(SELECT split_str(expiryDate,',',@i));
		
		SET @query = CONCAT('SELECT COUNT(*) INTO @count FROM `ios_provisioning_profile_list', @companyId , '` 
			WHERE device_uuid = "', deviceUuid, '" AND uuid = "', @id ,'"');
		PREPARE stmt FROM @query;
		EXECUTE stmt;
		
		IF (@count > 0) THEN
			SET @query = CONCAT('UPDATE `ios_provisioning_profile_list', @companyId , '` 
				SET name = "', @nm , '", 
				expiry_date = "', @date , '", 
				updated_timestamp = NOW() 
				WHERE device_uuid = "', deviceUuid, '" AND uuid = "', @id ,'"');
			PREPARE stmt FROM @query;
			EXECUTE stmt;
		ELSE		
			SET @query = CONCAT('INSERT INTO `ios_provisioning_profile_list', @companyId , '` (device_uuid, name, uuid, expiry_date, created_timestamp) 
				VALUES ("', deviceUuid, '","', @nm , '","', @id , '","', @date , '", NOW())');
			PREPARE stmt FROM @query;
			EXECUTE stmt;
		end if;
		
		SET @i = @i + 1;
	END WHILE;
END$$
DELIMITER ;
