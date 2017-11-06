DROP PROCEDURE IF EXISTS `user`.`getUserTransportPublicKey`;
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `user`.`getUserTransportPublicKey`(IN userId BIGINT)
BEGIN
SELECT publicKey FROM `user` WHERE id = userId;
    END$$
DELIMITER ;
