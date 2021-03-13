DROP DATABASE IF EXISTS hospital;
CREATE DATABASE hospital;
USE hospital;

-- Entity Sets

-- 1. Patient Entity

DROP TABLE IF EXISTS `Patient`;
CREATE TABLE `Patient` (
    `patient_id` int NOT NULL,
    `first_name` varchar(30),
    `last_name` varchar(30),
    `contact_no` varchar(15),
    `address` varchar(50),
    PRIMARY KEY (`patient_id`)
);

-- 2. Room Entity

DROP TABLE IF EXISTS `Room`;
CREATE TABLE `Room` (
    `room_no` int NOT NULL,
    `name` varchar(30),
    `availability` bit,
    PRIMARY KEY (`room_no`)
);

--  3. Doctor Entity

DROP TABLE IF EXISTS `Doctor`;
CREATE TABLE `Doctor` (
    `doctor_id` int NOT NULL,
    `first_name` varchar(30),
    `last_name` varchar(30),
    `contact_no` varchar(15),
    `address` varchar(50),
    `salary` decimal(10, 2),
    `specialization` varchar(30),
    `role` varchar(30),
    `room_no`int NOT NULL,
    PRIMARY KEY (`doctor_id`),
    FOREIGN KEY (`room_no`) REFERENCES `Room` ( `room_no` ) ON DELETE CASCADE
);

-- 4. Medicine Entity

DROP TABLE IF EXISTS `Medicine`;
CREATE TABLE `Medicine` (
    `medicine_id` int NOT NULL,
    `inventory_quantity` int,
    `name` varchar(30),
    `price` decimal(10, 2),
    PRIMARY KEY (`medicine_id`)
);

-- 5. Nurse entity

DROP TABLE IF EXISTS `Nurse`;
CREATE TABLE `Nurse` (
    `nurse_id` int NOT NULL,
    `first_name` varchar(30),
    `last_name` varchar(30),
    `contact_no` varchar(15),
    `address` varchar(50),
    `salary` decimal(10, 2),
    PRIMARY KEY (`nurse_id`)
);

-- 6. Bill Entity

DROP TABLE IF EXISTS `Bill`;
CREATE TABLE `Bill` (
    `bill_number` int NOT NULL,
    `bill_type` int,
    `total` decimal(10, 2),
    `subtotal` decimal(10, 2),
    `taxes` decimal(10, 2),
    `paid` bit,
    PRIMARY KEY (`bill_number`)
);

-- 7. Employee Entity

DROP TABLE IF EXISTS `Employee`;
CREATE TABLE `Employee` (
    `employee_id` int NOT NULL,
    `first_name` varchar(30),
    `last_name` varchar(30),
    `contact_no` varchar(15),
    `occupation` varchar(30),
    `address` varchar(50),
    `salary` decimal(10, 2),
    PRIMARY KEY (`employee_id`)
);

-- 8. Prescription Entity

DROP TABLE IF EXISTS `Prescription`;
CREATE TABLE `Prescription` (
    `prescription_id` int NOT NULL,
    PRIMARY KEY (`prescription_id`)
);

-- 9. Diagnosis Entity

DROP TABLE IF EXISTS `Diagnosis`;
CREATE TABLE `Diagnosis` (
    `diagnosis_id` int NOT NULL,
    `results` varchar(100),
    PRIMARY KEY (`diagnosis_id`)
);

-- 10. Treatment Entity

DROP TABLE IF EXISTS `Treatment`;
CREATE TABLE `Treatment` (
    `treatment_id` int NOT NULL,
    `start_date` Date,
    `end_date` Date,
    `details` varchar(255),
    PRIMARY KEY (`treatment_id`)
);

-- 11. Test Entity

DROP TABLE IF EXISTS `Test`;
CREATE TABLE `Test` (
    `test_id` int NOT NULL,
    `name` varchar(50),
    `cost` decimal(10, 2),
    PRIMARY KEY (`test_id`)
);

-- 12. Procedure Entity

DROP TABLE IF EXISTS `Procedure`;
CREATE TABLE `Procedure` (
    `procedure_id` int NOT NULL,
    `name` varchar(50),
    `cost` decimal(10, 2),
    PRIMARY KEY (`procedure_id`)
);

-- 13. Patient Log Entity

DROP TABLE IF EXISTS `Patient_Log`;
CREATE TABLE `Patient_Log` (
    `patient_id` int NOT NULL,
    `checkin` Datetime,
    `checkout` Datetime,
    PRIMARY KEY (`patient_id`, `checkin`),
    FOREIGN KEY (`patient_id`) REFERENCES `Patient` ( `patient_id` ) ON DELETE CASCADE
);

-- Relationship Sets

-- 1. Treated

DROP TABLE IF EXISTS `Treated`;
CREATE TABLE `Treated` (
    `patient_id` int,
    `treatment_id` int NOT NULL,
    PRIMARY KEY (`treatment_id`)
);