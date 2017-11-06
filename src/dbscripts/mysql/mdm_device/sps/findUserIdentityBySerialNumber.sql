DROP PROCEDURE IF EXISTS `mdm_device`.`findUserIdentityBySerialNumber`;
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `mdm_device`.`findUserIdentityBySerialNumber`(IN  `serialNumber` VARCHAR( 255 ) )
BEGIN
	select * from user_identity where serial_number = serialNumber;
END$$
DELIMITER ;
