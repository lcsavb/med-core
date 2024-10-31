/*M!999999\- enable the sandbox mode */ 
-- MariaDB dump 10.19-11.5.2-MariaDB, for Linux (x86_64)
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
-- Table structure for table `alembic_version`
--

DROP TABLE IF EXISTS `alembic_version`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `alembic_version` (
  `version_num` varchar(32) NOT NULL,
  PRIMARY KEY (`version_num`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `alembic_version`
--

LOCK TABLES `alembic_version` WRITE;
/*!40000 ALTER TABLE `alembic_version` DISABLE KEYS */;
INSERT INTO `alembic_version` VALUES
('3ae47c8761ac');
/*!40000 ALTER TABLE `alembic_version` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `appointments`
--

DROP TABLE IF EXISTS `appointments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `appointments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `patient_id` int(11) NOT NULL,
  `schedule_id` int(11) DEFAULT NULL,
  `medical_records_id` int(11) DEFAULT NULL,
  `appointment_date` datetime DEFAULT NULL,
  `clinic_id` int(11) DEFAULT NULL,
  `healthcare_professional_id` int(11) DEFAULT NULL,
  `confirmed` tinyint(1) DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `medical_records_id` (`medical_records_id`),
  KEY `patient_id` (`patient_id`),
  KEY `schedule_id` (`schedule_id`),
  KEY `fk_clinic` (`clinic_id`),
  KEY `fk_healthcare_professionals` (`healthcare_professional_id`),
  CONSTRAINT `appointments_ibfk_1` FOREIGN KEY (`medical_records_id`) REFERENCES `medical_records` (`id`),
  CONSTRAINT `appointments_ibfk_2` FOREIGN KEY (`patient_id`) REFERENCES `patients` (`id`),
  CONSTRAINT `appointments_ibfk_3` FOREIGN KEY (`schedule_id`) REFERENCES `schedules` (`id`),
  CONSTRAINT `fk_clinic` FOREIGN KEY (`clinic_id`) REFERENCES `clinics` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_doctor` FOREIGN KEY (`healthcare_professional_id`) REFERENCES `healthcare_professionals` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_healthcare_professionals` FOREIGN KEY (`healthcare_professional_id`) REFERENCES `healthcare_professionals` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=64 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `appointments`
--

LOCK TABLES `appointments` WRITE;
/*!40000 ALTER TABLE `appointments` DISABLE KEYS */;
INSERT INTO `appointments` VALUES
(1,1,NULL,NULL,'2024-10-31 09:00:00',1,4,0),
(2,2,NULL,NULL,'2024-10-31 09:30:00',1,4,0),
(3,3,NULL,NULL,'2024-10-31 10:00:00',1,4,0),
(4,4,NULL,NULL,'2024-10-31 10:30:00',1,4,0),
(5,5,NULL,NULL,'2024-10-31 11:00:00',1,4,0),
(6,6,NULL,NULL,'2024-10-31 11:30:00',1,4,0),
(7,7,NULL,NULL,'2024-10-31 12:00:00',1,4,0),
(8,8,NULL,NULL,'2024-10-31 12:30:00',1,4,0),
(9,9,NULL,NULL,'2024-10-31 13:00:00',1,4,0),
(10,10,NULL,NULL,'2024-10-31 13:30:00',1,4,0),
(11,11,NULL,NULL,'2024-10-31 14:00:00',1,4,0),
(12,12,NULL,NULL,'2024-10-31 14:30:00',1,4,0),
(13,13,NULL,NULL,'2024-10-31 15:00:00',1,4,0),
(14,14,NULL,NULL,'2024-10-31 15:30:00',1,4,0),
(15,15,NULL,NULL,'2024-10-31 16:00:00',1,4,0),
(16,16,NULL,NULL,'2024-10-31 16:30:00',1,4,0),
(17,17,NULL,NULL,'2024-10-31 17:00:00',1,4,0),
(18,18,NULL,NULL,'2024-10-31 17:30:00',1,4,0),
(19,19,NULL,NULL,'2024-10-31 18:00:00',1,4,0),
(20,20,NULL,NULL,'2024-10-31 18:30:00',1,4,0);
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
INSERT INTO `care_link` VALUES
(1,1,1,'2024-10-30 13:26:09'),
(2,1,2,'2024-10-30 13:26:09'),
(3,1,3,'2024-10-30 13:26:09'),
(4,2,4,'2024-10-30 13:26:09'),
(5,2,5,'2024-10-30 13:26:09'),
(6,2,6,'2024-10-30 13:26:09'),
(7,2,7,'2024-10-30 13:26:09'),
(8,1,8,'2024-10-30 13:26:09'),
(9,1,9,'2024-10-30 13:26:09'),
(10,1,10,'2024-10-30 13:26:09'),
(11,1,11,'2024-10-30 13:26:09'),
(12,1,12,'2024-10-30 13:26:09'),
(13,1,13,'2024-10-30 13:26:09'),
(14,1,14,'2024-10-30 13:26:09'),
(15,2,15,'2024-10-30 13:26:09'),
(16,1,20,'2024-10-30 13:26:09'),
(17,1,19,'2024-10-30 13:26:09'),
(18,1,18,'2024-10-30 13:26:09'),
(19,1,17,'2024-10-30 13:26:09'),
(20,1,16,'2024-10-30 13:26:09'),
(23,2,20,'2024-10-30 13:26:09'),
(24,2,19,'2024-10-30 13:26:09'),
(25,2,18,'2024-10-30 13:26:09'),
(26,2,17,'2024-10-30 13:26:09'),
(27,2,16,'2024-10-30 13:26:09');
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
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `clinics`
--

LOCK TABLES `clinics` WRITE;
/*!40000 ALTER TABLE `clinics` DISABLE KEYS */;
INSERT INTO `clinics` VALUES
(1,'Health Plus Clinic','123 Wellness Street','100',NULL,'12345','Cityville','CV','US','555-6789','contact@healthplus.com',NULL,'Private',8,NULL);
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
INSERT INTO `employment_link` VALUES
(1,1,1,'2024-10-30 13:24:49'),
(2,1,2,'2024-10-30 13:24:49');
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
  `created_at` text DEFAULT NULL,
  `clinic_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `clinic_id` (`clinic_id`),
  CONSTRAINT `healthcare_professionals_ibfk_1` FOREIGN KEY (`clinic_id`) REFERENCES `clinics` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `healthcare_professionals`
--

LOCK TABLES `healthcare_professionals` WRITE;
/*!40000 ALTER TABLE `healthcare_professionals` DISABLE KEYS */;
INSERT INTO `healthcare_professionals` VALUES
(4,1,0,'Doctor','Dr. Alice Johnson','Neurology','alice.johnson@example.com','555-1234','123 Wellness Street','101',NULL,'20',1);
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
INSERT INTO `patients` VALUES
(1,'John','Doe',NULL,'1985-01-01','M','123 Main St','1',NULL,'12345','555-1234','johndoe@example.com','active',NULL,NULL,NULL,NULL,NULL,NULL,'2024-10-31 21:42:29','2024-10-31 21:42:29'),
(2,'Jane','Smith',NULL,'1987-02-02','F','456 Oak St','2',NULL,'12345','555-5678','janesmith@example.com','active',NULL,NULL,NULL,NULL,NULL,NULL,'2024-10-31 21:42:29','2024-10-31 21:42:29'),
(3,'Alice','Johnson',NULL,'1990-03-03','F','789 Pine St','3',NULL,'12345','555-9012','alicejohnson@example.com','active',NULL,NULL,NULL,NULL,NULL,NULL,'2024-10-31 21:42:29','2024-10-31 21:42:29'),
(4,'Bob','Brown',NULL,'1983-04-04','M','101 Elm St','4',NULL,'12345','555-3456','bobbrown@example.com','active',NULL,NULL,NULL,NULL,NULL,NULL,'2024-10-31 21:42:29','2024-10-31 21:42:29'),
(5,'Charlie','Davis',NULL,'1992-05-05','M','202 Birch St','5',NULL,'12345','555-7890','charliedavis@example.com','active',NULL,NULL,NULL,NULL,NULL,NULL,'2024-10-31 21:42:29','2024-10-31 21:42:29'),
(6,'Diana','Miller',NULL,'1994-06-06','F','303 Maple St','6',NULL,'12345','555-2345','dianamiller@example.com','active',NULL,NULL,NULL,NULL,NULL,NULL,'2024-10-31 21:42:29','2024-10-31 21:42:29'),
(7,'Eve','Garcia',NULL,'1986-07-07','F','404 Cedar St','7',NULL,'12345','555-6789','evegarcia@example.com','active',NULL,NULL,NULL,NULL,NULL,NULL,'2024-10-31 21:42:29','2024-10-31 21:42:29'),
(8,'Frank','Martinez',NULL,'1988-08-08','M','505 Willow St','8',NULL,'12345','555-1234','frankmartinez@example.com','active',NULL,NULL,NULL,NULL,NULL,NULL,'2024-10-31 21:42:29','2024-10-31 21:42:29'),
(9,'Grace','Rodriguez',NULL,'1989-09-09','F','606 Spruce St','9',NULL,'12345','555-5678','gracerodriguez@example.com','active',NULL,NULL,NULL,NULL,NULL,NULL,'2024-10-31 21:42:29','2024-10-31 21:42:29'),
(10,'Henry','Wilson',NULL,'1991-10-10','M','707 Walnut St','10',NULL,'12345','555-9012','henrywilson@example.com','active',NULL,NULL,NULL,NULL,NULL,NULL,'2024-10-31 21:42:29','2024-10-31 21:42:29'),
(11,'Ivy','Lopez',NULL,'1985-11-11','F','808 Chestnut St','11',NULL,'12345','555-3456','ivylopez@example.com','active',NULL,NULL,NULL,NULL,NULL,NULL,'2024-10-31 21:42:29','2024-10-31 21:42:29'),
(12,'Jack','Clark',NULL,'1987-12-12','M','909 Cypress St','12',NULL,'12345','555-7890','jackclark@example.com','active',NULL,NULL,NULL,NULL,NULL,NULL,'2024-10-31 21:42:29','2024-10-31 21:42:29'),
(13,'Karen','Lee',NULL,'1990-01-13','F','1001 Poplar St','13',NULL,'12345','555-2345','karenlee@example.com','active',NULL,NULL,NULL,NULL,NULL,NULL,'2024-10-31 21:42:29','2024-10-31 21:42:29'),
(14,'Leo','Walker',NULL,'1992-02-14','M','1102 Hickory St','14',NULL,'12345','555-6789','leowalker@example.com','active',NULL,NULL,NULL,NULL,NULL,NULL,'2024-10-31 21:42:29','2024-10-31 21:42:29'),
(15,'Mia','Hall',NULL,'1986-03-15','F','1203 Dogwood St','15',NULL,'12345','555-1234','miahall@example.com','active',NULL,NULL,NULL,NULL,NULL,NULL,'2024-10-31 21:42:29','2024-10-31 21:42:29'),
(16,'Nina','Allen',NULL,'1988-04-16','F','1304 Magnolia St','16',NULL,'12345','555-5678','ninaallen@example.com','active',NULL,NULL,NULL,NULL,NULL,NULL,'2024-10-31 21:42:29','2024-10-31 21:42:29'),
(17,'Oscar','Young',NULL,'1989-05-17','M','1405 Redwood St','17',NULL,'12345','555-9012','oscaryoung@example.com','active',NULL,NULL,NULL,NULL,NULL,NULL,'2024-10-31 21:42:29','2024-10-31 21:42:29'),
(18,'Paula','Hernandez',NULL,'1991-06-18','F','1506 Aspen St','18',NULL,'12345','555-3456','paulahernandez@example.com','active',NULL,NULL,NULL,NULL,NULL,NULL,'2024-10-31 21:42:29','2024-10-31 21:42:29'),
(19,'Quinn','King',NULL,'1993-07-19','M','1607 Alder St','19',NULL,'12345','555-7890','quinnking@example.com','active',NULL,NULL,NULL,NULL,NULL,NULL,'2024-10-31 21:42:29','2024-10-31 21:42:29'),
(20,'Rose','Wright',NULL,'1995-08-20','F','1708 Juniper St','20',NULL,'12345','555-2345','rosewright@example.com','active',NULL,NULL,NULL,NULL,NULL,NULL,'2024-10-31 21:42:29','2024-10-31 21:42:29');
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
INSERT INTO `schedule_dates` VALUES
(1,1,'2024-10-30',NULL,NULL,'09:00:00','12:00:00'),
(2,1,'2024-11-04',NULL,NULL,'09:00:00','12:00:00'),
(3,1,'2024-11-06',NULL,NULL,'09:00:00','12:00:00'),
(4,1,'2024-11-11',NULL,NULL,'09:00:00','12:00:00'),
(5,1,'2024-11-13',NULL,NULL,'09:00:00','12:00:00'),
(6,1,'2024-11-18',NULL,NULL,'09:00:00','12:00:00'),
(7,1,'2024-11-20',NULL,NULL,'09:00:00','12:00:00'),
(8,1,'2024-11-25',NULL,NULL,'09:00:00','12:00:00'),
(9,1,'2024-11-27',NULL,NULL,'09:00:00','12:00:00'),
(10,1,'2024-12-02',NULL,NULL,'09:00:00','12:00:00'),
(11,1,'2024-12-04',NULL,NULL,'09:00:00','12:00:00'),
(12,1,'2024-12-09',NULL,NULL,'09:00:00','12:00:00'),
(13,1,'2024-12-11',NULL,NULL,'09:00:00','12:00:00'),
(14,1,'2024-12-16',NULL,NULL,'09:00:00','12:00:00'),
(15,1,'2024-12-18',NULL,NULL,'09:00:00','12:00:00'),
(16,1,'2024-12-23',NULL,NULL,'09:00:00','12:00:00'),
(17,1,'2024-12-25',NULL,NULL,'09:00:00','12:00:00'),
(18,1,'2024-12-30',NULL,NULL,'09:00:00','12:00:00'),
(19,1,'2025-01-01',NULL,NULL,'09:00:00','12:00:00'),
(20,1,'2025-01-06',NULL,NULL,'09:00:00','12:00:00'),
(21,1,'2025-01-08',NULL,NULL,'09:00:00','12:00:00'),
(22,1,'2025-01-13',NULL,NULL,'09:00:00','12:00:00'),
(23,1,'2025-01-15',NULL,NULL,'09:00:00','12:00:00'),
(32,2,'2024-10-31',NULL,NULL,'13:00:00','17:00:00'),
(33,2,'2024-11-05',NULL,NULL,'13:00:00','17:00:00'),
(34,2,'2024-11-07',NULL,NULL,'13:00:00','17:00:00'),
(35,2,'2024-11-12',NULL,NULL,'13:00:00','17:00:00'),
(36,2,'2024-11-14',NULL,NULL,'13:00:00','17:00:00'),
(37,2,'2024-11-19',NULL,NULL,'13:00:00','17:00:00'),
(38,2,'2024-11-21',NULL,NULL,'13:00:00','17:00:00'),
(39,2,'2024-11-26',NULL,NULL,'13:00:00','17:00:00'),
(40,2,'2024-11-28',NULL,NULL,'13:00:00','17:00:00'),
(41,2,'2024-12-03',NULL,NULL,'13:00:00','17:00:00'),
(42,2,'2024-12-05',NULL,NULL,'13:00:00','17:00:00'),
(43,2,'2024-12-10',NULL,NULL,'13:00:00','17:00:00'),
(44,2,'2024-12-12',NULL,NULL,'13:00:00','17:00:00'),
(45,2,'2024-12-17',NULL,NULL,'13:00:00','17:00:00'),
(46,2,'2024-12-19',NULL,NULL,'13:00:00','17:00:00'),
(47,2,'2024-12-24',NULL,NULL,'13:00:00','17:00:00'),
(48,2,'2024-12-26',NULL,NULL,'13:00:00','17:00:00'),
(49,2,'2024-12-31',NULL,NULL,'13:00:00','17:00:00'),
(50,2,'2025-01-02',NULL,NULL,'13:00:00','17:00:00'),
(51,2,'2025-01-07',NULL,NULL,'13:00:00','17:00:00'),
(52,2,'2025-01-09',NULL,NULL,'13:00:00','17:00:00'),
(53,2,'2025-01-14',NULL,NULL,'13:00:00','17:00:00'),
(54,2,'2025-01-16',NULL,NULL,'13:00:00','17:00:00');
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
INSERT INTO `schedules` VALUES
(1,1,1,'09:00:00','12:00:00',30,'2024-10-30','2025-01-22'),
(2,2,1,'13:00:00','17:00:00',30,'2024-10-30','2025-01-22');
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
INSERT INTO `users` VALUES
(8,'clinic_owner','Clinic Owner','owner@example.com','1234567890','[\"admin\"]','hashed_password_placeholder','active',NULL,'2024-10-30 13:24:49','2024-10-30 13:24:49');
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
/*M!100616 SET NOTE_VERBOSITY=@OLD_NOTE_VERBOSITY */;

-- Dump completed on 2024-10-31 22:52:09
