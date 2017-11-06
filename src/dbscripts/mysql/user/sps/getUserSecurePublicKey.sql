DROP PROCEDURE IF EXISTS `user`.`getUserSecurePublicKey`;
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `user`.`getUserSecurePublicKey`(IN userId BIGINT, IN userEmail VARCHAR(255))
BEGIN
	IF userId=0 THEN
		SELECT publicKey FROM `user_key_security` WHERE id = (SELECT id FROM `user` WHERE email = userEmail);
	ELSE
		SELECT publicKey FROM `user_key_security` WHERE id = userId;
	END IF;    
END$$
DELIMITER ;
