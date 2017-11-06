DELIMITER //
USE global_policy//
DROP PROCEDURE IF EXISTS `sp_insertCompany`//
CREATE PROCEDURE `sp_insertCompany`(
  IN inCompany_guid VARCHAR(36),
  IN inCompany_name VARCHAR(100),
  OUT outCompany_id BIGINT,
  OUT outStatus VARCHAR(100)
)
BEGIN
	/*
	--Revision History 
	---------------------------------------------------------------------------------------------------------------/
	--Author		RELEASE		DATE			DESCRIPTION
	---------------------------------------------------------------------------------------------------------------/
	--Karthik		4.0			Apr/17/2017		Created to manage Company data and dynamic tables for File Encryption.
    --Karthik		4.0			May/12/2017		Changed table names to all lower-case, since DB/Table name is case-sensitive.
    --Karthik		4.0			Sep/09/2017		Added created_timestamp, updated_timestamp fields to device<customer id> table.
	---------------------------------------------------------------------------------------------------------------/
    */
    
	/*
    #
    #Cannot use SQLEXCEPTION based ROLLBACK due to DML commands in this script, which will auto-commit any data changes.
    #
	DECLARE EXIT HANDLER FOR SQLEXCEPTION 
	BEGIN
		  #.. set any flags etc  eg. SET @flag = 0;
          SET outStatus = 'SQLEXCEPTION Rollback should happen.';
		  ROLLBACK;
	END;
	*/
	#For a given company_guid, only one company_id should exist.
	#company_name should be valid - not null, not empty.
    #SET @company_id = 0;
	SET outStatus = '';
	SET outCompany_id = 0;
    
    SET autocommit=0;
	
	SET inCompany_name = TRIM(inCompany_name);
	
	IF inCompany_name = '' THEN
		SET outStatus = 'Invalid company_name.';
	ELSE
		IF EXISTS (SELECT `company_id` FROM `company` WHERE `company_guid` = inCompany_guid) THEN
			SELECT 
				`company_id`
			INTO
				@company_id
			FROM
				`company`
			WHERE
				`company_guid` = inCompany_guid;
			SET outCompany_id = @company_id;
			SET outStatus = 'Duplicate';
		ELSE
			START TRANSACTION;

			INSERT INTO
				`company`
				(`company_guid`, `company_name`, `created_datetime`, `deleted`)
			VALUES
				(inCompany_guid, inCompany_name, UTC_TIMESTAMP(), FALSE);
			IF (ROW_COUNT() > 0) THEN
				SET outCompany_id = LAST_INSERT_ID();
                
                #file_encryption_device DB. 1 dynamic table.
                SET @feDevTblName = CONCAT('fedevice',  outCompany_id);							#FeDeviceTableName

				#global_policy DB. 3 dynamic tables.
                SET @grpTblName = CONCAT('group', outCompany_id);								#GroupTableName
                SET @fePlcyTblName = CONCAT('fepolicy', outCompany_id);							#FePolicyTableName
                SET @mdmPlcyTblName = CONCAT('mdmpolicy', outCompany_id);						#MdmPolicyTableName

				#mdm_device DB. 10 dynamic tables.
                SET @andAppLstTblName = CONCAT('android_application_list',  outCompany_id);		#AndAppListTableName
                SET @andDevInfoTblName = CONCAT('android_device_info',  outCompany_id);			#AndDevInfoTableName
                SET @cmdTblName = CONCAT('command',  outCompany_id);							#CommandTableName
                SET @devTblName = CONCAT('device',  outCompany_id);								#DeviceTableName
                SET @iOsAppLstTblName = CONCAT('ios_application_list',  outCompany_id);			#iOsAppListTableName
                SET @iOsCrtLstTblName = CONCAT('ios_certificate_list',  outCompany_id);			#iOsCertListTableName
                SET @iOsDevInfTblName = CONCAT('ios_device_info',  outCompany_id);				#iOsDevInfoTableName
                SET @iOsProfLstTblName = CONCAT('ios_profile_list',  outCompany_id);			#iOsProfListTableName
                SET @iOsProvProfTblName = CONCAT('ios_provisioning_profile',  outCompany_id);	#iOsProvProfTableName
                SET @iOsSecInfTblName = CONCAT('ios_security_info',  outCompany_id);			#iOsSecInfoTableName

                SELECT `global_policy`.`fn_table_count`('file_encryption_device', @feDevTblName) INTO @feDevTbl;

                SELECT `global_policy`.`fn_table_count`('global_policy', @grpTblName) INTO @grpTbl;
                SELECT `global_policy`.`fn_table_count`('global_policy', @grpTblName) INTO @fePlcyTbl;
                SELECT `global_policy`.`fn_table_count`('global_policy', @grpTblName) INTO @mdmPlcyTbl;

                SELECT `global_policy`.`fn_table_count`('mdm_device', @andAppLstTblName) INTO @andAppLstTbl;
                SELECT `global_policy`.`fn_table_count`('mdm_device', @andDevInfoTblName) INTO @andDevInfoTbl;
                SELECT `global_policy`.`fn_table_count`('mdm_device', @cmdTblName) INTO @cmdTbl;
                SELECT `global_policy`.`fn_table_count`('mdm_device', @devTblName) INTO @devTbl;
                SELECT `global_policy`.`fn_table_count`('mdm_device', @iOsAppLstTblName) INTO @iOsAppLstTbl;
                SELECT `global_policy`.`fn_table_count`('mdm_device', @iOsCrtLstTblName) INTO @iOsCrtLstTbl;
                SELECT `global_policy`.`fn_table_count`('mdm_device', @iOsDevInfTblName) INTO @iOsDevInfTbl;
                SELECT `global_policy`.`fn_table_count`('mdm_device', @iOsProfLstTblName) INTO @iOsProfLstTbl;
                SELECT `global_policy`.`fn_table_count`('mdm_device', @iOsProvProfTblName) INTO @iOsProvProfTbl;
                SELECT `global_policy`.`fn_table_count`('mdm_device', @iOsSecInfTblName) INTO @iOsSecInfTbl;

                IF (@feDevTbl > 0 OR
						@grpTbl > 0 OR @fePlcyTbl > 0 OR @mdmPlcyTbl > 0 OR
						@andAppLstTbl > 0 OR @andDevInfoTbl > 0 OR @cmdTbl > 0 OR @devTbl > 0 OR @iOsAppLstTbl > 0 OR
						@iOsCrtLstTbl > 0 OR @iOsDevInfTbl > 0 OR @iOsProfLstTbl > 0 OR @iOsProvProfTbl > 0 OR @iOsSecInfTbl > 0)
				THEN
					#One or more duplicate tables found, so rollback changes.
					ROLLBACK;
                    SET outStatus = 'Duplicate tables, changes rolled back.';
                    
                    IF (@feDevTbl > 0) THEN
						SET outStatus = CONCAT(outStatus, ' ', @feDevTblName);
					END IF;
                    IF (@grpTbl > 0) THEN
						SET outStatus = CONCAT(outStatus, ' ', @grpTblName);
					END IF;
                    IF (@fePlcyTbl > 0) THEN
						SET outStatus = CONCAT(outStatus, ' ', @fePlcyTblName);
					END IF;
                    IF (@mdmPlcyTbl > 0) THEN
						SET outStatus = CONCAT(outStatus, ' ', @mdmPlcyTblName);
					END IF;
                    IF (@andAppLstTbl > 0) THEN
						SET outStatus = CONCAT(outStatus, ' ', @andAppLstTblName);
					END IF;
                    IF (@andDevInfoTbl > 0) THEN
						SET outStatus = CONCAT(outStatus, ' ', @andDevInfoTblName);
					END IF;
                    IF (@cmdTbl > 0) THEN
						SET outStatus = CONCAT(outStatus, ' ', @cmdTblName);
					END IF;
                    IF (@devTbl > 0) THEN
						SET outStatus = CONCAT(outStatus, ' ', @devTblName);
					END IF;
                    IF (@iOsAppLstTbl > 0) THEN
						SET outStatus = CONCAT(outStatus, ' ', @iOsAppLstTblName);
					END IF;
                    IF (@iOsCrtLstTbl > 0) THEN
						SET outStatus = CONCAT(outStatus, ' ', @iOsCrtLstTblName);
					END IF;
                    IF (@iOsDevInfTbl > 0) THEN
						SET outStatus = CONCAT(outStatus, ' ', @iOsDevInfTblName);
					END IF;
                    IF (@iOsProfLstTbl > 0) THEN
						SET outStatus = CONCAT(outStatus, ' ', @iOsProfLstTblName);
					END IF;
                    IF (@iOsProvProfTbl > 0) THEN
						SET outStatus = CONCAT(outStatus, ' ', @iOsProvProfTblName);
					END IF;
                    IF (@iOsSecInfTbl > 0) THEN
						SET outStatus = CONCAT(outStatus, ' ', @iOsSecInfTblName);
					END IF;
				ELSE
                BEGIN
					#Create below tables in file_encryption_device DB.
					#FeDevice<company_id> structure. Table# 1
					SET @createtable = CONCAT(
						'CREATE TABLE `file_encryption_device`.`', @feDevTblName, '` (',
						' `id` int(11) NOT NULL AUTO_INCREMENT,',
						' `deviceName` varchar(255) DEFAULT NULL,',
						' `userId` int(11) NOT NULL DEFAULT \'0\',',
						' `updateDateTime` datetime DEFAULT NULL,',
						' PRIMARY KEY (`id`)',
						' ) ENGINE=InnoDB DEFAULT CHARSET=utf8;'
						);
					PREPARE createtb FROM @createtable;
					EXECUTE createtb;
					DEALLOCATE PREPARE createtb;

					#Create below tables in global_policy DB.
					#Group<company_id> structure. Table# 2
					SET @createtable = CONCAT(
						'CREATE TABLE `global_policy`.`', @grpTblName, '` (',
						' `id` int(11) NOT NULL AUTO_INCREMENT,',
						' `groupName` varchar(255) NOT NULL,',
						' `mdmPolicy` int(11) NOT NULL DEFAULT \'0\',',
						' `fePolicy` int(11) NOT NULL DEFAULT \'0\',',
						' PRIMARY KEY (`id`)',
						' ) ENGINE=InnoDB DEFAULT CHARSET=utf8;'
						);
					PREPARE createtb FROM @createtable;
					EXECUTE createtb;
					DEALLOCATE PREPARE createtb;

					#FePolicy<company_id> structure. Table# 3
					SET @createtable = CONCAT(
						'CREATE TABLE `global_policy`.`', @fePlcyTblName, '` (',
						' `id` int(11) NOT NULL AUTO_INCREMENT,',
						  ' `policyName` varchar(255) DEFAULT NULL,',
						  ' `description` varchar(5000) DEFAULT NULL,',
						  ' `policyJson` text,',
						  ' `defaultPolicy` tinyint(1) NOT NULL DEFAULT \'0\',',
						  ' `updateDateTime` datetime DEFAULT NULL,',
						  ' PRIMARY KEY (`id`)',
						' ) ENGINE=InnoDB DEFAULT CHARSET=utf8;'
						);
					PREPARE createtb FROM @createtable; 
					EXECUTE createtb;
					DEALLOCATE PREPARE createtb;

					#MdmPolicy<company_id> structure. Table# 4
					SET @createtable = CONCAT(
						'CREATE TABLE `global_policy`.`', @mdmPlcyTblName, '` (',
						' `id` int(11) NOT NULL AUTO_INCREMENT,',
						  ' `policyName` varchar(255) DEFAULT NULL,',
						  ' `description` varchar(5000) DEFAULT NULL,',
						  ' `androidJson` text,',
						  ' `iOsXml` text,',
						  ' `defaultPolicy` tinyint(1) NOT NULL DEFAULT \'0\',',
						  ' `updateDateTime` datetime DEFAULT NULL,',
						  ' PRIMARY KEY (`id`)',
						' ) ENGINE=InnoDB DEFAULT CHARSET=utf8;'
						);
					PREPARE createtb FROM @createtable;
					EXECUTE createtb;
					DEALLOCATE PREPARE createtb;

					#Create below tables in mdm_device DB.
					#android_application_list<company_id> structure. Table# 5
					SET @createtable = CONCAT(
						'CREATE TABLE `mdm_device`.`', @andAppLstTblName, '` (',
						' `id` bigint(20) NOT NULL AUTO_INCREMENT,',
						' ` device_uuid` varchar(255) COLLATE utf8_unicode_ci NOT NULL,',
						' ` name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,',
						' ` package_api` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,',
						' ` version` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,',
						' ` is_active` tinyint(1) DEFAULT NULL,',
						' ` is_system_app` tinyint(1) DEFAULT NULL,',
						' ` uss` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,',
						' PRIMARY KEY (`id`)',
						' ) ENGINE=InnoDB DEFAULT CHARSET=utf8;'
						);
					PREPARE createtb FROM @createtable;
					EXECUTE createtb;
					DEALLOCATE PREPARE createtb;

					#android_device_info<company_id> structure. Table# 6
					SET @createtable = CONCAT(
						'CREATE TABLE `mdm_device`.`', @andDevInfoTblName, '` (',
						' `id` bigint(20) NOT NULL AUTO_INCREMENT,',
						' `device_uuid` varchar(255) COLLATE utf8_unicode_ci NOT NULL,',
						' `serial` varchar(30) COLLATE utf8_unicode_ci DEFAULT NULL,',
						' `imei` varchar(30) COLLATE utf8_unicode_ci DEFAULT NULL,',
						' `imsi` varchar(30) COLLATE utf8_unicode_ci DEFAULT NULL,',
						' `mac` varchar(30) COLLATE utf8_unicode_ci DEFAULT NULL,',
						' `device_model` varchar(30) COLLATE utf8_unicode_ci DEFAULT NULL,',
						' `vendor` varchar(30) COLLATE utf8_unicode_ci DEFAULT NULL,',
						' `os_version` varchar(30) COLLATE utf8_unicode_ci DEFAULT NULL,',
						' `os_build_date` varchar(30) COLLATE utf8_unicode_ci DEFAULT NULL,',
						' `device_name` varchar(30) COLLATE utf8_unicode_ci DEFAULT NULL,',
						' `latitude` varchar(30) COLLATE utf8_unicode_ci DEFAULT NULL,',
						' `longitude` varchar(30) COLLATE utf8_unicode_ci DEFAULT NULL,',
						' `encryption_enabled` varchar(30) COLLATE utf8_unicode_ci DEFAULT NULL,',
						' `internal_total_memory` varchar(30) COLLATE utf8_unicode_ci DEFAULT NULL,',
						' `internal_available_memory` varchar(30) COLLATE utf8_unicode_ci DEFAULT NULL,',
						' `external_total_memory` varchar(30) COLLATE utf8_unicode_ci DEFAULT NULL,',
						' `external_available_memory` varchar(30) COLLATE utf8_unicode_ci DEFAULT NULL,',
						' `operator` varchar(30) COLLATE utf8_unicode_ci DEFAULT NULL,',
						' `battery_level` varchar(30) COLLATE utf8_unicode_ci DEFAULT NULL,',
						' `health` varchar(30) COLLATE utf8_unicode_ci DEFAULT NULL,',
						' `plugged` varchar(30) COLLATE utf8_unicode_ci DEFAULT NULL,',
						' PRIMARY KEY (`id`)',
						' ) ENGINE=InnoDB DEFAULT CHARSET=utf8;'
						);
					PREPARE createtb FROM @createtable;
					EXECUTE createtb;
					DEALLOCATE PREPARE createtb;

					#command<company_id> structure. Table# 7
					SET @createtable = CONCAT(
						'CREATE TABLE `mdm_device`.`', @cmdTblName, '` (',
						' `id` bigint(20) NOT NULL AUTO_INCREMENT,',
						' `device_uuid` varchar(255) COLLATE utf8_unicode_ci NOT NULL,',
						' `device_type` varchar(10) COLLATE utf8_unicode_ci NOT NULL,',
						' `command_type` varchar(50) COLLATE utf8_unicode_ci NOT NULL,',
						' `command_uuid` varchar(50) COLLATE utf8_unicode_ci NOT NULL,',
						' `command` text COLLATE utf8_unicode_ci,',
						' `created_timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,',
						' `pushed_timestamp` timestamp NULL DEFAULT \'0000-00-00 00:00:00\',',
						' `is_acknowledged` tinyint(1) NOT NULL DEFAULT \'0\',',
						' `command_error` tinyint(1) NOT NULL DEFAULT \'0\',',
						' PRIMARY KEY (`id`)',
						' ) ENGINE=InnoDB DEFAULT CHARSET=utf8;'
						);
					PREPARE createtb FROM @createtable;
					EXECUTE createtb;
					DEALLOCATE PREPARE createtb;

					#device<company_id> structure. Table# 8
					SET @createtable = CONCAT(
						'CREATE TABLE `mdm_device`.`', @devTblName, '` (',
						' `id` bigint(20) NOT NULL AUTO_INCREMENT,',
						' `device_uuid` varchar(255) COLLATE utf8_unicode_ci NOT NULL,',
						' `device_type` varchar(10) COLLATE utf8_unicode_ci NOT NULL,',
						' `user_id` bigint(20) NOT NULL,',
						' `device_push_magic` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,',
						' `device_token` varchar(255) COLLATE utf8_unicode_ci NOT NULL,',
						' `unlock_token` text COLLATE utf8_unicode_ci,',
						' `device_owner_type` varchar(10) COLLATE utf8_unicode_ci DEFAULT NULL,',
						' `is_deleted` tinyint(1) NOT NULL DEFAULT \'0\',',
						' `is_delete_requested` tinyint(1) NOT NULL DEFAULT \'0\',',
						' `created_timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,',
						' `updated_timestamp` timestamp NULL,',
						' PRIMARY KEY (`id`),',
						' UNIQUE KEY `unique_constrain` (`device_uuid`,`device_type`)',
						' ) ENGINE=InnoDB DEFAULT CHARSET=utf8;'
						);
					PREPARE createtb FROM @createtable;
					EXECUTE createtb;
					DEALLOCATE PREPARE createtb;

					#iOs_application_list<company_id> structure. Table# 9
					SET @createtable = CONCAT(
						'CREATE TABLE `mdm_device`.`', @iOsAppLstTblName, '` (',
						' `id` bigint(20) NOT NULL AUTO_INCREMENT,',
						' `device_uuid` varchar(255) COLLATE utf8_unicode_ci NOT NULL,',
						' `bundle_size` int(11) DEFAULT NULL,',
						' `dynamic_size` int(11) DEFAULT NULL,',
						' `identifier` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,',
						' `is_validated` tinyint(1) DEFAULT NULL,',
						' `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,',
						' `version` varchar(30) COLLATE utf8_unicode_ci DEFAULT NULL,',
						' PRIMARY KEY (`id`)',
						' ) ENGINE=InnoDB DEFAULT CHARSET=utf8;'
						);
					PREPARE createtb FROM @createtable;
					EXECUTE createtb;
					DEALLOCATE PREPARE createtb;

					#iOs_certificate_list<company_id> structure. Table# 10
					SET @createtable = CONCAT(
						'CREATE TABLE `mdm_device`.`', @iOsCrtLstTblName, '` (',
						' `id` bigint(20) NOT NULL AUTO_INCREMENT,',
						' `device_uuid` varchar(255) COLLATE utf8_unicode_ci NOT NULL,',
						' `common_name` varchar(255) COLLATE utf8_unicode_ci NOT NULL,',
						' `data` text COLLATE utf8_unicode_ci,',
						' `is_identity` tinyint(1) NOT NULL DEFAULT \'1\',',
						' `timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,',
						' PRIMARY KEY (`id`)',
						' ) ENGINE=InnoDB DEFAULT CHARSET=utf8;'
						);
					PREPARE createtb FROM @createtable;
					EXECUTE createtb;
					DEALLOCATE PREPARE createtb;

					#iOs_device_info<company_id> structure. Table# 11
					SET @createtable = CONCAT(
						'CREATE TABLE `mdm_device`.`', @iOsDevInfTblName, '` (',
						' `id` bigint(20) NOT NULL AUTO_INCREMENT,',
						' `device_uuid` varchar(255) COLLATE utf8_unicode_ci NOT NULL,',
						' `last_cloud_backup_date` timestamp NULL DEFAULT NULL,',
						' `device_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,',
						' `os_version` varchar(30) COLLATE utf8_unicode_ci DEFAULT NULL,',
						' `build_version` varchar(30) COLLATE utf8_unicode_ci DEFAULT NULL,',
						' `model_name` varchar(30) COLLATE utf8_unicode_ci DEFAULT NULL,',
						' `model` varchar(30) COLLATE utf8_unicode_ci DEFAULT NULL,',
						' `product_name` varchar(30) COLLATE utf8_unicode_ci DEFAULT NULL,',
						' `serial_number` varchar(30) COLLATE utf8_unicode_ci DEFAULT NULL,',
						' `device_capacity` varchar(30) COLLATE utf8_unicode_ci DEFAULT NULL,',
						' `available_device` varchar(30) COLLATE utf8_unicode_ci DEFAULT NULL,',
						' `battery_level` varchar(30) COLLATE utf8_unicode_ci DEFAULT NULL,',
						' `cellular_technology` varchar(1) COLLATE utf8_unicode_ci DEFAULT NULL,',
						' `imei` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,',
						' `meid` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,',
						' `modem_firmware_version` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,',
						' `is_supervised` varchar(10) COLLATE utf8_unicode_ci DEFAULT NULL,',
						' `eas_device_identifier` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,',
						' `is_cloud_backup_enabled` varchar(10) COLLATE utf8_unicode_ci DEFAULT NULL,',
						' `iccid` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,',
						' `bluetooth_mac` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,',
						' `wifi_mac` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,',
						' `phone_number` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,',
						' `is_roaming` varchar(10) COLLATE utf8_unicode_ci DEFAULT NULL,',
						' `subscriber_mcc` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,',
						' `subscriber_mnc` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,',
						' `current_mcc` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,',
						' `current_mnc` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,',
						' PRIMARY KEY (`id`)',
						' ) ENGINE=InnoDB DEFAULT CHARSET=utf8;'
						);
					PREPARE createtb FROM @createtable;
					EXECUTE createtb;
					DEALLOCATE PREPARE createtb;

					#iOs_profile_list<company_id> structure. Table# 12
					SET @createtable = CONCAT(
						'CREATE TABLE `mdm_device`.`', @iOsProfLstTblName, '` (',
						' `id` bigint(20) NOT NULL AUTO_INCREMENT,',
						' `device_uuid` varchar(255) COLLATE utf8_unicode_ci NOT NULL,',
						' `payload_identifier` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,',
						' `payload_organization` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,',
						' `payload_version` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,',
						' `payload_description` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,',
						' `timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,',
						' PRIMARY KEY (`id`)',
						' ) ENGINE=InnoDB DEFAULT CHARSET=utf8;'
						);
					PREPARE createtb FROM @createtable;
					EXECUTE createtb;
					DEALLOCATE PREPARE createtb;

					#iOs_provisioning_profile<company_id> structure. Table# 13
					SET @createtable = CONCAT(
						'CREATE TABLE `mdm_device`.`', @iOsProvProfTblName, '` (',
						' `id` bigint(20) NOT NULL AUTO_INCREMENT,',
						' `device_uuid` varchar(255) COLLATE utf8_unicode_ci NOT NULL,',
						' `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,',
						' `uuid` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,',
						' `timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,',
						' `expiry_date` timestamp NULL DEFAULT NULL,',
						' PRIMARY KEY (`id`)',
						' ) ENGINE=InnoDB DEFAULT CHARSET=utf8;'
						);
					PREPARE createtb FROM @createtable;
					EXECUTE createtb;
					DEALLOCATE PREPARE createtb;

					#iOs_security_info<company_id> structure. Table# 14
					SET @createtable = CONCAT(
						'CREATE TABLE `mdm_device`.`', @iOsSecInfTblName, '` (',
						' `id` bigint(20) NOT NULL AUTO_INCREMENT,',
						' `device_uuid` varchar(255) COLLATE utf8_unicode_ci NOT NULL,',
						' `hardware_encryption_caps` int(5) DEFAULT NULL,',
						' `passcode_compliant` tinyint(1) DEFAULT NULL,',
						' `passcode_compliant_with_profiles` tinyint(1) DEFAULT NULL,',
						' `passcode_lock_grace_period` int(5) DEFAULT NULL,',
						' `passcode_lock_grace_period_enforced` int(5) DEFAULT NULL,',
						' `passcode_present` tinyint(1) DEFAULT NULL,',
						' PRIMARY KEY (`id`)',
						' ) ENGINE=InnoDB DEFAULT CHARSET=utf8;'
						);
					PREPARE createtb FROM @createtable;
					EXECUTE createtb;
					DEALLOCATE PREPARE createtb;

					UPDATE
						`company`
					SET
						#file_encryption_device DB tables.
						`FeDeviceTableName` = @feDevTblName,

						#global_policy DB tables.
						`FePolicyTableName` = @fePlcyTblName,
						`GroupTableName` = @grpTblName,
						`MdmPolicyTableName` = @mdmPlcyTblName,

						#mdm_device DB tables.
						`AndAppListTableName` = @andAppLstTblName,
						`AndDevInfoTableName` = @andDevInfoTblName,
						`CommandTableName` = @cmdTblName,
						`DeviceTableName` = @devTblName,
						`iOsAppListTableName` = @iOsAppLstTblName,
						`iOsCertListTableName` = @iOsCrtLstTblName,
						`iOsDevInfoTableName` = @iOsDevInfTblName,
						`iOsProfListTableName` = @iOsProfLstTblName,
						`iOsProvProfTableName` = @iOsProvProfTblName,
						`iOsSecInfoTableName` = @iOsSecInfTblName
					WHERE
						`company_id` = outCompany_id;
					IF (ROW_COUNT() > 0) THEN
						SET outStatus = 'Inserted';
					ELSE
						SET outStatus = 'Dynamic table names updation failed.';
					END IF;
					
					COMMIT;
				END;
                END IF;
			ELSE
				SET outStatus = 'Insert failed';
			END IF;
		END IF;
	END IF;
END//
DELIMITER ;