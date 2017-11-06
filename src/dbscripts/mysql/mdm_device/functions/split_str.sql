DROP FUNCTION IF EXISTS `mdm_device`.`split_str`;
DELIMITER $$
CREATE DEFINER=`root`@`223.30.196.78` FUNCTION `mdm_device`.`split_str`(X text, delim VARCHAR(12), pos INT) RETURNS varchar(255) CHARSET utf8 COLLATE utf8_unicode_ci
RETURN REPLACE(SUBSTRING(SUBSTRING_INDEX(X, delim, pos),
	       LENGTH(SUBSTRING_INDEX(X, delim, pos -1)) + 1),
	       delim, '')$$
DELIMITER ;
