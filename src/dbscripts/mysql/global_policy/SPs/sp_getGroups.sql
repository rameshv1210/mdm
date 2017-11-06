DELIMITER //
USE global_policy//
DROP PROCEDURE IF EXISTS `sp_getGroups`//
CREATE PROCEDURE `sp_getGroups`(IN `companyGuid` CHAR(36))
BEGIN
	/*
	--Revision History 
	---------------------------------------------------------------------------------------------------------------/
	--Author		RELEASE		DATE			DESCRIPTION
	---------------------------------------------------------------------------------------------------------------/
	--Karthik		4.0			Apr/17/2017		Created to return user group(s) for File Encryption.
	---------------------------------------------------------------------------------------------------------------/
    */
	SET @id := 'group';
	SET @table := CONCAT(@id, companyGuid);
	/*SET @sql := CONCAT('SELECT `id`, `groupName` FROM ', @table, ';');*/
	SET @sql := CONCAT('SELECT `id`, `groupName` FROM `', @table, '`;');
	PREPARE stmt FROM @sql;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;
END//
DELIMITER ;
