DROP PROCEDURE IF EXISTS `keymanager`.`setKeys`;
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `keymanager`.`setKeys`(in idIn bigint(20), IN tableIn varchar(20), publicKeyIn text, privateKeyIn text)
BEGIN
	set @error = '';
	SET @userIdQry = CONCAT('SELECT COUNT(*) AS `count` INTO @count FROM ',tableIn,' where id =', idIn);
	PREPARE QUERY FROM @userIdQry;
        EXECUTE QUERY;
        DEALLOCATE PREPARE QUERY;
        IF @count < 1 THEN
		SET @userIdQry = CONCAT('INSERT INTO ',tableIn,' (id,publicKey,privateKey,insertDate) values(',idIn,',\'',publicKeyIn,'\',\'',privateKeyIn,'\',\'',UTC_TIMESTAMP,'\')');
		PREPARE QUERY FROM @userIdQry;
		EXECUTE QUERY;
		DEALLOCATE PREPARE QUERY;
        else
		set @error = 'Keys already exists';
        END IF;
        select @error as error;   
    END$$
DELIMITER ;
