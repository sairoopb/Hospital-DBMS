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
    PRIMARY KEY (`treatment_id`),
    FOREIGN KEY (`patient_id`) REFERENCES `Patient` (`patient_id`) ON DELETE CASCADE,
    FOREIGN KEY (`treatment_id`) REFERENCES `Treatment` (`treatment_id`) ON DELETE CASCADE
);

-- 2. Performs

DROP TABLE IF EXISTS `Performs`;
CREATE TABLE `Performs` (
    `doctor_id` int NOT NULL,
    `treatment_id` int NOT NULL,
    PRIMARY KEY (`treatment_id`,`doctor_id`),
    FOREIGN KEY (`doctor_id`) REFERENCES `Doctor` ( `doctor_id` ) ON DELETE CASCADE,
    FOREIGN KEY (`treatment_id`) REFERENCES `Treatment` ( `treatment_id` ) ON DELETE CASCADE

);

-- 3. Done_In

DROP TABLE IF EXISTS `Done_In`;
CREATE TABLE `Done_In` (
   	`treatment_id` int NOT NULL,
   	`room_no` int NOT NULL,
   	PRIMARY KEY (`treatment_id`),
   	FOREIGN KEY (`treatment_id`) REFERENCES `Treatment` ( `treatment_id` ) ON DELETE CASCADE,
   	FOREIGN KEY (`room_no`) REFERENCES `Room` ( `room_no` ) ON DELETE CASCADE
);

-- 4. Procedure_Treatment

DROP TABLE IF EXISTS `Consists`;
CREATE TABLE `Consists` (
    `procedure_id` int NOT NULL,
    `treatment_id` int NOT NULL,
    PRIMARY KEY (`procedure_id`, `treatment_id`),
    FOREIGN KEY (`procedure_id`) REFERENCES `Procedure` ( `procedure_id` ) ON DELETE CASCADE,
    FOREIGN KEY (`treatment_id`) REFERENCES `Treatment` ( `treatment_id` ) ON DELETE CASCADE
);

-- 5. Undergoes

DROP TABLE IF EXISTS `Undergoes`;
CREATE TABLE `Undergoes` (
    `patient_id` int,
    `diagnosis_id` int NOT NULL,
    PRIMARY KEY (`diagnosis_id`),
    FOREIGN KEY (`patient_id`) REFERENCES `Patient` (`patient_id`) ON DELETE CASCADE,
    FOREIGN KEY (`diagnosis_id`) REFERENCES `Diagnosis` (`diagnosis_id`) ON DELETE CASCADE
);

-- 6. Recommends

DROP TABLE IF EXISTS `Recommends`;   
CREATE TABLE `Recommends` (
   `doctor_id` int NOT NULL,
   `diagnosis_id` int NOT NULL,
   PRIMARY KEY (`diagnosis_id`),
   FOREIGN KEY (`doctor_id`) REFERENCES `Doctor` ( `doctor_id` ) ON DELETE CASCADE,
   FOREIGN KEY (`diagnosis_id`) REFERENCES `Diagnosis` ( `diagnosis_id` ) ON DELETE CASCADE

);

-- 7. Involves

DROP TABLE IF EXISTS `Involves`;
CREATE TABLE `Involves` (
   	`diagnosis_id` int NOT NULL,
   	`test_id` int NOT NULL,
   	`results` varchar(100),
   	PRIMARY KEY (`diagnosis_id`, `test_id`),
   	FOREIGN KEY (`diagnosis_id`) REFERENCES `Diagnosis` ( `diagnosis_id` ) ON DELETE CASCADE,
   	FOREIGN KEY (`test_id`) REFERENCES `Test` ( `test_id` ) ON DELETE CASCADE
);

-- 8. Treatment_Prescription

DROP TABLE IF EXISTS `Treatment_Presc`;
CREATE TABLE `Treatment_Presc` (
    `treatment_id` int NOT NULL,
    `prescription_id` int NOT NULL,
    PRIMARY KEY (`treatment_id`),
    FOREIGN KEY (`prescription_id`) REFERENCES `Prescription` ( `prescription_id` ) ON DELETE CASCADE,
    FOREIGN KEY (`treatment_id`) REFERENCES `Treatment` ( `treatment_id` ) ON DELETE CASCADE
);

-- 9. Diag_Presc

DROP TABLE IF EXISTS `Diag_Presc`;
CREATE TABLE `Diag_Presc` (
    `prescription_id` int,
    `diagnosis_id` int NOT NULL,
    PRIMARY KEY (`diagnosis_id`),
    FOREIGN KEY (`prescription_id`) REFERENCES `Prescription` (`prescription_id`) ON DELETE CASCADE,
    FOREIGN KEY (`diagnosis_id`) REFERENCES `Diagnosis` (`diagnosis_id`) ON DELETE CASCADE
);

-- 10. Includes

DROP TABLE IF EXISTS `Includes`;   
CREATE TABLE `Includes` (
   `medicine_id` int NOT NULL,
   `prescription_id` int NOT NULL,
   PRIMARY KEY (`medicine_id`,`prescription_id`),
   FOREIGN KEY (`medicine_id`) REFERENCES `Medicine` ( `medicine_id` ) ON DELETE CASCADE,
   FOREIGN KEY (`prescription_id`) REFERENCES `Prescription` ( `prescription_id` ) ON DELETE CASCADE

);

-- 11. Medical_Bill

DROP TABLE IF EXISTS `Medical_Bill`;
CREATE TABLE `Medical_Bill` (
   	`prescription_id` int NOT NULL,
   	`bill_number` int NOT NULL,
   	PRIMARY KEY (`prescription_id`),
   	FOREIGN KEY (`prescription_id`) REFERENCES `Prescription` ( `prescription_id` ) ON DELETE CASCADE,
   	FOREIGN KEY (`bill_number`) REFERENCES `Bill` ( `bill_number` ) ON DELETE CASCADE
);

-- 12. Doctor_Patient

DROP TABLE IF EXISTS `Appointment`;
CREATE TABLE `Appointment` (
    `doctor_id` int NOT NULL,
    `patient_id` int NOT NULL,
    `date` Date NOT NULL,
    `start_time` Time NOT NULL,
    PRIMARY KEY (`doctor_id`,`patient_id`, `date`, `start_time`),
    FOREIGN KEY (`doctor_id`) REFERENCES `Doctor` ( `doctor_id` ) ON DELETE CASCADE,
    FOREIGN KEY (`patient_id`) REFERENCES `Patient` ( `patient_id` ) ON DELETE CASCADE
);

-- 13. Treatment Bill

DROP TABLE IF EXISTS `Treatment_Bill`;
CREATE TABLE `Treatment_Bill` (
    `bill_number` int,
    `treatment_id` int NOT NULL,
    PRIMARY KEY (`treatment_id`),
    FOREIGN KEY (`bill_number`) REFERENCES `Bill` (`bill_number`) ON DELETE CASCADE,
    FOREIGN KEY (`treatment_id`) REFERENCES `Treatment` (`treatment_id`) ON DELETE CASCADE
);

-- 14. Pays

DROP TABLE IF EXISTS `Pays`;   
CREATE TABLE `Pays` (
   `patient_id` int NOT NULL,
   `bill_number` int NOT NULL,
   PRIMARY KEY (`bill_number`),
   FOREIGN KEY (`bill_number`) REFERENCES `Bill` ( `bill_number` ) ON DELETE CASCADE

);

-- 15. Nurse_Treatment

DROP TABLE IF EXISTS `Serves`;
CREATE TABLE `Serves` (
    `treatment_id` int NOT NULL,
    `nurse_id` int NOT NULL,
    PRIMARY KEY (`treatment_id`,`nurse_id`),
    FOREIGN KEY (`treatment_id`) REFERENCES `Treatment` ( `treatment_id` ) ON DELETE CASCADE,
    FOREIGN KEY (`nurse_id`) REFERENCES `Nurse` ( `nurse_id` ) ON DELETE CASCADE
);

-- 16. Treatment_Room

DROP TABLE IF EXISTS `Aftercare`;
CREATE TABLE `Aftercare` (
    `treatment_id` int NOT NULL,
    `room_no` int NOT NULL,
    `start_date` Date NOT NULL,
    `end_date` Date NOT NULL,
    PRIMARY KEY (`treatment_id`,`room_no`, `start_date`),
    FOREIGN KEY (`treatment_id`) REFERENCES `Treatment` ( `treatment_id` ) ON DELETE CASCADE,
    FOREIGN KEY (`room_no`) REFERENCES `Room` ( `room_no` ) ON DELETE CASCADE
);

-- 17. Bill_Diag

DROP TABLE IF EXISTS `Bill_Diag`;
CREATE TABLE `Bill_Diag` (
    `bill_number` int,
    `diagnosis_id` int NOT NULL,
    PRIMARY KEY (`diagnosis_id`),
    FOREIGN KEY (`bill_number`) REFERENCES `Bill` (`bill_number`) ON DELETE CASCADE,
    FOREIGN KEY (`diagnosis_id`) REFERENCES `Diagnosis` (`diagnosis_id`) ON DELETE CASCADE
);

-- 18. Implies

DROP TABLE IF EXISTS `Implies`;   
CREATE TABLE `Implies` (
   `diagnosis_id` int NOT NULL,
   `treatment_id` int NOT NULL,
   PRIMARY KEY (`diagnosis_id`),
   FOREIGN KEY (`diagnosis_id`) REFERENCES `Diagnosis` ( `diagnosis_id` ) ON DELETE CASCADE,
   FOREIGN KEY (`treatment_id`) REFERENCES `Treatment` ( `treatment_id` ) ON DELETE CASCADE
);