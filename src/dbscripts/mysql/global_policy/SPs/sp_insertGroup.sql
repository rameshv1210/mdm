DROP PROCEDURE IF EXISTS `global_policy`.`sp_insertGroup`//
DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `global_policy`.`sp_insertGroup`(
  IN inGroup_name VARCHAR(100),
  IN inGroupTableName VARCHAR(63),
  /*
  IN inFePolicyTableName VARCHAR(63),
  IN inMdmPolicyTableName VARCHAR(63),
  */
  OUT outGroup_id int,
  OUT outStatus VARCHAR(100)
  
)
BEGIN
	/*
	--Revision History 
	---------------------------------------------------------------------------------------------------------------/
	--Author		RELEASE		DATE			DESCRIPTION
	---------------------------------------------------------------------------------------------------------------/
	--Nishant		4.0			Apr/26/2017		Created to insert group data into dynamic tables for Groups.
	---------------------------------------------------------------------------------------------------------------/
    */
    
	#group_name should be valid - not null, not empty.
	SET outStatus = '';
    
	
		SET inGroup_name = TRIM(inGroup_name);
		
		IF inGroup_name = '' THEN
			SET outStatus = 'Invalid group_name.';
		ELSE
			SET @inserttable = CONCAT(
						'INSERT INTO `',
				inGroupTableName,
				'` (`groupName`)',
                ' VALUES ',
                ' (','''',inGroup_name,'''',');'
						);
            
                
		    PREPARE inserttb FROM @inserttable;
					EXECUTE inserttb;
					
                    
			IF (ROW_COUNT() > 0) THEN
                SET outGroup_id = LAST_INSERT_ID();
				SET outStatus = 'Inserted';
			ELSE
				SET outStatus = 'Insert failed';
			END IF;
            
            DEALLOCATE PREPARE inserttb;
		END IF;
	
END$$
DELIMITER ;
