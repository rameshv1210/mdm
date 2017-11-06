DROP PROCEDURE IF EXISTS `user`.`getUsersFromGroup`;
DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `user`.`getUsersFromGroup`(
  IN inGroupId char(36),
  IN inCompany_guid char(36)
)
BEGIN
	/*
	--Revision History 
	---------------------------------------------------------------------------------------------------------------/
	--Author		RELEASE		DATE			DESCRIPTION
	---------------------------------------------------------------------------------------------------------------/
	--Nishant		4.0			Apr/26/2017		Created to get users for a User group
	---------------------------------------------------------------------------------------------------------------/
    */
    
	SELECT *
    FROM `user`
    WHERE `company_guid` = inCompany_guid AND `groupId` = InGroupId;
			
END$$
DELIMITER ;
