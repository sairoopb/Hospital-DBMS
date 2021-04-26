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
    `contact_no` varchar(15) UNIQUE,
    `address` varchar(100),
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
    `doctor_id` int NOT NULL AUTO_INCREMENT,
    `first_name` varchar(30),
    `last_name` varchar(30),
    `contact_no` varchar(15) UNIQUE,
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
    `medicine_id` int NOT NULL AUTO_INCREMENT,
    `inventory_quantity` int,
    `name` varchar(30),
    `price` decimal(10, 2),
    PRIMARY KEY (`medicine_id`)
);

-- 5. Nurse entity

DROP TABLE IF EXISTS `Nurse`;
CREATE TABLE `Nurse` (
    `nurse_id` int NOT NULL AUTO_INCREMENT,
    `first_name` varchar(30),
    `last_name` varchar(30),
    `contact_no` varchar(15) UNIQUE,
    `address` varchar(100),
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
    `paid` int,
    PRIMARY KEY (`bill_number`)
);

-- 7. Employee Entity

DROP TABLE IF EXISTS `Employee`;
CREATE TABLE `Employee` (
    `employee_id` int NOT NULL AUTO_INCREMENT,
    `first_name` varchar(30),
    `last_name` varchar(30),
    `contact_no` varchar(15) UNIQUE,
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
    `results` varchar(150),
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
    `test_id` int NOT NULL AUTO_INCREMENT,
    `name` varchar(50),
    `cost` decimal(10, 2),
    PRIMARY KEY (`test_id`)
);

-- 12. Procedure Entity

DROP TABLE IF EXISTS `Procedure`;
CREATE TABLE `Procedure` (
    `procedure_id` int NOT NULL AUTO_INCREMENT,
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
   `unit` int DEFAULT 1,
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
    `end_date` Date,
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

--1.

CREATE VIEW Appointment_Schedule AS
SELECT  Doctor.doctor_id, first_name, last_name, role, specialization, date, start_time, room_no
FROM Appointment RIGHT OUTER JOIN
Doctor ON Doctor.doctor_id=Appointment.doctor_id;
 
--2.

CREATE VIEW Diagnosis_Raw AS
SELECT D.diagnosis_id, patient_id, doctor_id, test_id, prescription_id, Implies.treatment_id 
AS impliedTreatment, bill_number
FROM Diagnosis D LEFT OUTER JOIN
Undergoes ON D.diagnosis_id = Undergoes.diagnosis_id LEFT OUTER JOIN 
Recommends ON D.diagnosis_id = Recommends.diagnosis_id LEFT OUTER JOIN 
Involves ON D.diagnosis_id = Involves.diagnosis_id LEFT OUTER JOIN 
Diag_Presc ON D.diagnosis_id = Diag_Presc.diagnosis_id LEFT OUTER JOIN 
Implies ON D.diagnosis_id = Implies.diagnosis_id LEFT OUTER JOIN
Bill_Diag ON D.diagnosis_id = Bill_Diag.diagnosis_id;

-- 3.
CREATE VIEW Diagnosis_Report AS
SELECT Diagnosis_Raw.*, CONCAT(Patient.first_name," ",Patient.last_name) AS `Patient`, 
CONCAT(Doctor.first_name," ",Doctor.last_name) AS `Doctor`, Doctor.room_no, Test.name AS `Test Name`, Involves.results, 
Medicine.name AS `Medicine Name`, Includes.unit,
Diagnosis.results AS `Diagnosis Result`
FROM Diagnosis_Raw LEFT JOIN 
Patient ON Diagnosis_Raw.patient_id = Patient.patient_id LEFT JOIN 
Doctor ON Diagnosis_Raw.doctor_id = Doctor.doctor_id LEFT JOIN
Test ON Diagnosis_Raw.test_id = Test.test_id LEFT JOIN
Involves ON Diagnosis_Raw.test_id = Involves.test_id AND Diagnosis_Raw.diagnosis_id = Involves.diagnosis_id LEFT JOIN
Includes ON Diagnosis_Raw.prescription_id = Includes.prescription_id LEFT JOIN
Medicine ON Includes.medicine_id = Medicine.medicine_id LEFT JOIN
Diagnosis ON Diagnosis_Raw.diagnosis_id = Diagnosis.diagnosis_id;

-- 4.
CREATE VIEW Treatment_Raw AS
select T.treatment_id, patient_id, doctor_id, Done_In.room_no AS treatmentRoom, Aftercare.room_no AS aftercareRoom,
Serves.nurse_id AS aftercareNurseID, Implies.diagnosis_id AS relatedDiagnosis, prescription_id, procedure_id, bill_number
from Treatment T left outer join
Treated on T.treatment_id = Treated.treatment_id left outer join
Performs on T.treatment_id = Performs.treatment_id left outer join
Done_In on T.treatment_id = Done_In.treatment_id left outer join
Aftercare on T.treatment_id = Aftercare.treatment_id left outer join
Serves on T.treatment_id = Serves.treatment_id left outer join
Implies on T.treatment_id = Implies.treatment_id left outer join
Treatment_Presc on T.treatment_id = Treatment_Presc.treatment_id left outer join
Consists on T.treatment_id = Consists.treatment_id left outer join
Treatment_Bill on T.treatment_id = Treatment_Bill.treatment_id;

-- 5.
CREATE VIEW Treatment_Report AS
SELECT T.treatment_id, T.patient_id, T.doctor_id, T.treatmentRoom, T.relatedDiagnosis, 
T.prescription_id, T.procedure_id, CONCAT(Patient.first_name," ",Patient.last_name) AS `Patient`, 
CONCAT(Doctor.first_name," ",Doctor.last_name) AS `Doctor`, Doctor.room_no, 
`Procedure`.name AS `Procedures`, Treatment.details, Medicine.name AS `Medicine Name`, Includes.unit
FROM Treatment_Raw T LEFT JOIN 
Patient ON T.patient_id = Patient.patient_id LEFT JOIN 
Doctor ON T.doctor_id = Doctor.doctor_id LEFT JOIN
`Procedure` ON T.procedure_id = `Procedure`.procedure_id LEFT JOIN
Includes ON T.prescription_id = Includes.prescription_id LEFT JOIN
Medicine ON Includes.medicine_id = Medicine.medicine_id LEFT JOIN
Treatment ON T.treatment_id = Treatment.treatment_id;

-- 6.
CREATE VIEW Bill_Report AS
SELECT Bill.*, Test.name as `Tests`, Test.cost as `Test Cost`,`Procedure`.name as `Procedures`, `Procedure`.cost as `Procedure Cost`,
Medicine.name as `drug`, Includes.unit as `Medicine Qt`, Medicine.price as `Medicine Unit Cost`, 
Patient.patient_id, CONCAT(Patient.first_name, " ", Patient.last_name) as `Patient Name` 
FROM Bill LEFT JOIN
Pays ON Pays.bill_number = Bill.bill_number LEFT JOIN
Patient ON Patient.patient_id = Pays.patient_id LEFT JOIN
Medical_Bill ON Medical_Bill.bill_number = Bill.bill_number LEFT JOIN
Includes ON Includes.prescription_id = Medical_Bill.prescription_id LEFT JOIN
Medicine ON Medicine.medicine_id = Includes.medicine_id LEFT JOIN
Bill_Diag ON Bill_Diag.bill_number = Bill.bill_number LEFT JOIN
Involves ON Involves.diagnosis_id = Bill_Diag.diagnosis_id LEFT JOIN
Test ON Test.test_id = Involves.test_id LEFT JOIN
Treatment_Bill ON Treatment_Bill.bill_number = Bill.bill_number LEFT JOIN
Consists ON Consists.treatment_id = Treatment_Bill.treatment_id LEFT JOIN
`Procedure` ON `Procedure`.procedure_id = Consists.procedure_id;

-- 7.
CREATE VIEW Prescription_Report AS
SELECT Includes.prescription_id, Includes.unit, Medicine.name 
FROM Includes LEFT JOIN 
Medicine ON Includes.medicine_id = Medicine.medicine_id;

-- Create an appointment by the consultant 
DELIMITER # 
CREATE OR REPLACE FUNCTION create_appointment
(doctor int, patient_id int, start_datetime datetime)
RETURNS int
BEGIN
DECLARE created int;
IF (SELECT start_time FROM Appointment 
    WHERE `date` = DATE(start_datetime) AND 
    doctor_id = doctor AND start_time 
    BETWEEN (SELECT subtime(TIME(start_datetime),'00:29:59'))
    AND (SELECT subtime(TIME(start_datetime),'-00:29:59')))
    THEN SET created = 0;
ELSE
    INSERT INTO Appointment VALUES
    (doctor, patient_id, DATE(start_datetime), TIME(start_datetime));
    SET created = 1;
END IF;
RETURN created;
END#
DELIMITER ;

-- Check if the patient exists
DELIMITER #
CREATE OR REPLACE PROCEDURE patient_exists(IN pat_id int, IN contact_number varchar(15), OUT exist int)
BEGIN
IF contact_number IS NOT NULL THEN
    SELECT IF(COUNT(*) >0,1,0) INTO exist FROM `Patient` WHERE contact_no = contact_number;
ELSE
   SELECT IF(COUNT(*) >0,1,0) INTO exist FROM `Patient` WHERE patient_id = pat_id;
END IF;
END#
DELIMITER ;

-- Adding a new registration
DELIMITER #
CREATE OR REPLACE PROCEDURE new_registration(IN pat_id int,IN  f_name varchar(30), 
                                            IN l_name varchar(30), IN contact_number varchar(15),
                                            IN addr varchar(100))
BEGIN
DECLARE t int;
CALL patient_exists(pat_id,contact_number,t);
IF t > 0 THEN
    SELECT "Already Registered";
ELSE
    INSERT INTO `Patient` VALUES (pat_id, f_name, l_name, contact_number, addr); 
   
END IF;
END#
DELIMITER ;

-- Patient Log entry check
DELIMITER #
CREATE OR REPLACE PROCEDURE checkin_out(IN pat_id int, IN val DATETIME, IN chkin int)
BEGIN
    IF chkin = 1 THEN
        INSERT INTO `Patient_Log` VALUES (pat_id, val, NULL);
    ELSE
        UPDATE `Patient_Log` SET checkout = val WHERE patient_id = pat_id AND checkout IS NULL ;
    END IF;
END#
DELIMITER ;

INSERT INTO `Test` (`name`, `cost`) VALUES
("Ultrasound Imaging", 500),
("MRI", 3000),
("CT Scan", 4000),
("X-Ray", 1000),
("Blood Sugar", 5000);

INSERT INTO `Room` (`room_no`, `name`, `availability`) VALUES
(1, "ER Room", 1),
(2, "Doctor Room", 0),
(3, "Aftercare Room", 1),
(4, "Aftercare Room", 0),
(5, "Doctor Room", 0);

INSERT INTO `Employee` (`first_name`, `last_name`, `contact_no`, `occupation`, `address`, `salary`) VALUES
("arjun", "sheikh", "9010202211", "janitor", "Raj Bhavan Road", 10000),
("Rohit", "Sharma", "9876787687", "Driver", "Andheri East, Mumbai", 20000),
("naman", "ojha", "9010233211", "ward boy", "Gachibowli, Hyderabad", 7000),
("azad", "kade", "9911234544", "cleaning staff", "JUbilee Hills, Hyderabad",10000.00),
("Pitamaha", "Khandke", "02227221431", "mechanic", "Himayathnagar, Hyderabad", 99948.03);

INSERT INTO `Doctor` (`first_name`, `last_name`, `contact_no`, `address`, `salary`, `specialization`, `role`, `room_no`) VALUES
("Devika", "Patel", "9733277342", "E2, Near Lsr Collage, East Of Kailash, Delhi", 80000.00, "Neuro surgeon", "surgeon", 2), 
("Ameretat",  "Sachdev", "02226609802", "Rotary Service Centre, Mumbai", 150000.00, "Orthopedics", "General Physicain", 5),
("Revati", "Mehta", "9733277444", "274 /b, Girdhari Sadan, N.c.kelkar Road", 100000, "Orthopaedics", "Orthopedic surgeons", 2),
("Saka", "Ghate", "07925501915", "29 /b, Asopalav, Khanpur", 20000, "Cardiology", "Pathologist", 5),
("Matsya",  "Sridhar", "2660030345", "Bundi Mottu Avenue Road Cross, Avenue Road", 100000.00, "Pediatrics", "Pediatrician", 5);

INSERT INTO `Procedure` (`name`, `cost`) VALUES
("Coronary Angiogram", 63500.00),
("Angioplasty", 412750.00),
("Abdominal aortic aneurysm", 508000.00),
("Knee Replacement", 539750.00),
("ACL Reconstruction", 285750.00);

INSERT INTO `Nurse` (`first_name`, `last_name`, `contact_no`, `address`, `salary`) VALUES
("Maheshvari", "Gothe", "9292451252", "241 -, Natraj Market, Sv Road, Malad, Mumbai", 40000.00),
("Atman",  "Jain", "02225123138", "Chittranjan Nagar, Rajawadi, Ghatkoper, Mumbai", 25000.00),
("Archana", "Hans", "02227895689", "22  Rachna, Sector , Vashi, Mumbai", 30000.00),
("Bharat", "Badal", "02228882593", "109 , Parasrampuria Chambers, Opp Rly Stn, Malad (west)", 35000.00),
("Manda", "Saran", "02223862592", "448  A, Girgaum, Mumbai", 25000.00);

INSERT INTO `Medicine` (`inventory_quantity`, `name`, `price`) VALUES
(145, "Ifosfamide", 551.65),
(78, "Cisplatin", 360.00),
(233, "Oxaliplatin", 4798.00),
(124, "Methotrexate", 57.85),
(112, "Busulfan", 415.00);

INSERT INTO `Patient` VALUES
(1, "Jyotish","Divan", "02223443172", "417 ,sai Chambers,  Narshi Natha St, Chinch Bunder"),
(2, "Yasmine","Kumar","02224464461", "349 ,Allied Indl Estae Off Mmc, Off M.m.c Road, Mahim"),
(3, "Supriya", "Shanker", "02224092768", "41 /, Sadar Nagar No , Sion");

INSERT INTO `Patient_Log` (`patient_id`, `checkin`, `checkout`) VALUES
(1, "2012-12-02 20:20:10", NULL),
(2, "2020-08-05 14:56:24", "2020-08-05 18:34:32"),
(3, "2015-12-02 08:20:10", "2015-12-02 11:20:10"),
(3, "2015-12-05 10:20:10", "2015-12-06 11:20:10");

INSERT INTO `Appointment` (`doctor_id`, `patient_id`, `date`, `start_time`) VALUES
(3, 3, "2015-12-02", "08:35:00"),
(2, 2, "2020-08-05", "13:05:13");

INSERT INTO `Diagnosis` (`diagnosis_id`, `results`) VALUES
(3, "Type 2 diabetes"),
(2, "Scans Normal. No treatment required. Patient advised to take prescribed medicines");

INSERT INTO `Treatment` (`treatment_id`, `start_date`, `end_date`, `details`) VALUES
(1, "2012-12-02", "2012-12-03", "Success with slight knee complication"),
(2, "2015-12-05", "2015-12-06", "Sugar levels reduced");

INSERT INTO `Bill` VALUES
(1, 2,762000.00,700000,62000, 0),
(2, 1, 1000.5, 969.5,31, 1),
(3, 0, 6300, 6000, 300, 1),
(5, 0, 8000.00, 7500.00, 500.00, 1),
(6, 1, 952.95, 832.85, 120.10, 1),
(4, 2, 855000, 850500, 4500, 1);

INSERT INTO `Prescription` VALUES
(1),
(5);

INSERT INTO `Implies` (`diagnosis_id`, `treatment_id`) VALUES
(3, 2);

INSERT INTO `Recommends` (`doctor_id`, `diagnosis_id`) VALUES
(3, 3),
(2, 2);

INSERT INTO `Done_In` VALUES
(1, 1),
(2, 1);

INSERT INTO `Treated` VALUES
(1, 1),
(3, 2);

INSERT INTO `Performs` VALUES
(1, 1),
(4, 2),
(5, 2);

INSERT INTO `Consists` VALUES
(1, 1),
(2, 1),
(4, 1),
(4, 2),
(1, 2);

INSERT INTO `Treatment_Bill` VALUES
(1, 1),
(4, 2);

INSERT INTO `Pays` VALUES
(1, 1),
(3, 3),
(2, 5),
(2, 6),
(1, 2),
(3, 4);

INSERT INTO `Aftercare` VALUES
(1, 2, "2012-12-03", NULL);


INSERT INTO `Serves` VALUES
(1, 1);

INSERT INTO `Treatment_Presc` VALUES
(1, 1);

INSERT INTO `Includes` (`medicine_id`, `prescription_id`) VALUES
(1, 1),
(2, 1),
(4, 1),
(2, 5),
(4, 5),
(5, 5);

INSERT INTO `Medical_Bill` VALUES
(1, 2),
(5, 6);

INSERT INTO `Involves` VALUES
(2, 2, ""),
(2, 3, ""),
(3, 5, "Positive");

INSERT INTO `Undergoes` VALUES
(3, 3),
(2, 2);

INSERT INTO `Bill_Diag` VALUES
(3, 3),
(5, 2);

INSERT INTO `Diag_Presc` VALUES
(5, 2);