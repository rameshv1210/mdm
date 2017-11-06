DELIMITER $$
DROP PROCEDURE IF EXISTS `file_encryption_device`.`getPolicy` $$
CREATE PROCEDURE `file_encryption_device`.`getPolicy`(
	IN userIdIn INT(11),
    fePolicyTable VARCHAR(50),
    groupTable VARCHAR(50)
    )
BEGIN
	/*
	--Revision History 
	---------------------------------------------------------------------------------------------------------------/
	--Author		RELEASE		DATE			DESCRIPTION
	---------------------------------------------------------------------------------------------------------------/
	--SoftSuave		1.0			Oct/25/2016		Created for MDM.
    --Karthik		1.0			Jun/05/2017		Enhancement. Replicated MDM features.
	---------------------------------------------------------------------------------------------------------------/
    */
	SET @qry = CONCAT('SELECT * FROM ', fePolicyTable, ' WHERE `defaultPolicy` = 1');
	set @userId = userIdIn;
	set @gId = 0;
	SET @fepId = 0;

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
			SET @fepIdQry = CONCAT('SELECT `fePolicy` INTO @fepId FROM ', groupTable, ' WHERE `id` = @gId');
			PREPARE QUERY FROM @fepIdQry;
			EXECUTE QUERY;
			DEALLOCATE PREPARE QUERY;
			IF @fepId = 0 THEN
				PREPARE QUERY FROM @qry;
				EXECUTE QUERY;
				DEALLOCATE PREPARE QUERY;
			ELSE
				SET @fePolicyQry = CONCAT('SELECT * FROM ', fePolicyTable, ' WHERE `id` = @fepId');
				PREPARE QUERY FROM @fePolicyQry;
				EXECUTE QUERY;
				DEALLOCATE PREPARE QUERY;
			END IF;
		END IF;
	end if;
END$$
DELIMITER ;
