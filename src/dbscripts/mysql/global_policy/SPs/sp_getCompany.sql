DELIMITER //
USE global_policy//
DROP PROCEDURE IF EXISTS `sp_getCompany`//
CREATE PROCEDURE `sp_getCompany`(
  IN inCompany_id BIGINT,
  IN inCompany_guid VARCHAR(36),
  OUT outStatus VARCHAR(100)
)
BEGIN
	/*
	--Revision History 
	---------------------------------------------------------------------------------------------------------------/
	--Author		RELEASE		DATE			DESCRIPTION
	---------------------------------------------------------------------------------------------------------------/
	--Karthik		4.0			Apr/17/2017		Created to manage Company data and dynamic tables for File Encryption.
    --Karthik		4.0			Apr/25/2017		Added more dynamic tables.
	---------------------------------------------------------------------------------------------------------------/
    */
    
	#Return company record for company_id, and if it is not valid then for company_guid.
	SET outStatus = '';
	IF inCompany_id > 0 THEN
		SELECT
			`company_id`, `company_guid`, `company_name`,
            `FeDeviceTableName`,
            `GroupTableName`, `FePolicyTableName`, `MdmPolicyTableName`,
            `AndAppListTableName`, `AndDevInfoTableName`, `CommandTableName`, `DeviceTableName`,
				`iOsAppListTableName`, `iOsCertListTableName`, `iOsDevInfoTableName`, `iOsProfListTableName`,
                `iOsProvProfTableName`, `iOsSecInfoTableName`,
            `created_datetime`, `modified_datetime`, `deleted`
		FROM
			`company`
		WHERE
			`company_id` = inCompany_id;
		SET outStatus = 'Case #1 Company record for supplied company_id.';
	ELSEIF inCompany_guid <> '' THEN
		SELECT
			`company_id`, `company_guid`, `company_name`,
            `FeDeviceTableName`,
            `GroupTableName`, `FePolicyTableName`, `MdmPolicyTableName`,
            `AndAppListTableName`, `AndDevInfoTableName`, `CommandTableName`, `DeviceTableName`,
				`iOsAppListTableName`, `iOsCertListTableName`, `iOsDevInfoTableName`, `iOsProfListTableName`,
                `iOsProvProfTableName`, `iOsSecInfoTableName`,
            `created_datetime`, `modified_datetime`, `deleted`
		FROM
			`company`
		WHERE
			`company_guid` = inCompany_guid;
		SET outStatus = 'Case #2 Company record for supplied company_guid.';
	ELSE
		SET outStatus = 'Case #3 Invalid company_id and company_guid.';
	END IF;
END//
DELIMITER ;