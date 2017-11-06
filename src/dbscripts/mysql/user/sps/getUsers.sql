DROP PROCEDURE IF EXISTS `user`.`getUsers`;
DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `user`.`getUsers`(
IN inCompany_guid char(36))
BEGIN
/*
	--Revision History 
	---------------------------------------------------------------------------------------------------------------/
	--Author		RELEASE		DATE			DESCRIPTION
	---------------------------------------------------------------------------------------------------------------/
	--Nishant		4.0			Apr/26/2017		Created to get users for a company
	---------------------------------------------------------------------------------------------------------------/
    */
SELECT * from user where company_guid = inCompany_guid;
END$$
DELIMITER ;
