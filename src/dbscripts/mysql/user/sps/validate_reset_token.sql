DROP PROCEDURE IF EXISTS `user`.`validate_reset_token`;
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `user`.`validate_reset_token`(IN `emailID` VARCHAR(255), IN `iniToken` VARCHAR(255))
BEGIN
	DECLARE default_diff INT DEFAULT 15;
	
	SELECT count(*), id into @count, @user_id FROM `user` WHERE email = emailID Limit 1;
	
	if (@count > 0) then
	
		SELECT COUNT(*), TIMESTAMPDIFF(MINUTE, expire_timestamp, CURRENT_TIMESTAMP) into @resetCount, @diff FROM user_reset_password WHERE user_id = @user_id and token = iniToken limit 1;
		
		IF (@resetCount > 0) THEN
			if (default_diff > @diff ) then
				SELECT "Success" AS result;
			else
				select "EXPIRED" as result;
			end if;
		else
			SELECT "Invalid" AS result;
		end if;
	else
		SELECT "Invalid" AS result;
	end if;
END$$
DELIMITER ;
