DELIMITER $$
USE `mdm_device` $$
DROP PROCEDURE IF EXISTS `mdm_device`.`getPolicy` $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `mdm_device`.`getPolicy`(
	IN userIdIn BIGINT(20),
    mdmPolicyTable VARCHAR(50),
    groupTable VARCHAR(50)
    )
BEGIN
	/*
	--Revision History 
	---------------------------------------------------------------------------------------------------------------/
	--Author		RELEASE		DATE			DESCRIPTION
	---------------------------------------------------------------------------------------------------------------/
	--SoftSuave		1.0			Oct/25/2016		Created for MDM.
    --Karthik		1.0			May/12/2017		Bugfix. Removed hardcoded DB/Table delimiters, in queries.
	---------------------------------------------------------------------------------------------------------------/
    */
	SET @qry = CONCAT('select * from ', mdmPolicyTable, ' where `defaultPolicy` = 1');
	SET @userId = userIdIn;
	SET @gId = 0;
	SET @mdmId = 0;
	IF @userId = 0 THEN
		PREPARE QUERY FROM @qry;
		EXECUTE QUERY;
		DEALLOCATE PREPARE QUERY;
	ELSE
		SELECT groupId INTO @gId FROM user.user WHERE id=@userId;
		IF @gId = 0 THEN
			PREPARE QUERY FROM @qry;
			EXECUTE QUERY;
			DEALLOCATE PREPARE QUERY;
		ELSE
			SET @mdmIdQry = CONCAT('select mdmPolicy INTO @mdmId from ', groupTable, ' where id = @gId');
			PREPARE QUERY FROM @mdmIdQry;
			EXECUTE QUERY;
			DEALLOCATE PREPARE QUERY;
			IF @mdmId = 0 THEN
				PREPARE QUERY FROM @qry;
				EXECUTE QUERY;
				DEALLOCATE PREPARE QUERY;
			ELSE
				SET @mdmPolicyQry = CONCAT('select * from ', mdmPolicyTable, ' where id = @mdmId');
				PREPARE QUERY FROM @mdmPolicyQry;
				EXECUTE QUERY;
				DEALLOCATE PREPARE QUERY;
			END IF;
		END IF;
	END IF;
END$$
DELIMITER ;
