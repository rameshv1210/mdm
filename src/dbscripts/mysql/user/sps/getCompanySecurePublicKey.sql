DROP PROCEDURE IF EXISTS `user`.`getCompanySecurePublicKey`;
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `user`.`getCompanySecurePublicKey`(in companyId bigint)
BEGIN
select publicKey from `company_key_security` where id = companyId;
    
END$$
DELIMITER ;
