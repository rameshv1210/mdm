DROP FUNCTION IF EXISTS `user`.`split`;
DELIMITER $$
CREATE DEFINER=`root`@`localhost` FUNCTION `split`(sStringIn TEXT,splitChar VARCHAR(1)) RETURNS text CHARSET latin1
    NO SQL
BEGIN
DECLARE comma INT DEFAULT 0;
DECLARE mylist TEXT DEFAULT sStringIn;
DECLARE temp TEXT DEFAULT '';
DECLARE strlen INT DEFAULT LENGTH(sStringIn);
DECLARE outtext TEXT(10000) DEFAULT '';
SET comma = LOCATE(splitChar,mylist);
SET outtext='';
WHILE strlen > 0 DO
IF comma = 0 THEN
SET temp = TRIM(mylist);
SET mylist = '';
SET strlen = 0;
END IF;
IF comma != 0 THEN
SET temp = TRIM(SUBSTRING(mylist,1,comma-1));
SET mylist = TRIM(SUBSTRING(mylist FROM comma+1));
SET strlen = LENGTH(mylist);
END IF;
IF temp != ''
THEN
SET outtext = CONCAT(outtext,' and Path not like ',CHAR(39),CHAR(37),temp,CHAR(37),CHAR(39));
END IF;
SET comma = LOCATE(splitChar,mylist);
END WHILE;
RETURN outtext;
END$$
DELIMITER ;
