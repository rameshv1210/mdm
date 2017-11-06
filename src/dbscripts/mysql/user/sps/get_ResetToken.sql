DROP PROCEDURE IF EXISTS `user`.`get_ResetToken`;
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `user`.`get_ResetToken`(IN `emailID` VARCHAR(255), IN `iniToken` VARCHAR(255))
BEGIN
	DECLARE default_diff INT DEFAULT 14;
	
	SELECT count(*), id into @count, @user_id FROM `user` WHERE email = emailID Limit 1;
	
	if (@count > 0) then
	
		SELECT token, COUNT(*), TIMESTAMPDIFF(MINUTE, expire_timestamp, CURRENT_TIMESTAMP) into @oldToken, @resetCount, @diff FROM user_reset_password WHERE user_id = @user_id limit 1;
		
		IF (@resetCount > 0) THEN
			if (default_diff < @diff ) or ( @oldToken = '') then
				update user_reset_password set token = iniToken, expire_timestamp = current_timestamp where user_id = @user_id;
			else
				select "NOT_REQUIRED" as token;
			end if;
		else
			Insert into user_reset_password (user_id, token, expire_timestamp) values (@user_id, iniToken, CURRENT_TIMESTAMP);
		end if;
		select iniToken as token;
	else
		SELECT "Invalid" AS token;
	end if;
END$$
DELIMITER ;
