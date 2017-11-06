DROP TABLE IF EXISTS `file_upload`.`file_upload`;
CREATE TABLE `file_upload`.`file_upload`.`file_upload` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `uploader_firstname` varchar(50) NOT NULL,
  `uploader_lastname` varchar(50) NOT NULL,
  `uploader_email` varchar(50) NOT NULL,
  `location` varchar(50) NOT NULL,
  `receiver_id` bigint(20) DEFAULT NULL,
  `file_name` varchar(50) DEFAULT NULL,
  `upload_datetime` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=58 DEFAULT CHARSET=utf8;
