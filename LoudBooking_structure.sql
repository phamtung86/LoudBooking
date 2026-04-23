CREATE DATABASE  IF NOT EXISTS `loud_hotel` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `loud_hotel`;
-- MySQL dump 10.13  Distrib 8.0.42, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: loud_hotel
-- ------------------------------------------------------
-- Server version	9.3.0

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `bill_details`
--

DROP TABLE IF EXISTS `bill_details`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `bill_details` (
  `bill_detail_id` bigint NOT NULL AUTO_INCREMENT,
  `nights` int DEFAULT NULL,
  `old_price` double DEFAULT NULL,
  `subtotal` double DEFAULT NULL,
  `bill_id` bigint NOT NULL,
  `room_id` bigint DEFAULT NULL,
  `type_id` bigint DEFAULT NULL,
  PRIMARY KEY (`bill_detail_id`),
  KEY `FKfwm4sko9p82ndh6belyxx12bj` (`bill_id`),
  KEY `FKsbkfhslvh36wbyeq1osbtd23k` (`room_id`),
  KEY `FK4cvcod50iedw3lu7kuh000pht` (`type_id`),
  CONSTRAINT `FK4cvcod50iedw3lu7kuh000pht` FOREIGN KEY (`type_id`) REFERENCES `room_types` (`type_id`),
  CONSTRAINT `FKfwm4sko9p82ndh6belyxx12bj` FOREIGN KEY (`bill_id`) REFERENCES `bills` (`bill_id`),
  CONSTRAINT `FKsbkfhslvh36wbyeq1osbtd23k` FOREIGN KEY (`room_id`) REFERENCES `rooms` (`room_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `bills`
--

DROP TABLE IF EXISTS `bills`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `bills` (
  `bill_id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL,
  `hotel_id` bigint NOT NULL,
  `order_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `order_email` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `order_phone` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `check_in_date` date NOT NULL,
  `check_out_date` date NOT NULL,
  `actual_check_in_time` datetime DEFAULT NULL,
  `actual_check_out_time` datetime DEFAULT NULL,
  `total_cost` double DEFAULT NULL,
  `stay_status` enum('BOOKED','CHECKED_IN','COMPLETED','HOLD','CANCELED') COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `bill_status` enum('PENDING','PAID','CANCELED') COLLATE utf8mb4_unicode_ci NOT NULL,
  `payment_method` enum('CASH','VNPAY') COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `cancel_reason` enum('USER_CANCEL','HOTEL_CANCEL','NO_SHOW','VNPAY_CANCEL') COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `vnp_txn_ref` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `vnp_transaction_no` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `bill_code` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`bill_id`),
  KEY `fk_bill_user` (`user_id`),
  KEY `fk_bill_hotel` (`hotel_id`),
  CONSTRAINT `fk_bill_hotel` FOREIGN KEY (`hotel_id`) REFERENCES `hotels` (`hotel_id`),
  CONSTRAINT `fk_bill_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`),
  CONSTRAINT `chk_valid_dates` CHECK ((`check_out_date` > `check_in_date`))
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `chat_images`
--

DROP TABLE IF EXISTS `chat_images`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `chat_images` (
  `image_id` bigint NOT NULL AUTO_INCREMENT,
  `chat_id` bigint NOT NULL,
  `image_url` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`image_id`),
  KEY `fk_chat_image` (`chat_id`),
  CONSTRAINT `fk_chat_image` FOREIGN KEY (`chat_id`) REFERENCES `chat_messages` (`chat_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=174 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `chat_messages`
--

DROP TABLE IF EXISTS `chat_messages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `chat_messages` (
  `chat_id` bigint NOT NULL AUTO_INCREMENT,
  `conversation_id` bigint NOT NULL,
  `sender_id` bigint NOT NULL,
  `content_text` text COLLATE utf8mb4_unicode_ci,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`chat_id`),
  KEY `fk_chat_conversation` (`conversation_id`),
  KEY `fk_chat_sender` (`sender_id`),
  CONSTRAINT `fk_chat_conversation` FOREIGN KEY (`conversation_id`) REFERENCES `conversations` (`conversation_id`) ON DELETE CASCADE,
  CONSTRAINT `fk_chat_sender` FOREIGN KEY (`sender_id`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=299 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `conversations`
--

DROP TABLE IF EXISTS `conversations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `conversations` (
  `conversation_id` bigint NOT NULL AUTO_INCREMENT,
  `hotel_id` bigint NOT NULL,
  `user_id` bigint NOT NULL,
  `manager_id` bigint DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `last_message_at` datetime(6) DEFAULT NULL,
  `last_message_sender_id` bigint DEFAULT NULL,
  `unread_count_manager` int DEFAULT NULL,
  `unread_count_user` int DEFAULT NULL,
  PRIMARY KEY (`conversation_id`),
  UNIQUE KEY `uk_conversation` (`hotel_id`,`user_id`),
  UNIQUE KEY `UKb27qqtcufy7uuisb7xox23e4w` (`hotel_id`,`user_id`),
  KEY `fk_conversation_user` (`user_id`),
  KEY `fk_conversation_manager` (`manager_id`),
  CONSTRAINT `fk_conversation_hotel` FOREIGN KEY (`hotel_id`) REFERENCES `hotels` (`hotel_id`),
  CONSTRAINT `fk_conversation_manager` FOREIGN KEY (`manager_id`) REFERENCES `users` (`user_id`),
  CONSTRAINT `fk_conversation_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `hotel_images`
--

DROP TABLE IF EXISTS `hotel_images`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `hotel_images` (
  `image_id` bigint NOT NULL AUTO_INCREMENT,
  `created_at` datetime(6) DEFAULT NULL,
  `image_url` varchar(255) NOT NULL,
  `is_main` bit(1) DEFAULT NULL,
  `hotel_id` bigint NOT NULL,
  PRIMARY KEY (`image_id`),
  KEY `FK_hotel_images` (`hotel_id`),
  CONSTRAINT `FK_hotel_images` FOREIGN KEY (`hotel_id`) REFERENCES `hotels` (`hotel_id`)
) ENGINE=InnoDB AUTO_INCREMENT=136 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `hotels`
--

DROP TABLE IF EXISTS `hotels`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `hotels` (
  `hotel_id` bigint NOT NULL AUTO_INCREMENT,
  `address` varchar(255) DEFAULT NULL,
  `average_rating` double DEFAULT NULL,
  `created_at` datetime(6) DEFAULT NULL,
  `hotel_name` varchar(255) NOT NULL,
  `introduction` text,
  `hotel_status` enum('ACTIVE','INACTIVE','MAINTENANCE') DEFAULT NULL,
  `updated_at` datetime(6) DEFAULT NULL,
  `is_deleted` tinyint(1) DEFAULT '0',
  `manager_id` bigint DEFAULT NULL,
  `approval_status` enum('PENDING','APPROVED','REJECTED') DEFAULT NULL,
  `hotel_code` varchar(255) NOT NULL,
  PRIMARY KEY (`hotel_id`),
  KEY `FK_hotel_manager` (`manager_id`),
  CONSTRAINT `FK_hotel_manager` FOREIGN KEY (`manager_id`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=33 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `reviews`
--

DROP TABLE IF EXISTS `reviews`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `reviews` (
  `review_id` bigint NOT NULL AUTO_INCREMENT,
  `comment` text,
  `created_at` datetime(6) DEFAULT NULL,
  `rate` double DEFAULT NULL,
  `hotel_id` bigint NOT NULL,
  `user_id` bigint NOT NULL,
  `status` enum('ACTIVE','PENDING_HIDE','HIDDEN') DEFAULT 'ACTIVE',
  PRIMARY KEY (`review_id`),
  UNIQUE KEY `UK_user_hotel` (`user_id`,`hotel_id`),
  UNIQUE KEY `UK8o406x2md9iq7711vni73g261` (`user_id`,`hotel_id`),
  KEY `FK_review_hotel` (`hotel_id`),
  CONSTRAINT `FK_review_hotel` FOREIGN KEY (`hotel_id`) REFERENCES `hotels` (`hotel_id`) ON DELETE CASCADE,
  CONSTRAINT `FK_review_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`),
  CONSTRAINT `chk_rate_range` CHECK (((`rate` >= 0) and (`rate` <= 10)))
) ENGINE=InnoDB AUTO_INCREMENT=65 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `room_type_images`
--

DROP TABLE IF EXISTS `room_type_images`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `room_type_images` (
  `image_id` bigint NOT NULL AUTO_INCREMENT,
  `image_url` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `is_main` bit(1) DEFAULT NULL,
  `type_id` bigint DEFAULT NULL,
  `created_at` datetime(6) DEFAULT NULL,
  PRIMARY KEY (`image_id`),
  KEY `FKh5ppjdpf1hbet7xr9kqu74l2y` (`type_id`),
  CONSTRAINT `FKh5ppjdpf1hbet7xr9kqu74l2y` FOREIGN KEY (`type_id`) REFERENCES `room_types` (`type_id`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `room_types`
--

DROP TABLE IF EXISTS `room_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `room_types` (
  `type_id` bigint NOT NULL AUTO_INCREMENT,
  `capacity` int DEFAULT NULL,
  `created_at` datetime(6) DEFAULT NULL,
  `description` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `price` double DEFAULT NULL,
  `type_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `hotel_id` bigint DEFAULT NULL,
  `area` double DEFAULT NULL,
  `bed_count` int DEFAULT NULL,
  `bed_type` enum('SINGLE','DOUBLE','TWIN','QUEEN','KING') COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `is_deleted` tinyint(1) DEFAULT '0',
  `updated_at` datetime(6) DEFAULT NULL,
  PRIMARY KEY (`type_id`),
  KEY `FK42cc0t2sr43om89u1loqh7arj` (`hotel_id`),
  CONSTRAINT `FK42cc0t2sr43om89u1loqh7arj` FOREIGN KEY (`hotel_id`) REFERENCES `hotels` (`hotel_id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `rooms`
--

DROP TABLE IF EXISTS `rooms`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `rooms` (
  `room_id` bigint NOT NULL AUTO_INCREMENT,
  `created_at` datetime(6) DEFAULT NULL,
  `is_deleted` bit(1) DEFAULT NULL,
  `room_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `room_number` int DEFAULT NULL,
  `room_status` enum('ACTIVE','MAINTENANCE','INACTIVE') COLLATE utf8mb4_unicode_ci NOT NULL,
  `updated_at` datetime(6) DEFAULT NULL,
  `hotel_id` bigint NOT NULL,
  `type_id` bigint NOT NULL,
  PRIMARY KEY (`room_id`),
  KEY `FKp5lufxy0ghq53ugm93hdc941k` (`hotel_id`),
  KEY `FK36pnbgx5yxaalc346d0astj9s` (`type_id`),
  CONSTRAINT `FK36pnbgx5yxaalc346d0astj9s` FOREIGN KEY (`type_id`) REFERENCES `room_types` (`type_id`),
  CONSTRAINT `FKp5lufxy0ghq53ugm93hdc941k` FOREIGN KEY (`hotel_id`) REFERENCES `hotels` (`hotel_id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `user_id` bigint NOT NULL AUTO_INCREMENT,
  `created_at` datetime(6) DEFAULT NULL,
  `email` varchar(150) NOT NULL,
  `password` varchar(255) NOT NULL,
  `phone` varchar(20) NOT NULL,
  `refresh_token` text,
  `role` enum('ADMIN','MANAGER','USER') NOT NULL,
  `updated_at` datetime(6) DEFAULT NULL,
  `username` varchar(100) NOT NULL,
  `is_deleted` tinyint(1) DEFAULT '0',
  `deleted_at` datetime(6) DEFAULT NULL,
  `status` enum('ACTIVE','BLOCKED') DEFAULT 'ACTIVE',
  `first_name` varchar(100) DEFAULT NULL,
  `last_name` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `UK_email` (`email`),
  UNIQUE KEY `UK_phone` (`phone`),
  UNIQUE KEY `UK_username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=34 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `utilities`
--

DROP TABLE IF EXISTS `utilities`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `utilities` (
  `utilities_id` bigint NOT NULL AUTO_INCREMENT,
  `is_deleted` tinyint(1) DEFAULT '0',
  `utilities_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`utilities_id`),
  UNIQUE KEY `UK_so6ey20dm25han1b9ei93e330` (`utilities_name`)
) ENGINE=InnoDB AUTO_INCREMENT=33 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `utilities_hotel`
--

DROP TABLE IF EXISTS `utilities_hotel`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `utilities_hotel` (
  `hotel_id` bigint NOT NULL,
  `utilities_id` bigint NOT NULL,
  PRIMARY KEY (`hotel_id`,`utilities_id`),
  KEY `FKid1c7j06eybmri8rvmmvmo2ou` (`utilities_id`),
  CONSTRAINT `FKid1c7j06eybmri8rvmmvmo2ou` FOREIGN KEY (`utilities_id`) REFERENCES `utilities` (`utilities_id`),
  CONSTRAINT `FKik4htptkq4ip3ymbdh7biqyqp` FOREIGN KEY (`hotel_id`) REFERENCES `hotels` (`hotel_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `utilities_room_type`
--

DROP TABLE IF EXISTS `utilities_room_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `utilities_room_type` (
  `type_id` bigint NOT NULL,
  `utilities_id` bigint NOT NULL,
  PRIMARY KEY (`type_id`,`utilities_id`),
  KEY `FKogl81qs1gt6xsen801p1c98lc` (`utilities_id`),
  CONSTRAINT `FKb536eehs9ggu72nijnieunh5f` FOREIGN KEY (`type_id`) REFERENCES `room_types` (`type_id`),
  CONSTRAINT `FKogl81qs1gt6xsen801p1c98lc` FOREIGN KEY (`utilities_id`) REFERENCES `utilities` (`utilities_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping events for database 'loud_hotel'
--

--
-- Dumping routines for database 'loud_hotel'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-04-23 22:45:41
