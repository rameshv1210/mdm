DELIMITER $$
DROP PROCEDURE IF EXISTS `file_encryption_device`.`setPolicy` $$
CREATE PROCEDURE `file_encryption_device`.`setPolicy`(
	fePolicyTable VARCHAR(100),		#format: `db name`.`table name`
	groupTable VARCHAR(100),		#format: `db name`.`table name`
    idIn int(11),
    policyNameIn varchar(255),
    descriptionIn varchar(5000),
    policyJsonIn text,
    defaultPolicyIn tinyint(1),
    groupIdIn INT(11),
    updateDateTimeIn datetime
    )
BEGIN
	/*
	--Revision History 
	---------------------------------------------------------------------------------------------------------------/
	--Author		RELEASE		DATE			DESCRIPTION
	---------------------------------------------------------------------------------------------------------------/
	--SoftSuave		1.0			Oct/25/2016		Created for MDM.
    --Karthik		1.0			Jun/05/2017		Enhancement. Replicated MDM features.
    --Karthik		1.0			Jun/07/2017		Bugfix.
	---------------------------------------------------------------------------------------------------------------/
    */
    SET @outStatus = "";
    SET @outPolicyId = 0;
	IF defaultPolicyIn = 1 THEN
		SET @qry = CONCAT('UPDATE ', fePolicyTable,' SET `defaultPolicy` = 0');
		PREPARE QUERY FROM @qry;
		EXECUTE QUERY;
		DEALLOCATE PREPARE QUERY;
	END IF;
	IF idIn = 0 THEN
		#Check for duplicate policy name.
		SET @outPolicyId = 0;
		SET @checkQry = CONCAT('SELECT MAX(`id`) INTO @outPolicyId FROM ', fePolicyTable, ' WHERE `policyName` = \'', policyNameIn, '\'');
		PREPARE QUERY FROM @checkQry;
		EXECUTE QUERY;
		DEALLOCATE PREPARE QUERY;
		IF @outPolicyId > 0 THEN
			SET @outStatus = 'Duplicate';
            SET @outPolicyId = @outPolicyId;
		ELSE
			SET @insertQry = CONCAT('INSERT INTO ', fePolicyTable,
				' (`policyName`, `description`, `policyJson`, `defaultPolicy`, `updateDateTime`) values(\'',
                policyNameIn, '\',\'', descriptionIn, '\',\'', policyJsonIn, '\',\'', defaultPolicyIn, '\',\'', updateDateTimeIn, '\')'
                );
			PREPARE QUERY FROM @insertQry;
			EXECUTE QUERY;
			DEALLOCATE PREPARE QUERY;
			SET @outPolicyId = LAST_INSERT_ID();
            SET @outStatus = "Inserted";
		END IF;
	ELSE
		SET @updateQry = CONCAT('UPDATE ', fePolicyTable,
			' SET `policyName` = \'', policyNameIn,'\', `description` = \'', descriptionIn, '\', `defaultPolicy` = ', defaultPolicyIn,
            ', `updateDateTime` = \'', updateDateTimeIn, '\'');
		IF policyJsonIn != '' THEN
			SET @updateQry = CONCAT(@updateQry, ', `policyJson` = \'', policyJsonIn, '\'');
		END IF;
		SET @updateQry = CONCAT(@updateQry, ' WHERE `id` =', idIn);
		PREPARE QUERY FROM @updateQry;
		EXECUTE QUERY;
		DEALLOCATE PREPARE QUERY;
		SET @outStatus = "Updated";
        SET @outPolicyId = idIn;
	END IF;

    #Return result.
    SELECT @outStatus AS 'outStatus', @outPolicyId AS 'outPolicyId';

    ##Debug code, to be removed.
    #SELECT @updateQry;

	#Update group record for fe policy id, when policy is not default.
	IF defaultPolicyIn = 0 THEN
		SET @updateQry = CONCAT('UPDATE ', groupTable,' SET `fepolicy` = ', @outPolicyId, ' WHERE `id` = ', groupIdIn, ';');
		PREPARE QUERY FROM @updateQry;
		EXECUTE QUERY;
		DEALLOCATE PREPARE QUERY;

		##Debug code, to be removed.
		#SELECT @updateQry;
	END IF;
END$$
DELIMITER ;
