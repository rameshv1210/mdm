DROP PROCEDURE IF EXISTS `keymanager`.`getKey`;
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `keymanager`.`getKey`(in companyIdIn bigint, userId BIGINT)
BEGIN
        set @userExist = 0;
        set @publicKey = '';
        SET @privateKey = '';
        set @error = '';
	if companyIdIn = 0 then
		select id into @userExist from user.user where id = userId;
		if @userExist = 0 then
			select 'No user exists' into @error;
		else
			SELECT publicKey, privateKey INTO @publicKey, @privateKey FROM `userkey` WHERE id = userId;
			IF (@publicKey = '' AND @privateKey = '') THEN
				select 'No user key' into  @error;
			END IF;	
		end if;	
	else
		select publicKey, privateKey into @publicKey, @privateKey from `companykey` where id = companyIdIn;
		IF (@publicKey = '' and @privateKey = '') THEN
			sELECT 'No company key' INTO  @error;
		END IF;
	end if;
	select @error as error, @publicKey as publicKey, @privateKey as privateKey, @userId as userId;
    END$$
DELIMITER ;
