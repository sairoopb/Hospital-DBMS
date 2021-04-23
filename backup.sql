-- MySQL dump 10.17  Distrib 10.3.25-MariaDB, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: hospital
-- ------------------------------------------------------
-- Server version	10.3.25-MariaDB-0ubuntu0.20.04.1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `Aftercare`
--

DROP TABLE IF EXISTS `Aftercare`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Aftercare` (
  `treatment_id` int(11) NOT NULL,
  `room_no` int(11) NOT NULL,
  `start_date` date NOT NULL,
  `end_date` date DEFAULT NULL,
  PRIMARY KEY (`treatment_id`,`room_no`,`start_date`),
  KEY `room_no` (`room_no`),
  CONSTRAINT `Aftercare_ibfk_1` FOREIGN KEY (`treatment_id`) REFERENCES `Treatment` (`treatment_id`) ON DELETE CASCADE,
  CONSTRAINT `Aftercare_ibfk_2` FOREIGN KEY (`room_no`) REFERENCES `Room` (`room_no`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Aftercare`
--

LOCK TABLES `Aftercare` WRITE;
/*!40000 ALTER TABLE `Aftercare` DISABLE KEYS */;
INSERT INTO `Aftercare` VALUES (1,2,'2012-12-03',NULL);
/*!40000 ALTER TABLE `Aftercare` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Appointment`
--

DROP TABLE IF EXISTS `Appointment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Appointment` (
  `doctor_id` int(11) NOT NULL,
  `patient_id` int(11) NOT NULL,
  `date` date NOT NULL,
  `start_time` time NOT NULL,
  PRIMARY KEY (`doctor_id`,`patient_id`,`date`,`start_time`),
  KEY `patient_id` (`patient_id`),
  CONSTRAINT `Appointment_ibfk_1` FOREIGN KEY (`doctor_id`) REFERENCES `Doctor` (`doctor_id`) ON DELETE CASCADE,
  CONSTRAINT `Appointment_ibfk_2` FOREIGN KEY (`patient_id`) REFERENCES `Patient` (`patient_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Appointment`
--

LOCK TABLES `Appointment` WRITE;
/*!40000 ALTER TABLE `Appointment` DISABLE KEYS */;
INSERT INTO `Appointment` VALUES (2,2,'2020-08-05','13:05:13'),(3,3,'2015-12-02','08:35:00');
/*!40000 ALTER TABLE `Appointment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary table structure for view `Appointment_Schedule`
--

DROP TABLE IF EXISTS `Appointment_Schedule`;
/*!50001 DROP VIEW IF EXISTS `Appointment_Schedule`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `Appointment_Schedule` (
  `doctor_id` tinyint NOT NULL,
  `first_name` tinyint NOT NULL,
  `last_name` tinyint NOT NULL,
  `role` tinyint NOT NULL,
  `specialization` tinyint NOT NULL,
  `date` tinyint NOT NULL,
  `start_time` tinyint NOT NULL,
  `room_no` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `Bill`
--

DROP TABLE IF EXISTS `Bill`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Bill` (
  `bill_number` int(11) NOT NULL,
  `bill_type` int(11) DEFAULT NULL,
  `total` decimal(10,2) DEFAULT NULL,
  `subtotal` decimal(10,2) DEFAULT NULL,
  `taxes` decimal(10,2) DEFAULT NULL,
  `paid` int(11) DEFAULT NULL,
  PRIMARY KEY (`bill_number`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Bill`
--

LOCK TABLES `Bill` WRITE;
/*!40000 ALTER TABLE `Bill` DISABLE KEYS */;
INSERT INTO `Bill` VALUES (1,2,762000.00,700000.00,62000.00,0),(2,1,1000.50,969.50,31.00,1),(3,0,6300.00,6000.00,300.00,1),(4,2,855000.00,850500.00,4500.00,1),(5,0,8000.00,7500.00,500.00,1),(6,1,952.95,832.85,120.10,1);
/*!40000 ALTER TABLE `Bill` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Bill_Diag`
--

DROP TABLE IF EXISTS `Bill_Diag`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Bill_Diag` (
  `bill_number` int(11) DEFAULT NULL,
  `diagnosis_id` int(11) NOT NULL,
  PRIMARY KEY (`diagnosis_id`),
  KEY `bill_number` (`bill_number`),
  CONSTRAINT `Bill_Diag_ibfk_1` FOREIGN KEY (`bill_number`) REFERENCES `Bill` (`bill_number`) ON DELETE CASCADE,
  CONSTRAINT `Bill_Diag_ibfk_2` FOREIGN KEY (`diagnosis_id`) REFERENCES `Diagnosis` (`diagnosis_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Bill_Diag`
--

LOCK TABLES `Bill_Diag` WRITE;
/*!40000 ALTER TABLE `Bill_Diag` DISABLE KEYS */;
INSERT INTO `Bill_Diag` VALUES (3,3),(5,2);
/*!40000 ALTER TABLE `Bill_Diag` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary table structure for view `Bill_Report`
--

DROP TABLE IF EXISTS `Bill_Report`;
/*!50001 DROP VIEW IF EXISTS `Bill_Report`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `Bill_Report` (
  `bill_number` tinyint NOT NULL,
  `bill_type` tinyint NOT NULL,
  `total` tinyint NOT NULL,
  `subtotal` tinyint NOT NULL,
  `taxes` tinyint NOT NULL,
  `paid` tinyint NOT NULL,
  `Tests` tinyint NOT NULL,
  `Test Cost` tinyint NOT NULL,
  `Procedures` tinyint NOT NULL,
  `Procedure Cost` tinyint NOT NULL,
  `drug` tinyint NOT NULL,
  `Medicine Qt` tinyint NOT NULL,
  `Medicine Unit Cost` tinyint NOT NULL,
  `patient_id` tinyint NOT NULL,
  `Patient Name` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `Consists`
--

DROP TABLE IF EXISTS `Consists`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Consists` (
  `procedure_id` int(11) NOT NULL,
  `treatment_id` int(11) NOT NULL,
  PRIMARY KEY (`procedure_id`,`treatment_id`),
  KEY `treatment_id` (`treatment_id`),
  CONSTRAINT `Consists_ibfk_1` FOREIGN KEY (`procedure_id`) REFERENCES `Procedure` (`procedure_id`) ON DELETE CASCADE,
  CONSTRAINT `Consists_ibfk_2` FOREIGN KEY (`treatment_id`) REFERENCES `Treatment` (`treatment_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Consists`
--

LOCK TABLES `Consists` WRITE;
/*!40000 ALTER TABLE `Consists` DISABLE KEYS */;
INSERT INTO `Consists` VALUES (1,1),(1,2),(2,1),(4,1),(4,2);
/*!40000 ALTER TABLE `Consists` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Diag_Presc`
--

DROP TABLE IF EXISTS `Diag_Presc`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Diag_Presc` (
  `prescription_id` int(11) DEFAULT NULL,
  `diagnosis_id` int(11) NOT NULL,
  PRIMARY KEY (`diagnosis_id`),
  KEY `prescription_id` (`prescription_id`),
  CONSTRAINT `Diag_Presc_ibfk_1` FOREIGN KEY (`prescription_id`) REFERENCES `Prescription` (`prescription_id`) ON DELETE CASCADE,
  CONSTRAINT `Diag_Presc_ibfk_2` FOREIGN KEY (`diagnosis_id`) REFERENCES `Diagnosis` (`diagnosis_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Diag_Presc`
--

LOCK TABLES `Diag_Presc` WRITE;
/*!40000 ALTER TABLE `Diag_Presc` DISABLE KEYS */;
INSERT INTO `Diag_Presc` VALUES (5,2);
/*!40000 ALTER TABLE `Diag_Presc` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Diagnosis`
--

DROP TABLE IF EXISTS `Diagnosis`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Diagnosis` (
  `diagnosis_id` int(11) NOT NULL,
  `results` varchar(150) DEFAULT NULL,
  PRIMARY KEY (`diagnosis_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Diagnosis`
--

LOCK TABLES `Diagnosis` WRITE;
/*!40000 ALTER TABLE `Diagnosis` DISABLE KEYS */;
INSERT INTO `Diagnosis` VALUES (2,'Scans Normal. No treatment required. Patient advised to take prescribed medicines'),(3,'Type 2 diabetes');
/*!40000 ALTER TABLE `Diagnosis` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary table structure for view `Diagnosis_Raw`
--

DROP TABLE IF EXISTS `Diagnosis_Raw`;
/*!50001 DROP VIEW IF EXISTS `Diagnosis_Raw`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `Diagnosis_Raw` (
  `diagnosis_id` tinyint NOT NULL,
  `patient_id` tinyint NOT NULL,
  `doctor_id` tinyint NOT NULL,
  `test_id` tinyint NOT NULL,
  `prescription_id` tinyint NOT NULL,
  `impliedTreatment` tinyint NOT NULL,
  `bill_number` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `Diagnosis_Report`
--

DROP TABLE IF EXISTS `Diagnosis_Report`;
/*!50001 DROP VIEW IF EXISTS `Diagnosis_Report`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `Diagnosis_Report` (
  `diagnosis_id` tinyint NOT NULL,
  `patient_id` tinyint NOT NULL,
  `doctor_id` tinyint NOT NULL,
  `test_id` tinyint NOT NULL,
  `prescription_id` tinyint NOT NULL,
  `impliedTreatment` tinyint NOT NULL,
  `bill_number` tinyint NOT NULL,
  `Patient` tinyint NOT NULL,
  `Doctor` tinyint NOT NULL,
  `room_no` tinyint NOT NULL,
  `Test Name` tinyint NOT NULL,
  `results` tinyint NOT NULL,
  `Medicine Name` tinyint NOT NULL,
  `unit` tinyint NOT NULL,
  `Diagnosis Result` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `Doctor`
--

DROP TABLE IF EXISTS `Doctor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Doctor` (
  `doctor_id` int(11) NOT NULL AUTO_INCREMENT,
  `first_name` varchar(30) DEFAULT NULL,
  `last_name` varchar(30) DEFAULT NULL,
  `contact_no` varchar(15) DEFAULT NULL,
  `address` varchar(50) DEFAULT NULL,
  `salary` decimal(10,2) DEFAULT NULL,
  `specialization` varchar(30) DEFAULT NULL,
  `role` varchar(30) DEFAULT NULL,
  `room_no` int(11) NOT NULL,
  PRIMARY KEY (`doctor_id`),
  UNIQUE KEY `contact_no` (`contact_no`),
  KEY `room_no` (`room_no`),
  CONSTRAINT `Doctor_ibfk_1` FOREIGN KEY (`room_no`) REFERENCES `Room` (`room_no`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Doctor`
--

LOCK TABLES `Doctor` WRITE;
/*!40000 ALTER TABLE `Doctor` DISABLE KEYS */;
INSERT INTO `Doctor` VALUES (1,'Devika','Patel','9733277342','E2, Near Lsr Collage, East Of Kailash, Delhi',80000.00,'Neuro surgeon','surgeon',2),(2,'Ameretat','Sachdev','02226609802','Rotary Service Centre, Mumbai',150000.00,'Orthopedics','General Physicain',5),(3,'Revati','Mehta','9733277444','274 /b, Girdhari Sadan, N.c.kelkar Road',100000.00,'Orthopaedics','Orthopedic surgeons',2),(4,'Saka','Ghate','07925501915','29 /b, Asopalav, Khanpur',20000.00,'Cardiology','Pathologist',5),(5,'Matsya','Sridhar','2660030345','Bundi Mottu Avenue Road Cross, Avenue Road',100000.00,'Pediatrics','Pediatrician',5);
/*!40000 ALTER TABLE `Doctor` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Done_In`
--

DROP TABLE IF EXISTS `Done_In`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Done_In` (
  `treatment_id` int(11) NOT NULL,
  `room_no` int(11) NOT NULL,
  PRIMARY KEY (`treatment_id`),
  KEY `room_no` (`room_no`),
  CONSTRAINT `Done_In_ibfk_1` FOREIGN KEY (`treatment_id`) REFERENCES `Treatment` (`treatment_id`) ON DELETE CASCADE,
  CONSTRAINT `Done_In_ibfk_2` FOREIGN KEY (`room_no`) REFERENCES `Room` (`room_no`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Done_In`
--

LOCK TABLES `Done_In` WRITE;
/*!40000 ALTER TABLE `Done_In` DISABLE KEYS */;
INSERT INTO `Done_In` VALUES (1,1),(2,1);
/*!40000 ALTER TABLE `Done_In` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Employee`
--

DROP TABLE IF EXISTS `Employee`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Employee` (
  `employee_id` int(11) NOT NULL AUTO_INCREMENT,
  `first_name` varchar(30) DEFAULT NULL,
  `last_name` varchar(30) DEFAULT NULL,
  `contact_no` varchar(15) DEFAULT NULL,
  `occupation` varchar(30) DEFAULT NULL,
  `address` varchar(50) DEFAULT NULL,
  `salary` decimal(10,2) DEFAULT NULL,
  PRIMARY KEY (`employee_id`),
  UNIQUE KEY `contact_no` (`contact_no`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Employee`
--

LOCK TABLES `Employee` WRITE;
/*!40000 ALTER TABLE `Employee` DISABLE KEYS */;
INSERT INTO `Employee` VALUES (1,'arjun','sheikh','9010202211','janitor','Raj Bhavan Road',10000.00),(2,'Rohit','Sharma','9876787687','Driver','Andheri East, Mumbai',20000.00),(3,'naman','ojha','9010233211','ward boy','Gachibowli, Hyderabad',7000.00),(4,'azad','kade','9911234544','cleaning staff','JUbilee Hills, Hyderabad',10000.00),(5,'Pitamaha','Khandke','02227221431','mechanic','Himayathnagar, Hyderabad',99948.03);
/*!40000 ALTER TABLE `Employee` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Implies`
--

DROP TABLE IF EXISTS `Implies`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Implies` (
  `diagnosis_id` int(11) NOT NULL,
  `treatment_id` int(11) NOT NULL,
  PRIMARY KEY (`diagnosis_id`),
  KEY `treatment_id` (`treatment_id`),
  CONSTRAINT `Implies_ibfk_1` FOREIGN KEY (`diagnosis_id`) REFERENCES `Diagnosis` (`diagnosis_id`) ON DELETE CASCADE,
  CONSTRAINT `Implies_ibfk_2` FOREIGN KEY (`treatment_id`) REFERENCES `Treatment` (`treatment_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Implies`
--

LOCK TABLES `Implies` WRITE;
/*!40000 ALTER TABLE `Implies` DISABLE KEYS */;
INSERT INTO `Implies` VALUES (3,2);
/*!40000 ALTER TABLE `Implies` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Includes`
--

DROP TABLE IF EXISTS `Includes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Includes` (
  `medicine_id` int(11) NOT NULL,
  `prescription_id` int(11) NOT NULL,
  `unit` int(11) DEFAULT 1,
  PRIMARY KEY (`medicine_id`,`prescription_id`),
  KEY `prescription_id` (`prescription_id`),
  CONSTRAINT `Includes_ibfk_1` FOREIGN KEY (`medicine_id`) REFERENCES `Medicine` (`medicine_id`) ON DELETE CASCADE,
  CONSTRAINT `Includes_ibfk_2` FOREIGN KEY (`prescription_id`) REFERENCES `Prescription` (`prescription_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Includes`
--

LOCK TABLES `Includes` WRITE;
/*!40000 ALTER TABLE `Includes` DISABLE KEYS */;
INSERT INTO `Includes` VALUES (1,1,1),(2,1,1),(2,5,1),(4,1,1),(4,5,1),(5,5,1);
/*!40000 ALTER TABLE `Includes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Involves`
--

DROP TABLE IF EXISTS `Involves`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Involves` (
  `diagnosis_id` int(11) NOT NULL,
  `test_id` int(11) NOT NULL,
  `results` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`diagnosis_id`,`test_id`),
  KEY `test_id` (`test_id`),
  CONSTRAINT `Involves_ibfk_1` FOREIGN KEY (`diagnosis_id`) REFERENCES `Diagnosis` (`diagnosis_id`) ON DELETE CASCADE,
  CONSTRAINT `Involves_ibfk_2` FOREIGN KEY (`test_id`) REFERENCES `Test` (`test_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Involves`
--

LOCK TABLES `Involves` WRITE;
/*!40000 ALTER TABLE `Involves` DISABLE KEYS */;
INSERT INTO `Involves` VALUES (2,2,''),(2,3,''),(3,5,'Positive');
/*!40000 ALTER TABLE `Involves` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Medical_Bill`
--

DROP TABLE IF EXISTS `Medical_Bill`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Medical_Bill` (
  `prescription_id` int(11) NOT NULL,
  `bill_number` int(11) NOT NULL,
  PRIMARY KEY (`prescription_id`),
  KEY `bill_number` (`bill_number`),
  CONSTRAINT `Medical_Bill_ibfk_1` FOREIGN KEY (`prescription_id`) REFERENCES `Prescription` (`prescription_id`) ON DELETE CASCADE,
  CONSTRAINT `Medical_Bill_ibfk_2` FOREIGN KEY (`bill_number`) REFERENCES `Bill` (`bill_number`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Medical_Bill`
--

LOCK TABLES `Medical_Bill` WRITE;
/*!40000 ALTER TABLE `Medical_Bill` DISABLE KEYS */;
INSERT INTO `Medical_Bill` VALUES (1,2),(5,6);
/*!40000 ALTER TABLE `Medical_Bill` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Medicine`
--

DROP TABLE IF EXISTS `Medicine`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Medicine` (
  `medicine_id` int(11) NOT NULL AUTO_INCREMENT,
  `inventory_quantity` int(11) DEFAULT NULL,
  `name` varchar(30) DEFAULT NULL,
  `price` decimal(10,2) DEFAULT NULL,
  PRIMARY KEY (`medicine_id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Medicine`
--

LOCK TABLES `Medicine` WRITE;
/*!40000 ALTER TABLE `Medicine` DISABLE KEYS */;
INSERT INTO `Medicine` VALUES (1,145,'Ifosfamide',551.65),(2,78,'Cisplatin',360.00),(3,233,'Oxaliplatin',4798.00),(4,124,'Methotrexate',57.85),(5,112,'Busulfan',415.00);
/*!40000 ALTER TABLE `Medicine` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Nurse`
--

DROP TABLE IF EXISTS `Nurse`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Nurse` (
  `nurse_id` int(11) NOT NULL AUTO_INCREMENT,
  `first_name` varchar(30) DEFAULT NULL,
  `last_name` varchar(30) DEFAULT NULL,
  `contact_no` varchar(15) DEFAULT NULL,
  `address` varchar(100) DEFAULT NULL,
  `salary` decimal(10,2) DEFAULT NULL,
  PRIMARY KEY (`nurse_id`),
  UNIQUE KEY `contact_no` (`contact_no`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Nurse`
--

LOCK TABLES `Nurse` WRITE;
/*!40000 ALTER TABLE `Nurse` DISABLE KEYS */;
INSERT INTO `Nurse` VALUES (1,'Maheshvari','Gothe','9292451252','241 -, Natraj Market, Sv Road, Malad, Mumbai',40000.00),(2,'Atman','Jain','02225123138','Chittranjan Nagar, Rajawadi, Ghatkoper, Mumbai',25000.00),(3,'Archana','Hans','02227895689','22  Rachna, Sector , Vashi, Mumbai',30000.00),(4,'Bharat','Badal','02228882593','109 , Parasrampuria Chambers, Opp Rly Stn, Malad (west)',35000.00),(5,'Manda','Saran','02223862592','448  A, Girgaum, Mumbai',25000.00);
/*!40000 ALTER TABLE `Nurse` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Patient`
--

DROP TABLE IF EXISTS `Patient`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Patient` (
  `patient_id` int(11) NOT NULL,
  `first_name` varchar(30) DEFAULT NULL,
  `last_name` varchar(30) DEFAULT NULL,
  `contact_no` varchar(15) DEFAULT NULL,
  `address` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`patient_id`),
  UNIQUE KEY `contact_no` (`contact_no`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Patient`
--

LOCK TABLES `Patient` WRITE;
/*!40000 ALTER TABLE `Patient` DISABLE KEYS */;
INSERT INTO `Patient` VALUES (1,'Jyotish','Divan','02223443172','417 ,sai Chambers,  Narshi Natha St, Chinch Bunder'),(2,'Yasmine','Kumar','02224464461','349 ,Allied Indl Estae Off Mmc, Off M.m.c Road, Mahim'),(3,'Supriya','Shanker','02224092768','41 /, Sadar Nagar No , Sion');
/*!40000 ALTER TABLE `Patient` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Patient_Log`
--

DROP TABLE IF EXISTS `Patient_Log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Patient_Log` (
  `patient_id` int(11) NOT NULL,
  `checkin` datetime NOT NULL,
  `checkout` datetime DEFAULT NULL,
  PRIMARY KEY (`patient_id`,`checkin`),
  CONSTRAINT `Patient_Log_ibfk_1` FOREIGN KEY (`patient_id`) REFERENCES `Patient` (`patient_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Patient_Log`
--

LOCK TABLES `Patient_Log` WRITE;
/*!40000 ALTER TABLE `Patient_Log` DISABLE KEYS */;
INSERT INTO `Patient_Log` VALUES (1,'2012-12-02 20:20:10',NULL),(2,'2020-08-05 14:56:24','2020-08-05 18:34:32'),(3,'2015-12-02 08:20:10','2015-12-02 11:20:10'),(3,'2015-12-05 10:20:10','2015-12-06 11:20:10');
/*!40000 ALTER TABLE `Patient_Log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Pays`
--

DROP TABLE IF EXISTS `Pays`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Pays` (
  `patient_id` int(11) NOT NULL,
  `bill_number` int(11) NOT NULL,
  PRIMARY KEY (`bill_number`),
  CONSTRAINT `Pays_ibfk_1` FOREIGN KEY (`bill_number`) REFERENCES `Bill` (`bill_number`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Pays`
--

LOCK TABLES `Pays` WRITE;
/*!40000 ALTER TABLE `Pays` DISABLE KEYS */;
INSERT INTO `Pays` VALUES (1,1),(1,2),(3,3),(3,4),(2,5),(2,6);
/*!40000 ALTER TABLE `Pays` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Performs`
--

DROP TABLE IF EXISTS `Performs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Performs` (
  `doctor_id` int(11) NOT NULL,
  `treatment_id` int(11) NOT NULL,
  PRIMARY KEY (`treatment_id`,`doctor_id`),
  KEY `doctor_id` (`doctor_id`),
  CONSTRAINT `Performs_ibfk_1` FOREIGN KEY (`doctor_id`) REFERENCES `Doctor` (`doctor_id`) ON DELETE CASCADE,
  CONSTRAINT `Performs_ibfk_2` FOREIGN KEY (`treatment_id`) REFERENCES `Treatment` (`treatment_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Performs`
--

LOCK TABLES `Performs` WRITE;
/*!40000 ALTER TABLE `Performs` DISABLE KEYS */;
INSERT INTO `Performs` VALUES (1,1),(4,2),(5,2);
/*!40000 ALTER TABLE `Performs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Prescription`
--

DROP TABLE IF EXISTS `Prescription`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Prescription` (
  `prescription_id` int(11) NOT NULL,
  PRIMARY KEY (`prescription_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Prescription`
--

LOCK TABLES `Prescription` WRITE;
/*!40000 ALTER TABLE `Prescription` DISABLE KEYS */;
INSERT INTO `Prescription` VALUES (1),(5);
/*!40000 ALTER TABLE `Prescription` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary table structure for view `Prescription_Report`
--

DROP TABLE IF EXISTS `Prescription_Report`;
/*!50001 DROP VIEW IF EXISTS `Prescription_Report`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `Prescription_Report` (
  `prescription_id` tinyint NOT NULL,
  `unit` tinyint NOT NULL,
  `name` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `Procedure`
--

DROP TABLE IF EXISTS `Procedure`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Procedure` (
  `procedure_id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) DEFAULT NULL,
  `cost` decimal(10,2) DEFAULT NULL,
  PRIMARY KEY (`procedure_id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Procedure`
--

LOCK TABLES `Procedure` WRITE;
/*!40000 ALTER TABLE `Procedure` DISABLE KEYS */;
INSERT INTO `Procedure` VALUES (1,'Coronary Angiogram',63500.00),(2,'Angioplasty',412750.00),(3,'Abdominal aortic aneurysm',508000.00),(4,'Knee Replacement',539750.00),(5,'ACL Reconstruction',285750.00);
/*!40000 ALTER TABLE `Procedure` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Recommends`
--

DROP TABLE IF EXISTS `Recommends`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Recommends` (
  `doctor_id` int(11) NOT NULL,
  `diagnosis_id` int(11) NOT NULL,
  PRIMARY KEY (`diagnosis_id`),
  KEY `doctor_id` (`doctor_id`),
  CONSTRAINT `Recommends_ibfk_1` FOREIGN KEY (`doctor_id`) REFERENCES `Doctor` (`doctor_id`) ON DELETE CASCADE,
  CONSTRAINT `Recommends_ibfk_2` FOREIGN KEY (`diagnosis_id`) REFERENCES `Diagnosis` (`diagnosis_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Recommends`
--

LOCK TABLES `Recommends` WRITE;
/*!40000 ALTER TABLE `Recommends` DISABLE KEYS */;
INSERT INTO `Recommends` VALUES (2,2),(3,3);
/*!40000 ALTER TABLE `Recommends` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Room`
--

DROP TABLE IF EXISTS `Room`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Room` (
  `room_no` int(11) NOT NULL,
  `name` varchar(30) DEFAULT NULL,
  `availability` bit(1) DEFAULT NULL,
  PRIMARY KEY (`room_no`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Room`
--

LOCK TABLES `Room` WRITE;
/*!40000 ALTER TABLE `Room` DISABLE KEYS */;
INSERT INTO `Room` VALUES (1,'ER Room',''),(2,'Doctor Room','\0'),(3,'Aftercare Room',''),(4,'Aftercare Room','\0'),(5,'Doctor Room','\0');
/*!40000 ALTER TABLE `Room` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Serves`
--

DROP TABLE IF EXISTS `Serves`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Serves` (
  `treatment_id` int(11) NOT NULL,
  `nurse_id` int(11) NOT NULL,
  PRIMARY KEY (`treatment_id`,`nurse_id`),
  KEY `nurse_id` (`nurse_id`),
  CONSTRAINT `Serves_ibfk_1` FOREIGN KEY (`treatment_id`) REFERENCES `Treatment` (`treatment_id`) ON DELETE CASCADE,
  CONSTRAINT `Serves_ibfk_2` FOREIGN KEY (`nurse_id`) REFERENCES `Nurse` (`nurse_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Serves`
--

LOCK TABLES `Serves` WRITE;
/*!40000 ALTER TABLE `Serves` DISABLE KEYS */;
INSERT INTO `Serves` VALUES (1,1);
/*!40000 ALTER TABLE `Serves` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Test`
--

DROP TABLE IF EXISTS `Test`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Test` (
  `test_id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) DEFAULT NULL,
  `cost` decimal(10,2) DEFAULT NULL,
  PRIMARY KEY (`test_id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Test`
--

LOCK TABLES `Test` WRITE;
/*!40000 ALTER TABLE `Test` DISABLE KEYS */;
INSERT INTO `Test` VALUES (1,'Ultrasound Imaging',500.00),(2,'MRI',3000.00),(3,'CT Scan',4000.00),(4,'X-Ray',1000.00),(5,'Blood Sugar',5000.00);
/*!40000 ALTER TABLE `Test` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Treated`
--

DROP TABLE IF EXISTS `Treated`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Treated` (
  `patient_id` int(11) DEFAULT NULL,
  `treatment_id` int(11) NOT NULL,
  PRIMARY KEY (`treatment_id`),
  KEY `patient_id` (`patient_id`),
  CONSTRAINT `Treated_ibfk_1` FOREIGN KEY (`patient_id`) REFERENCES `Patient` (`patient_id`) ON DELETE CASCADE,
  CONSTRAINT `Treated_ibfk_2` FOREIGN KEY (`treatment_id`) REFERENCES `Treatment` (`treatment_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Treated`
--

LOCK TABLES `Treated` WRITE;
/*!40000 ALTER TABLE `Treated` DISABLE KEYS */;
INSERT INTO `Treated` VALUES (1,1),(3,2);
/*!40000 ALTER TABLE `Treated` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Treatment`
--

DROP TABLE IF EXISTS `Treatment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Treatment` (
  `treatment_id` int(11) NOT NULL,
  `start_date` date DEFAULT NULL,
  `end_date` date DEFAULT NULL,
  `details` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`treatment_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Treatment`
--

LOCK TABLES `Treatment` WRITE;
/*!40000 ALTER TABLE `Treatment` DISABLE KEYS */;
INSERT INTO `Treatment` VALUES (1,'2012-12-02','2012-12-03','Success with slight knee complication'),(2,'2015-12-05','2015-12-06','Sugar levels reduced');
/*!40000 ALTER TABLE `Treatment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Treatment_Bill`
--

DROP TABLE IF EXISTS `Treatment_Bill`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Treatment_Bill` (
  `bill_number` int(11) DEFAULT NULL,
  `treatment_id` int(11) NOT NULL,
  PRIMARY KEY (`treatment_id`),
  KEY `bill_number` (`bill_number`),
  CONSTRAINT `Treatment_Bill_ibfk_1` FOREIGN KEY (`bill_number`) REFERENCES `Bill` (`bill_number`) ON DELETE CASCADE,
  CONSTRAINT `Treatment_Bill_ibfk_2` FOREIGN KEY (`treatment_id`) REFERENCES `Treatment` (`treatment_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Treatment_Bill`
--

LOCK TABLES `Treatment_Bill` WRITE;
/*!40000 ALTER TABLE `Treatment_Bill` DISABLE KEYS */;
INSERT INTO `Treatment_Bill` VALUES (1,1),(4,2);
/*!40000 ALTER TABLE `Treatment_Bill` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Treatment_Presc`
--

DROP TABLE IF EXISTS `Treatment_Presc`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Treatment_Presc` (
  `treatment_id` int(11) NOT NULL,
  `prescription_id` int(11) NOT NULL,
  PRIMARY KEY (`treatment_id`),
  KEY `prescription_id` (`prescription_id`),
  CONSTRAINT `Treatment_Presc_ibfk_1` FOREIGN KEY (`prescription_id`) REFERENCES `Prescription` (`prescription_id`) ON DELETE CASCADE,
  CONSTRAINT `Treatment_Presc_ibfk_2` FOREIGN KEY (`treatment_id`) REFERENCES `Treatment` (`treatment_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Treatment_Presc`
--

LOCK TABLES `Treatment_Presc` WRITE;
/*!40000 ALTER TABLE `Treatment_Presc` DISABLE KEYS */;
INSERT INTO `Treatment_Presc` VALUES (1,1);
/*!40000 ALTER TABLE `Treatment_Presc` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary table structure for view `Treatment_Raw`
--

DROP TABLE IF EXISTS `Treatment_Raw`;
/*!50001 DROP VIEW IF EXISTS `Treatment_Raw`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `Treatment_Raw` (
  `treatment_id` tinyint NOT NULL,
  `patient_id` tinyint NOT NULL,
  `doctor_id` tinyint NOT NULL,
  `treatmentRoom` tinyint NOT NULL,
  `aftercareRoom` tinyint NOT NULL,
  `aftercareNurseID` tinyint NOT NULL,
  `relatedDiagnosis` tinyint NOT NULL,
  `prescription_id` tinyint NOT NULL,
  `procedure_id` tinyint NOT NULL,
  `bill_number` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `Treatment_Report`
--

DROP TABLE IF EXISTS `Treatment_Report`;
/*!50001 DROP VIEW IF EXISTS `Treatment_Report`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `Treatment_Report` (
  `treatment_id` tinyint NOT NULL,
  `patient_id` tinyint NOT NULL,
  `doctor_id` tinyint NOT NULL,
  `treatmentRoom` tinyint NOT NULL,
  `relatedDiagnosis` tinyint NOT NULL,
  `prescription_id` tinyint NOT NULL,
  `procedure_id` tinyint NOT NULL,
  `Patient` tinyint NOT NULL,
  `Doctor` tinyint NOT NULL,
  `room_no` tinyint NOT NULL,
  `Procedures` tinyint NOT NULL,
  `details` tinyint NOT NULL,
  `Medicine Name` tinyint NOT NULL,
  `unit` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `Undergoes`
--

DROP TABLE IF EXISTS `Undergoes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Undergoes` (
  `patient_id` int(11) DEFAULT NULL,
  `diagnosis_id` int(11) NOT NULL,
  PRIMARY KEY (`diagnosis_id`),
  KEY `patient_id` (`patient_id`),
  CONSTRAINT `Undergoes_ibfk_1` FOREIGN KEY (`patient_id`) REFERENCES `Patient` (`patient_id`) ON DELETE CASCADE,
  CONSTRAINT `Undergoes_ibfk_2` FOREIGN KEY (`diagnosis_id`) REFERENCES `Diagnosis` (`diagnosis_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Undergoes`
--

LOCK TABLES `Undergoes` WRITE;
/*!40000 ALTER TABLE `Undergoes` DISABLE KEYS */;
INSERT INTO `Undergoes` VALUES (2,2),(3,3);
/*!40000 ALTER TABLE `Undergoes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Final view structure for view `Appointment_Schedule`
--

/*!50001 DROP TABLE IF EXISTS `Appointment_Schedule`*/;
/*!50001 DROP VIEW IF EXISTS `Appointment_Schedule`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `Appointment_Schedule` AS select `Doctor`.`doctor_id` AS `doctor_id`,`Doctor`.`first_name` AS `first_name`,`Doctor`.`last_name` AS `last_name`,`Doctor`.`role` AS `role`,`Doctor`.`specialization` AS `specialization`,`Appointment`.`date` AS `date`,`Appointment`.`start_time` AS `start_time`,`Doctor`.`room_no` AS `room_no` from (`Doctor` left join `Appointment` on(`Doctor`.`doctor_id` = `Appointment`.`doctor_id`)) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `Bill_Report`
--

/*!50001 DROP TABLE IF EXISTS `Bill_Report`*/;
/*!50001 DROP VIEW IF EXISTS `Bill_Report`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `Bill_Report` AS select `Bill`.`bill_number` AS `bill_number`,`Bill`.`bill_type` AS `bill_type`,`Bill`.`total` AS `total`,`Bill`.`subtotal` AS `subtotal`,`Bill`.`taxes` AS `taxes`,`Bill`.`paid` AS `paid`,`Test`.`name` AS `Tests`,`Test`.`cost` AS `Test Cost`,`Procedure`.`name` AS `Procedures`,`Procedure`.`cost` AS `Procedure Cost`,`Medicine`.`name` AS `drug`,`Includes`.`unit` AS `Medicine Qt`,`Medicine`.`price` AS `Medicine Unit Cost`,`Patient`.`patient_id` AS `patient_id`,concat(`Patient`.`first_name`,' ',`Patient`.`last_name`) AS `Patient Name` from (((((((((((`Bill` left join `Pays` on(`Pays`.`bill_number` = `Bill`.`bill_number`)) left join `Patient` on(`Patient`.`patient_id` = `Pays`.`patient_id`)) left join `Medical_Bill` on(`Medical_Bill`.`bill_number` = `Bill`.`bill_number`)) left join `Includes` on(`Includes`.`prescription_id` = `Medical_Bill`.`prescription_id`)) left join `Medicine` on(`Medicine`.`medicine_id` = `Includes`.`medicine_id`)) left join `Bill_Diag` on(`Bill_Diag`.`bill_number` = `Bill`.`bill_number`)) left join `Involves` on(`Involves`.`diagnosis_id` = `Bill_Diag`.`diagnosis_id`)) left join `Test` on(`Test`.`test_id` = `Involves`.`test_id`)) left join `Treatment_Bill` on(`Treatment_Bill`.`bill_number` = `Bill`.`bill_number`)) left join `Consists` on(`Consists`.`treatment_id` = `Treatment_Bill`.`treatment_id`)) left join `Procedure` on(`Procedure`.`procedure_id` = `Consists`.`procedure_id`)) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `Diagnosis_Raw`
--

/*!50001 DROP TABLE IF EXISTS `Diagnosis_Raw`*/;
/*!50001 DROP VIEW IF EXISTS `Diagnosis_Raw`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `Diagnosis_Raw` AS select `D`.`diagnosis_id` AS `diagnosis_id`,`Undergoes`.`patient_id` AS `patient_id`,`Recommends`.`doctor_id` AS `doctor_id`,`Involves`.`test_id` AS `test_id`,`Diag_Presc`.`prescription_id` AS `prescription_id`,`Implies`.`treatment_id` AS `impliedTreatment`,`Bill_Diag`.`bill_number` AS `bill_number` from ((((((`Diagnosis` `D` left join `Undergoes` on(`D`.`diagnosis_id` = `Undergoes`.`diagnosis_id`)) left join `Recommends` on(`D`.`diagnosis_id` = `Recommends`.`diagnosis_id`)) left join `Involves` on(`D`.`diagnosis_id` = `Involves`.`diagnosis_id`)) left join `Diag_Presc` on(`D`.`diagnosis_id` = `Diag_Presc`.`diagnosis_id`)) left join `Implies` on(`D`.`diagnosis_id` = `Implies`.`diagnosis_id`)) left join `Bill_Diag` on(`D`.`diagnosis_id` = `Bill_Diag`.`diagnosis_id`)) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `Diagnosis_Report`
--

/*!50001 DROP TABLE IF EXISTS `Diagnosis_Report`*/;
/*!50001 DROP VIEW IF EXISTS `Diagnosis_Report`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `Diagnosis_Report` AS select `Diagnosis_Raw`.`diagnosis_id` AS `diagnosis_id`,`Diagnosis_Raw`.`patient_id` AS `patient_id`,`Diagnosis_Raw`.`doctor_id` AS `doctor_id`,`Diagnosis_Raw`.`test_id` AS `test_id`,`Diagnosis_Raw`.`prescription_id` AS `prescription_id`,`Diagnosis_Raw`.`impliedTreatment` AS `impliedTreatment`,`Diagnosis_Raw`.`bill_number` AS `bill_number`,concat(`Patient`.`first_name`,' ',`Patient`.`last_name`) AS `Patient`,concat(`Doctor`.`first_name`,' ',`Doctor`.`last_name`) AS `Doctor`,`Doctor`.`room_no` AS `room_no`,`Test`.`name` AS `Test Name`,`Involves`.`results` AS `results`,`Medicine`.`name` AS `Medicine Name`,`Includes`.`unit` AS `unit`,`Diagnosis`.`results` AS `Diagnosis Result` from (((((((`Diagnosis_Raw` left join `Patient` on(`Diagnosis_Raw`.`patient_id` = `Patient`.`patient_id`)) left join `Doctor` on(`Diagnosis_Raw`.`doctor_id` = `Doctor`.`doctor_id`)) left join `Test` on(`Diagnosis_Raw`.`test_id` = `Test`.`test_id`)) left join `Involves` on(`Diagnosis_Raw`.`test_id` = `Involves`.`test_id` and `Diagnosis_Raw`.`diagnosis_id` = `Involves`.`diagnosis_id`)) left join `Includes` on(`Diagnosis_Raw`.`prescription_id` = `Includes`.`prescription_id`)) left join `Medicine` on(`Includes`.`medicine_id` = `Medicine`.`medicine_id`)) left join `Diagnosis` on(`Diagnosis_Raw`.`diagnosis_id` = `Diagnosis`.`diagnosis_id`)) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `Prescription_Report`
--

/*!50001 DROP TABLE IF EXISTS `Prescription_Report`*/;
/*!50001 DROP VIEW IF EXISTS `Prescription_Report`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `Prescription_Report` AS select `Includes`.`prescription_id` AS `prescription_id`,`Includes`.`unit` AS `unit`,`Medicine`.`name` AS `name` from (`Includes` left join `Medicine` on(`Includes`.`medicine_id` = `Medicine`.`medicine_id`)) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `Treatment_Raw`
--

/*!50001 DROP TABLE IF EXISTS `Treatment_Raw`*/;
/*!50001 DROP VIEW IF EXISTS `Treatment_Raw`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `Treatment_Raw` AS select `T`.`treatment_id` AS `treatment_id`,`Treated`.`patient_id` AS `patient_id`,`Performs`.`doctor_id` AS `doctor_id`,`Done_In`.`room_no` AS `treatmentRoom`,`Aftercare`.`room_no` AS `aftercareRoom`,`Serves`.`nurse_id` AS `aftercareNurseID`,`Implies`.`diagnosis_id` AS `relatedDiagnosis`,`Treatment_Presc`.`prescription_id` AS `prescription_id`,`Consists`.`procedure_id` AS `procedure_id`,`Treatment_Bill`.`bill_number` AS `bill_number` from (((((((((`Treatment` `T` left join `Treated` on(`T`.`treatment_id` = `Treated`.`treatment_id`)) left join `Performs` on(`T`.`treatment_id` = `Performs`.`treatment_id`)) left join `Done_In` on(`T`.`treatment_id` = `Done_In`.`treatment_id`)) left join `Aftercare` on(`T`.`treatment_id` = `Aftercare`.`treatment_id`)) left join `Serves` on(`T`.`treatment_id` = `Serves`.`treatment_id`)) left join `Implies` on(`T`.`treatment_id` = `Implies`.`treatment_id`)) left join `Treatment_Presc` on(`T`.`treatment_id` = `Treatment_Presc`.`treatment_id`)) left join `Consists` on(`T`.`treatment_id` = `Consists`.`treatment_id`)) left join `Treatment_Bill` on(`T`.`treatment_id` = `Treatment_Bill`.`treatment_id`)) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `Treatment_Report`
--

/*!50001 DROP TABLE IF EXISTS `Treatment_Report`*/;
/*!50001 DROP VIEW IF EXISTS `Treatment_Report`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `Treatment_Report` AS select `T`.`treatment_id` AS `treatment_id`,`T`.`patient_id` AS `patient_id`,`T`.`doctor_id` AS `doctor_id`,`T`.`treatmentRoom` AS `treatmentRoom`,`T`.`relatedDiagnosis` AS `relatedDiagnosis`,`T`.`prescription_id` AS `prescription_id`,`T`.`procedure_id` AS `procedure_id`,concat(`Patient`.`first_name`,' ',`Patient`.`last_name`) AS `Patient`,concat(`Doctor`.`first_name`,' ',`Doctor`.`last_name`) AS `Doctor`,`Doctor`.`room_no` AS `room_no`,`Procedure`.`name` AS `Procedures`,`Treatment`.`details` AS `details`,`Medicine`.`name` AS `Medicine Name`,`Includes`.`unit` AS `unit` from ((((((`Treatment_Raw` `T` left join `Patient` on(`T`.`patient_id` = `Patient`.`patient_id`)) left join `Doctor` on(`T`.`doctor_id` = `Doctor`.`doctor_id`)) left join `Procedure` on(`T`.`procedure_id` = `Procedure`.`procedure_id`)) left join `Includes` on(`T`.`prescription_id` = `Includes`.`prescription_id`)) left join `Medicine` on(`Includes`.`medicine_id` = `Medicine`.`medicine_id`)) left join `Treatment` on(`T`.`treatment_id` = `Treatment`.`treatment_id`)) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2021-04-23 20:47:17
