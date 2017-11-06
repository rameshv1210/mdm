DELIMITER //
USE global_policy//
DROP PROCEDURE IF EXISTS `sp_updateCompany`//
CREATE PROCEDURE `sp_updateCompany`(
  IN inCompany_id BIGINT,
  IN inCompany_name VARCHAR(100),
  /*
  IN inGroupTableName VARCHAR(63),
  IN inFePolicyTableName VARCHAR(63),
  IN inMdmPolicyTableName VARCHAR(63),
  */
  IN inDeleted BOOLEAN,
  OUT outStatus VARCHAR(100)
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
    
	#company_name should be valid - not null, not empty.
	SET outStatus = '';
    
	IF (inCompany_id > 0) THEN
		SET inCompany_name = TRIM(inCompany_name);
		
		IF inCompany_name = '' THEN
			SET outStatus = 'Invalid company_name.';
		ELSE
			UPDATE
				`company`
			SET
				`company_name` = inCompany_name,
				`modified_datetime` = UTC_TIMESTAMP(),
				`deleted` = inDeleted
			WHERE
				`company_id` = inCompany_id;
			IF (ROW_COUNT() > 0) THEN
				SET outStatus = 'Updated';
			ELSE
				SET outStatus = 'Update failed';
			END IF;
		END IF;
	ELSE
		SET outStatus = 'Invalid company_id';
	END IF;
END//
DELIMITER ;
