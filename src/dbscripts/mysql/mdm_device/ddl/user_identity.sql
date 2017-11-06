DROP TABLE IF EXISTS `mdm_device`.`user_identity`;
CREATE TABLE `mdm_device`.`user_identity` (
  `user_id` bigint(20) NOT NULL,
  `identity_certificate` text COLLATE utf8_unicode_ci NOT NULL,
  `serial_number` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `created_timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
