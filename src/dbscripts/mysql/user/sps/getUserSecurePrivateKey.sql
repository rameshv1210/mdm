DROP PROCEDURE IF EXISTS `user`.`getUserSecurePrivateKey`;
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `user`.`getUserSecurePrivateKey`(IN userId BIGINT)
BEGIN
SELECT privateKey,keyPassword FROM `user_key_security` WHERE id = userId;
    END$$
DELIMITER ;
