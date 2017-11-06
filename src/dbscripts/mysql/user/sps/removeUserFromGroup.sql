DROP PROCEDURE IF EXISTS `user`.`removeUserFromGroup`;
DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `user`.`removeUserFromGroup`(
  IN inUser_id TEXT,
  IN inCompany_guid char(36),
  OUT outStatus VARCHAR(100)
  
)
BEGIN
	/*
	--Revision History 
	---------------------------------------------------------------------------------------------------------------/
	--Author		RELEASE		DATE			DESCRIPTION
	---------------------------------------------------------------------------------------------------------------/
	--Nishant		4.0			Apr/26/2017		Created to remove users from User  Groups.
	---------------------------------------------------------------------------------------------------------------/
    */
    
	
	SET outStatus = '';
    	
			SET @updatetable = CONCAT(
				'Update `user` ',
				' Set `Groupid` =','null',
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
	
END$$
DELIMITER ;
