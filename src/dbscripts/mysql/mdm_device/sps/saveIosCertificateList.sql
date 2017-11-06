DROP PROCEDURE IF EXISTS `mdm_device`.`saveIosCertificateList`;
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `mdm_device`.`saveIosCertificateList`(IN `userId` BIGINT(20), IN `deviceUuid` VARCHAR(255), IN `profileCount` INT(3), IN `commonName` TEXT,
						IN `certData` TEXT, IN `isIdentity` TEXT)
BEGIN
	SELECT company_guid INTO @companyId FROM user.user WHERE id = userId;
	
	SET @i = 1;
	WHILE (@i <= profileCount) DO
	
		SET @nm =(SELECT split_str(commonName,',',@i));
		SET @dt =(SELECT split_str(certData,',',@i));
		SET @iden =(SELECT split_str(isIdentity,',',@i));
		
		SET @query = CONCAT('SELECT COUNT(*) INTO @count FROM `ios_certificate_list', @companyId , '` 
			WHERE device_uuid = "', deviceUuid, '" AND common_name = "', @nm ,'"');
		PREPARE stmt FROM @query;
		EXECUTE stmt;
		
		IF (@count > 0) then
			SET @query = CONCAT('UPDATE `ios_certificate_list', @companyId , '` 
				SET data = "', @dt , '", 
				is_identity = ', @iden , ', 
				updated_timestamp = NOW() 
				WHERE device_uuid = "', deviceUuid, '" AND common_name = "', @nm ,'"');
			PREPARE stmt FROM @query;
			EXECUTE stmt;
		else
			SET @query = CONCAT('INSERT INTO `ios_certificate_list', @companyId , '` (device_uuid, common_name, data, is_identity, created_timestamp) 
				VALUES ("', deviceUuid, '","', @nm , '","', @dt , '",', @iden , ', NOW())');
			PREPARE stmt FROM @query;
			EXECUTE stmt;
		end if;
		
		SET @i = @i + 1;
	END WHILE;
END$$
DELIMITER ;
