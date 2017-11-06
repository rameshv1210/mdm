DELIMITER $$

USE `user`$$

DROP PROCEDURE IF EXISTS `user`.`sp_getCompanyUsers`$$

CREATE
    /*[DEFINER = { user | CURRENT_USER }]*/
    PROCEDURE `user`.`sp_getCompanyUsers`(IN `companyGuid` CHAR(36))
    /*LANGUAGE SQL
    | [NOT] DETERMINISTIC
    | { CONTAINS SQL | NO SQL | READS SQL DATA | MODIFIES SQL DATA }
    | SQL SECURITY { DEFINER | INVOKER }
    | COMMENT 'string'*/
	BEGIN
		SELECT
			`id`, `first_name`, `last_name`, `email`, `company_guid`, `groupId`,
			`account_status`, `created`
		FROM
			`user`
		WHERE
			`company_guid` = companyGuid;
	END$$

DELIMITER ;