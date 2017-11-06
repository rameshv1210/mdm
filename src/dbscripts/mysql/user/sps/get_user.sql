DROP PROCEDURE IF EXISTS `user`.`get_user`;
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `user`.`get_user`(IN `emailID` VARCHAR(255))
BEGIN
	SELECT * FROM `user` WHERE email = emailID;
    END$$
DELIMITER ;
