DROP PROCEDURE IF EXISTS `photo_upload`.`deleteUserPhoto`;
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `photo_upload`.`deleteUserPhoto`(IN userId BIGINT)
BEGIN
    DELETE  FROM `userphoto` WHERE id = userId;
    END$$
DELIMITER ;
