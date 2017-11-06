DROP PROCEDURE IF EXISTS `user`.`getCompanySecurePrivateKey`;
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `user`.`getCompanySecurePrivateKey`(in companyId bigint)
BEGIN
select privateKey from `company_key_security` where id = companyId;
END$$
DELIMITER ;
