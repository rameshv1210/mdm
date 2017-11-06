DELIMITER $$
USE `global_policy` $$
DROP PROCEDURE IF EXISTS `global_policy`.`sp_deleteGroupPolicy` $$
CREATE DEFINER=`root`@`%` PROCEDURE `sp_deleteGroupPolicy`(
  IN inGroupTableName VARCHAR(100),	#format: `db name`.`table name`
  IN inGroupId INT,
  IN inPolicyId INT,
  IN inPolicyType INT				#0-MDM policy, 1-FE policy.
)
BEGIN
	/*
	--Revision History 
	---------------------------------------------------------------------------------------------------------------/
	--Author		RELEASE		DATE			DESCRIPTION
	---------------------------------------------------------------------------------------------------------------/
	--Nishant		1.0			May/05/2017		Delete Mdm Policy for specified group id.
    --Karthik		1.0			Jun/05/2017		Enhanced to handle both mdm and fe policy.
	---------------------------------------------------------------------------------------------------------------/
    */
    DECLARE myRowCount int default 0;
	SET @outStatus = '';
    SET @outPolicyId = 0;
    SET @qryPolicyRecs = 0;
    
    SET @policyUpdate = '';
    IF (inPolicyType >= 1) THEN
		SET @policyUpdate = ' `fePolicy` = 0';
	ELSE
		SET @policyUpdate = ' `mdmPolicy` = 0';
    END IF;
	IF (inGroupId > 0) THEN
		SET @updateQuery = CONCAT(
		'UPDATE ', inGroupTableName,
			' SET',
			@policyUpdate,
			' WHERE',
			' `id`=', inGroupId,
            #' AND `mdmPolicy` = ', inPolicyId,
            ';'
			);
		PREPARE updatetb FROM @updateQuery;
		EXECUTE updatetb;
		SELECT row_count() INTO myRowCount;
		DEALLOCATE PREPARE updatetb;
        
		IF (myRowCount > 0) THEN
			SET @outStatus = 'Deleted';
			SET @outPolicyId = inPolicyId;
		ELSE
			SET @selecQuery = CONCAT(
			'SELECT `id` FROM ', inGroupTableName,
				' WHERE',
				' `id`=', inGroupId,
				' INTO @qryPolicyRecs;'
				);
			
			PREPARE qrytb FROM @selecQuery;
			EXECUTE qrytb;
			SELECT row_count() INTO myRowCount;
			DEALLOCATE PREPARE qrytb;
            
            IF (@qryPolicyRecs > 0) THEN
				SET @outStatus = 'Deleted';
				SET @outPolicyId = inPolicyId;
            ELSE
				SET @outStatus = 'Delete failed. No record found for supplied inGroupId';
			END IF;
		END IF;
	ELSE
		SET @outStatus = 'Invalid inGroupId';
	END IF;

    #Return result.
    SELECT @outStatus AS 'outStatus', @outPolicyId AS 'outPolicyId';	#, myRowCount AS 'myRowCount';
END$$
DELIMITER ;
