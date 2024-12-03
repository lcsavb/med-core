/*M!999999\- enable the sandbox mode */ 
-- MariaDB dump 10.19-11.6.2-MariaDB, for Linux (x86_64)
--
-- Host: 0.0.0.0    Database: medcore_db
-- ------------------------------------------------------
-- Server version	10.5.26-MariaDB-ubu2004

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*M!100616 SET @OLD_NOTE_VERBOSITY=@@NOTE_VERBOSITY, NOTE_VERBOSITY=0 */;

--
-- Temporary table structure for view `appointment_search`
--

DROP TABLE IF EXISTS `appointment_search`;
/*!50001 DROP VIEW IF EXISTS `appointment_search`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `appointment_search` AS SELECT
 1 AS `appointment_id`,
  1 AS `appointment_date`,
  1 AS `confirmed`,
  1 AS `patient_id`,
  1 AS `patient_first_name`,
  1 AS `patient_last_name`,
  1 AS `patient_date_of_birth`,
  1 AS `patient_gender`,
  1 AS `patient_phone`,
  1 AS `patient_email`,
  1 AS `patient_insurance_provider`,
  1 AS `doctor_id`,
  1 AS `doctor_name`,
  1 AS `clinic_id`,
  1 AS `clinic_name` */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `appointments`
--

DROP TABLE IF EXISTS `appointments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `appointments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `schedule_id` int(11) DEFAULT NULL,
  `appointment_date` datetime DEFAULT NULL,
  `confirmed` tinyint(1) DEFAULT 0,
  `care_link_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `schedule_id` (`schedule_id`),
  KEY `appointments_care_link_FK` (`care_link_id`),
  CONSTRAINT `appointments_care_link_FK` FOREIGN KEY (`care_link_id`) REFERENCES `care_link` (`id`),
  CONSTRAINT `appointments_ibfk_3` FOREIGN KEY (`schedule_id`) REFERENCES `schedules` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=72 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `appointments`
--

LOCK TABLES `appointments` WRITE;
/*!40000 ALTER TABLE `appointments` DISABLE KEYS */;
INSERT INTO `appointments` VALUES
(64,3,'2024-11-20 09:00:00',0,1),
(65,3,'2024-11-20 09:30:00',0,1),
(66,3,'2024-11-20 10:00:00',0,1),
(67,3,'2024-11-20 10:30:00',0,1),
(68,3,'2024-11-20 11:00:00',0,1),
(69,3,'2024-11-20 11:30:00',0,1),
(70,3,'2024-11-20 12:00:00',0,1),
(71,NULL,NULL,0,0);
/*!40000 ALTER TABLE `appointments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `care_link`
--

DROP TABLE IF EXISTS `care_link`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `care_link` (
  `id` int(11) NOT NULL,
  `clinic_id` int(11) NOT NULL,
  `doctor_id` int(11) NOT NULL,
  `patient_id` int(11) NOT NULL,
  `status` enum('active','inactive') DEFAULT 'active',
  PRIMARY KEY (`id`),
  UNIQUE KEY `clinic_id` (`clinic_id`,`doctor_id`,`patient_id`),
  KEY `doctor_id` (`doctor_id`),
  KEY `patient_id` (`patient_id`),
  CONSTRAINT `care_link_ibfk_1` FOREIGN KEY (`clinic_id`) REFERENCES `clinics` (`id`) ON DELETE CASCADE,
  CONSTRAINT `care_link_ibfk_2` FOREIGN KEY (`doctor_id`) REFERENCES `healthcare_professionals` (`id`) ON DELETE CASCADE,
  CONSTRAINT `care_link_ibfk_3` FOREIGN KEY (`patient_id`) REFERENCES `patients` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `care_link`
--

LOCK TABLES `care_link` WRITE;
/*!40000 ALTER TABLE `care_link` DISABLE KEYS */;
INSERT INTO `care_link` VALUES
(0,3,5,31,'active'),
(1,3,5,22,'active');
/*!40000 ALTER TABLE `care_link` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `clinics`
--

DROP TABLE IF EXISTS `clinics`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `clinics` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `address` text NOT NULL,
  `address_number` varchar(10) NOT NULL,
  `address_complement` varchar(100) DEFAULT NULL,
  `zip` varchar(20) NOT NULL,
  `city` varchar(100) NOT NULL,
  `state` char(2) NOT NULL,
  `country` char(2) NOT NULL,
  `phone` varchar(20) NOT NULL,
  `email` varchar(255) DEFAULT NULL,
  `website` varchar(255) DEFAULT NULL,
  `clinic_type` enum('Public','Private','Mixed') NOT NULL DEFAULT 'Private',
  `user_id` int(11) NOT NULL,
  `created_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `id` (`user_id`),
  CONSTRAINT `clinics_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `clinics`
--

LOCK TABLES `clinics` WRITE;
/*!40000 ALTER TABLE `clinics` DISABLE KEYS */;
INSERT INTO `clinics` VALUES
(3,'Santa Clara','','',NULL,'','','','','',NULL,NULL,'Private',32,NULL),
(4,'Medclinic','','',NULL,'','','','','',NULL,NULL,'Private',32,NULL);
/*!40000 ALTER TABLE `clinics` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `employment_link`
--

DROP TABLE IF EXISTS `employment_link`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `employment_link` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `clinic_id` int(11) NOT NULL,
  `doctor_id` int(11) NOT NULL,
  `created_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `clinic_id` (`clinic_id`),
  KEY `doctor_id` (`doctor_id`),
  CONSTRAINT `employment_link_ibfk_1` FOREIGN KEY (`clinic_id`) REFERENCES `clinics` (`id`),
  CONSTRAINT `employment_link_ibfk_2` FOREIGN KEY (`doctor_id`) REFERENCES `healthcare_professionals` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `employment_link`
--

LOCK TABLES `employment_link` WRITE;
/*!40000 ALTER TABLE `employment_link` DISABLE KEYS */;
INSERT INTO `employment_link` VALUES
(6,3,5,NULL),
(7,4,6,NULL);
/*!40000 ALTER TABLE `employment_link` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `front_desk_users`
--

DROP TABLE IF EXISTS `front_desk_users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `front_desk_users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `is_admin` tinyint(1) NOT NULL,
  `clinic_id` int(11) NOT NULL,
  `email` varchar(255) NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `address` text DEFAULT NULL,
  `address_number` varchar(10) DEFAULT NULL,
  `address_complement` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `clinic_id` (`clinic_id`),
  CONSTRAINT `front_desk_users_ibfk_1` FOREIGN KEY (`clinic_id`) REFERENCES `clinics` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `front_desk_users`
--

LOCK TABLES `front_desk_users` WRITE;
/*!40000 ALTER TABLE `front_desk_users` DISABLE KEYS */;
/*!40000 ALTER TABLE `front_desk_users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `healthcare_professionals`
--

DROP TABLE IF EXISTS `healthcare_professionals`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `healthcare_professionals` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `profession` varchar(50) NOT NULL,
  `full_name` varchar(300) NOT NULL,
  `specialty` varchar(100) DEFAULT NULL,
  `email` varchar(255) NOT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `address` text NOT NULL,
  `address_number` varchar(10) NOT NULL,
  `address_complement` varchar(100) DEFAULT NULL,
  `created_at` text DEFAULT NULL,
  `clinic_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `clinic_id` (`clinic_id`),
  CONSTRAINT `healthcare_professionals_ibfk_1` FOREIGN KEY (`clinic_id`) REFERENCES `clinics` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `healthcare_professionals`
--

LOCK TABLES `healthcare_professionals` WRITE;
/*!40000 ALTER TABLE `healthcare_professionals` DISABLE KEYS */;
INSERT INTO `healthcare_professionals` VALUES
(5,'','Amaro Amancio',NULL,'',NULL,'','',NULL,NULL,3),
(6,'','Sebastiao Salgado',NULL,'',NULL,'','',NULL,NULL,4);
/*!40000 ALTER TABLE `healthcare_professionals` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `medical_records`
--

DROP TABLE IF EXISTS `medical_records`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `medical_records` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `record_date` datetime DEFAULT NULL,
  `diagnosis` text NOT NULL,
  `anamnesis` text NOT NULL,
  `evolution` text NOT NULL,
  `pdf_file` blob DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `hash` char(64) NOT NULL,
  `appointment_id` int(11) NOT NULL,
  `care_link_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_appointment_id` (`appointment_id`),
  KEY `medical_records_care_link_FK` (`care_link_id`),
  CONSTRAINT `fk_appointment_id` FOREIGN KEY (`appointment_id`) REFERENCES `appointments` (`id`) ON DELETE CASCADE,
  CONSTRAINT `medical_records_care_link_FK` FOREIGN KEY (`care_link_id`) REFERENCES `care_link` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `medical_records`
--

LOCK TABLES `medical_records` WRITE;
/*!40000 ALTER TABLE `medical_records` DISABLE KEYS */;
INSERT INTO `medical_records` VALUES
(1,'2024-11-20 11:00:00','Diagnosis for patient 22','Anamnesis for patient 22','Evolution for patient 22',NULL,'2024-11-17 10:00:00','hash_22',64,1),
(2,'2024-11-20 11:00:00','Diagnosis for patient 23','Anamnesis for patient 23','Evolution for patient 23',NULL,'2024-11-17 10:00:00','hash_23',65,1),
(3,'2024-11-20 11:00:00','Diagnosis for patient 24','Anamnesis for patient 24','Evolution for patient 24',NULL,'2024-11-17 10:00:00','hash_24',66,0),
(4,'2024-11-20 11:00:00','Diagnosis for patient 25','Anamnesis for patient 25','Evolution for patient 25',NULL,'2024-11-17 10:00:00','hash_25',67,0),
(5,'2024-11-20 11:00:00','Diagnosis for patient 26','Anamnesis for patient 26','Evolution for patient 26',NULL,'2024-11-17 10:00:00','hash_26',68,0),
(6,'2024-11-20 11:00:00','Diagnosis for patient 27','Anamnesis for patient 27','Evolution for patient 27',NULL,'2024-11-17 10:00:00','hash_27',69,0),
(7,'2024-11-20 11:00:00','Diagnosis for patient 28','Anamnesis for patient 28','Evolution for patient 28',NULL,'2024-11-17 10:00:00','hash_28',70,0);
/*!40000 ALTER TABLE `medical_records` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `patient_identifiers`
--

DROP TABLE IF EXISTS `patient_identifiers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `patient_identifiers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `patient_id` int(11) NOT NULL,
  `identifier_type` enum('SUS','SSN','Insurance_ID','Passport_Number','CPF') NOT NULL,
  `identifier_value` varchar(50) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `patient_identifiers_ibfk_1` (`patient_id`),
  CONSTRAINT `patient_identifiers_ibfk_1` FOREIGN KEY (`patient_id`) REFERENCES `patients` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `patient_identifiers`
--

LOCK TABLES `patient_identifiers` WRITE;
/*!40000 ALTER TABLE `patient_identifiers` DISABLE KEYS */;
/*!40000 ALTER TABLE `patient_identifiers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `patients`
--

DROP TABLE IF EXISTS `patients`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `patients` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `first_name` varchar(50) NOT NULL,
  `last_name` varchar(50) NOT NULL,
  `picture` blob DEFAULT NULL,
  `date_of_birth` date NOT NULL,
  `gender` varchar(10) NOT NULL,
  `address` text NOT NULL,
  `address_number` varchar(10) NOT NULL,
  `address_complement` varchar(100) DEFAULT NULL,
  `zip` varchar(20) NOT NULL,
  `phone` varchar(20) NOT NULL,
  `email` varchar(100) NOT NULL,
  `status` enum('active','inactive','deceased') NOT NULL DEFAULT 'active',
  `emergency_contact_name` varchar(100) DEFAULT NULL,
  `emergency_contact_phone` varchar(20) DEFAULT NULL,
  `nationality` varchar(50) DEFAULT NULL,
  `language` varchar(50) DEFAULT NULL,
  `insurance_provider` varchar(100) DEFAULT NULL,
  `insurance_policy_number` varchar(50) DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=32 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `patients`
--

LOCK TABLES `patients` WRITE;
/*!40000 ALTER TABLE `patients` DISABLE KEYS */;
INSERT INTO `patients` VALUES
(21,'John','Doe',NULL,'1990-01-01','male','123 Main St','10','Apt 1','12345','123-456-7890','johndoe@example.com','active','Jane Doe','098-765-4321','American','English','Blue Cross','INS-1001','2024-11-14 19:47:33','2024-11-14 19:47:33'),
(22,'John','Doe',NULL,'1990-01-01','male','123 Main St','10','Apt 1','12345','123-456-7890','johndoe@example.com','active','Jane Doe','098-765-4321','American','English','Blue Cross','INS-1001','2024-11-14 19:50:39','2024-11-14 19:50:39'),
(23,'Alice','Smith',NULL,'1985-05-15','female','456 Oak St','20','Suite B','67890','234-567-8901','alicesmith@example.com','active','Bob Smith','987-654-3210','Canadian','French','United Health','INS-1002','2024-11-14 19:50:39','2024-11-14 19:50:39'),
(24,'Bob','Johnson',NULL,'1975-03-22','male','789 Pine St','30','Apt 2','54321','345-678-9012','bobjohnson@example.com','active','Anna Johnson','876-543-2109','British','English','Cigna','INS-1003','2024-11-14 19:50:39','2024-11-14 19:50:39'),
(25,'Carol','Taylor',NULL,'1992-09-10','female','101 Maple St','40',NULL,'98765','456-789-0123','caroltaylor@example.com','active','Eve Taylor','765-432-1098','Australian','English','Aetna','INS-1004','2024-11-14 19:50:39','2024-11-14 19:50:39'),
(26,'David','Brown',NULL,'1980-06-30','male','202 Cedar St','50','Unit 3','11223','567-890-1234','davidbrown@example.com','active','Fiona Brown','654-321-0987','Irish','English','Humana','INS-1005','2024-11-14 19:50:39','2024-11-14 19:50:39'),
(27,'Emma','Wilson',NULL,'1988-11-12','female','303 Elm St','60',NULL,'44556','678-901-2345','emmawilson@example.com','active','Harry Wilson','543-210-9876','German','German','Allianz','INS-1006','2024-11-14 19:50:39','2024-11-14 19:50:39'),
(28,'Frank','Moore',NULL,'1979-02-28','male','404 Walnut St','70','Penthouse','77889','789-012-3456','frankmoore@example.com','active','Ivy Moore','432-109-8765','Spanish','Spanish','AXA','INS-1007','2024-11-14 19:50:39','2024-11-14 19:50:39'),
(29,'Grace','Anderson',NULL,'1991-01-01','female','505 Birch St','80','Suite 2','33444','890-123-4567','graceanderson@example.com','active','John Anderson','321-098-7654','French','French','Blue Cross','INS-1008','2024-11-14 19:50:39','2024-11-14 19:50:39'),
(30,'Henry','Thomas',NULL,'1967-03-15','male','606 Cedar St','90',NULL,'55678','901-234-5678','henrythomas@example.com','active','Kathy Thomas','210-987-6543','Italian','Italian','United Health','INS-1009','2024-11-14 19:50:39','2024-11-14 19:50:39'),
(31,'Ivy','Jackson',NULL,'1982-07-19','female','707 Oak St','100','Apt 5','22334','012-345-6789','ivyjackson@example.com','active','Leo Jackson','109-876-5432','American','English','Cigna','INS-1010','2024-11-14 19:50:39','2024-11-14 19:50:39');
/*!40000 ALTER TABLE `patients` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `professional_identifiers`
--

DROP TABLE IF EXISTS `professional_identifiers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `professional_identifiers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `professional_id` int(11) NOT NULL,
  `identifier_type` enum('CRM','State_Medical_License','DEA','NPI','License','Certification') NOT NULL,
  `identifier_value` varchar(50) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `professional_identifiers_ibfk_1` (`professional_id`),
  CONSTRAINT `professional_identifiers_ibfk_1` FOREIGN KEY (`professional_id`) REFERENCES `healthcare_professionals` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `professional_identifiers`
--

LOCK TABLES `professional_identifiers` WRITE;
/*!40000 ALTER TABLE `professional_identifiers` DISABLE KEYS */;
/*!40000 ALTER TABLE `professional_identifiers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `schedule_dates`
--

DROP TABLE IF EXISTS `schedule_dates`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `schedule_dates` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `schedule_id` int(11) NOT NULL,
  `schedule_date` date NOT NULL,
  `break_start` time DEFAULT NULL,
  `break_end` time DEFAULT NULL,
  `start_time` time NOT NULL,
  `end_time` time NOT NULL,
  PRIMARY KEY (`id`),
  KEY `schedule_id` (`schedule_id`),
  CONSTRAINT `schedule_dates_ibfk_1` FOREIGN KEY (`schedule_id`) REFERENCES `schedules` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=63 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `schedule_dates`
--

LOCK TABLES `schedule_dates` WRITE;
/*!40000 ALTER TABLE `schedule_dates` DISABLE KEYS */;
/*!40000 ALTER TABLE `schedule_dates` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `schedules`
--

DROP TABLE IF EXISTS `schedules`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `schedules` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `doctor_id` int(11) NOT NULL,
  `clinic_id` int(11) NOT NULL,
  `available_from` time NOT NULL,
  `available_to` time NOT NULL,
  `appointment_interval` int(11) NOT NULL,
  `start_date` date DEFAULT NULL,
  `end_date` date DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `clinic_id` (`clinic_id`),
  KEY `doctor_id` (`doctor_id`),
  CONSTRAINT `schedules_ibfk_1` FOREIGN KEY (`clinic_id`) REFERENCES `clinics` (`id`),
  CONSTRAINT `schedules_ibfk_2` FOREIGN KEY (`doctor_id`) REFERENCES `healthcare_professionals` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `schedules`
--

LOCK TABLES `schedules` WRITE;
/*!40000 ALTER TABLE `schedules` DISABLE KEYS */;
INSERT INTO `schedules` VALUES
(3,5,3,'08:00:00','12:00:00',30,NULL,NULL);
/*!40000 ALTER TABLE `schedules` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(50) NOT NULL,
  `name` varchar(100) NOT NULL,
  `email` varchar(255) NOT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `password_hash` varchar(255) NOT NULL,
  `status` enum('active','inactive') NOT NULL DEFAULT 'active',
  `last_login` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `healthcare_professional_id` int(11) DEFAULT NULL,
  `front_desk_user_id` int(11) DEFAULT NULL,
  `roles` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`roles`)),
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`),
  UNIQUE KEY `email` (`email`),
  UNIQUE KEY `healthcare_professional_id` (`healthcare_professional_id`),
  UNIQUE KEY `front_desk_user_id` (`front_desk_user_id`),
  CONSTRAINT `fk_front_desk_user_id` FOREIGN KEY (`front_desk_user_id`) REFERENCES `front_desk_users` (`id`),
  CONSTRAINT `fk_healthcare_professional_id` FOREIGN KEY (`healthcare_professional_id`) REFERENCES `healthcare_professionals` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=33 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES
(31,'lcsavb2','clara','lcsaasdfasdfasdfsdfvb@gmail.com','asdf','scrypt:32768:8:1$xDwNKwVArrrp2pYK$f8cfb97396a7a47dd28518fd8b11badb48bea1dbc1d5fbc8d8d56f50156b27f4ce63ff7e8dc930a0287743b7a007153cbdd9bfe39420a5e6faa4bf9148825a52','active',NULL,'2024-11-14 19:26:01','2024-11-14 19:58:47',6,NULL,'[\"doctor\"]'),
(32,'lcs','jlakdsf','lakdjfalksdfjaksldjf@jalksdfjksd.com','65465','scrypt:32768:8:1$FLPrVWsRpodrQml5$9a219e414a2a9c03c3296e484113ce93f15e6e7ce65a7036e501b1a509a31313e9880acf02f9803804aef88742ea7e6850ac08ae87834a2a4ef2a162216f0827','active',NULL,'2024-11-14 19:26:39','2024-11-14 19:58:10',5,NULL,'[\"doctor\",\"front_desk_user\"]');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping routines for database 'medcore_db'
--

--
-- Final view structure for view `appointment_search`
--

/*!50001 DROP VIEW IF EXISTS `appointment_search`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `appointment_search` AS select `a`.`id` AS `appointment_id`,`a`.`appointment_date` AS `appointment_date`,`a`.`confirmed` AS `confirmed`,`cl`.`patient_id` AS `patient_id`,`p`.`first_name` AS `patient_first_name`,`p`.`last_name` AS `patient_last_name`,`p`.`date_of_birth` AS `patient_date_of_birth`,`p`.`gender` AS `patient_gender`,`p`.`phone` AS `patient_phone`,`p`.`email` AS `patient_email`,`p`.`insurance_provider` AS `patient_insurance_provider`,`hp`.`id` AS `doctor_id`,`hp`.`full_name` AS `doctor_name`,`c`.`id` AS `clinic_id`,`c`.`name` AS `clinic_name` from ((((`appointments` `a` join `care_link` `cl` on(`a`.`care_link_id` = `cl`.`id`)) join `patients` `p` on(`cl`.`patient_id` = `p`.`id`)) join `healthcare_professionals` `hp` on(`cl`.`doctor_id` = `hp`.`id`)) join `clinics` `c` on(`cl`.`clinic_id` = `c`.`id`)) */;
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
/*M!100616 SET NOTE_VERBOSITY=@OLD_NOTE_VERBOSITY */;

-- Dump completed on 2024-11-18 22:57:24
