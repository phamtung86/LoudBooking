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
-- Dumping data for table `bill_details`
--

LOCK TABLES `bill_details` WRITE;
/*!40000 ALTER TABLE `bill_details` DISABLE KEYS */;
/*!40000 ALTER TABLE `bill_details` ENABLE KEYS */;
UNLOCK TABLES;

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
-- Dumping data for table `bills`
--

LOCK TABLES `bills` WRITE;
/*!40000 ALTER TABLE `bills` DISABLE KEYS */;
INSERT INTO `bills` VALUES (1,2,2,'','','','2026-04-15','2026-04-19',NULL,NULL,88000000,'CANCELED','CANCELED','CASH','HOTEL_CANCEL',NULL,NULL,'2026-04-15 00:33:57','2026-04-15 01:56:00',''),(2,2,2,'an','northloud08@gmail.com','0123456789','2026-04-16','2026-04-17',NULL,NULL,9000000,'CANCELED','CANCELED','CASH','USER_CANCEL',NULL,NULL,'2026-04-15 00:47:29','2026-04-15 01:07:11',''),(3,2,2,'an','northloud08@gmail.com','0123456789','2026-04-15','2026-04-19',NULL,NULL,48000000,'BOOKED','PAID','CASH',NULL,NULL,NULL,'2026-04-15 01:14:06','2026-04-15 22:11:13',''),(4,2,4,'an','northloud08@gmail.com','0123456789','2026-04-15','2026-04-16','2026-04-15 18:29:08',NULL,8000000,'CHECKED_IN','PAID','CASH',NULL,NULL,NULL,'2026-04-15 01:59:02','2026-04-15 18:29:08',''),(5,3,2,'binh','binh@gmail.com','0369852147','2026-04-15','2026-04-16','2026-04-15 18:28:58',NULL,12000000,'CHECKED_IN','PAID','VNPAY',NULL,'ad36d19066fc4e7090171a19dd058c04','15497382','2026-04-15 13:32:15','2026-04-15 18:28:58',''),(6,3,2,'binh','binh@gmail.com','0369852147','2026-04-15','2026-04-16',NULL,NULL,3000000,'CANCELED','CANCELED','VNPAY','VNPAY_CANCEL','cf497e437b524ec6bf5a7cd569d80b87',NULL,'2026-04-15 13:34:24','2026-04-15 13:35:44',''),(7,32,2,'bac','bac@gmail.com','0369852140','2026-04-15','2026-04-16',NULL,NULL,10000000,'CANCELED','CANCELED','VNPAY','VNPAY_CANCEL','86531302768b46849c2a96605db1eecb',NULL,'2026-04-15 22:01:05','2026-04-15 22:02:11','BLB2026041576239'),(8,32,2,'bac','nls08082004@gmail.com','0369852140','2026-04-15','2026-04-16','2026-04-15 22:13:23','2026-04-20 15:47:59',10000000,'COMPLETED','PAID','CASH',NULL,NULL,NULL,'2026-04-15 22:03:04','2026-04-20 15:47:59','BLB2026041526530'),(9,32,2,'bac','nls08082004@gmail.com','0369852140','2026-04-16','2026-04-17','2026-04-20 15:47:43','2026-04-20 15:47:47',12000000,'COMPLETED','PAID','VNPAY',NULL,'4ef00f9858664a159020955ae9fb8020','15498300','2026-04-15 22:03:24','2026-04-20 15:47:47','BLB2026041565097'),(10,32,2,'bac','nls08082004@gmail.com','0369852140','2026-04-16','2026-04-17','2026-04-20 15:47:53','2026-04-20 15:47:56',3000000,'COMPLETED','PAID','CASH',NULL,NULL,NULL,'2026-04-15 22:06:17','2026-04-20 15:47:56','BLB2026041565982');
/*!40000 ALTER TABLE `bills` ENABLE KEYS */;
UNLOCK TABLES;

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
-- Dumping data for table `chat_images`
--

LOCK TABLES `chat_images` WRITE;
/*!40000 ALTER TABLE `chat_images` DISABLE KEYS */;
INSERT INTO `chat_images` VALUES (149,281,'/images/chat/1775653000030_0bba34f1-979c-4df2-9ded-372fea40ad3c.jpeg'),(150,281,'/images/chat/1775653000033_0fefd873-7fcb-467a-9678-207e2a225f6b.jpeg'),(151,281,'/images/chat/1775653000034_1d8d48e9-19e6-4a9c-bda1-1f0d356d07dd.jpeg'),(152,281,'/images/chat/1775653000035_1e2f5b73-20de-4c02-96f7-d524ffac3ec9.jpeg'),(153,282,'/images/chat/1775653025796_0d56f4f8-c9cb-4383-a28a-1876be65185c.jpeg'),(154,282,'/images/chat/1775653025797_0dd12298-ec7f-4637-a096-fab9a03c9ab6.jpeg'),(155,282,'/images/chat/1775653025798_1c545a74-11e1-4f6a-a190-f46f8588a5ee.jpeg'),(156,282,'/images/chat/1775653025799_2a13b312-d6f3-44e9-bf08-bbf0341afab9.jpeg'),(157,283,'/images/chat/1775751278854_2f53aec2-f220-41bd-a5f5-c70f229d2bb4.jpeg'),(158,283,'/images/chat/1775751278859_3a182879-e6e6-4024-b21e-465e55e53adc.jpeg'),(159,283,'/images/chat/1775751278860_3b569d11-9531-457c-bdf7-8cddd57400a9.jpeg'),(160,283,'/images/chat/1775751278860_5d4ab75a-9482-4185-bba1-a987ab375023.jpeg'),(161,283,'/images/chat/1775751278861_6b03f3e8-e949-433e-811b-2c043a11f29b.jpeg'),(162,283,'/images/chat/1775751278862_6c2251ae-9754-428d-87e8-c8965804e57c.jpeg'),(163,283,'/images/chat/1775751278862_6e4d33ea-0552-4950-b9cb-5d2c05d9694b.jpeg'),(164,284,'/images/chat/1775751312728_3e7389b6-b0c0-4c2d-8898-73a984ab364d.jpeg'),(165,284,'/images/chat/1775751312730_4a2c3bea-8ea5-452b-9741-69d45a97cccd.jpeg'),(166,284,'/images/chat/1775751312730_4a21bea1-68c4-4198-ae99-91a4f8ee4823.jpeg'),(167,286,'/images/chat/1775827611890_6c2a324c-ffa6-4dd0-9196-11719a76aadf.jpeg'),(168,287,'/images/chat/1776165024039_3e7389b6-b0c0-4c2d-8898-73a984ab364d.jpeg'),(169,287,'/images/chat/1776165024045_4a2c3bea-8ea5-452b-9741-69d45a97cccd.jpeg'),(170,287,'/images/chat/1776165024046_4a21bea1-68c4-4198-ae99-91a4f8ee4823.jpeg'),(171,288,'/images/chat/1776165075819_3e7389b6-b0c0-4c2d-8898-73a984ab364d.jpeg'),(172,288,'/images/chat/1776165075820_4a2c3bea-8ea5-452b-9741-69d45a97cccd.jpeg'),(173,291,'/images/chat/1776174326075_3e7389b6-b0c0-4c2d-8898-73a984ab364d.jpeg');
/*!40000 ALTER TABLE `chat_images` ENABLE KEYS */;
UNLOCK TABLES;

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
-- Dumping data for table `chat_messages`
--

LOCK TABLES `chat_messages` WRITE;
/*!40000 ALTER TABLE `chat_messages` DISABLE KEYS */;
INSERT INTO `chat_messages` VALUES (1,1,3,'Xin chào, tôi muốn hỏi về phòng','2026-04-01 18:10:11'),(2,1,22,'Chào bạn, bạn cần hỗ trợ gì?','2026-04-01 18:10:11'),(3,2,3,'Khách sạn còn phòng không?','2026-04-01 18:10:11'),(4,1,3,'chào bạn','2026-04-01 19:41:39'),(80,2,3,'ok','2026-04-02 21:59:32'),(81,2,22,'có','2026-04-02 22:03:35'),(82,2,3,'ok','2026-04-02 22:03:46'),(83,7,2,'xin chào','2026-04-02 22:17:11'),(84,8,2,'chào bạn','2026-04-02 22:17:31'),(85,12,2,'tôi muốn hỏi','2026-04-02 22:19:50'),(195,7,22,'lo','2026-04-03 12:58:34'),(196,1,22,'pl','2026-04-03 12:58:37'),(197,9,22,'pl','2026-04-03 12:58:41'),(198,2,22,'pl','2026-04-03 12:58:44'),(199,10,22,'ik','2026-04-03 12:58:47'),(200,8,22,'ol','2026-04-03 12:58:49'),(201,14,22,'ol','2026-04-03 12:58:53'),(202,16,22,'ol','2026-04-03 12:58:55'),(203,14,4,'ol','2026-04-03 12:59:03'),(204,10,4,'ol','2026-04-03 12:59:06'),(205,9,4,'ol','2026-04-03 12:59:08'),(206,16,3,'ok','2026-04-03 12:59:24'),(207,1,3,'pl','2026-04-03 12:59:29'),(208,2,3,'pl','2026-04-03 12:59:31'),(209,7,22,'ok','2026-04-03 13:00:00'),(210,7,2,'ok','2026-04-03 13:00:51'),(211,7,2,'ok','2026-04-03 13:01:04'),(212,8,2,'ok','2026-04-03 13:01:18'),(213,9,4,'plllll','2026-04-03 21:33:04'),(214,7,22,'ok','2026-04-03 21:51:01'),(215,7,22,'ok','2026-04-03 21:53:53'),(216,14,4,'ok','2026-04-03 21:58:58'),(217,14,4,'ok','2026-04-03 21:59:01'),(218,9,4,'ok','2026-04-03 21:59:10'),(219,2,3,'ok','2026-04-03 22:09:26'),(220,1,22,'ok','2026-04-03 22:09:34'),(221,1,22,'ok','2026-04-03 22:16:58'),(222,1,3,'alo','2026-04-03 22:17:43'),(223,1,3,'ok','2026-04-03 22:19:35'),(224,1,3,'ok','2026-04-03 22:23:17'),(225,1,22,'tôi đây','2026-04-03 22:23:36'),(226,1,22,'ok','2026-04-03 22:24:47'),(227,1,22,'ok','2026-04-03 22:25:16'),(228,1,22,'ok','2026-04-03 22:25:25'),(229,1,3,'tttt','2026-04-03 22:25:30'),(230,1,3,'o','2026-04-03 22:25:35'),(231,1,3,'o','2026-04-03 22:25:45'),(232,1,3,'alo','2026-04-03 22:26:21'),(233,1,3,'ok','2026-04-03 22:26:25'),(234,1,3,'1','2026-04-03 22:26:27'),(235,1,3,'2','2026-04-03 22:27:07'),(236,1,3,'3','2026-04-03 22:28:26'),(237,1,22,'4','2026-04-03 22:28:46'),(238,1,3,'5','2026-04-03 22:28:55'),(239,1,3,'6','2026-04-03 22:29:15'),(240,1,22,'7','2026-04-03 22:29:22'),(241,2,3,'p','2026-04-03 22:32:50'),(242,2,3,'ok','2026-04-03 22:35:36'),(243,1,3,'8','2026-04-03 22:35:39'),(244,16,3,'9','2026-04-03 22:35:43'),(245,1,22,'5','2026-04-03 22:42:29'),(246,2,22,'5','2026-04-03 22:42:32'),(247,16,22,'5','2026-04-03 22:42:35'),(248,16,3,'ok','2026-04-03 22:42:48'),(249,2,3,'5','2026-04-03 22:42:51'),(250,1,3,'20','2026-04-03 22:42:54'),(251,2,3,'5','2026-04-03 22:45:39'),(252,1,3,'4','2026-04-03 22:45:42'),(253,16,3,'4','2026-04-03 22:45:44'),(254,16,3,'p','2026-04-03 22:50:29'),(255,1,3,'i','2026-04-03 22:50:39'),(256,1,3,'l','2026-04-03 22:51:18'),(257,1,3,'l','2026-04-03 22:51:27'),(258,1,22,'ok','2026-04-03 22:51:42'),(259,1,3,'ok','2026-04-03 22:51:47'),(260,1,3,'ok','2026-04-03 22:56:30'),(261,1,3,'6','2026-04-03 22:57:44'),(262,16,3,'ok','2026-04-03 22:57:53'),(263,2,3,'ụ','2026-04-03 22:58:02'),(264,16,3,'0','2026-04-03 23:07:30'),(265,16,22,'ok','2026-04-03 23:09:20'),(266,1,22,'ok','2026-04-03 23:09:40'),(267,2,3,'8','2026-04-03 23:09:54'),(268,1,3,'9','2026-04-03 23:10:56'),(269,2,3,'ok','2026-04-03 23:23:59'),(270,1,3,'ok','2026-04-03 23:24:39'),(271,1,3,'ok','2026-04-03 23:24:46'),(272,1,3,'ok','2026-04-03 23:25:03'),(273,2,22,'ok','2026-04-03 23:25:20'),(274,2,3,'y','2026-04-03 23:25:35'),(275,2,3,'ok','2026-04-03 23:27:50'),(276,2,22,'ok','2026-04-03 23:28:07'),(277,1,22,'ok','2026-04-03 23:28:21'),(278,2,22,'ok','2026-04-03 23:28:33'),(279,16,22,'p','2026-04-03 23:28:55'),(280,2,3,'ok','2026-04-03 23:29:26'),(281,2,3,'ok','2026-04-08 19:56:40'),(282,2,22,'ok','2026-04-08 19:57:06'),(283,18,30,'xin chào','2026-04-09 23:14:39'),(284,18,22,'chào','2026-04-09 23:15:13'),(285,8,22,'lo','2026-04-10 20:26:47'),(286,8,22,'','2026-04-10 20:26:52'),(287,7,2,'ok','2026-04-14 18:10:24'),(288,8,2,'ok','2026-04-14 18:11:16'),(289,8,22,'ok','2026-04-14 18:14:24'),(290,8,22,'ok','2026-04-14 18:14:31'),(291,7,2,'ok','2026-04-14 20:45:26'),(292,7,2,'chào','2026-04-14 20:45:59'),(293,7,22,'chào','2026-04-14 20:46:32'),(294,8,2,'ok','2026-04-14 20:46:48'),(295,7,2,'ok','2026-04-14 20:46:51'),(296,7,2,'ok','2026-04-14 20:51:48'),(297,8,2,'ok','2026-04-14 20:52:44'),(298,8,22,'ok','2026-04-14 20:52:52');
/*!40000 ALTER TABLE `chat_messages` ENABLE KEYS */;
UNLOCK TABLES;

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
-- Dumping data for table `conversations`
--

LOCK TABLES `conversations` WRITE;
/*!40000 ALTER TABLE `conversations` DISABLE KEYS */;
INSERT INTO `conversations` VALUES (1,2,3,22,'2026-04-01 18:09:57','2026-04-03 23:28:20.756449',22,0,0),(2,4,3,22,'2026-04-01 18:09:57','2026-04-08 19:57:05.811288',22,0,0),(3,3,3,23,'2026-04-01 19:58:24','2026-04-02 23:23:55.632798',23,0,0),(7,2,2,22,'2026-04-01 22:31:51','2026-04-14 20:51:47.980530',2,0,0),(8,4,2,22,'2026-04-01 22:32:20','2026-04-14 20:52:51.563968',22,0,1),(9,2,4,22,'2026-04-01 22:32:50','2026-04-03 21:59:09.711534',4,0,0),(10,4,4,22,'2026-04-01 22:33:02','2026-04-03 12:59:05.542632',4,0,0),(12,3,2,23,'2026-04-02 22:19:50','2026-04-02 23:30:16.630695',23,0,0),(14,5,4,22,'2026-04-02 23:05:32','2026-04-03 21:59:01.429978',4,2,0),(15,3,4,23,'2026-04-02 23:05:50','2026-04-03 12:08:54.131803',4,1,0),(16,5,3,22,'2026-04-02 23:06:35','2026-04-03 23:28:55.486794',22,0,0),(17,7,2,23,'2026-04-02 23:26:19','2026-04-02 23:28:02.718037',23,0,0),(18,2,30,22,'2026-04-09 23:14:39','2026-04-09 23:15:12.743007',22,0,0);
/*!40000 ALTER TABLE `conversations` ENABLE KEYS */;
UNLOCK TABLES;

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
-- Dumping data for table `hotel_images`
--

LOCK TABLES `hotel_images` WRITE;
/*!40000 ALTER TABLE `hotel_images` DISABLE KEYS */;
INSERT INTO `hotel_images` VALUES (1,'2026-03-15 21:23:34.130973','/images/hotels/6d216904-977f-4f10-a3d2-da7d8872b4ff.jpeg',_binary '\0',1),(2,'2026-03-15 21:23:34.151490','/images/hotels/fdb0ccd5-a74e-4c7c-a83b-3e40838b6638.jpeg',_binary '',1),(3,'2026-03-15 21:23:47.146457','/images/hotels/088a43a0-b66e-484f-a550-d5745e1f01ca.jpeg',_binary '\0',1),(9,'2026-03-15 21:43:17.760749','/images/hotels/f06f0640-7a67-4445-b535-e9fc2695f101.jpeg',_binary '\0',22),(10,'2026-03-15 21:43:17.767807','/images/hotels/0dd12298-ec7f-4637-a096-fab9a03c9ab6.jpeg',_binary '',22),(11,'2026-03-16 13:10:00.787495','/images/hotels/10d92cda-90dd-46ea-98c0-d446e35449f4.jpeg',_binary '\0',2),(12,'2026-03-16 13:10:00.802801','/images/hotels/c3a1864b-17de-4b10-a4df-96932265c6c4.jpeg',_binary '\0',2),(15,'2026-03-16 13:13:39.055209','/images/hotels/176096be-547a-41f6-85a6-c44b4ec6547e.jpeg',_binary '',2),(16,'2026-03-16 13:14:08.529802','/images/hotels/d101b3d7-874d-4713-8ddc-113cef038af9.jpeg',_binary '\0',23),(17,'2026-03-16 13:14:08.534707','/images/hotels/a26aa2ea-1a8b-4bd2-b7a0-dd0436cae269.jpeg',_binary '\0',23),(18,'2026-03-16 13:14:16.770612','/images/hotels/4a2c3bea-8ea5-452b-9741-69d45a97cccd.jpeg',_binary '',23),(20,'2026-03-16 14:40:39.040496','/images/hotels/e8639aa8-5a0f-49a7-8263-d6a3cb3cd6ab.jpeg',_binary '\0',2),(21,'2026-03-16 14:40:39.054869','/images/hotels/bb221d5d-b0db-495e-b611-8f4104a7d0f0.jpeg',_binary '\0',2),(23,'2026-03-16 14:40:39.061288','/images/hotels/0d56f4f8-c9cb-4383-a28a-1876be65185c.jpeg',_binary '\0',2),(30,'2026-03-16 15:03:49.807035','/images/hotels/b9bc7f17-1a73-445b-81fe-b7b6cb8448fa.jpeg',_binary '\0',3),(31,'2026-03-16 15:03:49.824219','/images/hotels/8ad078ad-c44f-4264-a9a1-08c33bf08bcf.jpeg',_binary '\0',3),(32,'2026-03-16 15:03:49.840323','/images/hotels/4a21bea1-68c4-4198-ae99-91a4f8ee4823.jpeg',_binary '\0',3),(33,'2026-03-16 15:03:49.843246','/images/hotels/b9fd1ad9-2d51-4aac-a4e7-cae0ec014bea.jpeg',_binary '\0',3),(34,'2026-03-16 15:03:49.849980','/images/hotels/e812e5ea-ff78-4883-9f4f-2c1eddae3f23.jpeg',_binary '\0',3),(35,'2026-03-16 15:03:49.849980','/images/hotels/35d3ae00-cd68-4fd8-ae12-9d95c4dae7cc.jpeg',_binary '',3),(36,'2026-03-16 15:03:49.857871','/images/hotels/cb49a0b9-d657-470a-a923-28e1ba73607e.jpeg',_binary '\0',3),(43,'2026-03-16 15:54:12.477302','/images/hotels/1c545a74-11e1-4f6a-a190-f46f8588a5ee.jpeg',_binary '\0',5),(44,'2026-03-16 15:54:12.490037','/images/hotels/e7d6afaf-0f7b-463a-9fb4-7791e860b8ab.jpeg',_binary '\0',5),(45,'2026-03-16 15:54:12.492563','/images/hotels/5f65d889-84d2-4bf6-b952-f350db513511.jpeg',_binary '\0',5),(46,'2026-03-16 15:54:12.495597','/images/hotels/f75bc308-54ac-4a47-8cc0-d63f2ad6c36c.jpeg',_binary '\0',5),(47,'2026-03-16 15:54:12.495597','/images/hotels/10afa107-9bbc-4759-a37d-316dae955a30.jpeg',_binary '\0',5),(48,'2026-03-16 15:54:12.495597','/images/hotels/25a8e400-1004-4730-8dd2-aa95860e54b1.jpeg',_binary '\0',5),(49,'2026-03-16 15:54:12.505811','/images/hotels/b451db31-b887-4ed9-b732-e4207279e5e0.jpeg',_binary '',5),(50,'2026-03-16 15:54:12.510586','/images/hotels/d21de7f3-346c-4077-b900-187a6fab31a9.jpeg',_binary '\0',5),(51,'2026-03-16 15:54:12.514450','/images/hotels/939328bf-917f-468e-8cfd-83583ca7c3fb.jpeg',_binary '\0',5),(52,'2026-03-16 15:54:32.991801','/images/hotels/53161380-ef58-49ce-8e51-52d0db055528.jpeg',_binary '\0',4),(53,'2026-03-16 15:54:32.993934','/images/hotels/66d9bcb6-ce97-4ec5-83ea-731a6237e025.jpeg',_binary '\0',4),(54,'2026-03-16 15:54:33.000614','/images/hotels/6b0e3e3c-c761-4189-9728-a653476a9868.jpeg',_binary '\0',4),(55,'2026-03-16 15:54:33.000614','/images/hotels/f7c109d2-0638-4e81-9fa2-53a19c74fff7.jpeg',_binary '',4),(56,'2026-03-16 15:54:33.005697','/images/hotels/7e91f1dc-b383-4873-8491-8984eb1226d9.jpeg',_binary '\0',4),(57,'2026-03-16 15:54:33.012330','/images/hotels/cfb3c968-43e6-46a7-a195-a5f825c6c10d.jpeg',_binary '\0',4),(58,'2026-03-16 15:54:33.013803','/images/hotels/5fe2bdb3-7d22-49d2-aaae-fa24a1e7ced7.jpeg',_binary '\0',4),(59,'2026-03-16 15:54:33.019276','/images/hotels/acc9b98a-7443-479f-a447-56f7f8a5a91e.jpeg',_binary '\0',4),(60,'2026-03-16 15:54:33.022453','/images/hotels/a31a375b-668f-4c4e-a08b-6352852b8a6c.jpeg',_binary '\0',4),(61,'2026-03-16 15:54:33.025686','/images/hotels/96cef710-8a91-468b-b920-4800806570c3.jpeg',_binary '\0',4),(62,'2026-03-16 15:54:33.029313','/images/hotels/69035e62-b40e-45fe-80bb-388f25e184e7.jpeg',_binary '\0',4),(63,'2026-03-16 15:54:33.031964','/images/hotels/e96e84ae-7193-4a50-a611-28ae912c4000.jpeg',_binary '\0',4),(64,'2026-03-17 21:40:26.112284','/images/hotels/ae9de25e-bee7-4a07-9261-6768124b37e6.jpeg',_binary '\0',6),(65,'2026-03-17 21:40:26.116153','/images/hotels/228de49a-b849-4bc8-91ba-c2643e33a195.jpeg',_binary '\0',6),(66,'2026-03-17 21:40:26.120898','/images/hotels/518effff-4f02-4135-96c5-fb03280e9148.jpeg',_binary '\0',6),(67,'2026-03-17 21:40:26.124916','/images/hotels/b7b1606f-be3f-482a-8829-dcc005933555.jpeg',_binary '\0',6),(68,'2026-03-17 21:40:26.129206','/images/hotels/a3c5995e-87f8-4546-960a-0b97ea20064a.jpeg',_binary '\0',6),(69,'2026-03-17 21:40:26.133030','/images/hotels/3d5ac949-eaa1-4f7a-8f21-a2553b383a2e.jpeg',_binary '\0',6),(70,'2026-03-17 21:40:26.135789','/images/hotels/9001d807-46d4-4991-8e4a-75eb2ffcf3a6.jpeg',_binary '',6),(71,'2026-03-17 21:40:26.139822','/images/hotels/88a033a6-6e4c-42dc-8f57-661341518721.jpeg',_binary '\0',6),(72,'2026-03-17 21:40:26.143865','/images/hotels/9104fc6c-9198-4ade-b9ef-92938117cd90.jpeg',_binary '\0',6),(73,'2026-03-17 21:40:26.146520','/images/hotels/ec9d643d-8fd2-4a47-b3ee-d654746ee681.jpeg',_binary '\0',6),(74,'2026-03-17 21:40:26.150388','/images/hotels/e70716cb-49e5-4b77-8042-2ee31ec88d1d.jpeg',_binary '\0',6),(75,'2026-03-17 21:40:26.153912','/images/hotels/d1d9cfdc-3d0d-491b-801a-99773ce35e53.jpeg',_binary '\0',6),(76,'2026-03-17 21:40:46.507719','/images/hotels/429b5245-398f-4731-af1d-36f5164c736c.jpeg',_binary '',7),(77,'2026-03-17 21:40:46.512200','/images/hotels/f618c3bc-87d2-48bc-a7e2-928d7f831524.jpeg',_binary '\0',7),(78,'2026-03-17 21:40:46.515566','/images/hotels/6c2a324c-ffa6-4dd0-9196-11719a76aadf.jpeg',_binary '\0',7),(79,'2026-03-17 21:40:46.518697','/images/hotels/88d05022-489f-45fc-8dff-0179f61d0e54.jpeg',_binary '\0',7),(80,'2026-03-17 21:40:46.522995','/images/hotels/9f33926d-2497-4a49-baa8-a64351462470.jpeg',_binary '\0',7),(81,'2026-03-17 21:40:46.527450','/images/hotels/76f8cc3f-4a1d-45b4-9d85-d60cd9c9cbb8.jpeg',_binary '\0',7),(82,'2026-03-17 21:40:46.530611','/images/hotels/81739a3c-0fe0-40be-8bb4-d927323ee041.jpeg',_binary '\0',7),(83,'2026-03-17 21:40:46.534568','/images/hotels/9f1d407e-944f-4769-9521-f74eb24bdecd.jpeg',_binary '\0',7),(84,'2026-03-17 21:40:46.537667','/images/hotels/3cb52474-74a2-4129-b7d0-3b7806574fbb.jpeg',_binary '\0',7),(85,'2026-03-17 21:40:46.542430','/images/hotels/b2d4da24-69c2-4f95-bfd5-275c0af12dd9.jpeg',_binary '\0',7),(89,'2026-03-18 15:26:35.309249','/images/hotels/959dc8c5-b70b-4c91-ad05-daf6debe16d0.jpeg',_binary '\0',24),(90,'2026-03-18 15:26:35.313478','/images/hotels/53fbfe0a-ce6d-4c24-b539-fc1e1f3ea1e0.jpeg',_binary '\0',24),(91,'2026-03-18 15:26:35.317648','/images/hotels/e1b30e72-f661-4de7-968c-73a612edbce3.jpeg',_binary '\0',24),(92,'2026-03-18 15:26:35.322130','/images/hotels/6813ad36-160f-4070-bbb8-10ae9797c014.jpeg',_binary '\0',24),(93,'2026-03-18 15:26:35.326365','/images/hotels/9cc8b0af-7fee-4a73-9dbf-7b967c08e5bd.jpeg',_binary '\0',24),(94,'2026-03-18 15:26:35.330390','/images/hotels/b0389e20-9419-4816-b938-9e2a657603cc.jpeg',_binary '\0',24),(95,'2026-03-18 15:26:35.334001','/images/hotels/2a13b312-d6f3-44e9-bf08-bbf0341afab9.jpeg',_binary '\0',24),(96,'2026-03-18 15:26:35.337162','/images/hotels/894ba33d-36da-4818-8362-1528f672bdd0.jpeg',_binary '\0',24),(97,'2026-03-18 15:27:23.563308','/images/hotels/f6da2484-812c-432f-9670-2587397b1f7a.jpeg',_binary '',24),(98,'2026-03-18 15:27:23.566982','/images/hotels/7073205c-5333-472f-82f6-56f67a0cea15.jpeg',_binary '\0',24),(99,'2026-03-18 15:27:23.570435','/images/hotels/62e5efbb-b454-4638-8267-1d8e2c998093.jpeg',_binary '\0',24),(100,'2026-03-18 17:13:28.736282','/images/hotels/ecb3b278-dd91-4893-bcba-79dc58e72661.jpeg',_binary '\0',25),(101,'2026-03-18 17:13:28.740148','/images/hotels/f9742b73-32ee-45bc-abd4-a57b3a89a63e.jpeg',_binary '',25),(102,'2026-03-18 17:13:28.743037','/images/hotels/72015d74-8bc4-421b-94e6-fcf51c2f0817.jpeg',_binary '\0',25),(103,'2026-03-18 17:13:28.746521','/images/hotels/b536bc41-4821-4e20-acde-567084900273.jpeg',_binary '\0',25),(104,'2026-03-18 17:13:28.750113','/images/hotels/ebc5276d-0f8a-4586-afb4-29b7b7e2e5e3.jpeg',_binary '\0',25),(105,'2026-03-18 17:13:28.752670','/images/hotels/499aa350-260a-4d48-91e3-24bf48773407.jpeg',_binary '\0',25),(106,'2026-03-18 17:13:28.755954','/images/hotels/e2cb8cb8-8039-4a53-9c64-514dbf47e899.jpeg',_binary '\0',25),(107,'2026-03-18 17:13:28.759086','/images/hotels/e2ae2103-d156-4f72-98f4-9cfc69604d7d.jpeg',_binary '\0',25),(108,'2026-03-18 17:13:28.761738','/images/hotels/a8e861aa-e565-4e89-a3cf-544f2dd1e6ed.jpeg',_binary '\0',25),(109,'2026-03-18 17:13:56.582559','/images/hotels/8a5a77f7-f4ff-4d7a-857c-62d504352afd.jpeg',_binary '\0',25),(110,'2026-03-18 17:13:56.586354','/images/hotels/56d63bb0-a36b-4515-b6b9-3a0d8166d9b0.jpeg',_binary '\0',25),(111,'2026-03-18 17:13:56.588701','/images/hotels/d54e08e4-fd58-4d92-95e1-e7880b7ce405.jpeg',_binary '\0',25),(112,'2026-03-18 17:13:56.592713','/images/hotels/14d97275-7639-4187-8d4d-3c53c16e9f18.jpeg',_binary '\0',25),(113,'2026-03-18 17:13:56.596502','/images/hotels/c39a652f-00f2-4e18-8aba-0af4f3bb5266.jpeg',_binary '\0',25),(114,'2026-03-18 17:13:56.600018','/images/hotels/2b92d1d3-c026-496d-a857-ffdab9dfa284.jpeg',_binary '\0',25),(115,'2026-03-22 13:29:54.321320','/images/hotels/a1a03c94-35d3-431e-bcdf-acb12f680018.jpeg',_binary '',26),(116,'2026-03-22 13:29:54.325198','/images/hotels/5a1d0344-272f-4b71-abe4-27371dc1feb8.jpeg',_binary '\0',26),(117,'2026-03-22 13:29:54.329227','/images/hotels/51a7eea1-a0df-4ed1-b305-857624670a83.jpeg',_binary '\0',26),(120,'2026-03-28 14:18:05.140955','/images/hotels/fff7e39b-5eb0-4f1d-a27e-4fc22a1238ce.jpeg',_binary '',27),(122,'2026-04-02 22:10:46.462921','/images/hotels/ac9e75f4-37f2-449a-bb48-85e36738fb0a.jpeg',_binary '\0',9),(123,'2026-04-02 22:10:46.490796','/images/hotels/38528bf3-0c7d-498e-9f7e-95fccb787c62.jpeg',_binary '\0',9),(124,'2026-04-02 22:10:46.496606','/images/hotels/5052abe3-2f2f-4855-99cd-ebe61e0ff96f.jpeg',_binary '\0',9),(125,'2026-04-02 22:10:46.496606','/images/hotels/57649d73-d74d-4f13-b5b9-2e230ce10a3c.jpeg',_binary '\0',9),(126,'2026-04-02 22:10:46.502989','/images/hotels/8dfbd324-a24f-4d0d-82b0-7ab5d213edcd.jpeg',_binary '',9),(127,'2026-04-02 22:10:46.502989','/images/hotels/3e7389b6-b0c0-4c2d-8898-73a984ab364d.jpeg',_binary '\0',9),(128,'2026-04-02 22:10:46.513020','/images/hotels/7b609c50-1759-45cc-9abc-28e737717edc.jpeg',_binary '\0',9),(129,'2026-04-02 22:10:46.518180','/images/hotels/c5a2a2c9-34a8-4474-89c9-8d5fc7884045.jpeg',_binary '\0',9),(130,'2026-04-02 22:10:46.522213','/images/hotels/a0f48a12-21a1-46e4-a332-43d1ed0e5fab.jpeg',_binary '\0',9),(132,'2026-04-04 17:25:27.501764','/images/hotels/58d4bfb6-46aa-4a7c-9446-257be2ddb9b3.jpeg',_binary '\0',28),(133,'2026-04-04 17:25:27.518776','/images/hotels/8a7a8e69-50ec-49d4-879e-4d80b72affc1.jpeg',_binary '',28),(134,'2026-04-04 17:25:27.522096','/images/hotels/4bf92a1a-9047-4fda-8396-91bf05de01cd.jpeg',_binary '\0',28),(135,'2026-04-14 16:34:09.075028','/images/hotels/84cc1d1f-4879-4a04-9de9-ac2a7b1476d3.jpeg',_binary '\0',2);
/*!40000 ALTER TABLE `hotel_images` ENABLE KEYS */;
UNLOCK TABLES;

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
-- Dumping data for table `hotels`
--

LOCK TABLES `hotels` WRITE;
/*!40000 ALTER TABLE `hotels` DISABLE KEYS */;
INSERT INTO `hotels` VALUES (1,'235 Nguyen Van Cu, District 1, Ho Chi Minh City',9.1,'2026-03-15 21:12:59.000000','Hotel Nikko Saigon','Luxury 5-star hotel near city center with modern facilities.','ACTIVE','2026-04-19 13:37:29.194380',0,NULL,NULL,'KS-HN-001'),(2,'17 Ton Duc Thang, District 1, Ho Chi Minh City.',8.966666666666667,'2026-03-15 21:12:59.000000','Liberty Central Saigon Riverside Hotel','Bypass thử','ACTIVE','2026-04-20 16:54:31.997754',0,22,NULL,'KS-HCM-001'),(3,'73-75 Thu Khoa Huan, District 1, Ho Chi Minh City',6.9,'2026-03-15 21:12:59.000000','Silverland Yen Hotel','Boutique hotel close to Ben Thanh Market','ACTIVE','2026-04-19 13:33:45.108237',0,23,NULL,'KS-HP-001'),(4,'6-8 Ho Huan Nghiep, District 1, Ho Chi Minh City',8.275,'2026-03-15 21:12:59.000000','The Myst Dong Khoi','Luxury boutique hotel with unique design and rooftop pool.','ACTIVE','2026-04-15 23:37:35.565956',0,22,NULL,''),(5,'15 Ngo Quyen, Hoan Kiem, Hanoi',7.675,'2026-03-15 21:12:59.000000','Sofitel Legend Metropole Hanoi','Historic luxury hotel in the heart of Hanoi.','ACTIVE','2026-04-14 15:31:21.475642',0,22,NULL,''),(6,'54 Lieu Giai, Ba Dinh, Hanoi',9,'2026-03-15 21:12:59.000000','Lotte Hotel Hanoi','Modern skyscraper hotel with panoramic city view.','ACTIVE','2026-04-04 15:55:03.859251',0,23,NULL,''),(7,'136 Hang Trong, Hoan Kiem, Hanoi',8.8,'2026-03-15 21:12:59.000000','Apricot Hotel','Art inspired boutique hotel near Hoan Kiem Lake.','ACTIVE','2026-03-25 22:57:25.811808',0,23,NULL,''),(8,'94 Ma May, Hoan Kiem, Hanoi',9.1,'2026-03-15 21:12:59.000000','Hanoi La Siesta Hotel & Spa','Luxury boutique hotel in the Old Quarter.','ACTIVE','2026-04-04 22:32:42.796326',1,NULL,NULL,''),(9,'Bai Bac, Son Tra Peninsula, Da Nang',9.4,'2026-03-15 21:12:59.000000','InterContinental Danang Sun Peninsula Resort','World-class luxury resort overlooking the sea.','ACTIVE','2026-04-14 16:35:01.958368',0,22,NULL,''),(10,'36 Bach Dang, Hai Chau, Da Nang',8.9,'2026-03-15 21:12:59.000000','Novotel Danang Premier Han River','Riverside hotel with modern rooms and skyline views.','ACTIVE','2026-03-25 22:57:27.903715',0,24,NULL,''),(11,'162 Bach Dang, Hai Chau, Da Nang',8.9,'2026-03-15 21:12:59.000000','Brilliant Hotel Danang','Central hotel near Han River and Dragon Bridge.','INACTIVE','2026-04-04 22:35:37.251925',0,24,NULL,''),(12,'36-38 Lam Hoanh, Son Tra, Da Nang',9,'2026-03-15 21:12:59.000000','Sala Danang Beach Hotel','Beachfront hotel with rooftop infinity pool.','ACTIVE','2026-03-25 22:57:29.332964',0,NULL,NULL,''),(13,'2 Tran Phu, Da Lat',9.1,'2026-03-15 21:12:59.000000','Dalat Palace Heritage Hotel','Historic French colonial luxury hotel.','ACTIVE','2026-03-25 22:57:29.839776',0,NULL,NULL,''),(14,'Le Lai Street, Da Lat',9,'2026-03-15 21:12:59.000000','Ana Mandara Villas Dalat Resort','Resort with classic French villas in pine forest.','ACTIVE','2026-03-25 22:57:30.896361',0,NULL,NULL,''),(15,'Tuyen Lam Lake, Da Lat',8.9,'2026-03-15 21:12:59.000000','Terracotta Hotel & Resort Dalat','Peaceful resort by Tuyen Lam lake.','ACTIVE','2026-03-25 22:57:31.207903',0,NULL,NULL,''),(16,'10 Phan Boi Chau, Da Lat',8.9,'2026-03-15 21:12:59.000000','Colline Dalat Hotel','Modern hotel near Dalat Market.','ACTIVE','2026-03-25 22:57:32.215755',0,NULL,NULL,''),(17,'Manhattan 9, Vinhomes Imperia, Hai Phong',9.1,'2026-03-15 21:12:59.000000','Vinpearl Hotel Imperia Hai Phong','Luxury hotel with modern architecture.','ACTIVE','2026-03-25 22:57:32.950713',0,NULL,NULL,''),(18,'12 Lach Tray, Ngo Quyen, Hai Phong',8.9,'2026-03-15 21:12:59.000000','Mercure Hai Phong','International hotel brand in city center.','ACTIVE','2026-03-25 22:57:33.373798',0,NULL,NULL,''),(19,'Tower A, TD Plaza, Hai Phong',8.9,'2026-03-15 21:12:59.000000','Somerset Central TD Hai Phong','Serviced apartment hotel with modern facilities.','ACTIVE','2026-03-25 22:57:34.252683',0,NULL,NULL,''),(20,'64 Dien Bien Phu, Hai Phong',9,'2026-03-15 21:12:59.000000','Manoir Des Arts Hotel','Boutique hotel with classic French architecture.','ACTIVE','2026-03-25 22:57:34.714985',0,NULL,NULL,''),(21,'Sapa5',NULL,'2026-03-15 21:40:55.872644','Gió Núi Homestay5','View núi đẹp5','INACTIVE','2026-03-25 22:57:35.207116',0,NULL,NULL,''),(22,'Sapa2',NULL,'2026-03-15 21:43:17.654053','Gió Núi Homestay2','View núi đẹp2','INACTIVE','2026-03-15 22:29:54.824275',1,NULL,NULL,''),(23,'Sapa',NULL,'2026-03-16 13:14:08.506934','Gió Núi Homestay','View núi đẹp','ACTIVE','2026-03-25 22:57:36.109787',0,NULL,NULL,''),(24,'6-8 Ho Huan Nghiep, District 2, Ho Chi Minh City',NULL,'2026-03-18 15:26:35.280906','The Myst Dong Khoi 2','Luxury boutique hotel with unique design and rooftop pool.','ACTIVE','2026-03-25 22:57:36.569387',0,NULL,NULL,''),(25,'94 Ma May, Hoan Kiem, Hanoi',NULL,'2026-03-18 17:13:28.699441','Test2','Rất đẹp','ACTIVE','2026-03-25 22:57:37.474923',0,NULL,NULL,''),(26,'73-75 Thu Khoa Huan, District 1, Ho Chi Minh City 11',NULL,'2026-03-22 13:29:54.262374','Silverland Yen Hotel 11','Boutique hotel close to Ben Thanh Market 11','ACTIVE','2026-03-22 13:30:42.838846',0,24,NULL,''),(27,'17 Ton Duc Thang, District 1, Ho Chi Minh City2',NULL,'2026-03-28 14:18:05.070848','Liberty Central Saigon Riverside Hotel2','Modern hotel overlooking Saigon River with rooftop pool2.','ACTIVE','2026-03-28 14:18:15.853311',0,22,NULL,''),(28,'17 Ton Duc Thang, District 1, Ho Chi Minh City3',NULL,'2026-03-28 21:42:21.558281','Liberty Central Saigon Riverside Hotel3','Modern hotel overlooking Saigon River with rooftop pool3','ACTIVE','2026-04-04 17:25:54.218183',0,22,NULL,''),(29,'17 Ton Duc Thang, District 1, Ho Chi Minh City4',NULL,'2026-03-28 21:44:47.103968','Liberty Central Saigon Riverside Hotel4','Modern hotel overlooking Saigon River with rooftop pool4','ACTIVE','2026-03-28 21:45:09.697702',1,22,NULL,''),(30,'ggg',NULL,'2026-04-04 17:27:27.731250','gggg','ggggg','ACTIVE','2026-04-14 16:34:55.381722',0,22,NULL,''),(31,'17 Ton Duc Thang, District 1, Ho Chi Minh City.',NULL,'2026-04-15 13:45:49.650642','Liberty Central Saigon Riverside Hotel','kkkk','ACTIVE','2026-04-15 13:45:49.650642',0,22,NULL,''),(32,'Đà Lạt',NULL,'2026-04-15 14:25:40.124257','An Nhiên Homestay333','','ACTIVE','2026-04-15 21:26:50.406024',0,31,NULL,'KS-HN-32');
/*!40000 ALTER TABLE `hotels` ENABLE KEYS */;
UNLOCK TABLES;

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
-- Dumping data for table `reviews`
--

LOCK TABLES `reviews` WRITE;
/*!40000 ALTER TABLE `reviews` DISABLE KEYS */;
INSERT INTO `reviews` VALUES (1,'Phòng đẹp, vị trí trung tâm rất thuận tiện.','2026-03-15 21:27:55.000000',9.1,1,2,'ACTIVE'),(2,'tốt','2026-03-15 21:27:55.000000',10,2,3,'HIDDEN'),(3,'Khách sạn sạch sẽ và rất yên tĩnh.','2026-03-15 21:27:55.000000',9.4,2,4,'PENDING_HIDE'),(4,'View sông rất đẹp, phòng rộng.','2026-03-15 21:27:55.000000',8.8,2,5,'ACTIVE'),(5,'Bữa sáng ngon và đa dạng.','2026-03-15 21:27:55.000000',9,2,6,'ACTIVE'),(6,'Giá hợp lý so với vị trí.','2026-03-15 21:27:55.000000',8.5,2,7,'ACTIVE'),(7,'Khách sạn rất gần chợ Bến Thành.','2026-03-15 21:27:55.000000',9.3,2,8,'ACTIVE'),(8,'Phòng sạch và nhân viên nhiệt tình.','2026-03-15 21:27:55.000000',8.9,2,9,'ACTIVE'),(9,'Rất đáng tiền.','2026-03-15 21:27:55.000000',6.9,3,10,'ACTIVE'),(10,'Thiết kế khách sạn rất đẹp.','2026-03-15 21:27:55.000000',7.8,4,11,'ACTIVE'),(11,'Hồ bơi rooftop rất ấn tượng.','2026-03-15 21:27:55.000000',7.6,4,12,'ACTIVE'),(12,'Không gian sang trọng.','2026-03-15 21:27:55.000000',7.7,4,13,'ACTIVE'),(13,'Khách sạn lịch sử rất đẹp.','2026-03-15 21:27:55.000000',7,5,14,'ACTIVE'),(14,'Vị trí gần hồ Hoàn Kiếm.','2026-03-15 21:27:55.000000',6.8,5,15,'ACTIVE'),(15,'Dịch vụ rất chuyên nghiệp.','2026-03-15 21:27:55.000000',6.9,5,16,'ACTIVE'),(16,'View thành phố từ tầng cao rất đẹp.','2026-03-15 21:27:55.000000',9.3,2,17,'ACTIVE'),(17,'Phòng hiện đại.','2026-03-15 21:27:55.000000',8.8,6,18,'ACTIVE'),(18,'Rất đáng trải nghiệm.','2026-03-15 21:27:55.000000',9.1,6,19,'ACTIVE'),(19,'Khách sạn mang phong cách nghệ thuật.','2026-03-15 21:27:55.000000',8.7,7,20,'ACTIVE'),(20,'Gần hồ Hoàn Kiếm.','2026-03-15 21:27:55.000000',9,7,21,'ACTIVE'),(21,'Phòng ấm cúng.','2026-03-15 21:27:55.000000',8.8,7,2,'ACTIVE'),(22,'Khách sạn boutique rất đẹp.','2026-03-15 21:27:55.000000',9.2,8,3,'ACTIVE'),(23,'Dịch vụ spa tốt.','2026-03-15 21:27:55.000000',8.9,8,4,'ACTIVE'),(24,'Vị trí trung tâm phố cổ.','2026-03-15 21:27:55.000000',9.1,8,5,'ACTIVE'),(25,'Resort tuyệt vời, view biển đẹp.','2026-03-15 21:27:55.000000',9.7,9,6,'ACTIVE'),(26,'Không gian nghỉ dưỡng đẳng cấp.','2026-03-15 21:27:55.000000',9.4,9,7,'ACTIVE'),(27,'Dịch vụ 5 sao.','2026-03-15 21:27:55.000000',9.2,9,8,'ACTIVE'),(28,'View sông Hàn rất đẹp.','2026-03-15 21:27:55.000000',8.9,10,9,'ACTIVE'),(29,'Phòng rộng rãi.','2026-03-15 21:27:55.000000',9,10,10,'ACTIVE'),(30,'Bữa sáng ngon.','2026-03-15 21:27:55.000000',8.7,10,11,'ACTIVE'),(31,'Khách sạn gần cầu Rồng.','2026-03-15 21:27:55.000000',8.8,11,12,'ACTIVE'),(32,'Nhân viên thân thiện.','2026-03-15 21:27:55.000000',9.1,11,13,'ACTIVE'),(33,'Phòng sạch.','2026-03-15 21:27:55.000000',8.9,11,14,'ACTIVE'),(34,'Hồ bơi vô cực rất đẹp.','2026-03-15 21:27:55.000000',9.3,12,15,'ACTIVE'),(35,'Gần biển.','2026-03-15 21:27:55.000000',9,12,16,'ACTIVE'),(36,'Dịch vụ ổn.','2026-03-15 21:27:55.000000',8.8,12,17,'ACTIVE'),(37,'Khách sạn cổ kính rất đẹp.','2026-03-15 21:27:55.000000',9.4,13,18,'ACTIVE'),(38,'Không khí Đà Lạt tuyệt vời.','2026-03-15 21:27:55.000000',9.1,13,19,'ACTIVE'),(39,'Phòng ấm cúng.','2026-03-15 21:27:55.000000',8.9,13,20,'ACTIVE'),(40,'Biệt thự Pháp rất đẹp.','2026-03-15 21:27:55.000000',9,14,21,'ACTIVE'),(41,'Không gian yên tĩnh.','2026-03-15 21:27:55.000000',9.2,14,2,'ACTIVE'),(42,'Phù hợp nghỉ dưỡng.','2026-03-15 21:27:55.000000',8.8,14,3,'ACTIVE'),(43,'View hồ Tuyền Lâm đẹp.','2026-03-15 21:27:55.000000',8.9,15,4,'ACTIVE'),(44,'Không gian rộng.','2026-03-15 21:27:55.000000',9.1,15,5,'ACTIVE'),(45,'Phòng sạch.','2026-03-15 21:27:55.000000',8.7,15,6,'ACTIVE'),(46,'Gần chợ Đà Lạt.','2026-03-15 21:27:55.000000',8.8,16,7,'ACTIVE'),(47,'Phòng hiện đại.','2026-03-15 21:27:55.000000',9,16,8,'ACTIVE'),(48,'Dịch vụ tốt.','2026-03-15 21:27:55.000000',8.9,16,9,'ACTIVE'),(49,'Khách sạn sang trọng.','2026-03-15 21:27:55.000000',9.2,17,10,'ACTIVE'),(50,'View thành phố.','2026-03-15 21:27:55.000000',9.1,17,11,'ACTIVE'),(51,'Phòng rộng.','2026-03-15 21:27:55.000000',8.9,17,12,'ACTIVE'),(52,'Khách sạn quốc tế.','2026-03-15 21:27:55.000000',8.7,18,13,'ACTIVE'),(53,'Dịch vụ tốt.','2026-03-15 21:27:55.000000',8.9,18,14,'ACTIVE'),(54,'Phòng sạch.','2026-03-15 21:27:55.000000',9,18,15,'ACTIVE'),(55,'Căn hộ dịch vụ tiện nghi.','2026-03-15 21:27:55.000000',9.1,19,16,'ACTIVE'),(56,'Không gian rộng.','2026-03-15 21:27:55.000000',8.8,19,17,'ACTIVE'),(57,'Phù hợp gia đình.','2026-03-15 21:27:55.000000',8.9,19,18,'ACTIVE'),(58,'Khách sạn cổ điển đẹp.','2026-03-15 21:27:55.000000',9,20,19,'ACTIVE'),(59,'Vị trí trung tâm.','2026-03-15 21:27:55.000000',8.8,20,20,'ACTIVE'),(60,'Dịch vụ tốt.','2026-03-15 21:27:55.000000',9.1,20,21,'ACTIVE'),(61,'ok tốt','2026-03-17 17:10:52.546731',9,2,2,'HIDDEN'),(62,'tốt','2026-03-17 21:10:06.159119',10,5,2,'ACTIVE'),(63,'tốt','2026-03-18 17:17:07.489332',10,3,2,'HIDDEN'),(64,'ok','2026-04-12 19:46:01.992915',10,4,30,'ACTIVE');
/*!40000 ALTER TABLE `reviews` ENABLE KEYS */;
UNLOCK TABLES;

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
-- Dumping data for table `room_type_images`
--

LOCK TABLES `room_type_images` WRITE;
/*!40000 ALTER TABLE `room_type_images` DISABLE KEYS */;
INSERT INTO `room_type_images` VALUES (1,'/images/room-types/24b6244e-6a50-4963-980e-b85f1b2bbc96.jpeg',_binary '\0',1,'2026-04-19 12:33:04.792836'),(2,'/images/room-types/f5273ce9-6bbf-48dc-8c9e-bb6905df93bf.jpeg',_binary '',1,'2026-04-19 12:33:04.796503'),(3,'/images/room-types/6a875dab-befa-4a82-8ae7-875bf5651973.jpeg',_binary '\0',1,'2026-04-19 12:33:04.800416'),(4,'/images/room-types/fb09c3a0-3e8a-432e-8db8-5c22b00bcffa.jpeg',_binary '\0',2,'2026-04-19 12:35:07.399215'),(5,'/images/room-types/6f056f56-47c4-4e42-816a-a75bbed1f7b2.jpeg',_binary '\0',2,'2026-04-19 12:35:07.404199'),(6,'/images/room-types/e99dbaa9-973b-47c8-a6e1-b307b1db26fd.jpeg',_binary '\0',2,'2026-04-19 12:35:07.407554'),(7,'/images/room-types/9898ae18-7b15-4715-8ed1-67f00eaabcf9.jpeg',_binary '\0',3,'2026-04-19 13:06:45.719599'),(8,'/images/room-types/871bbf3b-1628-4a60-8bd3-f3fbd4dcdfdb.jpeg',_binary '',2,'2026-04-19 14:50:57.988383'),(9,'/images/room-types/de8aac83-64d4-4c5d-a0ac-252d745e9005.jpeg',_binary '\0',4,'2026-04-19 14:54:34.873386'),(10,'/images/room-types/0fecc9f0-046b-4cf3-9385-41afbc8ec0cc.jpeg',_binary '\0',5,'2026-04-19 14:55:10.758993'),(11,'/images/room-types/c5bb81fb-0130-4508-888c-239a1997c7b9.jpeg',_binary '',5,'2026-04-19 14:55:23.385300'),(12,'/images/room-types/9e4cb167-6787-4f1e-ad86-50be825e3bbc.jpeg',_binary '',4,'2026-04-19 14:55:45.114449'),(13,'/images/room-types/7fbeed05-23e9-4a13-8cf9-f718eee53bf0.jpeg',_binary '',6,'2026-04-19 15:38:09.883801'),(14,'/images/room-types/e8d8628c-91b5-422c-9a9e-785274026dee.jpeg',_binary '',7,'2026-04-19 16:09:45.716334'),(15,'/images/room-types/fe75ee9b-aaac-4f18-a54a-ebd7bf7ccb64.jpeg',_binary '',8,'2026-04-20 15:36:14.825502'),(16,'/images/room-types/9f6367d4-bab3-4406-87d2-15edce5dfe14.jpeg',_binary '',9,'2026-04-20 15:41:46.932544'),(17,'/images/room-types/d4d688ca-2ef8-41da-869a-d2529f2a7ef6.jpeg',_binary '',10,'2026-04-20 16:10:32.846382'),(18,'/images/room-types/0db4aab9-4d70-42b0-abf3-40afaca2fc46.jpeg',_binary '',3,'2026-04-20 16:10:45.550271');
/*!40000 ALTER TABLE `room_type_images` ENABLE KEYS */;
UNLOCK TABLES;

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
-- Dumping data for table `room_types`
--

LOCK TABLES `room_types` WRITE;
/*!40000 ALTER TABLE `room_types` DISABLE KEYS */;
INSERT INTO `room_types` VALUES (1,4,'2026-04-19 12:33:04.722912','rất đẹp',5000000,'Phòng đơn vip pro',1,45,2,'QUEEN',0,'2026-04-19 13:20:25.174182'),(2,4,'2026-04-19 12:35:07.358069','ok',5000000,'Phòng đơn vip pro',1,45,2,'SINGLE',0,'2026-04-19 12:35:07.358069'),(3,3,'2026-04-19 13:06:45.664646','lll',5000000,'Phòng đôi',2,45,2,'DOUBLE',0,'2026-04-19 15:35:02.807396'),(4,1,'2026-04-19 14:54:34.848296','okdkdkd',3000000,'Phòng đơn',2,45,1,'SINGLE',0,'2026-04-19 14:54:34.848296'),(5,2,'2026-04-19 14:55:10.732445','ffff',3500000,'Phòng Queen',2,45,2,'QUEEN',0,'2026-04-19 15:42:53.360228'),(6,2,'2026-04-19 15:37:53.953778','hjjjjjo',7000000,'Phòng King ',2,45,1,'KING',0,'2026-04-19 15:40:28.490529'),(7,2,'2026-04-19 16:07:53.946975','uuu',100000,' King 2',2,45,1,'SINGLE',0,'2026-04-19 20:31:58.658019'),(8,2,'2026-04-20 15:36:14.752702','kkkk',100000,'Phòng King Nikko',1,45,1,'SINGLE',0,'2026-04-20 15:36:14.752702'),(9,1,'2026-04-20 15:41:46.864492','kkkk',100000,'Phòng Queen Nikko',1,40,1,'SINGLE',0,'2026-04-20 15:41:46.864492'),(10,2,'2026-04-20 16:10:32.797273','kkk',7000000,'Phòng Queen Liberty 2',2,45,2,'QUEEN',0,'2026-04-20 16:50:21.853300');
/*!40000 ALTER TABLE `room_types` ENABLE KEYS */;
UNLOCK TABLES;

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
-- Dumping data for table `rooms`
--

LOCK TABLES `rooms` WRITE;
/*!40000 ALTER TABLE `rooms` DISABLE KEYS */;
INSERT INTO `rooms` VALUES (1,'2026-04-19 15:01:49.890450',_binary '\0','',301,'ACTIVE','2026-04-19 15:58:10.590429',2,5),(2,'2026-04-19 15:41:15.658260',_binary '\0','',401,'ACTIVE','2026-04-19 15:57:50.169380',2,6),(3,'2026-04-19 15:42:28.415230',_binary '\0','',201,'ACTIVE','2026-04-19 16:00:54.281076',2,3),(4,'2026-04-19 16:01:07.057755',_binary '\0','',101,'ACTIVE','2026-04-19 16:01:07.057755',2,4),(5,'2026-04-19 20:34:01.159700',_binary '\0','',501,'ACTIVE','2026-04-20 16:45:29.402497',2,10),(6,'2026-04-20 18:10:08.665131',_binary '\0',NULL,202,'ACTIVE','2026-04-20 18:10:08.665131',2,3),(7,'2026-04-20 18:10:19.428339',_binary '\0',NULL,203,'ACTIVE','2026-04-20 18:10:19.428339',2,3);
/*!40000 ALTER TABLE `rooms` ENABLE KEYS */;
UNLOCK TABLES;

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
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'2026-03-15 21:12:51.096269','admin@gmail.com','$2a$10$FK0u/ZeAOaxUZzzMnTZUdOZHbI6sAQJMvxzucDeBBhpk/sok8aFQa','0000000000','eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJhZG1pbkBnbWFpbC5jb20iLCJpYXQiOjE3NzY2NzEwMzksImV4cCI6MTc3NzI3NTgzOX0.t7cJ2FvN6lmVKzDEWxjPXnDZpTEzzrZWoeFttfD3IAY','ADMIN','2026-04-20 14:43:59.869108','admin',0,NULL,'ACTIVE',NULL,NULL),(2,'2026-03-15 21:12:59.000000','nguyen.an@gmail.com','$2a$10$e3Mlufc5yXsBRzbwDpUUOuyqa/iOxWPvgBRnSfH.1hbwacH.C0xBa','0912345601','eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJuZ3V5ZW4uYW5AZ21haWwuY29tIiwiaWF0IjoxNzc2OTU1MjUzLCJleHAiOjE3Nzc1NjAwNTN9.yanacAajOGZliJ_QHiSO9j5rn3EnrXsnqQ2pIGtbBP4','USER','2026-04-23 21:40:53.490059','NguyenAn',0,NULL,'ACTIVE','Nguyễn Thị','An'),(3,'2026-03-15 21:12:59.000000','tran.binh@gmail.com','$2a$10$e3Mlufc5yXsBRzbwDpUUOuyqa/iOxWPvgBRnSfH.1hbwacH.C0xBa','0912345602','eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ0cmFuLmJpbmhAZ21haWwuY29tIiwiaWF0IjoxNzc2MjM0NDM3LCJleHAiOjE3NzY4MzkyMzd9.73oGINk964SxhCPgJwqPPqofC1w_EP2k_bB7pzrNm-Q','USER','2026-04-15 13:27:17.076822','Tran Binh ',0,NULL,'ACTIVE',NULL,NULL),(4,'2026-03-15 21:12:59.000000','le.chi@gmail.com','$2a$10$e3Mlufc5yXsBRzbwDpUUOuyqa/iOxWPvgBRnSfH.1hbwacH.C0xBa','0912345603','eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJsZS5jaGlAZ21haWwuY29tIiwiaWF0IjoxNzc1MjI3ODc2LCJleHAiOjE3NzU4MzI2NzZ9.mHpMUTRrqvakczi-MRkbDwRxM7fPO5XNTO8_-S7QI9M','USER','2026-04-03 21:51:16.363828','Le Chi ',0,NULL,'ACTIVE',NULL,NULL),(5,'2026-03-15 21:12:59.000000','pham.dung@gmail.com','$2a$10$e3Mlufc5yXsBRzbwDpUUOuyqa/iOxWPvgBRnSfH.1hbwacH.C0xBa','0912345604','eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJwaGFtLmR1bmdAZ21haWwuY29tIiwiaWF0IjoxNzc1MDU3NjkwLCJleHAiOjE3NzU2NjI0OTB9.FMIdYaRRp19JRTcwVj_kfnfXzj0_XM_OLzdNClO2LUY','USER','2026-04-01 22:34:50.263170','Pham Dung',0,NULL,'ACTIVE',NULL,NULL),(6,'2026-03-15 21:12:59.000000','hoang.giang@gmail.com','$2a$10$e3Mlufc5yXsBRzbwDpUUOuyqa/iOxWPvgBRnSfH.1hbwacH.C0xBa','0912345605',NULL,'USER',NULL,'Hoang Giang',0,NULL,'ACTIVE',NULL,NULL),(7,'2026-03-15 21:12:59.000000','vu.hai@gmail.com','$2a$10$e3Mlufc5yXsBRzbwDpUUOuyqa/iOxWPvgBRnSfH.1hbwacH.C0xBa','0912345606',NULL,'USER',NULL,'Vu Hai',0,NULL,'ACTIVE',NULL,NULL),(8,'2026-03-15 21:12:59.000000','dang.khoa@gmail.com','$2a$10$e3Mlufc5yXsBRzbwDpUUOuyqa/iOxWPvgBRnSfH.1hbwacH.C0xBa','0912345607',NULL,'USER',NULL,'Dang Khoa',0,NULL,'ACTIVE',NULL,NULL),(9,'2026-03-15 21:12:59.000000','do.linh@gmail.com','$2a$10$e3Mlufc5yXsBRzbwDpUUOuyqa/iOxWPvgBRnSfH.1hbwacH.C0xBa','0912345608',NULL,'USER',NULL,'Do Linh',0,NULL,'ACTIVE',NULL,NULL),(10,'2026-03-15 21:12:59.000000','pham.minh@gmail.com','$2a$10$e3Mlufc5yXsBRzbwDpUUOuyqa/iOxWPvgBRnSfH.1hbwacH.C0xBa','0912345609',NULL,'USER',NULL,'Pham Minh',0,NULL,'ACTIVE',NULL,NULL),(11,'2026-03-15 21:12:59.000000','tran.ngoc@gmail.com','$2a$10$e3Mlufc5yXsBRzbwDpUUOuyqa/iOxWPvgBRnSfH.1hbwacH.C0xBa','0912345610',NULL,'USER',NULL,'Tran Ngoc',0,NULL,'ACTIVE',NULL,NULL),(12,'2026-03-15 21:12:59.000000','nguyen.phuc@gmail.com','$2a$10$e3Mlufc5yXsBRzbwDpUUOuyqa/iOxWPvgBRnSfH.1hbwacH.C0xBa','0912345611',NULL,'USER',NULL,'Nguyen Phuc',0,NULL,'ACTIVE',NULL,NULL),(13,'2026-03-15 21:12:59.000000','le.quan@gmail.com','$2a$10$e3Mlufc5yXsBRzbwDpUUOuyqa/iOxWPvgBRnSfH.1hbwacH.C0xBa','0912345612',NULL,'USER',NULL,'Le Quan',0,NULL,'ACTIVE',NULL,NULL),(14,'2026-03-15 21:12:59.000000','hoang.son@gmail.com','$2a$10$e3Mlufc5yXsBRzbwDpUUOuyqa/iOxWPvgBRnSfH.1hbwacH.C0xBa','0912345613',NULL,'USER',NULL,'Hoang Son',0,NULL,'ACTIVE',NULL,NULL),(15,'2026-03-15 21:12:59.000000','pham.tuan@gmail.com','$2a$10$e3Mlufc5yXsBRzbwDpUUOuyqa/iOxWPvgBRnSfH.1hbwacH.C0xBa','0912345614',NULL,'USER',NULL,'Pham Tuan',0,NULL,'ACTIVE',NULL,NULL),(16,'2026-03-15 21:12:59.000000','dang.viet@gmail.com','$2a$10$e3Mlufc5yXsBRzbwDpUUOuyqa/iOxWPvgBRnSfH.1hbwacH.C0xBa','0912345615',NULL,'USER',NULL,'Dang Viet',0,NULL,'ACTIVE',NULL,NULL),(17,'2026-03-15 21:12:59.000000','nguyen.yen@gmail.com','$2a$10$e3Mlufc5yXsBRzbwDpUUOuyqa/iOxWPvgBRnSfH.1hbwacH.C0xBa','0912345616',NULL,'USER',NULL,'Nguyen Yen',0,NULL,'ACTIVE',NULL,NULL),(18,'2026-03-15 21:12:59.000000','tran.ha@gmail.com','$2a$10$e3Mlufc5yXsBRzbwDpUUOuyqa/iOxWPvgBRnSfH.1hbwacH.C0xBa','0912345617',NULL,'USER',NULL,'Tran Ha',0,NULL,'ACTIVE',NULL,NULL),(19,'2026-03-15 21:12:59.000000','le.trang@gmail.com','$2a$10$e3Mlufc5yXsBRzbwDpUUOuyqa/iOxWPvgBRnSfH.1hbwacH.C0xBa','0912345618',NULL,'USER',NULL,'Le Trang',0,NULL,'ACTIVE',NULL,NULL),(20,'2026-03-15 21:12:59.000000','pham.huong@gmail.com','$2a$10$e3Mlufc5yXsBRzbwDpUUOuyqa/iOxWPvgBRnSfH.1hbwacH.C0xBa','0912345619',NULL,'USER',NULL,'Pham Huong',0,NULL,'ACTIVE',NULL,NULL),(21,'2026-03-15 21:12:59.000000','vu.thao@gmail.com','$2a$10$e3Mlufc5yXsBRzbwDpUUOuyqa/iOxWPvgBRnSfH.1hbwacH.C0xBa','0912345620',NULL,'USER',NULL,'Vu Thao',0,NULL,'ACTIVE',NULL,NULL),(22,'2026-03-22 10:10:29.178558','manager1@gmail.com','$2a$10$yG9c0Q9w7F516UhIFQmw1.HxAUaTKhXvskGS5g4VgQ/0rfRmwjTP6','0336500001','eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJtYW5hZ2VyMUBnbWFpbC5jb20iLCJpYXQiOjE3NzY5NTUyMzQsImV4cCI6MTc3NzU2MDAzNH0.Zxl884MUk-LRt7sBs07dhzta95cRY2BLgVZhsh_ZGAk','MANAGER','2026-04-23 21:40:34.818216','manager1',0,NULL,'ACTIVE',NULL,NULL),(23,'2026-03-22 13:12:59.050282','manager2@gmail.com','$2a$10$/8Z2aXMgFONUBcDiqRWBiO3dxievFbBvu8sz3SXZG8ppgqIDuVYki','0336500002','eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJtYW5hZ2VyMkBnbWFpbC5jb20iLCJpYXQiOjE3NzU4MTYzMjcsImV4cCI6MTc3NjQyMTEyN30.QdPHI0DY98FkWinHsihZiwpstkETtnqokVz4t0zsb40','MANAGER','2026-04-10 17:18:47.163999','manager2',0,NULL,'ACTIVE',NULL,NULL),(24,'2026-03-22 13:28:37.586736','manager3@gmail.com','$2a$10$cuhMUzEqiNCBiF23OIsJbuvb2e7ZSQDf7FEfsScdWa/qSzimHBQDa','0336500003','eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJtYW5hZ2VyM0BnbWFpbC5jb20iLCJpYXQiOjE3NzQxNjA5NjYsImV4cCI6MTc3NDc2NTc2Nn0.VU12mCShh_1fmu1KbIYHfDGyQkNx8LsECmKZwj3x4Rw','MANAGER','2026-03-22 13:29:26.454738','manager3',0,NULL,'ACTIVE',NULL,NULL),(25,'2026-03-22 18:07:39.747675','bac1@gmail.com','$2a$10$pEjnOOAPuBpzt/jS80AC2.Lp5Sa1PbUAo5YfIN3BcaeqqjjFo6zB2','0336500251','eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJiYWMxQGdtYWlsLmNvbSIsImlhdCI6MTc3NDE3NzcwNywiZXhwIjoxNzc0NzgyNTA3fQ.hjjmWvDT3SlWSun4mpGK_J1jrMcxq5BjpFOGelpw34E','USER','2026-03-22 18:08:34.531125','bac1',1,'2026-03-22 18:08:34.530121','ACTIVE',NULL,NULL),(30,'2026-04-09 22:54:12.505814','bacvx@gmail.com','$2a$10$VvBbFL.HMmjNaulbkLVIJuR9zZExnhCF0ip2CN6yjQN.wXJ2lJWVq','0336500258','eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJiYWN2eEBnbWFpbC5jb20iLCJpYXQiOjE3NzY2ODEzNjcsImV4cCI6MTc3NzI4NjE2N30.eTVCXPIErv1eSE_ZrPZi906y54j2FIUv4TVET9k6GRM','USER','2026-04-20 17:36:07.170548','bacvx',0,NULL,'ACTIVE',NULL,NULL),(31,'2026-04-15 14:23:38.249835','manager4@gmail.com','$2a$10$4iSa.oFkLvw.fotU8lEjy..BB0se756FOUZK9oI2PeAnZTTfEjFEa','0336500254',NULL,'MANAGER','2026-04-15 18:28:05.127611','manager4',0,NULL,'ACTIVE','manager','4'),(32,'2026-04-15 15:00:05.989201','vubac@gmail.com','$2a$10$gpWJsjhMyLsc78yad7zUA.k/6aFsFBpE0g19qfm4ftygChOurOoCK','0336529871','eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ2dWJhY0BnbWFpbC5jb20iLCJpYXQiOjE3NzY2MTQ0MjEsImV4cCI6MTc3NzIxOTIyMX0.K47QcmCRGiiJ_o8Jixs5WU2kAlHVKKE0QphjENtLTMM','USER','2026-04-19 23:00:21.027281','vubac',0,NULL,'ACTIVE','Vũ Xuân','Bắc'),(33,'2026-04-15 18:27:39.412624','manager5@gmail.com','$2a$10$PttB/JUOlo5Py.bH8wYls.K24M5ItARNa5gnqkKY426kbWyyy.EeW','0336500009',NULL,'MANAGER','2026-04-15 18:27:39.412624','manager5',0,NULL,'ACTIVE','manager5','manager5');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

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
-- Dumping data for table `utilities`
--

LOCK TABLES `utilities` WRITE;
/*!40000 ALTER TABLE `utilities` DISABLE KEYS */;
INSERT INTO `utilities` VALUES (1,0,'Wifi miễn phí'),(2,0,'Bãi đỗ xe'),(3,0,'Điều hòa'),(4,0,'Nước nóng'),(5,0,'Tivi'),(6,0,'Bếp riêng'),(7,0,'Máy giặt'),(8,0,'Ban công'),(9,0,'View biển'),(10,0,'View núi'),(11,0,'Hồ bơi'),(12,0,'Lễ tân 24/7'),(13,0,'Cho thuê xe máy'),(14,0,'Ăn sáng miễn phí'),(15,0,'Thú cưng cho phép'),(16,0,'Dọn phòng hàng ngày'),(17,0,'Máy sấy tóc'),(18,0,'Bàn làm việc'),(19,0,'Thang máy'),(20,0,'Phòng gia đình'),(21,0,'Khu BBQ'),(22,0,'Sân vườn'),(23,0,'Quầy bar'),(24,0,'Camera an ninh'),(25,0,'Bình chữa cháy'),(26,0,'Máy pha cà phê'),(27,0,'Cách âm'),(28,0,'Gần trung tâm'),(29,0,'Gần biển'),(30,0,'Phòng gym'),(31,0,'Sân bóng rổ'),(32,0,'Sân bóng bàn');
/*!40000 ALTER TABLE `utilities` ENABLE KEYS */;
UNLOCK TABLES;

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
-- Dumping data for table `utilities_hotel`
--

LOCK TABLES `utilities_hotel` WRITE;
/*!40000 ALTER TABLE `utilities_hotel` DISABLE KEYS */;
INSERT INTO `utilities_hotel` VALUES (1,1),(2,1),(4,1),(8,1),(10,1),(19,1),(25,1),(27,1),(1,2),(2,2),(18,2),(4,3),(12,3),(27,3),(2,4),(13,4),(2,5),(4,5),(6,5),(15,5),(4,6),(5,6),(12,6),(20,6),(7,7),(16,7),(27,7),(2,8),(3,8),(14,8),(27,8),(1,9),(11,9),(4,10),(8,10),(17,10),(2,11),(11,11),(4,12),(6,12),(17,12),(9,13),(19,13),(4,14),(14,14),(12,15),(2,16),(7,16),(15,16),(27,16),(8,17),(2,18),(4,18),(5,18),(16,18),(2,19),(9,19),(18,19),(2,20),(3,20),(13,20),(6,21),(16,21),(10,22),(20,22),(2,23),(13,23),(9,24),(17,24),(8,25),(19,25),(27,25),(11,26),(2,27),(4,27),(14,27),(27,27),(2,28),(10,28),(18,28),(2,29),(7,29),(20,29),(25,29),(2,30),(4,30),(5,30),(15,30),(4,31),(21,31),(4,32),(25,32);
/*!40000 ALTER TABLE `utilities_hotel` ENABLE KEYS */;
UNLOCK TABLES;

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
-- Dumping data for table `utilities_room_type`
--

LOCK TABLES `utilities_room_type` WRITE;
/*!40000 ALTER TABLE `utilities_room_type` DISABLE KEYS */;
INSERT INTO `utilities_room_type` VALUES (2,1),(3,1),(4,1),(7,1),(2,2),(3,2),(4,2),(3,3),(7,3),(4,4),(3,5),(7,5),(7,6),(4,7),(3,8),(4,9),(4,14),(4,15),(6,25),(5,26),(5,28),(6,28),(5,29),(5,30),(6,31),(6,32);
/*!40000 ALTER TABLE `utilities_room_type` ENABLE KEYS */;
UNLOCK TABLES;

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

-- Dump completed on 2026-04-23 22:46:18
