DROP PROCEDURE IF EXISTS `user`.`getCompanyPrivateKey`;
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `user`.`getCompanyPrivateKey`(in companyId bigint)
BEGIN
select privateKey from `company_key_security` where id = companyId;
    END$$
DELIMITER ;
