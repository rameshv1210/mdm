DROP PROCEDURE IF EXISTS `mdm_device`.`saveIosDeviceInformation`;
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `mdm_device`.`saveIosDeviceInformation`(IN `userId` BIGINT(20), IN `deviceUuid` VARCHAR(255), IN `deviceInfo` text)
BEGIN
	SELECT company_guid INTO @companyId FROM user.user WHERE id = userId;
	
	SET @id1 =(SELECT split_str(deviceInfo,'|',1));
	SET @id2 =(SELECT split_str(deviceInfo,'|',2));
	SET @id3 =(SELECT split_str(deviceInfo,'|',3));
	SET @id4 =(SELECT split_str(deviceInfo,'|',4));
	SET @id5 =(SELECT split_str(deviceInfo,'|',5));
	SET @id6 =(SELECT split_str(deviceInfo,'|',6));
	SET @id7 =(SELECT split_str(deviceInfo,'|',7));
	SET @id8 =(SELECT split_str(deviceInfo,'|',8));
	SET @id9 =(SELECT split_str(deviceInfo,'|',9));
	SET @id10 =(SELECT split_str(deviceInfo,'|',10));
	SET @id11 =(SELECT split_str(deviceInfo,'|',11));
	SET @id12 =(SELECT split_str(deviceInfo,'|',12));
	SET @id13 =(SELECT split_str(deviceInfo,'|',13));
	SET @id14 =(SELECT split_str(deviceInfo,'|',14));
	SET @id15 =(SELECT split_str(deviceInfo,'|',15));
	SET @id16 =(SELECT split_str(deviceInfo,'|',16));
	SET @id17 =(SELECT split_str(deviceInfo,'|',17));
	SET @id18 =(SELECT split_str(deviceInfo,'|',18));
	SET @id19 =(SELECT split_str(deviceInfo,'|',19));
	SET @id20 =(SELECT split_str(deviceInfo,'|',20));
	SET @id21 =(SELECT split_str(deviceInfo,'|',21));
	SET @id22 =(SELECT split_str(deviceInfo,'|',22));
	SET @id23 =(SELECT split_str(deviceInfo,'|',23));
	SET @id24 =(SELECT split_str(deviceInfo,'|',24));
	SET @id25 =(SELECT split_str(deviceInfo,'|',25));
	SET @id26 =(SELECT split_str(deviceInfo,'|',26));
	SET @id27 =(SELECT split_str(deviceInfo,'|',27));
	
	SET @query = CONCAT('SELECT COUNT(*) INTO @count FROM `ios_device_info', @companyId , '` WHERE device_uuid = "', deviceUuid ,'";');
	PREPARE stmt FROM @query;
	EXECUTE stmt;
	
	IF (@count > 0) THEN
		SET @query = CONCAT('UPDATE `ios_device_info', @companyId , '`
			SET last_cloud_backup_date = "', @id1 , '", device_name = "', @id2 , '", os_version = "', @id3 , '", build_version = "', @id4 , '", 
			model_name = "', @id5 , '", model = "', @id6 , '", product_name = "', @id7 , '", serial_number = "', @id8 , '", device_capacity = "', @id9 , '", 
			available_device = "', @id10 , '", battery_level = "', @id11 , '", cellular_technology = "', @id12 , '", imei = "', @id13 , '", meid = "', @id14 , '", 
			modem_firmware_version = "', @id15 , '", is_supervised = "', @id16 , '", eas_device_identifier = "', @id17 , '", is_cloud_backup_enabled = "', @id18 , '", 
			iccid = "', @id19 , '", bluetooth_mac = "', @id20 , '", wifi_mac = "', @id21 , '", phone_number = "', @id22 , '", is_roaming = "', @id23 , '", 
			subscriber_mcc = "', @id24 , '", subscriber_mnc = "', @id25 , '", current_mcc = "', @id26 , '", current_mnc = "', @id27 , '", 
			updated_timestamp = NOW() WHERE device_uuid = "', deviceUuid ,'";');
		PREPARE stmt FROM @query;
		EXECUTE stmt;
	ELSE
		SET @query = CONCAT('INSERT INTO `ios_device_info', @companyId , '` (device_uuid, last_cloud_backup_date, device_name, 
				os_version, build_version, model_name, model, product_name, serial_number, device_capacity, 
				available_device, battery_level, cellular_technology, imei, meid, modem_firmware_version, 
				is_supervised, eas_device_identifier, is_cloud_backup_enabled, iccid, bluetooth_mac, wifi_mac, 
				phone_number, is_roaming, subscriber_mcc, subscriber_mnc, current_mcc, current_mnc, created_timestamp) 
				VALUES ("', deviceUuid, '","', @id1 , '","', @id2 , '","', @id3 , '","', @id4 , '","', @id5 , '"
				,"', @id6 , '","', @id7 , '","', @id8 , '","', @id9 , '","', @id10 , '","', @id11 , '"
				,"', @id12 , '","', @id13 , '","', @id14 , '","', @id15 , '","', @id16 , '","', @id17 , '"
				,"', @id18 , '","', @id19 , '","', @id20 , '","', @id21 , '","', @id22 , '","', @id23 , '"
				,"', @id24 , '","', @id25 , '","', @id26 , '","', @id27 , '", NOW())');
		PREPARE stmt FROM @query;
		EXECUTE stmt;
	END IF;
END$$
DELIMITER ;
