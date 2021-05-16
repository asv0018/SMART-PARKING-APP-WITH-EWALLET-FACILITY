-- phpMyAdmin SQL Dump
-- version 4.7.1
-- https://www.phpmyadmin.net/
--
-- Host: sql6.freesqldatabase.com:3306	
-- Generation Time: May 16, 2021 at 09:52 PM
-- Server version: 5.5.62-0ubuntu0.14.04.1
-- PHP Version: 7.0.33-0ubuntu0.16.04.16

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `sql6412573`
--
CREATE DATABASE IF NOT EXISTS `sql6412573` DEFAULT CHARACTER SET latin1 COLLATE latin1_swedish_ci;
USE `sql6412573`;

-- --------------------------------------------------------

--
-- Table structure for table `all_transaction_details`
--

CREATE TABLE `all_transaction_details` (
  `slno` int(4) NOT NULL,
  `uuid` varchar(50) DEFAULT NULL,
  `datetime` varchar(20) DEFAULT NULL,
  `occupiedslot` varchar(10) DEFAULT NULL,
  `starttime` varchar(20) DEFAULT NULL,
  `endtime` varchar(20) DEFAULT NULL,
  `bill` float DEFAULT NULL,
  `balance` float DEFAULT NULL,
  `transactdatetime` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `all_transaction_details`
--

INSERT INTO `all_transaction_details` (`slno`, `uuid`, `datetime`, `occupiedslot`, `starttime`, `endtime`, `bill`, `balance`, `transactdatetime`) VALUES
(5, '60f129c8-b3df-11eb-b149-8c164576dc29', '14/05/2021 21:52:38', 'Slot 1', NULL, '14/05/2021 21:52:38', 40, 4545, '14/05/2021 21:52:38'),
(6, '60f129c8-b3df-11eb-b149-8c164576dc29', '14/05/2021 21:54:58', 'Slot 1', '14/05/2021', '14/05/2021 21:54:57', 40, 4505, '14/05/2021 21:54:58'),
(7, '60f129c8-b3df-11eb-b149-8c164576dc29', '14/05/2021 21:57:50', 'Slot 1', '14/05/2021 21:57:45', '14/05/2021 21:57:49', 40, 4465, '14/05/2021 21:57:50'),
(8, '60f129c8-b3df-11eb-b149-8c164576dc29', '14/05/2021 21:59:25', 'Slot 2', '14/05/2021 21:59:19', '14/05/2021 21:59:25', 40, 4425, '14/05/2021 21:59:25'),
(9, '60f129c8-b3df-11eb-b149-8c164576dc29', '14/05/2021 22:00:29', 'Slot 1', '14/05/2021 22:00:26', '14/05/2021 22:00:29', 40, 4385, '14/05/2021 22:00:29'),
(10, '60f129c8-b3df-11eb-b149-8c164576dc29', '15/05/2021 15:29:42', 'Slot 1', '15/05/2021 15:29:36', '15/05/2021 15:29:42', 40, 4345, '15/05/2021 15:29:42'),
(11, '60f129c8-b3df-11eb-b149-8c164576dc29', '15/05/2021 22:03:15', 'Slot 1', '15/05/2021 18:20:43', '15/05/2021 22:03:15', 56.5, 4288.5, '15/05/2021 22:03:15'),
(12, '60f129c8-b3df-11eb-b149-8c164576dc29', '15/05/2021 22:18:15', 'Slot 1', '15/05/2021 22:15:55', '15/05/2021 22:18:15', 41, 4247.5, '15/05/2021 22:18:15'),
(13, '39eaec1e-b61e-11eb-b5f5-02470107fa5f', '16/05/2021 15:01:47', 'Slot 1', '16/05/2021 14:45:13', '16/05/2021 15:01:47', 40, 460, '16/05/2021 15:01:47'),
(14, '39eaec1e-b61e-11eb-b5f5-02470107fa5f', '16/05/2021 17:12:37', 'Slot 1', '16/05/2021 15:04:51', '16/05/2021 17:12:37', 40, 420, '16/05/2021 17:12:37'),
(15, '39eaec1e-b61e-11eb-b5f5-02470107fa5f', '17/05/2021 02:27:47', 'Slot 1', '16/05/2021 17:13:15', '17/05/2021 02:27:47', -403, 823, '17/05/2021 02:27:47'),
(16, '39eaec1e-b61e-11eb-b5f5-02470107fa5f', '17/05/2021 02:50:35', 'Slot 1', '17/05/2021 02:47:33', '17/05/2021 02:50:35', 41.5, 781.5, '17/05/2021 02:50:35'),
(17, '39eaec1e-b61e-11eb-b5f5-02470107fa5f', '17/05/2021 02:51:50', 'Slot 1', '17/05/2021 02:51:05', '17/05/2021 02:51:50', 40, 741.5, '17/05/2021 02:51:50');

-- --------------------------------------------------------

--
-- Table structure for table `slot_database_details`
--

CREATE TABLE `slot_database_details` (
  `slno` int(3) NOT NULL,
  `slotname` varchar(10) NOT NULL,
  `occupieduuid` varchar(100) DEFAULT NULL,
  `orderedtime` varchar(30) DEFAULT NULL,
  `startdatetime` varchar(40) DEFAULT NULL,
  `currentbill` double DEFAULT NULL,
  `status` varchar(15) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `slot_database_details`
--

INSERT INTO `slot_database_details` (`slno`, `slotname`, `occupieduuid`, `orderedtime`, `startdatetime`, `currentbill`, `status`) VALUES
(1, 'Slot 1', NULL, NULL, NULL, NULL, 'AVAILABLE'),
(2, 'Slot 2', NULL, NULL, NULL, NULL, 'AVAILABLE'),
(3, 'Slot 3', NULL, NULL, NULL, NULL, 'RESERVED'),
(4, 'Slot 4', NULL, NULL, NULL, NULL, 'MAINTANANCE'),
(5, 'Slot 5', NULL, NULL, NULL, NULL, 'MAINTANANCE'),
(6, 'Slot 6', NULL, NULL, NULL, NULL, 'RESERVED'),
(7, 'Slot 7', NULL, NULL, NULL, NULL, 'RESERVED'),
(8, 'Slot 8', NULL, NULL, NULL, NULL, 'MAINTANANCE'),
(9, 'Slot 9', NULL, NULL, NULL, NULL, 'RESERVED'),
(10, 'Slot 10', NULL, NULL, NULL, NULL, 'MAINTANANCE'),
(11, 'Slot 11', NULL, NULL, NULL, NULL, 'MAINTANANCE'),
(12, 'Slot 12', NULL, NULL, NULL, NULL, 'MAINTANANCE');

-- --------------------------------------------------------

--
-- Table structure for table `smart-parking-bank-account-with-transactions`
--

CREATE TABLE `smart-parking-bank-account-with-transactions` (
  `slno` int(255) NOT NULL,
  `date_time` varchar(50) NOT NULL,
  `from_account` varchar(50) NOT NULL,
  `to_account` varchar(50) NOT NULL,
  `amount_credited` double NOT NULL,
  `closing_balance` double NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `smart-parking-bank-account-with-transactions`
--

INSERT INTO `smart-parking-bank-account-with-transactions` (`slno`, `date_time`, `from_account`, `to_account`, `amount_credited`, `closing_balance`) VALUES
(4, '11/12/12 12:33:23', 'SELF', '121112122212G', 0, 0),
(5, '14/05/2021 21:57:50', '60f129c8-b3df-11eb-b149-8c164576dc29', '121112122212G', 40, 40),
(6, '14/05/2021 21:59:25', '60f129c8-b3df-11eb-b149-8c164576dc29', '121112122212G', 40, 80),
(7, '14/05/2021 22:00:29', '60f129c8-b3df-11eb-b149-8c164576dc29', '121112122212G', 40, 120),
(8, '15/05/2021 15:29:42', '60f129c8-b3df-11eb-b149-8c164576dc29', '121112122212G', 40, 160),
(9, '15/05/2021 22:03:15', '60f129c8-b3df-11eb-b149-8c164576dc29', '121112122212G', 56.5, 216.5),
(10, '15/05/2021 22:18:15', '60f129c8-b3df-11eb-b149-8c164576dc29', '121112122212G', 41, 257.5),
(11, '16/05/2021 15:01:47', '39eaec1e-b61e-11eb-b5f5-02470107fa5f', '121112122212G', 40, 297.5),
(12, '16/05/2021 17:12:37', '39eaec1e-b61e-11eb-b5f5-02470107fa5f', '121112122212G', 40, 337.5),
(13, '17/05/2021 02:27:47', '39eaec1e-b61e-11eb-b5f5-02470107fa5f', '121112122212G', -403, -65.5),
(14, '17/05/2021 02:50:35', '39eaec1e-b61e-11eb-b5f5-02470107fa5f', '121112122212G', 41.5, -24),
(15, '17/05/2021 02:51:50', '39eaec1e-b61e-11eb-b5f5-02470107fa5f', '121112122212G', 40, 16);

-- --------------------------------------------------------

--
-- Table structure for table `user_database`
--

CREATE TABLE `user_database` (
  `slno` bigint(255) NOT NULL,
  `uuid` varchar(100) NOT NULL,
  `name` varchar(32) NOT NULL,
  `email` varchar(50) NOT NULL,
  `password` varchar(100) NOT NULL,
  `current_balance` double NOT NULL,
  `wallet_pin` varchar(4) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `user_database`
--

INSERT INTO `user_database` (`slno`, `uuid`, `name`, `email`, `password`, `current_balance`, `wallet_pin`) VALUES
(5, 'f259727d-b3db-11eb-b149-8c164576dc29', 'shreevallabhapoop sharma', 'shreevallabhooael@gmail.com', '$5$rounds=535000$TqExeUKnmuWP0ype$wb3cAX/hLV542cGE2g7CdnmtCqSfV0e8E7huPpO6hWD', 666, '$5$r'),
(6, '4b9a0dba-b3dc-11eb-b149-8c164576dc29', 'shreevallabhapoop sharma', 'shreevallaopkbhooael@gmail.com', '$5$rounds=535000$hcAAsSzyCD.2YQ1f$ktRNCzLeKgI0/SGG3F5Md5ZvZe82W9JAmPU3.XTfE79', 666, '$5$r'),
(7, '60f129c8-b3df-11eb-b149-8c164576dc29', 'prathyusaha sastry', 'prathyu@gmail.com', '$5$rounds=535000$H0.Tkmy/sXPy1pJw$xqLPXgeIjB1p/.2vcoDhDdjkFvf1Lne4Mu77a5My4NB', 4247.5, '$5$r'),
(8, 'dfe73354-b562-11eb-b5f5-02470107fa5f', 'Sherlie Khan', 'she@gmail.com', '$5$rounds=535000$yKLamGty.zs8Fw2O$OQYoVmVFL/27FcJxuXr9FSbuTYCfuxL1TkjlR8ahyr9', 556000, '1231'),
(9, '0868fc77-b563-11eb-b5f5-02470107fa5f', 'Sherlie Joshed', 'sha@gmail.com', '$5$rounds=535000$SgIwrgahgEHiVd.0$Jpf3FXLzyEjigzgAkusGGFu0UfL34tUUznQJP2SouYA', 56000, '1111'),
(10, '39eaec1e-b61e-11eb-b5f5-02470107fa5f', 'chikitha Reddy', 'chikitha@gmail.com', '$5$rounds=535000$50DU1dfMh47gRVwr$orWpREeBcCDllxoFKaG56KPLOWDFETI7FERcENUyaT8', 741.5, '1996');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `all_transaction_details`
--
ALTER TABLE `all_transaction_details`
  ADD PRIMARY KEY (`slno`);

--
-- Indexes for table `slot_database_details`
--
ALTER TABLE `slot_database_details`
  ADD PRIMARY KEY (`slno`);

--
-- Indexes for table `smart-parking-bank-account-with-transactions`
--
ALTER TABLE `smart-parking-bank-account-with-transactions`
  ADD PRIMARY KEY (`slno`);

--
-- Indexes for table `user_database`
--
ALTER TABLE `user_database`
  ADD PRIMARY KEY (`slno`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `all_transaction_details`
--
ALTER TABLE `all_transaction_details`
  MODIFY `slno` int(4) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;
--
-- AUTO_INCREMENT for table `slot_database_details`
--
ALTER TABLE `slot_database_details`
  MODIFY `slno` int(3) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;
--
-- AUTO_INCREMENT for table `smart-parking-bank-account-with-transactions`
--
ALTER TABLE `smart-parking-bank-account-with-transactions`
  MODIFY `slno` int(255) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;
--
-- AUTO_INCREMENT for table `user_database`
--
ALTER TABLE `user_database`
  MODIFY `slno` bigint(255) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
