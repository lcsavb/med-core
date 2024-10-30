/*M!999999\- enable the sandbox mode */ 
-- MariaDB dump 10.19  Distrib 10.5.26-MariaDB, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: medcore_db
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
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `appointments`
--

DROP TABLE IF EXISTS `appointments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `appointments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `patient_id` int(11) NOT NULL,
  `schedule_id` int(11) NOT NULL,
  `medical_records_id` int(11) DEFAULT NULL,
  `appointment_time` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `medical_records_id` (`medical_records_id`),
  KEY `patient_id` (`patient_id`),
  KEY `schedule_id` (`schedule_id`),
  CONSTRAINT `appointments_ibfk_1` FOREIGN KEY (`medical_records_id`) REFERENCES `medical_records` (`id`),
  CONSTRAINT `appointments_ibfk_2` FOREIGN KEY (`patient_id`) REFERENCES `patients` (`id`),
  CONSTRAINT `appointments_ibfk_3` FOREIGN KEY (`schedule_id`) REFERENCES `schedules` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=64 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `appointments`
--

LOCK TABLES `appointments` WRITE;
/*!40000 ALTER TABLE `appointments` DISABLE KEYS */;
INSERT INTO `appointments` (`id`, `patient_id`, `schedule_id`, `medical_records_id`, `appointment_time`) VALUES (1,1,1,NULL,'2024-10-30 00:00:00'),(2,1,2,NULL,'2024-10-30 00:00:00'),(3,2,1,NULL,'2024-10-31 00:00:00'),(4,2,2,NULL,'2024-10-31 00:00:00'),(5,3,1,NULL,'2024-10-30 00:00:00'),(6,3,2,NULL,'2024-10-31 00:00:00'),(7,4,1,NULL,'2024-10-31 00:00:00'),(8,4,2,NULL,'2024-10-30 00:00:00'),(9,5,1,NULL,'2024-10-31 00:00:00'),(10,5,2,NULL,'2024-10-30 00:00:00'),(11,6,1,NULL,'2024-10-30 00:00:00'),(12,6,2,NULL,'2024-10-30 00:00:00'),(13,7,1,NULL,'2024-10-30 00:00:00'),(14,7,2,NULL,'2024-10-30 00:00:00'),(15,8,1,NULL,'2024-10-31 00:00:00'),(16,8,2,NULL,'2024-10-31 00:00:00'),(17,9,1,NULL,'2024-10-30 00:00:00'),(18,9,2,NULL,'2024-10-30 00:00:00'),(19,10,1,NULL,'2024-10-31 00:00:00'),(20,10,2,NULL,'2024-10-31 00:00:00'),(21,11,1,NULL,'2024-10-30 00:00:00'),(22,11,2,NULL,'2024-10-31 00:00:00'),(23,12,1,NULL,'2024-10-31 00:00:00'),(24,12,2,NULL,'2024-10-31 00:00:00'),(25,13,1,NULL,'2024-10-31 00:00:00'),(26,13,2,NULL,'2024-10-30 00:00:00'),(27,14,1,NULL,'2024-10-30 00:00:00'),(28,14,2,NULL,'2024-10-30 00:00:00'),(29,15,1,NULL,'2024-10-31 00:00:00'),(30,15,2,NULL,'2024-10-30 00:00:00'),(31,16,1,NULL,'2024-10-30 00:00:00'),(32,16,2,NULL,'2024-10-31 00:00:00'),(33,17,1,NULL,'2024-10-30 00:00:00'),(34,17,2,NULL,'2024-10-30 00:00:00'),(35,18,1,NULL,'2024-10-31 00:00:00'),(36,18,2,NULL,'2024-10-30 00:00:00'),(37,19,1,NULL,'2024-10-31 00:00:00'),(38,19,2,NULL,'2024-10-30 00:00:00'),(39,20,1,NULL,'2024-10-30 00:00:00'),(40,20,2,NULL,'2024-10-30 00:00:00');
/*!40000 ALTER TABLE `appointments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `care_link`
--

DROP TABLE IF EXISTS `care_link`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `care_link` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `doctor_id` int(11) NOT NULL,
  `patient_id` int(11) NOT NULL,
  `assigned_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `doctor_id` (`doctor_id`),
  KEY `patient_id` (`patient_id`),
  CONSTRAINT `care_link_ibfk_1` FOREIGN KEY (`doctor_id`) REFERENCES `healthcare_professionals` (`id`),
  CONSTRAINT `care_link_ibfk_2` FOREIGN KEY (`patient_id`) REFERENCES `patients` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=30 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `care_link`
--

LOCK TABLES `care_link` WRITE;
/*!40000 ALTER TABLE `care_link` DISABLE KEYS */;
INSERT INTO `care_link` (`id`, `doctor_id`, `patient_id`, `assigned_at`) VALUES (1,1,1,'2024-10-30 13:26:09'),(2,1,2,'2024-10-30 13:26:09'),(3,1,3,'2024-10-30 13:26:09'),(4,2,4,'2024-10-30 13:26:09'),(5,2,5,'2024-10-30 13:26:09'),(6,2,6,'2024-10-30 13:26:09'),(7,2,7,'2024-10-30 13:26:09'),(8,1,8,'2024-10-30 13:26:09'),(9,1,9,'2024-10-30 13:26:09'),(10,1,10,'2024-10-30 13:26:09'),(11,1,11,'2024-10-30 13:26:09'),(12,1,12,'2024-10-30 13:26:09'),(13,1,13,'2024-10-30 13:26:09'),(14,1,14,'2024-10-30 13:26:09'),(15,2,15,'2024-10-30 13:26:09'),(16,1,20,'2024-10-30 13:26:09'),(17,1,19,'2024-10-30 13:26:09'),(18,1,18,'2024-10-30 13:26:09'),(19,1,17,'2024-10-30 13:26:09'),(20,1,16,'2024-10-30 13:26:09'),(23,2,20,'2024-10-30 13:26:09'),(24,2,19,'2024-10-30 13:26:09'),(25,2,18,'2024-10-30 13:26:09'),(26,2,17,'2024-10-30 13:26:09'),(27,2,16,'2024-10-30 13:26:09');
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
  `admin_user_id` int(11) NOT NULL,
  `created_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `admin_user_id` (`admin_user_id`),
  CONSTRAINT `clinics_ibfk_1` FOREIGN KEY (`admin_user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `clinics`
--

LOCK TABLES `clinics` WRITE;
/*!40000 ALTER TABLE `clinics` DISABLE KEYS */;
INSERT INTO `clinics` (`id`, `name`, `address`, `address_number`, `address_complement`, `zip`, `city`, `state`, `country`, `phone`, `email`, `website`, `clinic_type`, `admin_user_id`, `created_at`) VALUES (1,'Health Plus Clinic','123 Wellness Street','100',NULL,'12345','Cityville','CV','US','555-6789','contact@healthplus.com',NULL,'Private',8,NULL);
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
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `employment_link`
--

LOCK TABLES `employment_link` WRITE;
/*!40000 ALTER TABLE `employment_link` DISABLE KEYS */;
INSERT INTO `employment_link` (`id`, `clinic_id`, `doctor_id`, `created_at`) VALUES (1,1,1,'2024-10-30 13:24:49'),(2,1,2,'2024-10-30 13:24:49');
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
  `is_doctor` tinyint(1) NOT NULL,
  `is_admin` tinyint(1) NOT NULL,
  `profession` varchar(50) NOT NULL,
  `full_name` varchar(300) NOT NULL,
  `specialty` varchar(100) DEFAULT NULL,
  `email` varchar(255) NOT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `address` text NOT NULL,
  `address_number` varchar(10) NOT NULL,
  `address_complement` varchar(100) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `user_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `healthcare_professionals_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `healthcare_professionals`
--

LOCK TABLES `healthcare_professionals` WRITE;
/*!40000 ALTER TABLE `healthcare_professionals` DISABLE KEYS */;
INSERT INTO `healthcare_professionals` (`id`, `is_doctor`, `is_admin`, `profession`, `full_name`, `specialty`, `email`, `phone`, `address`, `address_number`, `address_complement`, `created_at`, `user_id`) VALUES (1,1,0,'Doctor','Dr. John Smith','Cardiology','dr.john@example.com','555-1234','456 Main St','200',NULL,'2024-10-30 13:24:49',8),(2,1,0,'Doctor','Dr. Jane Doe','Pediatrics','dr.jane@example.com','555-5678','789 Health St','300',NULL,'2024-10-30 13:24:49',8);
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
  `patient_id` int(11) NOT NULL,
  `record_date` datetime DEFAULT NULL,
  `diagnosis` text NOT NULL,
  `anamnesis` text NOT NULL,
  `evolution` text NOT NULL,
  `pdf_file` blob DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `hash` char(64) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `patient_id` (`patient_id`),
  CONSTRAINT `medical_records_ibfk_1` FOREIGN KEY (`patient_id`) REFERENCES `patients` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `medical_records`
--

LOCK TABLES `medical_records` WRITE;
/*!40000 ALTER TABLE `medical_records` DISABLE KEYS */;
/*!40000 ALTER TABLE `medical_records` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER prevent_medical_records_update
BEFORE UPDATE ON medical_records
FOR EACH ROW
BEGIN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Updates to medical records are not allowed';
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

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
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `patients`
--

LOCK TABLES `patients` WRITE;
/*!40000 ALTER TABLE `patients` DISABLE KEYS */;
INSERT INTO `patients` (`id`, `first_name`, `last_name`, `picture`, `date_of_birth`, `gender`, `address`, `address_number`, `address_complement`, `zip`, `phone`, `email`, `status`, `emergency_contact_name`, `emergency_contact_phone`, `nationality`, `language`, `insurance_provider`, `insurance_policy_number`, `created_at`, `updated_at`) VALUES (1,'Alice','Smith',NULL,'1980-05-15','Female','789 Elm St','12A',NULL,'20000','5551234567','alice.smith@example.com','active',NULL,NULL,NULL,NULL,NULL,NULL,'2024-10-30 13:26:09','2024-10-30 13:26:09'),(2,'Bob','Jones',NULL,'1975-10-20','Male','123 Oak St','5',NULL,'20001','5552345678','bob.jones@example.com','active',NULL,NULL,NULL,NULL,NULL,NULL,'2024-10-30 13:26:09','2024-10-30 13:26:09'),(3,'Charlie','Brown',NULL,'1990-03-25','Male','456 Maple St','23B',NULL,'20002','5553456789','charlie.brown@example.com','active',NULL,NULL,NULL,NULL,NULL,NULL,'2024-10-30 13:26:09','2024-10-30 13:26:09'),(4,'David','Wilson',NULL,'1985-12-30','Male','789 Birch St','2',NULL,'20003','5554567890','david.wilson@example.com','active',NULL,NULL,NULL,NULL,NULL,NULL,'2024-10-30 13:26:09','2024-10-30 13:26:09'),(5,'Emma','Davis',NULL,'1992-07-19','Female','321 Cedar St','19',NULL,'20004','5555678901','emma.davis@example.com','active',NULL,NULL,NULL,NULL,NULL,NULL,'2024-10-30 13:26:09','2024-10-30 13:26:09'),(6,'Fiona','Moore',NULL,'1987-11-11','Female','654 Pine St','10',NULL,'20005','5556789012','fiona.moore@example.com','active',NULL,NULL,NULL,NULL,NULL,NULL,'2024-10-30 13:26:09','2024-10-30 13:26:09'),(7,'George','Taylor',NULL,'1979-08-22','Male','987 Spruce St','3A',NULL,'20006','5557890123','george.taylor@example.com','active',NULL,NULL,NULL,NULL,NULL,NULL,'2024-10-30 13:26:09','2024-10-30 13:26:09'),(8,'Hannah','Anderson',NULL,'1991-02-14','Female','432 Willow St','17',NULL,'20007','5558901234','hannah.anderson@example.com','active',NULL,NULL,NULL,NULL,NULL,NULL,'2024-10-30 13:26:09','2024-10-30 13:26:09'),(9,'Ivy','Thomas',NULL,'1984-04-04','Female','210 Redwood St','9',NULL,'20008','5559012345','ivy.thomas@example.com','active',NULL,NULL,NULL,NULL,NULL,NULL,'2024-10-30 13:26:09','2024-10-30 13:26:09'),(10,'Jack','White',NULL,'1982-06-06','Male','111 Cypress St','5C',NULL,'20009','5550123456','jack.white@example.com','active',NULL,NULL,NULL,NULL,NULL,NULL,'2024-10-30 13:26:09','2024-10-30 13:26:09'),(11,'Laura','Patterson',NULL,'1989-09-12','Female','123 Main St','8',NULL,'20010','5551122334','laura.patterson@example.com','active',NULL,NULL,NULL,NULL,NULL,NULL,'2024-10-30 13:26:09','2024-10-30 13:26:09'),(12,'Mark','Johnson',NULL,'1977-03-17','Male','456 North Ave','20B',NULL,'20011','5552233445','mark.johnson@example.com','active',NULL,NULL,NULL,NULL,NULL,NULL,'2024-10-30 13:26:09','2024-10-30 13:26:09'),(13,'Nina','Williams',NULL,'1993-01-20','Female','789 South St','15A',NULL,'20012','5553344556','nina.williams@example.com','active',NULL,NULL,NULL,NULL,NULL,NULL,'2024-10-30 13:26:09','2024-10-30 13:26:09'),(14,'Oliver','Brown',NULL,'1986-05-29','Male','321 East St','10',NULL,'20013','5554455667','oliver.brown@example.com','active',NULL,NULL,NULL,NULL,NULL,NULL,'2024-10-30 13:26:09','2024-10-30 13:26:09'),(15,'Paula','Roberts',NULL,'1994-10-10','Female','654 West Blvd','13',NULL,'20014','5555566778','paula.roberts@example.com','active',NULL,NULL,NULL,NULL,NULL,NULL,'2024-10-30 13:26:09','2024-10-30 13:26:09'),(16,'Quincy','Young',NULL,'1983-07-07','Male','987 Pine Rd','5',NULL,'20015','5556677889','quincy.young@example.com','active',NULL,NULL,NULL,NULL,NULL,NULL,'2024-10-30 13:26:09','2024-10-30 13:26:09'),(17,'Rachel','Green',NULL,'1995-03-30','Female','432 Maple St','8',NULL,'20016','5557788990','rachel.green@example.com','active',NULL,NULL,NULL,NULL,NULL,NULL,'2024-10-30 13:26:09','2024-10-30 13:26:09'),(18,'Steve','Parker',NULL,'1978-06-15','Male','210 Birch Ave','4',NULL,'20017','5558899001','steve.parker@example.com','active',NULL,NULL,NULL,NULL,NULL,NULL,'2024-10-30 13:26:09','2024-10-30 13:26:09'),(19,'Tina','Turner',NULL,'1981-11-19','Female','123 Elm St','9',NULL,'20018','5559900112','tina.turner@example.com','active',NULL,NULL,NULL,NULL,NULL,NULL,'2024-10-30 13:26:09','2024-10-30 13:26:09'),(20,'Uma','Black',NULL,'1990-08-25','Female','789 Cedar Ln','2',NULL,'20019','5550011223','uma.black@example.com','active',NULL,NULL,NULL,NULL,NULL,NULL,'2024-10-30 13:26:09','2024-10-30 13:26:09');
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
INSERT INTO `schedule_dates` (`id`, `schedule_id`, `schedule_date`, `break_start`, `break_end`, `start_time`, `end_time`) VALUES (1,1,'2024-10-30',NULL,NULL,'09:00:00','12:00:00'),(2,1,'2024-11-04',NULL,NULL,'09:00:00','12:00:00'),(3,1,'2024-11-06',NULL,NULL,'09:00:00','12:00:00'),(4,1,'2024-11-11',NULL,NULL,'09:00:00','12:00:00'),(5,1,'2024-11-13',NULL,NULL,'09:00:00','12:00:00'),(6,1,'2024-11-18',NULL,NULL,'09:00:00','12:00:00'),(7,1,'2024-11-20',NULL,NULL,'09:00:00','12:00:00'),(8,1,'2024-11-25',NULL,NULL,'09:00:00','12:00:00'),(9,1,'2024-11-27',NULL,NULL,'09:00:00','12:00:00'),(10,1,'2024-12-02',NULL,NULL,'09:00:00','12:00:00'),(11,1,'2024-12-04',NULL,NULL,'09:00:00','12:00:00'),(12,1,'2024-12-09',NULL,NULL,'09:00:00','12:00:00'),(13,1,'2024-12-11',NULL,NULL,'09:00:00','12:00:00'),(14,1,'2024-12-16',NULL,NULL,'09:00:00','12:00:00'),(15,1,'2024-12-18',NULL,NULL,'09:00:00','12:00:00'),(16,1,'2024-12-23',NULL,NULL,'09:00:00','12:00:00'),(17,1,'2024-12-25',NULL,NULL,'09:00:00','12:00:00'),(18,1,'2024-12-30',NULL,NULL,'09:00:00','12:00:00'),(19,1,'2025-01-01',NULL,NULL,'09:00:00','12:00:00'),(20,1,'2025-01-06',NULL,NULL,'09:00:00','12:00:00'),(21,1,'2025-01-08',NULL,NULL,'09:00:00','12:00:00'),(22,1,'2025-01-13',NULL,NULL,'09:00:00','12:00:00'),(23,1,'2025-01-15',NULL,NULL,'09:00:00','12:00:00'),(32,2,'2024-10-31',NULL,NULL,'13:00:00','17:00:00'),(33,2,'2024-11-05',NULL,NULL,'13:00:00','17:00:00'),(34,2,'2024-11-07',NULL,NULL,'13:00:00','17:00:00'),(35,2,'2024-11-12',NULL,NULL,'13:00:00','17:00:00'),(36,2,'2024-11-14',NULL,NULL,'13:00:00','17:00:00'),(37,2,'2024-11-19',NULL,NULL,'13:00:00','17:00:00'),(38,2,'2024-11-21',NULL,NULL,'13:00:00','17:00:00'),(39,2,'2024-11-26',NULL,NULL,'13:00:00','17:00:00'),(40,2,'2024-11-28',NULL,NULL,'13:00:00','17:00:00'),(41,2,'2024-12-03',NULL,NULL,'13:00:00','17:00:00'),(42,2,'2024-12-05',NULL,NULL,'13:00:00','17:00:00'),(43,2,'2024-12-10',NULL,NULL,'13:00:00','17:00:00'),(44,2,'2024-12-12',NULL,NULL,'13:00:00','17:00:00'),(45,2,'2024-12-17',NULL,NULL,'13:00:00','17:00:00'),(46,2,'2024-12-19',NULL,NULL,'13:00:00','17:00:00'),(47,2,'2024-12-24',NULL,NULL,'13:00:00','17:00:00'),(48,2,'2024-12-26',NULL,NULL,'13:00:00','17:00:00'),(49,2,'2024-12-31',NULL,NULL,'13:00:00','17:00:00'),(50,2,'2025-01-02',NULL,NULL,'13:00:00','17:00:00'),(51,2,'2025-01-07',NULL,NULL,'13:00:00','17:00:00'),(52,2,'2025-01-09',NULL,NULL,'13:00:00','17:00:00'),(53,2,'2025-01-14',NULL,NULL,'13:00:00','17:00:00'),(54,2,'2025-01-16',NULL,NULL,'13:00:00','17:00:00');
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
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `schedules`
--

LOCK TABLES `schedules` WRITE;
/*!40000 ALTER TABLE `schedules` DISABLE KEYS */;
INSERT INTO `schedules` (`id`, `doctor_id`, `clinic_id`, `available_from`, `available_to`, `appointment_interval`, `start_date`, `end_date`) VALUES (1,1,1,'09:00:00','12:00:00',30,'2024-10-30','2025-01-22'),(2,2,1,'13:00:00','17:00:00',30,'2024-10-30','2025-01-22');
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
  `user_roles` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL DEFAULT 'admin' CHECK (json_valid(`user_roles`)),
  `password_hash` varchar(255) NOT NULL,
  `status` enum('active','inactive') NOT NULL DEFAULT 'active',
  `last_login` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` (`id`, `username`, `name`, `email`, `phone`, `user_roles`, `password_hash`, `status`, `last_login`, `created_at`, `updated_at`) VALUES (8,'clinic_owner','Clinic Owner','owner@example.com','1234567890','[\"admin\"]','hashed_password_placeholder','active',NULL,'2024-10-30 13:24:49','2024-10-30 13:24:49');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping routines for database 'medcore_db'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-10-30 13:37:08
