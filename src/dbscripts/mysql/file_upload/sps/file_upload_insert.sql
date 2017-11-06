DROP PROCEDURE IF EXISTS `file_upload`.`file_upload_insert`;
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `file_upload`.`file_upload_insert`(IN fName varchar(50), lName VARCHAR(50), email VARCHAR(50),loc VARCHAR(50), rId BIGINT, fn VARCHAR(50))
BEGIN
insert into `file_upload`(uploader_firstname,uploader_lastname,uploader_email,location, receiver_id, file_name, upload_datetime) 
values (fName, lName, email, loc, rId, fn, UTC_TIMESTAMP);
    END$$
DELIMITER ;
