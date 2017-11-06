DELIMITER //
USE global_policy//
DROP PROCEDURE IF EXISTS `sp_deleteCompany`//
CREATE PROCEDURE `sp_deleteCompany`(
#  IN inCompany_id BIGINT(20),
  IN inCompany_guid VARCHAR(36),
  IN inDropDynamicTables BOOL,
  OUT outCompany_id BIGINT,
  OUT outStatus VARCHAR(1000)
)
BEGIN
	/*
	--Revision History 
	---------------------------------------------------------------------------------------------------------------/
	--Author		RELEASE		DATE			DESCRIPTION
	---------------------------------------------------------------------------------------------------------------/
	--Karthik		4.0			Apr/17/2017		Created to manage Company data and dynamic tables for File Encryption.
	---------------------------------------------------------------------------------------------------------------/
    */
    
	SET outStatus = '';
	SET outCompany_id = 0;
    
    SET autocommit=0;
	
    IF inCompany_guid = '' THEN
		SET outStatus = 'Invalid inCompany_guid';
    ELSE
		IF NOT EXISTS (SELECT `company_id` FROM `company` WHERE `company_guid` = inCompany_guid) THEN
			SET outStatus = 'No data found';
		ELSE
			SELECT 
				`company_id`
			INTO
				@company_id
			FROM
				`company`
			WHERE
				`company_guid` = inCompany_guid;
			SET outCompany_id = @company_id;

			IF @company_id <= 0 THEN
				SET outStatus = 'No data found for supplied inCompany_guid';
			ELSE
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

                IF (inDropDynamicTables AND
						(@feDevTbl > 0 OR
						@grpTbl > 0 OR @fePlcyTbl > 0 OR @mdmPlcyTbl > 0 OR
						@andAppLstTbl > 0 OR @andDevInfoTbl > 0 OR @cmdTbl > 0 OR @devTbl > 0 OR @iOsAppLstTbl > 0 OR
						@iOsCrtLstTbl > 0 OR @iOsDevInfTbl > 0 OR @iOsProfLstTbl > 0 OR @iOsProvProfTbl > 0 OR @iOsSecInfTbl > 0)
					)
				THEN
					START TRANSACTION;

                    SET outStatus = 'Dynamic tables fouond. Dropping ';

					#One or more tables found, so drop them.
					#Drop below tables in file_encryption_device, global_policy & mdm_device DBs.

                    IF (@feDevTbl > 0) THEN
						SET @dropTable = CONCAT('DROP TABLE `file_encryption_device`.`', @feDevTblName, '`;');
						PREPARE createtb FROM @dropTable;
						EXECUTE createtb;
						DEALLOCATE PREPARE createtb;
						SET outStatus = CONCAT(outStatus, ' ', @feDevTblName);
					END IF;

                    IF (@grpTbl > 0) THEN
						SET @dropTable = CONCAT('DROP TABLE `global_policy`.`', @grpTblName, '`;');
						PREPARE createtb FROM @dropTable;
						EXECUTE createtb;
						DEALLOCATE PREPARE createtb;
						SET outStatus = CONCAT(outStatus, ' ', @grpTblName);
					END IF;
                    
                    IF (@fePlcyTbl > 0) THEN
						SET @dropTable = CONCAT('DROP TABLE `global_policy`.`', @fePlcyTblName, '`;');
						PREPARE createtb FROM @dropTable;
						EXECUTE createtb;
						DEALLOCATE PREPARE createtb;
						SET outStatus = CONCAT(outStatus, ' ', @fePlcyTblName);
					END IF;
                    
                    IF (@mdmPlcyTbl > 0) THEN
						SET @dropTable = CONCAT('DROP TABLE `global_policy`.`', @mdmPlcyTblName, '`;');
						PREPARE createtb FROM @dropTable;
						EXECUTE createtb;
						DEALLOCATE PREPARE createtb;
						SET outStatus = CONCAT(outStatus, ' ', @mdmPlcyTblName);
					END IF;

                    IF (@andAppLstTbl > 0) THEN
						SET @dropTable = CONCAT('DROP TABLE `mdm_device`.`', @andAppLstTblName, '`;');
						PREPARE createtb FROM @dropTable;
						EXECUTE createtb;
						DEALLOCATE PREPARE createtb;
						SET outStatus = CONCAT(outStatus, ' ', @andAppLstTblName);
					END IF;
                    
                    IF (@andDevInfoTbl > 0) THEN
						SET @dropTable = CONCAT('DROP TABLE `mdm_device`.`', @andDevInfoTblName, '`;');
						PREPARE createtb FROM @dropTable;
						EXECUTE createtb;
						DEALLOCATE PREPARE createtb;
						SET outStatus = CONCAT(outStatus, ' ', @andDevInfoTblName);
					END IF;
                    
                    IF (@cmdTbl > 0) THEN
						SET @dropTable = CONCAT('DROP TABLE `mdm_device`.`', @cmdTblName, '`;');
						PREPARE createtb FROM @dropTable;
						EXECUTE createtb;
						DEALLOCATE PREPARE createtb;
						SET outStatus = CONCAT(outStatus, ' ', @cmdTblName);
					END IF;
                    
                    IF (@devTbl > 0) THEN
						SET @dropTable = CONCAT('DROP TABLE `mdm_device`.`', @devTblName, '`;');
						PREPARE createtb FROM @dropTable;
						EXECUTE createtb;
						DEALLOCATE PREPARE createtb;
						SET outStatus = CONCAT(outStatus, ' ', @devTblName);
					END IF;
                    
                    IF (@iOsAppLstTbl > 0) THEN
						SET @dropTable = CONCAT('DROP TABLE `mdm_device`.`', @iOsAppLstTblName, '`;');
						PREPARE createtb FROM @dropTable;
						EXECUTE createtb;
						DEALLOCATE PREPARE createtb;
						SET outStatus = CONCAT(outStatus, ' ', @iOsAppLstTblName);
					END IF;

                    IF (@iOsCrtLstTbl > 0) THEN
						SET @dropTable = CONCAT('DROP TABLE `mdm_device`.`', @iOsCrtLstTblName, '`;');
						PREPARE createtb FROM @dropTable;
						EXECUTE createtb;
						DEALLOCATE PREPARE createtb;
						SET outStatus = CONCAT(outStatus, ' ', @iOsCrtLstTblName);
					END IF;
                    
                    IF (@iOsDevInfTbl > 0) THEN
						SET @dropTable = CONCAT('DROP TABLE `mdm_device`.`', @iOsDevInfTblName, '`;');
						PREPARE createtb FROM @dropTable;
						EXECUTE createtb;
						DEALLOCATE PREPARE createtb;
						SET outStatus = CONCAT(outStatus, ' ', @iOsDevInfTblName);
					END IF;
                    
                    IF (@iOsProfLstTbl > 0) THEN
						SET @dropTable = CONCAT('DROP TABLE `mdm_device`.`', @iOsProfLstTblName, '`;');
						PREPARE createtb FROM @dropTable;
						EXECUTE createtb;
						DEALLOCATE PREPARE createtb;
						SET outStatus = CONCAT(outStatus, ' ', @iOsProfLstTblName);
					END IF;
                    
                    IF (@iOsProvProfTbl > 0) THEN
						SET @dropTable = CONCAT('DROP TABLE `mdm_device`.`', @iOsProvProfTblName, '`;');
						PREPARE createtb FROM @dropTable;
						EXECUTE createtb;
						DEALLOCATE PREPARE createtb;
						SET outStatus = CONCAT(outStatus, ' ', @iOsProvProfTblName);
					END IF;
                    
                    IF (@iOsSecInfTbl > 0) THEN
						SET @dropTable = CONCAT('DROP TABLE `mdm_device`.`', @iOsSecInfTblName, '`;');
						PREPARE createtb FROM @dropTable;
						EXECUTE createtb;
						DEALLOCATE PREPARE createtb;
						SET outStatus = CONCAT(outStatus, ' ', @iOsSecInfTblName);
					END IF;
                    
					DELETE FROM
						`company`
					WHERE
						`company_id` = outCompany_id;
					
                    COMMIT;

					SET outStatus = CONCAT(outStatus, ' Company record deleted.');
				ELSE
					IF inDropDynamicTables THEN
						SET outStatus = 'Dynamic table not found.';
					ELSE
						SET outStatus = 'inDropDynamicTables is not set.';
                    END IF;
                END IF;

-- 				UPDATE
-- 					`company`
-- 				SET
-- 					`modified_datetime` = UTC_TIMESTAMP(),
-- 					`deleted` = true
-- 				WHERE
-- 					`company_id` = outCompany_id;
--                     
-- 				SET outStatus = CONCAT(outStatus, ' Company record soft deleted.');

 			END IF;
		END IF;
	END IF;
END//
DELIMITER ;