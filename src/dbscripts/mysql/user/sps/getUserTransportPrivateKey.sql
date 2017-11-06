DROP PROCEDURE IF EXISTS `user`.`getUserTransportPrivateKey`;
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `user`.`getUserTransportPrivateKey`(IN userId BIGINT, userEmail VARCHAR(255))
BEGIN
IF(userId = 0) THEN
SELECT privateKey,keyPassword FROM `user` WHERE email = userEmail;
ELSE 
SELECT privateKey,keyPassword FROM `user` WHERE id = userId;
END IF;
    END$$
DELIMITER ;
