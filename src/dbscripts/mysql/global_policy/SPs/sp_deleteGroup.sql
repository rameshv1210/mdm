DROP PROCEDURE IF EXISTS `global_policy`.`sp_deleteGroup`//
DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `global_policy`.`sp_deleteGroup`(
 IN inGroup_id INT,
  IN inGroupTableName VARCHAR(63),
  OUT outStatus VARCHAR(1000)
)
BEGIN
	/*
	--Revision History 
	---------------------------------------------------------------------------------------------------------------/
	--Author		RELEASE		DATE			DESCRIPTION
	---------------------------------------------------------------------------------------------------------------/
	--Nishant		4.0			Apr/24/2017		Created to delete user group.
	---------------------------------------------------------------------------------------------------------------/
    */
    
	SET outStatus = '';
	    	
    IF inGroup_id < 1 THEN
		SET outStatus = 'Invalid inGroup_id';
    ELSE
	IF inGroupTableName	= ''  THEN
    SET outStatus = 'Invalid group_table_name';
	ELSE
    SET @updatetable = CONCAT(
						'DELETE FROM `', inGroupTableName, '`',
						' WHERE ',
                        '`id`=',inGroup_id,';'
						);
            
                
		    PREPARE updatetb FROM @updatetable;
					EXECUTE updatetb;
					
                    
			IF (ROW_COUNT() > 0) THEN
				SET outStatus = 'Deleted';
			ELSE
				SET outStatus = 'Delete failed';
			END IF;
            DEALLOCATE PREPARE updatetb;
	END IF;
    END IF;
END$$
DELIMITER ;
