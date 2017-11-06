DROP PROCEDURE IF EXISTS `user`.`saveCompanySecureKeys`;
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `user`.`saveCompanySecureKeys`( IN companyId bigint, `securePublicKey` TEXT, IN  `securePrivateKey` TEXT)
BEGIN 
INSERT INTO `company_key_security` SET publicKey = securePublicKey,privateKey = securePrivateKey,id =  companyId;
END$$
DELIMITER ;
