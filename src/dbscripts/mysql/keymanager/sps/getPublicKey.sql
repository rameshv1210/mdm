DROP PROCEDURE IF EXISTS `keymanager`.`getPublicKey`;
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `keymanager`.`getPublicKey`(IN companyIdIn BIGINT, userIdIn BIGINT, userEmail VARCHAR(100))
BEGIN
        SET @userId = 0;
        SET @publicKey = '';
        SET @error = '';
	IF companyIdIn = 0 THEN
		IF userIdIn = 0 THEN
			SELECT id INTO @userId FROM user.user WHERE email = userEmail;
			IF @userId = 0 THEN
				SELECT 'No user exists' INTO @error;
			ELSE
				SELECT publicKey INTO @publicKey FROM `userkey` WHERE id = @userId;
				IF @publicKey = '' THEN
					SELECT 'No user key' INTO  @error;
				END IF;	
			END IF;	
		ELSE 
			SELECT publicKey INTO @publicKey FROM `userkey` WHERE id = userIdIn;
				IF @publicKey = '' THEN
					SELECT 'No user key' INTO  @error;
				END IF;
		END IF;	
	ELSE
		SELECT publicKey INTO @publicKey FROM `companykey` WHERE id = companyIdIn;
		IF @publicKey = '' THEN
			SELECT 'No company key' INTO  @error;
		END IF;
	END IF;
	SELECT @error AS error, @publicKey AS publicKey, @userId AS userId;
    END$$
DELIMITER ;
