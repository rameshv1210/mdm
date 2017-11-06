DROP PROCEDURE IF EXISTS `mdm_device`.`saveDeviceCommand`;
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `mdm_device`.`saveDeviceCommand`(IN `companyId` VARCHAR(255), IN `groupId` VARCHAR(255), IN `userId` BIGINT(20), 
									in `deviceUuid` varchar(255), in `deviceType` varchar(10), 
									IN `commandType` VARCHAR(50), IN `commandUuid` VARCHAR(50), IN `command` TEXT)
BEGIN
	IF userId <> '' THEN
		SELECT company_guid INTO @companyId FROM user.user WHERE id = userId;
		SET companyId = @companyId;
		
		IF deviceUuid <> '' THEN
			SET @query = CONCAT('SELECT GROUP_CONCAT(device_uuid), GROUP_CONCAT(device_type), COUNT(*) INTO @deviceIds, @deviceTypes, @deviceCount 
						FROM `device', @companyId , '` WHERE is_deleted = FALSE AND user_id = ', userId ,
						' AND device_type = "', deviceType ,'" AND device_uuid = "', deviceUuid ,'"');
			PREPARE stmt FROM @query;
			EXECUTE stmt;
		ELSE
			SET @query = CONCAT('SELECT GROUP_CONCAT(device_uuid), GROUP_CONCAT(device_type), COUNT(*) INTO @deviceIds, @deviceTypes, @deviceCount 
						FROM `device', @companyId , '` WHERE is_deleted = FALSE AND user_id = ', userId ,
						' AND device_type = "', deviceType ,'"');
			PREPARE stmt FROM @query;
			EXECUTE stmt;
		END IF;
	ELSE
		IF groupId <> '' THEN
			SET @query = CONCAT('SELECT GROUP_CONCAT(device_uuid), GROUP_CONCAT(device_type), COUNT(*) INTO @deviceIds, @deviceTypes, @deviceCount 
							FROM `device', companyId , '` WHERE is_deleted = FALSE AND device_type = "', deviceType ,'" AND user_id IN 
							( SELECT id FROM user.user WHERE groupId = "', groupId ,'" )' );
			PREPARE stmt FROM @query;
			EXECUTE stmt;
		ELSEIF deviceUuid <> '' THEN
			SET @query = CONCAT('SELECT GROUP_CONCAT(device_uuid), GROUP_CONCAT(device_type), COUNT(*) INTO @deviceIds, @deviceTypes, @deviceCount 
							FROM `device', companyId , '` WHERE is_deleted = FALSE AND 
							device_type = "', deviceType ,'" AND device_uuid = "', deviceUuid ,'"' );
			PREPARE stmt FROM @query;
			EXECUTE stmt;
		ELSE
			SET @query = CONCAT('SELECT GROUP_CONCAT(device_uuid), GROUP_CONCAT(device_type), COUNT(*) INTO @deviceIds, @deviceTypes, @deviceCount 
							FROM `device', companyId , '` WHERE is_deleted = FALSE AND device_type = "', deviceType ,'"' );
			PREPARE stmt FROM @query;
			EXECUTE stmt;
		END IF;
	END IF;
	
	SET @i = 1;
	WHILE (@i <= @deviceCount) DO
	
		SET @id =(SELECT split_str(@deviceIds,',',@i));
		SET @type =(SELECT split_str(@deviceTypes,',',@i));
		
		SET @query = CONCAT('INSERT INTO `command', companyId , '` (device_uuid, device_type, command_type, command_uuid, command, created_timestamp) 
			VALUES ("', @id, '","', @type , '","', commandType , '","', commandUuid , '","', REPLACE(REPLACE(command, '"', '\\"'), "'", "\\'") , '", NOW())');
		PREPARE stmt FROM @query;
		EXECUTE stmt;
		
		IF (deviceUuid <> '') and (commandType = "ENTERPRISE_WIPE" or commandType = "DISENROLL" or commandType = "EraseDevice" OR commandType = "RemoveProfile") THEN
			SET @query = CONCAT('UPDATE `device', companyId , '` SET is_delete_requested = TRUE WHERE device_uuid = "', @id ,'" AND device_type = "', @type ,'";');
			PREPARE stmt FROM @query;
			EXECUTE stmt;
		end if;
		
		SET @i = @i + 1;
	END WHILE;
END$$
DELIMITER ;
