-- MySQL dump 10.13  Distrib 5.6.2-m5, for Win64 (x86)
--
-- Host: localhost    Database: development
-- ------------------------------------------------------
-- Server version	5.6.2-m5

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `groups`
--

DROP TABLE IF EXISTS `groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `groups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `description` text COLLATE utf8_unicode_ci,
  `view_count` int(11) DEFAULT '0',
  `active` tinyint(1) DEFAULT '1',
  `access_level` int(11) DEFAULT '0',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `groups`
--

LOCK TABLES `groups` WRITE;
/*!40000 ALTER TABLE `groups` DISABLE KEYS */;
INSERT INTO `groups` VALUES (1,'My first group','In this group I will put posts about creation of this website.',5,1,1,'2011-09-18 10:40:08','2011-09-23 11:14:53'),(2,'Testing','I created another account for testing purposes.',4,1,0,'2011-09-18 12:33:15','2011-09-22 15:14:47'),(3,'Ajax','Testing Ajax and more...',7,1,0,'2011-09-20 20:28:23','2011-09-23 21:48:22'),(4,'Goblins','This group is about fantasy.',4,1,0,'2011-09-23 14:00:12','2011-09-23 21:50:15'),(5,'My public group','Welcome to my group. Here we will talk about some crap and something else. I don\'t know what can we talk about, but we have to talk about something. If we talk long enough, we will definitely find something to talk about. ',2,1,1,'2011-09-23 21:54:35','2011-09-24 08:28:40'),(6,'Cool Profile','With this group I will start testing ajax for groups on user profile.',1,1,1,'2011-09-24 08:07:05','2011-09-24 08:07:48');
/*!40000 ALTER TABLE `groups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `members`
--

DROP TABLE IF EXISTS `members`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `members` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `group_id` int(11) DEFAULT NULL,
  `owner` tinyint(1) DEFAULT '0',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_members_on_user_id_and_group_id` (`user_id`,`group_id`),
  KEY `index_members_on_group_id` (`group_id`),
  KEY `index_members_on_owner` (`owner`),
  KEY `index_members_on_user_id` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `members`
--

LOCK TABLES `members` WRITE;
/*!40000 ALTER TABLE `members` DISABLE KEYS */;
INSERT INTO `members` VALUES (1,1,1,1,'2011-09-18 10:40:08','2011-09-18 10:40:08'),(2,2,2,1,'2011-09-18 12:33:16','2011-09-18 12:33:16'),(3,2,1,0,'2011-09-18 12:50:39','2011-09-18 12:50:39'),(4,18,3,1,'2011-09-20 20:28:24','2011-09-20 20:28:24'),(5,22,3,0,'2011-09-20 20:29:01','2011-09-20 20:29:01'),(6,21,4,1,'2011-09-23 14:00:12','2011-09-23 14:00:12'),(7,21,3,0,'2011-09-23 14:02:31','2011-09-23 14:02:31'),(8,23,4,0,'2011-09-23 14:35:11','2011-09-23 14:35:11'),(9,22,5,1,'2011-09-23 21:54:36','2011-09-23 21:54:36'),(10,18,6,1,'2011-09-24 08:07:05','2011-09-24 08:07:05');
/*!40000 ALTER TABLE `members` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `messages`
--

DROP TABLE IF EXISTS `messages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `messages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `from_user` int(11) NOT NULL,
  `to_user` int(11) NOT NULL,
  `subject` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `content` text COLLATE utf8_unicode_ci NOT NULL,
  `msg_type` int(11) NOT NULL,
  `msg_state` int(11) NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `group_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `messages`
--

LOCK TABLES `messages` WRITE;
/*!40000 ALTER TABLE `messages` DISABLE KEYS */;
INSERT INTO `messages` VALUES (1,2,1,'Request to join your group \"My first group\"','Hi!\r\nI would like to join your group.\r\nThank you!',1,2,'2011-09-18 12:49:58','2011-09-18 12:50:39',1),(2,22,18,'Request to join your group \"Ajax\"','Hi!\r\nI would like to join your group.\r\nThank you!',1,2,'2011-09-20 20:28:47','2011-09-20 20:29:00',3),(3,21,18,'Request to join your group \"Ajax\"','Hi!\r\nI would like to join your group.\r\nThank you!',1,2,'2011-09-23 14:02:03','2011-09-23 14:02:31',3),(4,23,21,'Request to join your group \"Goblins\"','Hi! I want this group.',1,2,'2011-09-23 14:34:27','2011-09-23 14:35:11',4);
/*!40000 ALTER TABLE `messages` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `postings`
--

DROP TABLE IF EXISTS `postings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `postings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `group_id` int(11) NOT NULL,
  `active_group` tinyint(1) DEFAULT '1',
  `user_id` int(11) NOT NULL,
  `active_user` tinyint(1) DEFAULT '1',
  `visibility` int(11) DEFAULT '0',
  `subject` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `content` text COLLATE utf8_unicode_ci NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `access_level` int(11) DEFAULT '0',
  `view_count` int(11) DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `index_postings_on_created_at` (`created_at`),
  KEY `index_postings_on_group_id` (`group_id`),
  KEY `index_postings_on_user_id` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=210 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `postings`
--

LOCK TABLES `postings` WRITE;
/*!40000 ALTER TABLE `postings` DISABLE KEYS */;
INSERT INTO `postings` VALUES (45,1,1,1,1,1,'','one!','2011-09-19 09:24:16','2011-09-19 09:24:16',0,0),(46,1,1,1,1,1,'','fdhsdfhfs','2011-09-19 09:34:19','2011-09-19 09:34:19',0,0),(47,1,1,1,1,1,'','new onw','2011-09-19 09:50:26','2011-09-19 09:50:26',0,0),(48,1,1,1,1,1,'','one more','2011-09-19 09:51:54','2011-09-19 09:51:54',0,0),(49,1,1,1,1,1,'','fgsdfgsd','2011-09-19 09:52:45','2011-09-19 09:52:45',0,0),(50,1,1,1,1,1,'','hey!','2011-09-19 10:02:00','2011-09-19 10:02:00',0,0),(51,1,1,1,1,0,'','json','2011-09-19 10:11:04','2011-09-19 10:11:04',0,0),(52,1,1,1,1,1,'','ggggg','2011-09-19 10:18:02','2011-09-19 10:18:02',0,0),(53,1,1,1,1,1,'','ok','2011-09-19 10:24:57','2011-09-19 10:24:57',0,0),(54,1,1,1,1,1,'','hey!','2011-09-19 10:26:48','2011-09-19 10:26:48',0,0),(55,1,1,1,1,1,'','hey!','2011-09-19 10:37:08','2011-09-19 10:37:08',0,0),(56,1,1,1,1,1,'','hey!','2011-09-19 10:37:50','2011-09-19 10:37:50',0,0),(57,1,1,1,1,1,'','hey!','2011-09-19 10:37:51','2011-09-19 10:37:51',0,0),(58,1,1,1,1,0,'ooops','ooops','2011-09-19 10:39:12','2011-09-19 10:39:12',0,0),(59,1,1,1,1,1,'','render!','2011-09-19 10:45:07','2011-09-19 10:45:07',0,0),(60,1,1,1,1,1,'','render!','2011-09-19 10:45:26','2011-09-19 10:45:26',0,0),(61,1,1,1,1,1,'','render!','2011-09-19 10:49:52','2011-09-19 10:49:52',0,0),(62,1,1,1,1,1,'','render!','2011-09-19 11:03:29','2011-09-19 11:03:29',0,0),(63,1,1,1,1,1,'','hhhhhhhhhhhhhhhhhhhhhhhhh','2011-09-19 11:09:45','2011-09-19 11:09:45',0,0),(70,1,1,1,1,1,'','aha','2011-09-19 11:58:07','2011-09-19 11:58:07',0,0),(71,1,1,1,1,1,'','aga!','2011-09-19 11:59:46','2011-09-19 11:59:46',0,0),(75,1,1,1,1,1,'','fadsfads','2011-09-19 12:03:45','2011-09-19 12:03:45',0,0),(76,1,1,1,1,1,'','fadsfads','2011-09-19 12:03:49','2011-09-19 12:03:49',0,0),(77,1,1,1,1,1,'','oppp!','2011-09-19 12:55:07','2011-09-19 12:55:07',0,0),(78,1,1,1,1,1,'','hey!','2011-09-19 13:23:18','2011-09-19 13:23:18',0,0),(79,1,1,1,1,1,'','hhhhh','2011-09-19 13:30:47','2011-09-19 13:30:47',0,0),(80,3,1,22,1,0,'Hi!','Let\'s test this group!','2011-09-20 20:29:44','2011-09-20 20:29:44',0,0),(81,3,1,18,1,0,'','hi!','2011-09-20 20:38:23','2011-09-20 20:38:23',0,0),(82,3,1,22,1,0,'Hi!','Let\'s test this group!','2011-09-20 20:40:45','2011-09-20 20:40:45',0,0),(83,3,1,22,1,0,'Hi!','Let\'s test this group!','2011-09-20 20:43:33','2011-09-20 20:43:33',0,0),(84,3,1,22,1,0,'Hi!','Works?','2011-09-20 20:44:36','2011-09-20 20:44:36',0,0),(85,3,1,18,1,0,'','hey!','2011-09-20 21:43:09','2011-09-20 21:43:09',0,0),(87,3,1,18,1,0,'','oopa....','2011-09-20 21:45:45','2011-09-20 21:45:45',0,0),(88,3,1,18,1,1,'','all right!','2011-09-20 22:07:41','2011-09-24 15:25:48',0,1),(89,3,1,18,1,1,'','hey!','2011-09-20 22:15:22','2011-09-20 22:15:22',0,0),(90,3,1,18,1,0,'','one','2011-09-20 22:16:29','2011-09-20 22:16:29',0,0),(91,3,1,18,1,0,'','two','2011-09-20 22:17:25','2011-09-20 22:17:25',0,0),(92,3,1,18,1,0,'','tree','2011-09-20 22:18:53','2011-09-20 22:18:53',0,0),(93,3,1,18,1,0,'','test!','2011-09-21 00:04:42','2011-09-21 00:04:42',0,0),(94,3,1,18,1,1,'','hey!','2011-09-21 00:13:04','2011-09-21 00:13:04',0,0),(95,3,1,18,1,0,'','oooops!','2011-09-21 00:16:24','2011-09-21 00:16:24',0,0),(96,3,1,18,1,0,'','la!','2011-09-21 00:27:04','2011-09-21 00:27:04',0,0),(97,3,1,18,1,0,'','la!','2011-09-21 00:27:11','2011-09-21 00:27:11',0,0),(98,3,1,18,1,0,'','la!','2011-09-21 00:27:15','2011-09-21 00:27:15',0,0),(99,3,1,18,1,0,'','la!','2011-09-21 00:27:16','2011-09-21 10:01:27',0,2),(100,3,1,18,1,0,'','la!','2011-09-21 00:28:41','2011-09-21 00:28:41',0,0),(101,3,1,18,1,0,'','la!','2011-09-21 00:28:44','2011-09-21 00:28:44',0,0),(102,3,1,18,1,0,'','la!','2011-09-21 00:28:46','2011-09-21 00:28:46',0,0),(103,3,1,18,1,1,'','la!','2011-09-21 00:29:50','2011-09-21 00:29:50',0,0),(104,3,1,18,1,1,'','la!','2011-09-21 00:29:55','2011-09-21 00:29:55',0,0),(105,3,1,18,1,0,'','test!','2011-09-21 00:36:07','2011-09-21 00:36:07',0,0),(106,3,1,18,1,0,'','Hey!','2011-09-21 00:41:10','2011-09-21 00:41:10',0,0),(107,3,1,18,1,0,'','Hey!','2011-09-21 00:41:14','2011-09-21 00:41:14',0,0),(108,3,1,18,1,0,'','na na na','2011-09-21 00:42:30','2011-09-21 00:42:30',0,0),(109,3,1,18,1,0,'','na na na','2011-09-21 00:43:44','2011-09-21 00:43:44',0,0),(110,3,1,18,1,0,'','na na na','2011-09-21 00:43:46','2011-09-21 00:43:46',0,0),(111,3,1,18,1,0,'','hey','2011-09-21 00:58:54','2011-09-21 00:58:54',0,0),(112,3,1,18,1,1,'','hey','2011-09-21 00:59:11','2011-09-21 00:59:11',0,0),(113,3,1,18,1,0,'','clearing...','2011-09-21 07:12:01','2011-09-21 07:12:01',0,0),(114,3,1,18,1,0,'','one more time!','2011-09-21 07:13:50','2011-09-21 07:13:50',0,0),(115,3,1,18,1,0,'','one more!','2011-09-21 07:17:23','2011-09-21 07:17:23',0,0),(116,3,1,18,1,0,'','once again...','2011-09-21 07:19:22','2011-09-21 07:19:22',0,0),(117,3,1,18,1,0,'','one more...','2011-09-21 07:21:01','2011-09-21 07:21:01',0,0),(118,3,1,18,1,0,'','doc ready...','2011-09-21 07:23:22','2011-09-21 07:23:22',0,0),(119,3,1,18,1,0,'','one more try...','2011-09-21 07:25:26','2011-09-21 07:25:26',0,0),(120,3,1,18,1,0,'','YES!!!!','2011-09-21 07:25:35','2011-09-21 07:25:35',0,0),(121,3,1,18,1,0,'ooops','no?','2011-09-21 07:25:48','2011-09-21 07:25:48',0,0),(122,3,1,18,1,0,'ooops','try now!','2011-09-21 07:27:01','2011-09-21 07:27:01',0,0),(123,3,1,18,1,0,'ooops','one more...','2011-09-21 07:27:11','2011-09-21 07:27:11',0,0),(124,3,1,18,1,0,'','again.','2011-09-21 07:27:40','2011-09-21 07:27:40',0,0),(125,3,1,18,1,0,'','let\'s see','2011-09-21 07:31:28','2011-09-21 07:31:28',0,0),(126,3,1,18,1,0,'','hry!','2011-09-21 07:57:16','2011-09-21 07:57:16',0,0),(127,3,1,18,1,0,'','hey!','2011-09-21 08:30:49','2011-09-21 08:30:49',0,0),(128,3,1,18,1,0,'','hey again!','2011-09-21 08:46:44','2011-09-21 08:46:44',0,0),(129,3,1,18,1,0,'','one more...','2011-09-21 08:51:15','2011-09-21 08:51:15',0,0),(130,3,1,18,1,0,'hey','hey!','2011-09-21 09:12:16','2011-09-21 09:12:16',0,0),(131,3,1,18,1,0,'oops','hey!','2011-09-21 09:13:58','2011-09-21 09:13:58',0,0),(132,3,1,22,1,1,'','Hey! I want to post something too!','2011-09-21 09:19:39','2011-09-23 11:03:07',0,5),(133,3,1,18,1,0,'','my new post','2011-09-21 09:24:58','2011-09-21 09:24:58',0,0),(134,3,1,18,1,0,'','gena','2011-09-21 09:55:27','2011-09-21 09:59:02',0,2),(135,3,1,22,1,0,'Reply to Genadi Reznichenko (18)','Да уже... Гена :)','2011-09-21 09:59:21','2011-09-21 09:59:58',0,1),(136,3,1,18,1,0,'Reply to Andrey Tabachnik (22)','hi!','2011-09-21 16:33:34','2011-09-21 16:33:34',0,0),(137,3,1,18,1,0,'Reply to Andrey Tabachnik (22)','hi!','2011-09-21 16:34:06','2011-09-21 16:34:06',0,0),(138,3,1,18,1,0,'hey!','What is new?!','2011-09-21 16:35:01','2011-09-21 16:35:01',0,0),(139,3,1,18,1,0,'hey!','What is new?!','2011-09-21 16:35:08','2011-09-21 16:35:08',0,0),(140,3,1,18,1,0,'','hey!','2011-09-22 09:38:42','2011-09-22 09:38:42',0,0),(141,3,1,18,1,0,'','test','2011-09-22 10:24:51','2011-09-22 10:24:51',0,0),(142,3,1,18,1,0,'','hey!','2011-09-22 11:32:31','2011-09-22 11:32:31',0,0),(143,3,1,18,1,0,'','hey!','2011-09-22 14:08:51','2011-09-22 14:08:51',0,0),(144,3,1,18,1,0,'','test!','2011-09-22 14:11:38','2011-09-22 14:11:38',0,0),(145,3,1,18,1,0,'','hey again!','2011-09-22 14:21:06','2011-09-22 14:21:06',0,0),(146,3,1,18,1,0,'','oppa!','2011-09-22 14:42:41','2011-09-22 14:42:41',0,0),(147,3,1,18,1,0,'','hey!','2011-09-22 15:01:57','2011-09-22 15:01:57',0,0),(148,3,1,18,1,0,'','hey!','2011-09-22 15:02:55','2011-09-22 15:02:55',0,0),(149,3,1,18,1,1,'','test again...','2011-09-22 15:34:35','2011-09-22 15:34:35',0,0),(150,3,1,18,1,0,'','hey!','2011-09-22 16:06:54','2011-09-22 16:06:54',0,0),(151,3,1,18,1,0,'','hey again!','2011-09-22 16:07:26','2011-09-22 16:07:26',0,0),(152,3,1,18,1,0,'','opps!','2011-09-22 16:13:05','2011-09-22 16:13:05',0,0),(153,3,1,18,1,0,'','la-la!!!!','2011-09-22 16:15:01','2011-09-22 16:15:01',0,0),(154,3,1,18,1,0,'','ooopa!','2011-09-22 16:16:51','2011-09-22 16:16:51',0,0),(155,3,1,18,1,0,'','test','2011-09-22 16:19:27','2011-09-22 16:19:27',0,0),(156,3,1,18,1,1,'','let\'s check!','2011-09-22 16:28:17','2011-09-22 16:28:17',0,0),(157,3,1,18,1,0,'','test','2011-09-22 16:31:58','2011-09-22 16:31:58',0,0),(158,3,1,18,1,0,'','hey!','2011-09-22 16:33:01','2011-09-22 16:33:01',0,0),(159,3,1,18,1,0,'','op!','2011-09-22 16:33:37','2011-09-22 16:33:37',0,0),(160,3,1,18,1,0,'','hey!','2011-09-22 16:36:40','2011-09-22 16:36:40',0,0),(162,3,1,18,1,1,'','hey na na na!','2011-09-22 16:52:37','2011-09-22 16:52:37',0,0),(163,3,1,18,1,0,'','oppa!','2011-09-22 17:48:27','2011-09-22 17:48:27',0,0),(164,3,1,18,1,0,'','test','2011-09-22 17:51:52','2011-09-22 17:51:52',0,0),(165,3,1,18,1,0,'','one more','2011-09-22 17:58:04','2011-09-22 17:58:04',0,0),(166,3,1,18,1,1,'','hey! let\'s try!','2011-09-22 19:14:22','2011-09-22 19:14:22',0,0),(167,3,1,18,1,0,'','hey!','2011-09-22 20:46:51','2011-09-22 20:46:51',0,0),(168,3,1,18,1,0,'','hey!','2011-09-22 21:23:52','2011-09-22 21:23:52',0,0),(169,3,1,18,1,0,'','hey! you!','2011-09-22 22:14:59','2011-09-22 22:14:59',0,0),(170,3,1,18,1,0,'','opa!','2011-09-22 22:15:21','2011-09-22 22:15:21',0,0),(171,3,1,18,1,0,'','hey!','2011-09-22 22:18:48','2011-09-22 22:45:54',0,1),(174,3,1,18,1,0,'','hey!','2011-09-22 23:10:32','2011-09-22 23:10:32',0,0),(175,3,1,18,1,0,'','hey again!','2011-09-23 09:13:47','2011-09-23 09:13:47',0,0),(176,3,1,18,1,1,'','test','2011-09-23 09:20:34','2011-09-23 09:48:27',0,1),(177,3,1,18,1,1,'Reply to Andrey Tabachnik (22)','Hi!','2011-09-23 11:03:16','2011-09-23 11:03:16',0,0),(178,3,1,18,1,0,'','testing ajax','2011-09-23 11:33:23','2011-09-23 11:33:23',0,0),(179,3,1,18,1,1,'','it is working!','2011-09-23 11:33:40','2011-09-23 11:33:40',0,0),(180,3,1,22,1,0,'','Hi! It is me! What\'s going on?','2011-09-23 13:55:49','2011-09-23 13:55:49',0,0),(181,3,1,22,1,1,'','Hey!','2011-09-23 13:56:42','2011-09-23 13:56:42',0,0),(182,3,1,22,1,1,'','Once again!','2011-09-23 13:57:24','2011-09-23 13:57:24',0,0),(183,4,1,21,1,1,'Hello!','Hi everyone!','2011-09-23 14:00:43','2011-09-23 14:00:43',0,0),(184,4,1,23,1,0,'I am coming...','Я пришла!','2011-09-23 14:36:20','2011-09-23 14:36:20',0,0),(185,3,1,18,1,0,'','hey!','2011-09-23 21:48:29','2011-09-23 21:48:29',0,0),(186,5,1,22,1,1,'Say \"Hi!\"','Hey! it is my ....th group here.','2011-09-23 22:16:01','2011-09-23 22:16:01',0,0),(187,6,1,18,1,1,'Test','Hey! Let\'s check this out.','2011-09-24 08:33:29','2011-09-24 08:33:29',0,0),(188,6,1,18,1,1,'','let\'s try!','2011-09-24 08:44:30','2011-09-24 08:44:30',0,0),(189,6,1,18,1,1,'','hey!','2011-09-24 08:47:23','2011-09-24 08:47:23',0,0),(190,6,1,18,1,0,'','test','2011-09-24 08:53:05','2011-09-24 08:53:05',0,0),(191,6,1,18,1,1,'','try now!','2011-09-24 09:07:03','2011-09-24 09:07:03',0,0),(192,3,1,18,1,0,'','how r doing?','2011-09-24 09:17:47','2011-09-24 09:17:47',0,0),(193,3,1,18,1,0,'','hey!','2011-09-24 09:18:40','2011-09-24 09:18:40',0,0),(194,3,1,18,1,0,'','let\'s do it!','2011-09-24 09:20:25','2011-09-24 09:20:25',0,0),(195,3,1,18,1,0,'','hey!','2011-09-24 09:28:44','2011-09-24 09:28:44',0,0),(196,3,1,18,1,0,'','hey!','2011-09-24 09:29:36','2011-09-24 09:29:36',0,0),(197,3,1,18,1,0,'','test','2011-09-24 09:30:38','2011-09-24 09:30:38',0,0),(198,3,1,18,1,0,'','try it','2011-09-24 09:40:04','2011-09-24 09:40:04',0,0),(199,3,1,18,1,1,'','again','2011-09-24 09:41:22','2011-09-24 09:41:22',0,0),(200,3,1,18,1,0,'','one more time','2011-09-24 09:42:23','2011-09-24 09:42:23',0,0),(201,3,1,18,1,0,'','and again','2011-09-24 09:43:06','2011-09-24 09:43:06',0,0),(202,3,1,18,1,1,'','and here!','2011-09-24 09:44:10','2011-09-24 09:44:10',0,0),(203,3,1,18,1,0,'','how about now?','2011-09-24 09:45:18','2011-09-24 09:45:18',0,0),(204,6,1,18,1,1,'','and here!','2011-09-24 09:54:08','2011-09-24 09:54:08',0,0),(205,6,1,18,1,1,'','hey!','2011-09-24 10:59:43','2011-09-24 10:59:43',0,0),(206,3,1,18,1,0,'','hey!','2011-09-24 12:14:53','2011-09-24 12:14:53',0,0),(207,3,1,18,1,1,'','writing in Ajax...','2011-09-24 17:41:39','2011-09-24 17:41:39',0,0),(208,6,1,18,1,1,'Hey!','Writing to cool profile...','2011-09-24 17:42:11','2011-09-24 17:42:11',0,0),(209,6,1,18,1,1,'','hey!','2011-09-24 20:03:46','2011-09-24 20:03:46',0,0);
/*!40000 ALTER TABLE `postings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `schema_migrations`
--

DROP TABLE IF EXISTS `schema_migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `schema_migrations` (
  `version` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  UNIQUE KEY `unique_schema_migrations` (`version`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `schema_migrations`
--

LOCK TABLES `schema_migrations` WRITE;
/*!40000 ALTER TABLE `schema_migrations` DISABLE KEYS */;
INSERT INTO `schema_migrations` VALUES ('20110907085710'),('20110907113304'),('20110907135738'),('20110909213443'),('20110909221225'),('20110909234414'),('20110913194617'),('20110914120122'),('20110916142529'),('20110917091724');
/*!40000 ALTER TABLE `schema_migrations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `email` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `first_name` varchar(150) COLLATE utf8_unicode_ci NOT NULL,
  `last_name` varchar(150) COLLATE utf8_unicode_ci NOT NULL,
  `country` varchar(150) COLLATE utf8_unicode_ci DEFAULT NULL,
  `state` varchar(2) COLLATE utf8_unicode_ci DEFAULT NULL,
  `city` varchar(150) COLLATE utf8_unicode_ci DEFAULT NULL,
  `admin` tinyint(1) DEFAULT '0',
  `active` tinyint(1) DEFAULT '1',
  `view_count` int(11) DEFAULT '0',
  `remember_token` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `password_digest` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `salt` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_users_on_email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (18,'genadi.reznichenko@gmail.com','Genadi','Reznichenko','Israel','ZZ','Haifa',0,1,3,NULL,'9dd863583b84eb3c2e95b2baf6272e48f6b553fbd2bbb3ffd3d6f6e0a88b7e50','866dc1caea3e0c9fbe67be3b9555f95ee9f597fdb44659ec48b1eb344240ed69','2011-09-20 12:29:31','2011-09-24 15:24:59'),(21,'myotherneeds@gmail.com','Bilbo','Baggins','Laflandia','ZZ','Top',0,1,3,NULL,'81d284d6cc2d77a2a3c689656a89721058b27551d3a9ab3c2d7097335f6b8cac','a7737b84e09c1c0dae1f8b3cbf5bb2ca2171f5eb1d07eee74f9bc6f459c01351','2011-09-20 12:54:44','2011-09-24 12:10:05'),(22,'genreil@yahoo.com','Andrey','Tabachnik','United States','CA','San Jose',0,1,4,NULL,'618d9a2a0c82c5931147f0a694d57d3c60110cc6cbbfbc2aa8fe0aa25bdf001d','69fd9d393afb564283faed7ac51b4f17a6085bc660fe641116218d0f9d21d18d','2011-09-20 14:42:59','2011-09-23 14:01:44'),(23,'pupsik@gmail.com','Marina','Alexandorva','Israel','','Haifa',0,1,1,NULL,'2bae30c7144ce4ede2749f5e85584a0d066e2eea110390b52015f4e021f648b6','e7cbd28d7fa34b8e2166188470a449869c2c9613608a3ac30836bcafc29700ab','2011-09-23 14:33:23','2011-09-24 17:46:51');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2011-09-24 23:04:58
