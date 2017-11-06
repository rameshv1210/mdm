DROP PROCEDURE IF EXISTS `user`.`get_ABTicket`;
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `user`.`get_ABTicket`(IN `emailID` VARCHAR(255))
BEGIN 
	SELECT CONCAT(id, '||||', UNIX_TIMESTAMP()) AS abTicket, id AS userId, publicKey FROM `user` WHERE email = emailID;
END$$
DELIMITER ;
