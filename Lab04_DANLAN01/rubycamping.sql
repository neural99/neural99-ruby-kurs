-- MySQL dump 10.13  Distrib 5.1.41, for debian-linux-gnu (i486)
--
-- Host: localhost    Database: rubycamping
-- ------------------------------------------------------
-- Server version	5.1.41-3ubuntu12.3

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
-- Table structure for table `Cabin`
--

DROP TABLE IF EXISTS `Cabin`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Cabin` (
  `name` varchar(255) DEFAULT NULL,
  `customerID` int(11) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Cabin`
--

LOCK TABLES `Cabin` WRITE;
/*!40000 ALTER TABLE `Cabin` DISABLE KEYS */;
INSERT INTO `Cabin` VALUES ('Frodo',NULL),('Samwise',NULL),('Meriadoc',NULL),('Peregrin',NULL),('Gandalf',NULL),('Aragon',NULL),('Legolas',NULL),('Gimli',NULL),('Boromir',NULL),('Sauron',NULL),('Saruman',NULL),('Gollum',NULL);
/*!40000 ALTER TABLE `Cabin` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Customers`
--

DROP TABLE IF EXISTS `Customers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Customers` (
  `id` int(11) DEFAULT NULL,
  `firstName` varchar(255) DEFAULT NULL,
  `lastName` varchar(255) DEFAULT NULL,
  `adress` varchar(255) DEFAULT NULL,
  `phone` varchar(255) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Customers`
--

LOCK TABLES `Customers` WRITE;
/*!40000 ALTER TABLE `Customers` DISABLE KEYS */;
/*!40000 ALTER TABLE `Customers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `EconomyPost`
--

DROP TABLE IF EXISTS `EconomyPost`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `EconomyPost` (
  `id` int(11) NOT NULL,
  `type` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `EconomyPost`
--

LOCK TABLES `EconomyPost` WRITE;
/*!40000 ALTER TABLE `EconomyPost` DISABLE KEYS */;
/*!40000 ALTER TABLE `EconomyPost` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ElectricityEconomyPost`
--

DROP TABLE IF EXISTS `ElectricityEconomyPost`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ElectricityEconomyPost` (
  `id` int(11) DEFAULT NULL,
  `date` varchar(255) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `kwatts` int(11) DEFAULT NULL,
  `price` int(11) DEFAULT NULL,
  `total` int(11) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ElectricityEconomyPost`
--

LOCK TABLES `ElectricityEconomyPost` WRITE;
/*!40000 ALTER TABLE `ElectricityEconomyPost` DISABLE KEYS */;
/*!40000 ALTER TABLE `ElectricityEconomyPost` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Plot`
--

DROP TABLE IF EXISTS `Plot`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Plot` (
  `id` int(11) DEFAULT NULL,
  `customerID` int(11) DEFAULT NULL,
  `gauge` int(11) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Plot`
--

LOCK TABLES `Plot` WRITE;
/*!40000 ALTER TABLE `Plot` DISABLE KEYS */;
INSERT INTO `Plot` VALUES (1,NULL,3428),(2,NULL,2441),(3,NULL,2221),(4,NULL,2037),(5,NULL,3093),(6,NULL,2517),(7,NULL,2390),(8,NULL,2122),(9,NULL,3979),(10,NULL,2618),(11,NULL,2134),(12,NULL,2243),(13,NULL,2265),(14,NULL,4855),(15,NULL,3897),(16,NULL,2226),(17,NULL,3808),(18,NULL,3208),(19,NULL,2001),(20,NULL,2631),(21,NULL,3710),(22,NULL,3053),(23,NULL,2869),(24,NULL,2019),(25,NULL,2650),(26,NULL,4565),(27,NULL,3923),(28,NULL,3623),(29,NULL,2269),(30,NULL,3942),(31,NULL,2029),(32,NULL,2982),(1,NULL,2936),(2,NULL,3776),(3,NULL,3166),(4,NULL,2325),(5,NULL,2577),(6,NULL,3054),(7,NULL,2501),(8,NULL,2950),(9,NULL,3498),(10,NULL,2638),(11,NULL,3338),(12,NULL,3558),(13,NULL,3744),(14,NULL,2940),(15,NULL,2170),(16,NULL,2647),(17,NULL,3086),(18,NULL,3450),(19,NULL,3598),(20,NULL,3073),(21,NULL,2464),(22,NULL,3197),(23,NULL,3960),(24,NULL,3066),(25,NULL,3654),(26,NULL,3173),(27,NULL,2959),(28,NULL,2505),(29,NULL,2733),(30,NULL,2892),(31,NULL,3790),(32,NULL,2855);
/*!40000 ALTER TABLE `Plot` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `PriceListEntry`
--

DROP TABLE IF EXISTS `PriceListEntry`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `PriceListEntry` (
  `id` int(11) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `value` int(11) DEFAULT NULL,
  `symbol` varchar(255) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `PriceListEntry`
--

LOCK TABLES `PriceListEntry` WRITE;
/*!40000 ALTER TABLE `PriceListEntry` DISABLE KEYS */;
INSERT INTO `PriceListEntry` VALUES (0,'Elpris per kWh',5,'electricity'),(1,'Stuga per dag',450,'cabin_day'),(2,'Husvagn per dag',200,'caravan'),(3,'Husbil per dag',300,'camper'),(4,'TÃ¤lt per dag',150,'tent'),(5,'Stuga per vecka',3000,'cabin_week');
/*!40000 ALTER TABLE `PriceListEntry` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `RentEconomyPost`
--

DROP TABLE IF EXISTS `RentEconomyPost`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `RentEconomyPost` (
  `id` int(11) DEFAULT NULL,
  `date` varchar(255) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `type` varchar(255) DEFAULT NULL,
  `arrival` varchar(255) DEFAULT NULL,
  `departure` varchar(255) DEFAULT NULL,
  `days` int(11) DEFAULT NULL,
  `price` int(11) DEFAULT NULL,
  `payment_plan` varchar(255) DEFAULT NULL,
  `total` int(11) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `RentEconomyPost`
--

LOCK TABLES `RentEconomyPost` WRITE;
/*!40000 ALTER TABLE `RentEconomyPost` DISABLE KEYS */;
/*!40000 ALTER TABLE `RentEconomyPost` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Stay`
--

DROP TABLE IF EXISTS `Stay`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Stay` (
  `customerID` int(11) DEFAULT NULL,
  `arrival` varchar(255) DEFAULT NULL,
  `departure` varchar(255) DEFAULT NULL,
  `type` varchar(255) DEFAULT NULL,
  `plotID` int(11) DEFAULT NULL,
  `cabinID` varchar(255) DEFAULT NULL,
  `payment_plan` varchar(255) DEFAULT NULL,
  `electricity` tinyint(1) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Stay`
--

LOCK TABLES `Stay` WRITE;
/*!40000 ALTER TABLE `Stay` DISABLE KEYS */;
/*!40000 ALTER TABLE `Stay` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2010-07-22  0:02:42
