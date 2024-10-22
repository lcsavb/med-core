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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

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
  `city` VARCHAR(100) NOT NULL,
  `state` CHAR(2) NOT NULL, -- Standard two-letter abbreviation (e.g., SP, RJ)
  `country` CHAR(2) NOT NULL, -- ISO COUNTRY CODE (e.g., BR, US)
  `phone` varchar(20) NOT NULL,
  `email` VARCHAR(255) DEFAULT NULL,
  `website` VARCHAR(255) DEFAULT NULL,
  `clinic_type` ENUM('Public', 'Private', 'Mixed') NOT NULL DEFAULT 'Private', -- Type of clinic
  `admin_user_id` int(11) NOT NULL,
  `created_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `admin_user_id` (`admin_user_id`),
  CONSTRAINT `clinics_ibfk_1` FOREIGN KEY (`admin_user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

DROP TABLE IF EXISTS `clinic_identifiers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;

-- This table stores identifiers based on the country's requirements

CREATE TABLE `clinic_identifiers` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `clinic_id` INT NOT NULL, -- Foreign key referencing the clinic
  `identifier_type` ENUM('CNES', 'CNPJ' 'NPI', 'HRB') NOT NULL, -- The type of identifier
  CONSTRAINT `clinic_identifiers_ibfk_1` FOREIGN KEY (`clinic_id`) REFERENCES `clinics`(`id`)
);



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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

DROP TABLE IF EXISTS `professional_identifiers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;

CREATE TABLE `professional_identifiers` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `professional_id` INT NOT NULL, -- Foreign key referencing the healthcare professional
  `identifier_type` ENUM('CRM', 'State_Medical_License', 'DEA', 'NPI', 'License', 'Certification') NOT NULL, -- Type of identifier
  `identifier_value` VARCHAR(50) NOT NULL, -- Actual identifier value (e.g., CRM number, DEA registration)
  CONSTRAINT `professional_identifiers_ibfk_1` FOREIGN KEY (`professional_id`) REFERENCES `healthcare_professionals`(`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


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
  `hash` CHAR(64) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `patient_id` (`patient_id`),
  CONSTRAINT `medical_records_ibfk_1` FOREIGN KEY (`patient_id`) REFERENCES `patients` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;


-- Trigger to prevent updates to medical records

DELIMITER $$
CREATE TRIGGER prevent_medical_records_update
BEFORE UPDATE ON medical_records
FOR EACH ROW
BEGIN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Updates to medical records are not allowed';
END$$
DELIMITER ;

REVOKE UPDATE ON medical_records FROM PUBLIC;


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
  `status` ENUM('active', 'inactive', 'deceased') NOT NULL DEFAULT 'active', -- Patient status
  `emergency_contact_name` varchar(100) DEFAULT NULL, -- Emergency contact person
  `emergency_contact_phone` varchar(20) DEFAULT NULL, -- Emergency contact phone number
  `nationality` varchar(50) DEFAULT NULL, -- Nationality of the patient
  `language` varchar(50) DEFAULT NULL, -- Preferred language
  `insurance_provider` varchar(100) DEFAULT NULL, -- Insurance company/provider name
  `insurance_policy_number` varchar(50) DEFAULT NULL, -- Insurance policy number
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP, -- Record creation time
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, -- Last update time
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;


DROP TABLE IF EXISTS `patient_identifiers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;

CREATE TABLE `patient_identifiers` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `patient_id` INT NOT NULL, -- Foreign key referencing the patients table
  `identifier_type` ENUM('SUS', 'SSN', 'Insurance_ID', 'Passport_Number', 'CPF') NOT NULL, -- Type of identifier
  `identifier_value` VARCHAR(50) NOT NULL, -- Actual identifier value (e.g., SUS number or SSN)
  CONSTRAINT `patient_identifiers_ibfk_1` FOREIGN KEY (`patient_id`) REFERENCES `patients`(`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


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
  `appointment_interval` INT NOT NULL, -- Interval in minutes
  `start_date` DATE DEFAULT NULL, -- Start date for recurring schedules
  `end_date` DATE DEFAULT NULL, -- End date for recurring schedules
  PRIMARY KEY (`id`),
  KEY `clinic_id` (`clinic_id`),
  KEY `doctor_id` (`doctor_id`),
  CONSTRAINT `schedules_ibfk_1` FOREIGN KEY (`clinic_id`) REFERENCES `clinics` (`id`),
  CONSTRAINT `schedules_ibfk_2` FOREIGN KEY (`doctor_id`) REFERENCES `healthcare_professionals` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

/*!40101 SET character_set_client = @saved_cs_client */;

-- Table structure for schedule dates

DROP TABLE IF EXISTS `schedule_dates`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `schedule_dates` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `schedule_id` int(11) NOT NULL, -- Foreign key to the schedules table
  `schedule_date` DATE NOT NULL, -- Specific date for the doctor's availability
  `break_start` TIME DEFAULT NULL, -- Start time for the doctor's break
  `break_end` TIME DEFAULT NULL, -- End time for the doctor's break
  `start_time` TIME NOT NULL, -- Start time for the doctor's availability
  `end_time` TIME NOT NULL, -- End time for the doctor's availability
  PRIMARY KEY (`id`),
  KEY `schedule_id` (`schedule_id`),
  CONSTRAINT `schedule_dates_ibfk_1` FOREIGN KEY (`schedule_id`) REFERENCES `schedules` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(50) NOT NULL, -- Username for login
  `name` varchar(100) NOT NULL, -- Admin's name
  `email` varchar(255) NOT NULL, -- Admin's email
  `phone` varchar(20) DEFAULT NULL, -- Admin's phone number
  `is_doctor` tinyint(1) NOT NULL, -- Is this user a doctor? (1 = yes, 0 = no)
  `password_hash` varchar(255) NOT NULL, -- Securely stored password hash
  `status` ENUM('active', 'inactive') NOT NULL DEFAULT 'active', -- Account status
  `last_login` datetime DEFAULT NULL, -- Track the last login time
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP, -- Track when the account was created
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, -- Track when account details were last updated
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`), -- Ensure unique usernames
  UNIQUE KEY `email` (`email`) -- Ensure unique emails
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-10-22 20:22:44
