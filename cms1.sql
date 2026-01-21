-- Adminer 5.3.0 MariaDB 10.4.32-MariaDB dump

SET NAMES utf8;
SET time_zone = '+00:00';
SET foreign_key_checks = 0;
SET sql_mode = 'NO_AUTO_VALUE_ON_ZERO';

SET NAMES utf8mb4;

DROP TABLE IF EXISTS `client_tbl`;
CREATE TABLE `client_tbl` (
  `clientID` int(11) NOT NULL AUTO_INCREMENT,
  `clientName` varchar(45) NOT NULL,
  `companyName` varchar(45) NOT NULL,
  `phoneNo` int(12) NOT NULL,
  `email` varchar(45) DEFAULT NULL,
  `region` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`clientID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


DROP TABLE IF EXISTS `device_tbl`;
CREATE TABLE `device_tbl` (
  `dID` bigint(30) NOT NULL,
  `deviceName` varchar(45) NOT NULL,
  `status` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`dID`),
  UNIQUE KEY `dID` (`dID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


DROP VIEW IF EXISTS `fleet_summary`;
CREATE TABLE `fleet_summary` (`clientID` int(11), `clientName` varchar(45), `companyName` varchar(45), `region` varchar(30), `phoneNo` int(12), `email` varchar(45), `cost` double, `device` bigint(21));


DROP TABLE IF EXISTS `fleet_tbl`;
CREATE TABLE `fleet_tbl` (
  `No` int(11) NOT NULL AUTO_INCREMENT,
  `clientID` int(11) NOT NULL,
  `dID` bigint(30) NOT NULL,
  `simID` bigint(20) NOT NULL,
  `plateNo` varchar(30) NOT NULL,
  `cost` varchar(30) NOT NULL,
  `installDate` date NOT NULL,
  `comment` varchar(150) DEFAULT NULL,
  PRIMARY KEY (`No`),
  KEY `clientID` (`clientID`),
  KEY `dID` (`dID`),
  KEY `simID` (`simID`),
  CONSTRAINT `fleet_tbl_ibfk_1` FOREIGN KEY (`clientID`) REFERENCES `client_tbl` (`clientID`),
  CONSTRAINT `fleet_tbl_ibfk_7` FOREIGN KEY (`simID`) REFERENCES `simcard_tbl` (`simID`) ON UPDATE CASCADE,
  CONSTRAINT `fleet_tbl_ibfk_8` FOREIGN KEY (`dID`) REFERENCES `device_tbl` (`dID`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;


DROP VIEW IF EXISTS `fleet_view`;
CREATE TABLE `fleet_view` (`No` int(11), `clientID` int(11), `dID` bigint(30), `simID` bigint(20), `provider` varchar(45), `status` text, `clientName` varchar(45), `companyName` varchar(45), `phoneNo` int(12), `email` varchar(45), `plateNo` varchar(30), `cost` varchar(30), `installDate` date, `comment` varchar(150));


DROP VIEW IF EXISTS `fleet_view2`;
CREATE TABLE `fleet_view2` (`clientID` int(11), `dID` bigint(30), `simID` bigint(20), `provider` varchar(45), `companyName` varchar(45), `plateNo` varchar(30), `cost` varchar(30), `installDate` date, `comment` varchar(150));


DROP TABLE IF EXISTS `hosting_tbl`;
CREATE TABLE `hosting_tbl` (
  `hNo` int(11) NOT NULL AUTO_INCREMENT,
  `clientID` int(11) NOT NULL,
  `sID` int(11) NOT NULL,
  `costs` int(10) NOT NULL,
  `startDate` date NOT NULL,
  `description` varchar(100) NOT NULL,
  PRIMARY KEY (`hNo`),
  KEY `clientID` (`clientID`),
  KEY `sID` (`sID`),
  CONSTRAINT `hosting_tbl_ibfk_1` FOREIGN KEY (`clientID`) REFERENCES `client_tbl` (`clientID`),
  CONSTRAINT `hosting_tbl_ibfk_2` FOREIGN KEY (`sID`) REFERENCES `service_tbl` (`sID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


DROP VIEW IF EXISTS `hosting_view`;
CREATE TABLE `hosting_view` (`hNo` int(11), `clientID` int(11), `sID` int(11), `clientName` varchar(45), `serviceName` varchar(45), `costs` int(10), `startDate` date, `description` varchar(100));


DROP TABLE IF EXISTS `login_credentials`;
CREATE TABLE `login_credentials` (
  `id` int(11) NOT NULL,
  `username` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


DROP TABLE IF EXISTS `service_tbl`;
CREATE TABLE `service_tbl` (
  `sID` int(11) NOT NULL AUTO_INCREMENT,
  `serviceName` varchar(45) NOT NULL,
  PRIMARY KEY (`sID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


DROP TABLE IF EXISTS `simcard_tbl`;
CREATE TABLE `simcard_tbl` (
  `simID` bigint(20) NOT NULL,
  `iccdNo` varchar(30) DEFAULT NULL,
  `provider` varchar(45) NOT NULL,
  `status` text NOT NULL,
  `store` varchar(45) NOT NULL,
  PRIMARY KEY (`simID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


DROP TABLE IF EXISTS `user_tbl`;
CREATE TABLE `user_tbl` (
  `uID` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(20) NOT NULL,
  `password` varchar(20) NOT NULL,
  PRIMARY KEY (`uID`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


DROP TABLE IF EXISTS `fleet_summary`;
CREATE ALGORITHM=UNDEFINED DEFINER=`africake`@`localhost` SQL SECURITY DEFINER VIEW `fleet_summary` AS select `cms1`.`fleet_tbl`.`clientID` AS `clientID`,`cms1`.`client_tbl`.`clientName` AS `clientName`,`cms1`.`client_tbl`.`companyName` AS `companyName`,`cms1`.`client_tbl`.`region` AS `region`,`cms1`.`client_tbl`.`phoneNo` AS `phoneNo`,`cms1`.`client_tbl`.`email` AS `email`,sum(`cms1`.`fleet_tbl`.`cost`) AS `cost`,count(`cms1`.`device_tbl`.`dID`) AS `device` from ((`fleet_tbl` join `client_tbl` on(`cms1`.`client_tbl`.`clientID` = `cms1`.`fleet_tbl`.`clientID`)) join `device_tbl` on(`cms1`.`device_tbl`.`dID` = `cms1`.`fleet_tbl`.`dID`)) group by `cms1`.`fleet_tbl`.`clientID`;

DROP TABLE IF EXISTS `fleet_view`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `fleet_view` AS select `fleet_tbl`.`No` AS `No`,`fleet_tbl`.`clientID` AS `clientID`,`fleet_tbl`.`dID` AS `dID`,`fleet_tbl`.`simID` AS `simID`,`simcard_tbl`.`provider` AS `provider`,`simcard_tbl`.`status` AS `status`,`client_tbl`.`clientName` AS `clientName`,`client_tbl`.`companyName` AS `companyName`,`client_tbl`.`phoneNo` AS `phoneNo`,`client_tbl`.`email` AS `email`,`fleet_tbl`.`plateNo` AS `plateNo`,`fleet_tbl`.`cost` AS `cost`,`fleet_tbl`.`installDate` AS `installDate`,`fleet_tbl`.`comment` AS `comment` from (((`fleet_tbl` join `client_tbl` on(`client_tbl`.`clientID` = `fleet_tbl`.`clientID`)) join `device_tbl` on(`device_tbl`.`dID` = `fleet_tbl`.`dID`)) join `simcard_tbl` on(`simcard_tbl`.`simID` = `fleet_tbl`.`simID`));

DROP TABLE IF EXISTS `fleet_view2`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `fleet_view2` AS select `fleet_tbl`.`clientID` AS `clientID`,`fleet_tbl`.`dID` AS `dID`,`fleet_tbl`.`simID` AS `simID`,`simcard_tbl`.`provider` AS `provider`,`client_tbl`.`companyName` AS `companyName`,`fleet_tbl`.`plateNo` AS `plateNo`,`fleet_tbl`.`cost` AS `cost`,`fleet_tbl`.`installDate` AS `installDate`,`fleet_tbl`.`comment` AS `comment` from (((`fleet_tbl` join `client_tbl` on(`client_tbl`.`clientID` = `fleet_tbl`.`clientID`)) join `device_tbl` on(`device_tbl`.`dID` = `fleet_tbl`.`dID`)) join `simcard_tbl` on(`simcard_tbl`.`simID` = `fleet_tbl`.`simID`));

DROP TABLE IF EXISTS `hosting_view`;
CREATE ALGORITHM=UNDEFINED DEFINER=`africake`@`localhost` SQL SECURITY DEFINER VIEW `hosting_view` AS select `cms1`.`hosting_tbl`.`hNo` AS `hNo`,`cms1`.`hosting_tbl`.`clientID` AS `clientID`,`cms1`.`hosting_tbl`.`sID` AS `sID`,`cms1`.`client_tbl`.`clientName` AS `clientName`,`cms1`.`service_tbl`.`serviceName` AS `serviceName`,`cms1`.`hosting_tbl`.`costs` AS `costs`,`cms1`.`hosting_tbl`.`startDate` AS `startDate`,`cms1`.`hosting_tbl`.`description` AS `description` from ((`hosting_tbl` join `client_tbl` on(`cms1`.`client_tbl`.`clientID` = `cms1`.`hosting_tbl`.`clientID`)) join `service_tbl` on(`cms1`.`service_tbl`.`sID` = `cms1`.`hosting_tbl`.`sID`));

-- 2025-09-18 09:54:35 UTC
