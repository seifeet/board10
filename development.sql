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
) ENGINE=InnoDB AUTO_INCREMENT=146 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `groups`
--

LOCK TABLES `groups` WRITE;
/*!40000 ALTER TABLE `groups` DISABLE KEYS */;
INSERT INTO `groups` VALUES (142,'It is my first private group.','I will talk about making this application.',2,1,0,'2011-09-15 14:46:50','2011-09-15 14:49:25'),(143,'Photo','About photo and photography.',4,1,0,'2011-09-15 15:48:07','2011-09-15 23:22:07'),(144,'Goblins','We will talk about goblins and hobbits and other crap. ',2,1,1,'2011-09-15 23:20:44','2011-09-16 08:29:07'),(145,'It is a special group for very long titles, subjects, and descriptions. Please join it and make your contribution.','By: Sharad Jain|June 6, 200813 Comments\r\n\r\nwill_paginate is very well designed plugin. Besides ActiveRecord object integration, it can integrate with array and any collection that you may have. The README.rdoc (in version 2.2.2) and wiki clearly and concisely document how to use it with ActiveRecord objects. I recently needed to use it for a collection outside of activerecord and here is how I did it.\r\n\r\nMy input params supplied the current page and the per_page. So, I had\r\n\r\ncurrent_page = params[:page]\r\nper_page = params[:per_page] # could be configurable or fixed in your app\r\n1) Fetch your collection:\r\nIn case of ActiveRecord object, we would do:\r\n\r\n@posts = Post.paginate :page => params[:page], :per_page => 50\r\nIn case of non-ActiveRecord, the onus is still on us to fetch just the records that we need. If we can’t and we need to work with full collection, will_paginate doesn’t mind. So, here we go…\r\n\r\n# Non-ActiveRecord Post\r\n@posts = Post.perform_search_and_obtain_collection(params[:criteria])\r\n2) IMP*: Create an instance of WillPaginate::Collection class.\r\n\r\n@page_results = WillPaginate::Collection.create(current_page, per_page, @results.total_results) do |pager|\r\n   pager.replace(@posts.to_array)\r\nend\r\nWillPaginate::Collection extends Array class and added properties like @current_page, @per_page, @total_entries etc. We pass the current_page, per_page properties in constructor and we replace the array contents by converting our @posts to an array (@posts.to_array). This is assuming that @posts contains only the collection for current-page. If @post contains _all_ results, then we can do following:\r\n\r\n@page_results = WillPaginate::Collection.create(current_page, per_page, @results.total_results) do |pager|\r\n  start = (current_page-1)*per_page # assuming current_page is 1 based.\r\n  pager.replace(@posts.to_array[start, per_page])\r\nend\r\nIf our search results were already an array, then it is even easier. All we do is:\r\n\r\n@page_results = @posts.paginate(params[:current_page], params[:per_page])\r\nYes, the plugin adds a method “paginate” to Array class.\r\n\r\nOnce we have an instance of WillPaginate::Collection object, it behaves exactly same as the one we normally obtain from ActiveRecord.paginate() function. So, we can continue to do this in viewer:\r\n\r\n<ol>\r\n<% for post in @page_results -%>\r\n<li>Render `results` in some nice way.</li>\r\n<% end -%>\r\n</ol>\r\n\r\n<p>Now let\'s render us some pagination!</p>\r\n<%= will_paginate @page_results %>\r\nAlso, I encourage you to peek into the source code. I found paginated_section that renders pagination stuff at the top/bottom of page.\r\n\r\n<% paginated_section @posts do %>\r\n<ol id=\"posts\">\r\n<% for post in @posts %>\r\n<li> ... </li>\r\n<% end %>\r\n</ol>\r\n<% end %>\r\nEven the rendering is done using a pluggable class, incase if you want to render page links differently.\r\n\r\nRelated Services: Ruby on Rails Development, Custom Software Development',1,1,0,'2011-09-16 11:31:53','2011-09-16 11:31:53');
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
) ENGINE=InnoDB AUTO_INCREMENT=186 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `members`
--

LOCK TABLES `members` WRITE;
/*!40000 ALTER TABLE `members` DISABLE KEYS */;
INSERT INTO `members` VALUES (178,102,142,1,'2011-09-15 14:46:51','2011-09-15 14:46:51'),(179,103,142,0,'2011-09-15 14:50:20','2011-09-15 14:50:20'),(180,104,143,1,'2011-09-15 15:48:08','2011-09-15 15:48:08'),(181,103,143,0,'2011-09-15 15:49:19','2011-09-15 15:49:19'),(182,105,144,1,'2011-09-15 23:20:44','2011-09-15 23:20:44'),(183,105,143,0,'2011-09-15 23:22:10','2011-09-15 23:22:10'),(184,104,144,0,'2011-09-16 08:29:11','2011-09-16 08:29:11'),(185,104,145,1,'2011-09-16 11:31:53','2011-09-16 11:31:53');
/*!40000 ALTER TABLE `members` ENABLE KEYS */;
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
) ENGINE=InnoDB AUTO_INCREMENT=1848 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `postings`
--

LOCK TABLES `postings` WRITE;
/*!40000 ALTER TABLE `postings` DISABLE KEYS */;
INSERT INTO `postings` VALUES (1827,142,1,102,1,0,'Time is running....','I have spent several weeks writing it...','2011-09-15 14:47:37','2011-09-15 14:47:37',0,0),(1828,142,1,103,1,0,'Hi there!','I am the second visitor on this website.','2011-09-15 14:51:13','2011-09-15 14:51:13',0,0),(1829,142,1,103,1,1,'We go public!','We are going public! Join us now and you will thank us later.','2011-09-15 14:53:06','2011-09-15 14:53:06',0,0),(1830,143,1,104,1,0,'First post about photo','I am an experienced photographer and I like it very much.','2011-09-15 17:24:12','2011-09-15 18:15:04',0,1),(1831,143,1,103,1,0,'I am in!','I also like photography. I would like to join this group.','2011-09-15 17:43:27','2011-09-15 22:57:30',0,1),(1832,143,1,104,1,1,'About me','I made my first photo when I was a child. I liked it a lot.','2011-09-15 23:09:09','2011-09-16 07:32:20',0,1),(1833,144,1,105,1,1,'What do you think?','They all assholes, and I hate them!','2011-09-15 23:21:54','2011-09-15 23:21:54',0,0),(1834,143,1,105,1,1,'I want to join this group','I want to join this group because I hate goblins and I will photoshop them until they dead!','2011-09-15 23:23:03','2011-09-15 23:23:13',0,0),(1838,143,1,104,1,0,'Reply to Marina Alexandrova (104)','Long testing....','2011-09-16 08:09:24','2011-09-16 08:09:24',0,0),(1839,143,1,104,1,0,'Reply to Marina Alexandrova (104)','Long testing....','2011-09-16 08:14:12','2011-09-16 08:14:12',0,0),(1840,143,1,103,1,0,'Reply to Marina Alexandrova (104)','Nice testing!!!','2011-09-16 08:16:12','2011-09-16 08:17:32',0,1),(1841,143,1,104,1,0,'Reply to Andrey Tabachnik (103)','Agree!!!','2011-09-16 08:17:48','2011-09-16 11:12:55',0,1),(1842,143,1,104,1,1,'Reply to all','How are you, guys?!','2011-09-16 08:20:59','2011-09-16 08:21:50',0,1),(1843,143,1,105,1,1,'Reply to Marina Alexandrova (104)','We are fine! We kill them all! Goblins must die!','2011-09-16 08:22:41','2011-09-16 08:22:41',0,0),(1844,144,1,104,1,0,'Hi!','I would like to join your group.','2011-09-16 08:29:41','2011-09-16 08:29:41',0,0),(1845,143,1,103,1,0,'Reply to Marina Alexandrova (104)','Nice testing!!!','2011-09-16 08:57:04','2011-09-16 08:57:04',0,0),(1846,143,1,104,1,1,NULL,'Gooood!','2011-09-16 11:13:14','2011-09-16 11:14:19',0,1),(1847,145,1,104,1,1,'','Yalla! Join the group!','2011-09-16 11:33:49','2011-09-16 11:33:49',0,0);
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
INSERT INTO `schema_migrations` VALUES ('20110907085710'),('20110907113304'),('20110907135738'),('20110909213443'),('20110909221225'),('20110909234414'),('20110913194617'),('20110914120122');
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
) ENGINE=InnoDB AUTO_INCREMENT=106 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (102,'genadi.reznichenko@gmail.com','Genadi','Reznichenko','Israel','','Haifa',1,1,1,NULL,'029b43e39758603d28497070632ed5b76aac814b57440d7cb9f0ec3690ed717c','808a9a3a8119acb92a2145f19f02a3347b9a57f6d2f383b974a5ec4749345e0c','2011-09-15 14:45:57','2011-09-15 14:45:57'),(103,'genreil@yahoo.com','Andrey','Tabachnik','United States','CA','San Jose',0,1,2,NULL,'99acbf6d63607e7c2113981235fedf4c1df00021b88866cec394786802d3966c','21ca448bdbf7873d7b250d40cdff7273dc281f548fe52364fc45b1ffb9277d9b','2011-09-15 14:49:16','2011-09-15 22:58:17'),(104,'hey@gmail.com','Marina','Alexandrova','Russia','','Moscow',0,1,4,NULL,'c2569234e5a787af74041aa24b36bea1f43423e92b989dcc9bae3b527f05bbb0','c02539e10fc05313db19dc8963fc4bfaff5d3051680ee3e475a0ace2138b333b','2011-09-15 15:47:17','2011-09-15 21:31:09'),(105,'Bilbo.Baggins@gmail.com','Bilbo','Baggins','Laplandia','ZU','Kiev',0,1,2,NULL,'8f56c0cd58c4708e681ad17dff469b43344852e179cfd138094b2117d024f7d7','67f8659d807cec854bc469a609c990998be7e22ab1a1d2d0a40d4521ed44ce95','2011-09-15 23:19:12','2011-09-16 11:14:05');
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

-- Dump completed on 2011-09-16 14:36:13
