DROP PROCEDURE IF EXISTS `mdm_device`.`saveIosSecurityInfo`;
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `mdm_device`.`saveIosSecurityInfo`(IN `userId` BIGINT(20), IN `deviceUuid` VARCHAR(255), IN `hardwareEncryptionCaps` int,
						IN `passcodeCompliant` VARCHAR(10), IN `passcodeCompliantWithProfiles` VARCHAR(10), IN `passcodeLockGracePeriod` int,
						IN `passcodeLockGracePeriodEnforced` int, IN `passcodePresent` varchar(10))
BEGIN
	SELECT company_guid INTO @companyId FROM user.user WHERE id = userId;
	
	SET @query = CONCAT('SELECT COUNT(*) INTO @count FROM `ios_security_info', @companyId , '` WHERE device_uuid = "', deviceUuid, '"');
	PREPARE stmt FROM @query;
	EXECUTE stmt;
	
	IF (@count > 0) then
		SET @query = CONCAT('UPDATE `ios_security_info', @companyId , '` 
			SET hardware_encryption_caps = ', hardwareEncryptionCaps , ', 
			passcode_compliant = ', passcodeCompliant , ', 
			passcode_compliant_with_profiles = ', passcodeCompliantWithProfiles , ', 
			passcode_lock_grace_period = ', passcodeLockGracePeriod , ', 
			passcode_lock_grace_period_enforced = ', passcodeLockGracePeriodEnforced , ', 
			passcode_present = ', passcodePresent , ' 
			WHERE device_uuid = "', deviceUuid, '"');
		PREPARE stmt FROM @query;
		EXECUTE stmt;
	else
		SET @query = CONCAT('INSERT INTO `ios_security_info', @companyId , '` (device_uuid, hardware_encryption_caps, 
				passcode_compliant, passcode_compliant_with_profiles, passcode_lock_grace_period, passcode_lock_grace_period_enforced, passcode_present) 
				VALUES ("', deviceUuid, '",', hardwareEncryptionCaps , ',', passcodeCompliant , ',', passcodeCompliantWithProfiles , ',
				', passcodeLockGracePeriod , ',', passcodeLockGracePeriodEnforced , ',', passcodePresent , ')');
		PREPARE stmt FROM @query;
		EXECUTE stmt;
	end if;
END$$
DELIMITER ;
