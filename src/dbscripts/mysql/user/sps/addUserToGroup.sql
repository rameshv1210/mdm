DROP PROCEDURE IF EXISTS `user`.`addUserToGroup`;
DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `user`.`addUserToGroup`(
  IN inUser_id TEXT,
  IN inGroupId char(36),
  IN inCompany_guid char(36),
  OUT outStatus VARCHAR(100)
  
)
BEGIN
	/*
	--Revision History 
	---------------------------------------------------------------------------------------------------------------/
	--Author		RELEASE		DATE			DESCRIPTION
	---------------------------------------------------------------------------------------------------------------/
	--Nishant		4.0			Apr/26/2017		Created to add existing users to User Groups.
	---------------------------------------------------------------------------------------------------------------/
    */
    
	#group_name should be valid - not null, not empty.
	SET outStatus = '';
    		
		IF inGroupId = '' THEN
			SET outStatus = 'Invalid group_id.';
		ELSE
			SET @updatetable = CONCAT(
				'Update `user` ',
				' Set `GroupId` =','''',inGroupId,'''',
                ' Where id in (',inUser_id,')',
                ' And `company_guid` = ','''',inCompany_guid,'''',';'
						);
            
                
		    PREPARE updatetb FROM @updatetable;
					EXECUTE updatetb;
				                
			IF (ROW_COUNT() > 0) THEN
                SET outStatus = 'Updated';
			ELSE
				SET outStatus = 'Update failed';
			END IF;
             DEALLOCATE PREPARE updatetb;           
		END IF;
	
END$$
DELIMITER ;
