DROP PROCEDURE IF EXISTS `mdm_device`.`findUserDevice`;
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `mdm_device`.`findUserDevice`(IN `companyId` char(36), IN `groupId` CHAR(36), IN `userId` BIGINT(20), 
								IN `deviceUuid` VARCHAR(255), IN `deviceType` VARCHAR(10))
BEGIN
	IF userId <> '' THEN
		SELECT company_guid INTO @companyId FROM user.user WHERE id = userId;
		
		IF deviceUuid <> '' THEN
			SET @query = CONCAT('SELECT * FROM `device', @companyId , '` WHERE is_deleted = FALSE AND device_type = "', deviceType ,'" AND user_id = ', userId ,
						' AND device_uuid = "', deviceUuid ,'"');
			PREPARE stmt FROM @query;
			EXECUTE stmt;
		ELSE
			SET @query = CONCAT('SELECT * FROM `device', @companyId , '` WHERE is_deleted = FALSE AND device_type = "', deviceType ,'" AND user_id =  ', userId );
			PREPARE stmt FROM @query;
			EXECUTE stmt;
		END IF;
	else
		IF groupId <> '' THEN
			SET @query = CONCAT('SELECT * FROM `device', companyId , '` WHERE is_deleted = FALSE AND device_type = "', deviceType ,'" 
						AND user_id IN ( SELECT id FROM user.user WHERE groupId = "', groupId ,'" )' );
			PREPARE stmt FROM @query;
			EXECUTE stmt;
		ELSEIF deviceUuid <> '' THEN
			SET @query = CONCAT('SELECT * FROM `device', companyId , '` WHERE is_deleted = FALSE AND 
						device_type = "', deviceType ,'" AND device_uuid = "', deviceUuid ,'"' );
			PREPARE stmt FROM @query;
			EXECUTE stmt;
		ELSE
			SET @query = CONCAT('SELECT * FROM `device', companyId , '` WHERE is_deleted = FALSE AND device_type = "', deviceType ,'" ');
			PREPARE stmt FROM @query;
			EXECUTE stmt;
		END IF;
	end if;
END$$
DELIMITER ;
