DROP PROCEDURE IF EXISTS `photo_upload`.`selectUser`;
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `photo_upload`.`selectUser`(in userId bigint)
BEGIN
    SELECT * FROM `userphoto` WHERE id = userId;
    END$$
DELIMITER ;
