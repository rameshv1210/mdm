DROP PROCEDURE IF EXISTS `mdm_device`.`saveUserIdentity`;
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `mdm_device`.`saveUserIdentity`(IN  `userId` BIGINT( 20 ) ,IN  `identityCert` text, IN  `serialNumber` varchar(255))
BEGIN
	INSERT INTO `user_identity` 
		SET user_id = userId,
		identity_certificate = identityCert,
		serial_number = serialNumber;
END$$
DELIMITER ;
