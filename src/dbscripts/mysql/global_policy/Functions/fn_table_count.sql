DELIMITER //
USE global_policy//
DROP FUNCTION IF EXISTS `fn_table_count`//
CREATE FUNCTION `fn_table_count` (
	inSchema VARCHAR(50),
    inTable VARCHAR(50)
)
RETURNS INT
BEGIN
	/*
	--Revision History 
	---------------------------------------------------------------------------------------------------------------/
	--Author		RELEASE		DATE			DESCRIPTION
	---------------------------------------------------------------------------------------------------------------/
    --Karthik		1.0			Apr/20/2017		Created to return count of tables matching supplied name.
	---------------------------------------------------------------------------------------------------------------/
    */
	SET @count = 0;
	SELECT
		count(*)
	INTO
		@count
	FROM
		`information_schema`.`TABLES`
	WHERE
		`TABLE_SCHEMA` = inSchema
        AND `TABLE_NAME` = inTable;
	RETURN @count;
END//
DELIMITER ;
