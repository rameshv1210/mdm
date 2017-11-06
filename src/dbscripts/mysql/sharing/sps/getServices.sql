DROP PROCEDURE IF EXISTS `sharing`.`getServices`;
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sharing`.`getServices`(IN userIdIn BIGINT )
BEGIN
SELECT usd.*,u.email,u.first_name,u.last_name FROM `upload_service_details` usd JOIN user.user u ON u.id = usd.id WHERE usd.id = userIdIn;
    END$$
DELIMITER ;
