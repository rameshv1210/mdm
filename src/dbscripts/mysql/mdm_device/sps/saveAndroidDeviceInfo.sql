DROP PROCEDURE IF EXISTS `mdm_device`.`saveAndroidDeviceInfo`;
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `mdm_device`.`saveAndroidDeviceInfo`(IN `userId` BIGINT(20), IN `deviceUuid` VARCHAR(255), IN `deviceInfo` TEXT)
BEGIN
	SELECT company_guid INTO @companyId FROM user.user WHERE id = userId;
	
	SET @id1 =(SELECT split_str(deviceInfo,',',1));
	SET @id2 =(SELECT split_str(deviceInfo,',',2));
	SET @id3 =(SELECT split_str(deviceInfo,',',3));
	SET @id4 =(SELECT split_str(deviceInfo,',',4));
	SET @id5 =(SELECT split_str(deviceInfo,',',5));
	SET @id6 =(SELECT split_str(deviceInfo,',',6));
	SET @id7 =(SELECT split_str(deviceInfo,',',7));
	SET @id8 =(SELECT split_str(deviceInfo,',',8));
	SET @id9 =(SELECT split_str(deviceInfo,',',9));
	SET @id10 =(SELECT split_str(deviceInfo,',',10));
	SET @id11 =(SELECT split_str(deviceInfo,',',11));
	SET @id12 =(SELECT split_str(deviceInfo,',',12));
	SET @id13 =(SELECT split_str(deviceInfo,',',13));
	SET @id14 =(SELECT split_str(deviceInfo,',',14));
	SET @id15 =(SELECT split_str(deviceInfo,',',15));
	SET @id16 =(SELECT split_str(deviceInfo,',',16));
	SET @id17 =(SELECT split_str(deviceInfo,',',17));
	SET @id18 =(SELECT split_str(deviceInfo,',',18));
	SET @id19 =(SELECT split_str(deviceInfo,',',19));
	SET @id20 =(SELECT split_str(deviceInfo,',',20));
	
	SET @query = CONCAT('SELECT COUNT(*) INTO @count FROM `android_device_info', @companyId , '` WHERE device_uuid = "', deviceUuid ,'";');
	PREPARE stmt FROM @query;
	EXECUTE stmt;
	
	IF (@count > 0) THEN
		SET @query = CONCAT('UPDATE `android_device_info', @companyId , '` 
			SET serial = "', @id1 , '", imei = "', @id2 , '", imsi = "', @id3 , '", mac = "', @id4 , '", device_model = "', @id5 , '", 
			vendor = "', @id6 , '", os_version = "', @id7 , '", os_build_date = "', @id8 , '", device_name = "', @id9 , '", 
			latitude = "', @id10 , '", longitude = "', @id11 , '", encryption_enabled = "', @id12 , '", internal_total_memory = "', @id13 , '", 
			internal_available_memory = "', @id14 , '", external_total_memory = "', @id15 , '", external_available_memory = "', @id16 , '", 
			operator = "', @id17 , '", battery_level = "', @id18 , '", health = "', @id19 , '", plugged = "', @id20 , '", updated_timestamp = NOW()
			WHERE device_uuid = "', deviceUuid ,'";');
		PREPARE stmt FROM @query;
		EXECUTE stmt;
	ELSE
		SET @query = CONCAT('INSERT INTO `android_device_info', @companyId , '` (device_uuid, serial, imei, imsi, mac, device_model, vendor, 
				os_version, os_build_date, device_name, latitude, longitude, encryption_enabled, internal_total_memory,
				internal_available_memory, external_total_memory, external_available_memory, operator, battery_level, health, plugged, created_timestamp) 
				VALUES ("', deviceUuid, '","', @id1 , '","', @id2 , '","', @id3 , '","', @id4 , '","', @id5 , '"
				,"', @id6 , '","', @id7 , '","', @id8 , '","', @id9 , '","', @id10 , '","', @id11 , '"
				,"', @id12 , '","', @id13 , '","', @id14 , '","', @id15 , '","', @id16 , '","', @id17 , '"
				,"', @id18 , '","', @id19 , '","', @id20 , '", NOW())');
		PREPARE stmt FROM @query;
		EXECUTE stmt;
	END IF;
	
END$$
DELIMITER ;
