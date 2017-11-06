DROP PROCEDURE IF EXISTS `mdm_device`.`sp_create_mdm_device_views`;
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `mdm_device`.`sp_create_mdm_device_views`(
   	IN `inCompanyId` char(36)		#String version of Company Id (BIGINT).
    )
BEGIN
    IF inCompanyId <> '' THEN
		#Main device table/view.
		SET @deviceTable = CONCAT('`device', inCompanyId, '`');
		SET @deviceView = CONCAT('`vw_atm_device', inCompanyId, '`');
		SET @dropQuery = CONCAT('DROP VIEW IF EXISTS ', @deviceView, ';');
		PREPARE stmt FROM @dropQuery;
		EXECUTE stmt;

		SET @createQuery = CONCAT(
			'CREATE VIEW ', @deviceView, ' AS ',
			'SELECT 
				`id`,`device_uuid`,`device_type`,`user_id`,`device_push_magic`,
				`device_token`,`unlock_token`,`device_owner_type`,`is_deleted`,`is_delete_requested`,
                `created_timestamp`,`updated_timestamp` ',
			'FROM ', @deviceTable, ';'
            );
		PREPARE stmt FROM @createQuery;
		EXECUTE stmt;

		#Android device info table/view.
		SET @deviceTable = CONCAT('`android_device_info', inCompanyId, '`');
		SET @atmAndroidDeviceView = CONCAT('`vw_atm_android_device_info', inCompanyId, '`');
		SET @dropQuery = CONCAT('DROP VIEW IF EXISTS ', @atmAndroidDeviceView, ';');
		PREPARE stmt FROM @dropQuery;
		EXECUTE stmt;

        SET @createQuery = CONCAT(
			'CREATE VIEW ', @atmAndroidDeviceView, ' AS ',
			'SELECT `battery_level`,`device_model`,`device_name`,`device_uuid`,`encryption_enabled`,`external_available_memory`,
				`external_total_memory`,`health`,`id`,`imei`,`imsi`,`internal_available_memory`,`internal_total_memory`,
				`latitude`,`longitude`,`mac`,`operator`,`os_build_date`,`os_version`,`plugged`,`serial`,`vendor` ',
			'FROM ', @deviceTable, ';'
            );
		PREPARE stmt FROM @createQuery;
		EXECUTE stmt;

		#iOS device info table/view.
		SET @deviceTable = CONCAT('`ios_device_info', inCompanyId, '`');
		SET @atmiOSDeviceView = CONCAT('`vw_atm_ios_device_info', inCompanyId, '`');
		SET @dropQuery = CONCAT('DROP VIEW IF EXISTS ', @atmiOSDeviceView, ';');
		PREPARE stmt FROM @dropQuery;
		EXECUTE stmt;

        SET @createQuery = CONCAT(
			'CREATE VIEW ', @atmiOSDeviceView, ' AS ',
			'SELECT `available_device`,`battery_level`,`bluetooth_mac`,`build_version`,`cellular_technology`,`current_mcc`,
                `current_mnc`,`device_capacity`,`device_name`,`device_uuid`,`eas_device_identifier`,`iccid`,`id`,`imei`,
                `is_cloud_backup_enabled`,`is_roaming`,`is_supervised`,`last_cloud_backup_date`,`meid`,`model_name`,
                `model`,`modem_firmware_version`,`os_version`,`phone_number`,`product_name`,`serial_number`,
                `subscriber_mcc`,`subscriber_mnc`,`wifi_mac` ',
			'FROM ', @deviceTable, ';'
            );
		PREPARE stmt FROM @createQuery;
		EXECUTE stmt;
        
		#Wrapper view. Merge all fields from device view, Android device info view & iOS device info view.
		SET @deviceWRAView = CONCAT('`vw_wra_device', inCompanyId, '`');
		SET @dropQuery = CONCAT('DROP VIEW IF EXISTS ', @deviceWRAView, ';');
		PREPARE stmt FROM @dropQuery;
		EXECUTE stmt;

        SET @createQuery = CONCAT(
			'CREATE VIEW ', @deviceWRAView, ' AS ',
			'SELECT
				`v2`.`id`,`v2`.`device_uuid`,`v2`.`device_type`,`v2`.`user_id`,`v2`.`device_push_magic`,
				`v2`.`device_token`,`v2`.`unlock_token`,`v2`.`device_owner_type`,`v2`.`is_deleted`,`v2`.`is_delete_requested`,
                `v2`.`created_timestamp`,`v2`.`updated_timestamp`,
                
                `u`.`email`,`u`.`first_name`,`u`.`last_name`,

#				\'Android\' AS \'device_type\',
				\'\' AS `available_device`,
				COALESCE(`v1`.`battery_level`, \'\') AS `battery_level`,
				\'\' AS `bluetooth_mac`,
				\'\' AS `build_version`,
				\'\' AS `cellular_technology`,
				\'\' AS `current_mcc`,
				\'\' AS `current_mnc`,
				\'\' AS `device_capacity`,
				COALESCE(`v1`.`device_model`, \'\') AS `device_model`,
				COALESCE(`v1`.`device_name`, \'\') AS `device_name`,
#				COALESCE(`v1`.`device_uuid`, \'\') AS `device_uuid`,
				\'\' AS `eas_device_identifier`,
				COALESCE(`v1`.`encryption_enabled`, \'\') AS `encryption_enabled`,
				COALESCE(`v1`.`external_available_memory`, \'\') AS `external_available_memory`,
				COALESCE(`v1`.`external_total_memory`, \'\') AS `external_total_memory`,
				COALESCE(`v1`.`health`, \'\') AS `health`,
				\'\' AS `iccid`,
#				COALESCE(`v1`.`id`, 0) AS `id`,
				COALESCE(`v1`.`imei`, \'\') AS `imei`,
				COALESCE(`v1`.`imsi`, \'\') AS `imsi`,
				COALESCE(`v1`.`internal_available_memory`, \'\') AS `internal_available_memory`,
				COALESCE(`v1`.`internal_total_memory`, \'\') AS `internal_total_memory`,
				\'\' AS `is_cloud_backup_enabled`,
				\'\' AS `is_roaming`,
				\'\' AS `is_supervised`,
				\'\' AS `last_cloud_backup_date`,
				COALESCE(`v1`.`latitude`, \'\') AS `latitude`,
				COALESCE(`v1`.`longitude`, \'\') AS `longitude`,
				COALESCE(`v1`.`mac`, \'\') AS `mac`,
				\'\' AS `meid`,
#				\'\' AS `model_name`,
#				\'\' AS `model`,
				\'\' AS `modem_firmware_version`,
				COALESCE(`v1`.`operator`, \'\') AS `operator`,
				COALESCE(`v1`.`os_build_date`, \'\') AS `os_build_date`,
				COALESCE(`v1`.`os_version`, \'\') AS `os_version`,
				\'\' AS `phone_number`,
				\'\' AS `product_name`,
				COALESCE(`v1`.`plugged`, \'\') AS `plugged`,
				COALESCE(`v1`.`serial`, \'\') AS `serial_number`,
				\'\' AS `subscriber_mcc`,
				\'\' AS `subscriber_mnc`,
				COALESCE(`v1`.`vendor`, \'\') AS `vendor`,
				\'\' AS `wifi_mac`
			FROM ', 
				@deviceView, ' `v2` 
				LEFT OUTER JOIN ', @atmAndroidDeviceView, ' `v1` 
					ON `v2`.`id` = `v1`.`id` 
				LEFT OUTER JOIN `user`.`vw_atm_user` `u`
					ON `v2`.`user_id` = `u`.`id` ',
#            @atmAndroidDeviceView, ' `v1` 
#				RIGHT OUTER JOIN ', @deviceView, ' `v2` ON `v2`.`id` = `v1`.`id` 
#                RIGHT OUTER JOIN `user`.`vw_atm_user` `u` ON `v2`.`user_id` = `u`.`id` 
			'WHERE
				`v2`.`device_type` = \'android\' ',
				
			'UNION

			SELECT
				`v2`.`id`,`v2`.`device_uuid`,`v2`.`device_type`,`v2`.`user_id`,`v2`.`device_push_magic`,
				`v2`.`device_token`,`v2`.`unlock_token`,`v2`.`device_owner_type`,`v2`.`is_deleted`,`v2`.`is_delete_requested`,
                `v2`.`created_timestamp`,`v2`.`updated_timestamp`,
                
                `u`.`email`,`u`.`first_name`,`u`.`last_name`,

#				\'iOS\' AS \'device_type\',
				COALESCE(`v1`.`available_device`, \'\') AS `available_device`,
				COALESCE(`v1`.`battery_level`, \'\') AS `battery_level`,
				COALESCE(`v1`.`bluetooth_mac`, \'\') AS `bluetooth_mac`,
				COALESCE(`v1`.`build_version`, \'\') AS `build_version`,
				COALESCE(`v1`.`cellular_technology`, \'\') AS `cellular_technology`,
				COALESCE(`v1`.`current_mcc`, \'\') AS `current_mcc`,
				COALESCE(`v1`.`current_mnc`, \'\') AS `current_mnc`,
				COALESCE(`v1`.`device_capacity`, \'\') AS `device_capacity`,
#				\'\' AS `device_model`,
                (COALESCE(`v1`.`model_name`, \'\') + \' \' + COALESCE(`v1`.`model`, \'\')) AS `device_model`,
				COALESCE(`v1`.`device_name`, \'\') AS `device_name`,
#				COALESCE(`v1`.`device_uuid`, \'\') AS `device_uuid`,
				COALESCE(`v1`.`eas_device_identifier`, \'\') AS `eas_device_identifier`,
				\'\' AS `encryption_enabled`,
				\'\' AS `external_available_memory`,
				\'\' AS `external_total_memory`,
				\'\' AS `health`,
				COALESCE(`v1`.`iccid`, \'\') AS `iccid`,
#				COALESCE(`v1`.`id`, 0) AS `id`,
				COALESCE(`v1`.`imei`, \'\') AS `imei`,
				\'\' AS `imsi`,
				\'\' AS `internal_available_memory`,
				\'\' AS `internal_total_memory`,
				COALESCE(`v1`.`is_cloud_backup_enabled`, \'\') AS `is_cloud_backup_enabled`,
				COALESCE(`v1`.`is_roaming`, \'\') AS `is_roaming`,
				COALESCE(`v1`.`is_supervised`, \'\') AS `is_supervised`,
				COALESCE(`v1`.`last_cloud_backup_date`, \'\') AS `last_cloud_backup_date`,
				\'\' AS `latitude`,
				\'\' AS `longitude`,
				\'\' AS `mac`,
				COALESCE(`v1`.`meid`, \'\') AS `meid`,
#				COALESCE(`v1`.`model_name`, \'\') AS `model_name`,
#				COALESCE(`v1`.`model`, \'\') AS `model`,
				COALESCE(`v1`.`modem_firmware_version`, \'\') AS `modem_firmware_version`,
				\'\' AS `operator`,
				\'\' AS `os_build_date`,
				COALESCE(`v1`.`os_version`, \'\') AS `os_version`,
				COALESCE(`v1`.`phone_number`, \'\') AS `phone_number`,
				COALESCE(`v1`.`product_name`, \'\') AS `product_name`,
				\'\' AS `plugged`,
				COALESCE(`v1`.`serial_number`, \'\') AS `serial_number`,
				COALESCE(`v1`.`subscriber_mcc`, \'\') AS `subscriber_mcc`,
				COALESCE(`v1`.`subscriber_mnc`, \'\') AS `subscriber_mnc`,
				\'\' AS `vendor`,
				COALESCE(`v1`.`wifi_mac`, \'\') AS `wifi_mac` 
			FROM ', 
				@deviceView, ' `v2` 
				LEFT OUTER JOIN ', @atmiOSDeviceView, ' `v1` 
					ON `v2`.`id` = `v1`.`id` 
				LEFT OUTER JOIN `user`.`vw_atm_user` `u`
					ON `v2`.`user_id` = `u`.`id` ',
#            @atmAndroidDeviceView, ' `v1` 
#				RIGHT OUTER JOIN ', @deviceView, ' `v2` ON `v2`.`id` = `v1`.`id` 
#                RIGHT OUTER JOIN `user`.`vw_atm_user` `u` ON `v2`.`user_id` = `u`.`id` 
			'WHERE
				`v2`.`device_type` = \'ios\' '
            );

#			FROM ', @atmiOSDeviceView, ' `v1` 
#				RIGHT OUTER JOIN ', @deviceView, ' `v2` ON `v2`.`id` = `v1`.`id` 
#                RIGHT OUTER JOIN `user`.`vw_atm_user` `u` ON `v2`.`user_id` = `u`.`id` 
#			WHERE
#				`v2`.`device_type` = \'ios\' '
#            );
#select @createQuery;
		PREPARE stmt FROM @createQuery;
		EXECUTE stmt;
	ELSE
		SELECT 'Invalid inCompanyId parameter.';
	END IF;
END$$
DELIMITER ;
