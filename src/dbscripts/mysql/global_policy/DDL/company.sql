DELIMITER //
USE global_policy//
DROP TABLE IF EXISTS `company`//

CREATE TABLE `company` (
  `company_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'PK for Company table.',
  `company_guid` char(36) NOT NULL,
  `company_name` varchar(100) NOT NULL,
  `GroupTableName` VARCHAR(50) NULL,
  `FeDeviceTableName` VARCHAR(50) NULL,
  `FePolicyTableName` VARCHAR(50) NULL,
  `MdmPolicyTableName` VARCHAR(50) NULL,
  `AndAppListTableName` VARCHAR(50) NULL,
  `AndDevInfoTableName` VARCHAR(50) NULL,
  `CommandTableName` VARCHAR(50) NULL,
  `DeviceTableName` VARCHAR(50) NULL,
  `iOsAppListTableName` VARCHAR(50) NULL,
  `iOsCertListTableName` VARCHAR(50) NULL,
  `iOsDevInfoTableName` VARCHAR(50) NULL,
  `iOsProfListTableName` VARCHAR(50) NULL,
  `iOsProvProfTableName` VARCHAR(50) NULL,
  `iOsSecInfoTableName` VARCHAR(50) NULL,
  `created_datetime` datetime NOT NULL,
  `deleted` bool DEFAULT NULL,
  `modified_datetime` datetime DEFAULT NULL,
  PRIMARY KEY (`company_id`),
  UNIQUE KEY `company_guid` (`company_guid`)
) ENGINE=InnoDB AUTO_INCREMENT=1000000001 DEFAULT CHARSET=utf8//
DELIMITER ;
