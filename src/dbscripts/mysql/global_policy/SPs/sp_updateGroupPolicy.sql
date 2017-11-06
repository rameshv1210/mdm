DROP PROCEDURE IF EXISTS `global_policy`.`sp_updateGroupPolicy`//
DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `global_policy`.`sp_updateGroupPolicy`(
  IN inGroup_id INT,
  IN mdmPolicy_id INT,
  IN inGroupTableName VARCHAR(63),
  /*
  IN inFePolicyTableName VARCHAR(63),
  IN inMdmPolicyTableName VARCHAR(63),
  */
 OUT outStatus VARCHAR(100)
  
)
BEGIN
	/*
	--Revision History 
	---------------------------------------------------------------------------------------------------------------/
	--Author		RELEASE		DATE			DESCRIPTION
	---------------------------------------------------------------------------------------------------------------/
	--Nishant		4.0			May/05/2017		Update Mdm Policy for specified group id, Remove any previous group 
                                                associtaion for current group if exists
	---------------------------------------------------------------------------------------------------------------/
    */
    
	#group_name should be valid - not null, not empty.
	SET outStatus = '';
    
	IF (inGroup_id > 0) THEN
		
			SET @updatetable = CONCAT(
			
            'UPDATE `', inGroupTableName, '`',
						' SET',
						' `mdmPolicy`=','null',
						' WHERE ',
                        '`id`=',inGroup_id,';'
                       );
            
                
		    PREPARE updatetb FROM @updatetable;
					EXECUTE updatetb;
                    SET @updatetable = CONCAT(
			
            'UPDATE `', inGroupTableName, '`',
						' SET',
						' `mdmPolicy`=',mdmPolicy_id,
						' WHERE ',
                        '`id`=',inGroup_id,';'
                       
						);
            
                
		    PREPARE updatetb FROM @updatetable;
					EXECUTE updatetb;
					 
                     
                    
			IF (ROW_COUNT() > 0) THEN
				SET outStatus = 'Updated';
			ELSE
				SET outStatus = 'Update failed';
			END IF;
            DEALLOCATE PREPARE updatetb;
		       
	ELSE
		SET outStatus = 'Invalid group_id';
	END IF;
END$$
DELIMITER ;
