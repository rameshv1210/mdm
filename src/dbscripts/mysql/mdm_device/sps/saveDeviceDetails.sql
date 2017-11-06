DROP PROCEDURE IF EXISTS `mdm_device`.`saveDeviceDetails`;
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `mdm_device`.`saveDeviceDetails`(IN  `deviceUUID` VARCHAR( 255 ), IN  `deviceType` VARCHAR( 10 ), IN  `userId` BIGINT( 20 ),
					IN  `devicePushMagic` VARCHAR( 255 ), IN  `deviceToken` VARCHAR( 255 ), IN  `unlockToken` text, IN  `deviceOwnerType` VARCHAR( 10 ))
BEGIN
	SELECT company_guid INTO @companyId FROM user.user WHERE id = userId;
	
	SET @query = CONCAT('SELECT COUNT(*) INTO @deviceCount FROM `device', @companyId , '` WHERE device_uuid = "', deviceUUID ,'" AND device_type = "', deviceType ,'";');
	PREPARE stmt FROM @query;
	EXECUTE stmt;
	
	if (@deviceCount > 0) THEN
		IF devicePushMagic <> '' THEN
			SET @query = CONCAT('UPDATE `device', @companyId , '` 
				SET user_id = "', userId ,'", 
				device_push_magic = "', devicePushMagic ,'", 
				device_token = "', deviceToken ,'", 
				unlock_token = "', unlockToken ,'", 
				is_deleted = FALSE,
				is_delete_requested = FALSE,
				updated_timestamp = NOW() WHERE device_uuid = "', deviceUUID ,'" AND device_type = "', deviceType ,'";');
			PREPARE stmt FROM @query;
			EXECUTE stmt;
		else
			SET @query = CONCAT('UPDATE `device', @companyId , '` 
				SET user_id = "', userId ,'", 
				device_token = "', deviceToken ,'", 
				device_owner_type = "', deviceOwnerType ,'",
				is_deleted = FALSE,
				is_delete_requested = FALSE,
				updated_timestamp = NOW() WHERE device_uuid = "', deviceUUID ,'" AND device_type = "', deviceType ,'";');
			PREPARE stmt FROM @query;
			EXECUTE stmt;
		end if;
	Else
		IF devicePushMagic <> '' THEN
			SET @query = CONCAT('INSERT INTO `device', @companyId , '` (device_uuid, device_type, user_id, device_push_magic, device_token, unlock_token, created_timestamp) 
				VALUES ("', deviceUUID, '","', deviceType , '","', userId , '","', devicePushMagic , '","', deviceToken , '","', unlockToken, '", NOW())');
			PREPARE stmt FROM @query;
			EXECUTE stmt;
		else
			SET @query = CONCAT('INSERT INTO `device', @companyId , '` (device_uuid, device_type, user_id, device_token, device_owner_type, created_timestamp) 
				VALUES ("', deviceUUID, '","', deviceType , '","', userId , '","', deviceToken , '","', deviceOwnerType, '", NOW())');
			PREPARE stmt FROM @query;
			EXECUTE stmt;
		end if;
	end if;
END$$
DELIMITER ;
