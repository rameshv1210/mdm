DROP PROCEDURE IF EXISTS `photo_upload`.`saveUserPhoto`;
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `photo_upload`.`saveUserPhoto`(IN userId BIGINT, photoURLIn VARCHAR(200), userExists BOOLEAN)
BEGIN
	IF userExists = TRUE THEN
	UPDATE `userphoto` SET photoURL = photoURLIn, updateDate = UTC_TIMESTAMP WHERE id = userId;
	ELSE
	INSERT INTO `userPhoto`  (id, photoURL, updateDate) VALUES (userId , photoURLIn, UTC_TIMESTAMP);
	END IF;
    END$$
DELIMITER ;
