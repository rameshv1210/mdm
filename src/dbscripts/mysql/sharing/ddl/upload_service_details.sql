DROP TABLE IF EXISTS `sharing`.`upload_service_details`;
CREATE TABLE `sharing`.`upload_service_details` (
  `id` bigint(20) NOT NULL COMMENT 'userId',
  `serviceId` int(2) DEFAULT NULL COMMENT '1-Box,2-Dropbox,3-Googledrive,4-Onedrive',
  `boxAccessToken` varchar(50) DEFAULT NULL,
  `boxRefreshToken` varchar(75) DEFAULT NULL,
  `boxExpiryDate` datetime DEFAULT NULL,
  `dropboxAccessToken` varchar(75) DEFAULT NULL,
  `dropboxRefreshToken` varchar(100) DEFAULT NULL,
  `googledriveAccessToken` varchar(75) DEFAULT NULL,
  `googledriveRefreshToken` varchar(100) DEFAULT NULL,
  `googledriveExpiryDate` datetime DEFAULT NULL,
  `onedriveAccessToken` text,
  `onedriveRefreshToken` text,
  `onedriveExpiryDate` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
