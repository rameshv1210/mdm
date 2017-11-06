DROP PROCEDURE IF EXISTS `mdm_device`.`getDevices`;
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `mdm_device`.`getDevices`(
	IN `inDeviceId` BIGINT(20),
    IN `inDeviceUUID` VARCHAR(255),
   	IN `inCompanyId` char(36)
    )
BEGIN
	#Get device data from device wrapper view.
	SET @deviceView = CONCAT('`vw_wra_device', inCompanyId, '`');

	SET @mycolumns = CONCAT('
	#Device data.
		`created_timestamp`,
        `device_uuid`,`device_type`,`user_id`,`device_push_magic`,`device_token`,`device_owner_type`,
        `id`,`is_deleted`,`is_delete_requested`,
        `updated_timestamp`,`unlock_token`,
        
	#User data.
    `email`,`first_name`,`last_name`,
        
    #Device info data.
		`available_device`,
		`battery_level`,`bluetooth_mac`,`build_version`,
		`cellular_technology`,`current_mcc`,`current_mnc`,
		`device_capacity`,`device_model`,`device_name`,
		`eas_device_identifier`,`encryption_enabled`,`external_available_memory`,`external_total_memory`,
		`health`,
		`iccid`,`imei`,`imsi`,`internal_available_memory`,`internal_total_memory`,`is_cloud_backup_enabled`,
		`is_roaming`,`is_supervised`,`last_cloud_backup_date`,`latitude`,`longitude`,
		`mac`,`meid`,`modem_firmware_version`,
		`operator`,`os_build_date`,`os_version`,
		`phone_number`,`product_name`,`plugged`,
		`serial_number`,`subscriber_mcc`,`subscriber_mnc`,
		`vendor`,
		`wifi_mac`
		'
        );

    IF inCompanyId <> '' THEN
		SET @query = CONCAT('SELECT ', @mycolumns, ' FROM ', @deviceView);
        
        IF COALESCE(inDeviceUUID, '') <> '' THEN
			SET @query = CONCAT(@query, ' WHERE `device_uuid` = \'', inDeviceUUID, '\'');
        ELSE 
			IF COALESCE(inDeviceId, 0) <> 0 THEN
				SET @query = CONCAT(@query, ' WHERE `id` = ', inDeviceId);
			END IF;
		END IF;

		SET @query = CONCAT(@query, ';');

		PREPARE stmt FROM @query;
		EXECUTE stmt;
	ELSE
		SELECT 'Invalid inCompanyId parameter.';
        CALL `raiseError`(2017, 'Invalid inCompanyId parameter.');
	END IF;
END$$
DELIMITER ;
