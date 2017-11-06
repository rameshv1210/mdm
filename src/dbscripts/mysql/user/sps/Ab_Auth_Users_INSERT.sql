DROP PROCEDURE IF EXISTS `user`.`Ab_Auth_Users_INSERT`;
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `user`.`Ab_Auth_Users_INSERT`( IN  `in_email` VARCHAR( 100 ) , IN  `in_password` TEXT , 
IN  `in_PasswordSalt` VARCHAR( 100 ) , IN  `mobile_number` VARCHAR( 20 ) , IN  `transportPublicKey` BLOB, IN  `transportPrivateKey` BLOB ,
IN transportKeyPassword  VARCHAR( 50), IN  `securePublicKey` BLOB, IN  `securePrivateKey` BLOB, IN secureKeyPassword  VARCHAR( 50), IN  `company_guid` VARCHAR( 100 ) )
    NO SQL
BEGIN 
INSERT INTO `user`
SET email = in_email,
PASSWORD = in_password,
PasswordSalt = in_PasswordSalt,
mobile_number = mobile_number,
company_guid = company_guid,
publicKey = transportPublicKey,
privateKey = transportPrivateKey,
keyPassword = transportKeyPassword,
created=NOW();
SELECT id INTO @userId FROM `user` WHERE email = in_email;
INSERT INTO `user_key_security` SET publicKey = securePublicKey,privateKey = securePrivateKey, keyPassword = secureKeyPassword, id = @userId;
END$$
DELIMITER ;
