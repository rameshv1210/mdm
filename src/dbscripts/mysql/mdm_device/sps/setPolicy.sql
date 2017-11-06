DELIMITER $$
USE `mdm_device` $$
DROP PROCEDURE IF EXISTS `mdm_device`.`setPolicy` $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `mdm_device`.`setPolicy`(
	mdmPolicyTable VARCHAR(100),	#format: `db name`.`table name`
	groupTable VARCHAR(100),		#format: `db name`.`table name`
    idIn INT(11),
    policyNameIn VARCHAR(255),
    descriptionIn VARCHAR(5000), 
    androidJsonIn TEXT,
    iOsXmlIn TEXT,
    defaultPolicyIn TINYINT(1),
    groupIdIn INT(11),
    updateDateTimeIn DATETIME,
    updateJson VARCHAR(10)
    )
BEGIN
	/*
	--Revision History 
	---------------------------------------------------------------------------------------------------------------/
	--Author		RELEASE		DATE			DESCRIPTION
	---------------------------------------------------------------------------------------------------------------/
	--SoftSuave		1.0			Oct/25/2016		Created for MDM.
    --Karthik		1.0			May/12/2017		Bugfix. Removed hardcoded DB/Table delimiters, in Insert, Update queries.
    --Karthik		1.0			May/15/2017		Enhancement. Prevented duplicate policy. Added policyId to return data.
    --Karthik		1.0			May/24/2017		Enhancement. Added groupId to associate policy with user group when policy is not default.
	---------------------------------------------------------------------------------------------------------------/
    */
    SET @outStatus = "";
    SET @outPolicyId = 0;
	IF defaultPolicyIn = 1 THEN
		SET @qry = CONCAT('UPDATE ', mdmPolicyTable,' set defaultPolicy = 0');
		PREPARE QUERY FROM @qry;
		EXECUTE QUERY;
		DEALLOCATE PREPARE QUERY;
	END IF;
	IF idIn = 0 THEN
		#Check for duplicate policy name.
		SET @outPolicyId = 0;
		SET @checkQry = CONCAT('SELECT MAX(`id`) INTO @outPolicyId FROM ', mdmPolicyTable, ' WHERE `policyName` = \'', policyNameIn, '\'');
		PREPARE QUERY FROM @checkQry;
		EXECUTE QUERY;
		DEALLOCATE PREPARE QUERY;
		IF @outPolicyId > 0 THEN
			SET @outStatus = 'Duplicate';
            SET @outPolicyId = @outPolicyId;
		ELSE
			SET @insertQry = CONCAT('INSERT INTO ', mdmPolicyTable,' (`policyName`, `description`, `androidJson`, `iOsXml`, `defaultPolicy`, `updateDateTime`) VALUES (\'',
				policyNameIn,'\',\'',descriptionIn,'\',\'',androidJsonIn,'\',\'',iOsXmlIn,'\',\'',defaultPolicyIn,'\',\'',updateDateTimeIn,'\')');
			PREPARE QUERY FROM @insertQry;
			EXECUTE QUERY;
			DEALLOCATE PREPARE QUERY;
			SET @outPolicyId = LAST_INSERT_ID();
            SET @outStatus = "Inserted";
		END IF;
	ELSE
		/*
		 IF updateJson = 'none' THEN
			SET @updateQry = CONCAT('UPDATE ', mdmPolicyTable,' SET `policyName` =\'', policyNameIn,'\', `description` =\'', descriptionIn, '\',defaultPolicy =', defaultPolicyIn, ',updateDateTime = \'', updateDateTimeIn, '\' where id =', idIn);
		 ELSEIF updateJson = 'both' THEN
			SET @updateQry = CONCAT('UPDATE ', mdmPolicyTable,' SET `policyName` =\'', policyNameIn,'\', `description` =\'', descriptionIn, '\',androidJson =\'', androidJsonIn, '\',iOsXml =\'', iOsXmlIn, '\',defaultPolicy =', defaultPolicyIn, ',updateDateTime = \'', updateDateTimeIn, '\' where id =', idIn);
		 ELSEIF updateJson = 'ios' THEN
			SET @updateQry = CONCAT('UPDATE ', mdmPolicyTable,' SET `policyName` =\'', policyNameIn,'\', `description` =\'', descriptionIn, '\',androidJson = androidJson',',iOsXml =\'', iOsXmlIn, '\',defaultPolicy =', defaultPolicyIn, ',updateDateTime = \'', updateDateTimeIn, '\' where id =', idIn);
		 ELSEIF updateJson = 'android' THEN
			SET @updateQry = CONCAT('UPDATE ', mdmPolicyTable,' SET `policyName` =\'', policyNameIn,'\', `description` =\'', descriptionIn, '\',androidJson =\'', androidJsonIn, '\',iOsXml =iOsXml', ',defaultPolicy =', defaultPolicyIn, ',updateDateTime = \'', updateDateTimeIn, '\' where id =', idIn);
		END IF;
        */
        
		SET @updateQry1 = CONCAT('UPDATE ', mdmPolicyTable,' SET `policyName` = \'', policyNameIn,'\', `description` = \'',
			descriptionIn, '\', `defaultPolicy` = ', defaultPolicyIn);
		IF updateJson = 'none' THEN
			SET @updateQry2 = ' ';
		ELSEIF updateJson = 'both' THEN
			SET @updateQry2 = CONCAT(', `androidJson` =\'', androidJsonIn, '\', `iOsXml` =\'', iOsXmlIn, '\' ');
		ELSEIF updateJson = 'ios' THEN
			SET @updateQry2 = CONCAT(', `iOsXml` =\'', iOsXmlIn, '\' ');
		ELSEIF updateJson = 'android' THEN
			SET @updateQry2 = CONCAT(', `androidJson` =\'', androidJsonIn, '\' ');
		END IF;
		SET @updateQry3 = CONCAT(', `updateDateTime` = \'', updateDateTimeIn, '\' WHERE `id` = ', idIn, ';');

		SET @updateQry1 = CONCAT(@updateQry1, @updateQry2, @updateQry3);
		PREPARE QUERY FROM @updateQry1;
		EXECUTE QUERY;
		DEALLOCATE PREPARE QUERY;
		SET @outStatus = "Updated";
        SET @outPolicyId = idIn;
	END IF;

    #Return result.
    SELECT @outStatus AS 'outStatus', @outPolicyId AS 'outPolicyId';

    ##Debug code, to be removed.
    #SELECT @updateQry1;

	#Update group record for mdm policy id, when policy is not default.
	IF defaultPolicyIn = 0 THEN
		SET @updateQry2 = CONCAT('UPDATE ', groupTable,' SET `mdmpolicy` = ', @outPolicyId, ' WHERE `id` = ', groupIdIn, ';');
		PREPARE QUERY FROM @updateQry2;
		EXECUTE QUERY;
		DEALLOCATE PREPARE QUERY;

		##Debug code, to be removed.
		#SELECT @updateQry2;
	END IF;
END$$
DELIMITER ;
