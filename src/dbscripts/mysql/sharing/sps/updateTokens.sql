DROP PROCEDURE IF EXISTS `sharing`.`updateTokens`;
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sharing`.`updateTokens`(in serviceId int(2), accessToken text, refreshToken text, expiry datetime)
BEGIN
case  
when serviceId = 1 then
update `upload_service_details`  set boxAccessToken = accessToken, boxRefreshToken = refreshToken, boxExpiryDate = expiry;
WHEN serviceId = 2 THEN
UPDATE `upload_service_details`  SET dropboxAccessToken = accessToken, dropboxRefreshToken = refreshToken;
WHEN serviceId = 3 THEN
UPDATE `upload_service_details`  SET googledriveAccessToken = accessToken, googledriveRefreshToken = refreshToken, googledriveExpiryDate = expiry;
WHEN serviceId = 4 THEN
UPDATE `upload_service_details`  SET onedriveAccessToken = accessToken, onedriveRefreshToken = refreshToken, onedriveExpiryDate = expiry;
end case;  
    END$$
DELIMITER ;
