USE hospital;

DELETE FROM `Medicine`;
DELETE FROM `Nurse`;
DELETE FROM `Procedure`;
DELETE FROM `Doctor`;
DELETE FROM `Employee`;
DELETE FROM `Room`;
DELETE FROM `Test`;

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
(4, 3, 855000, 850500, 4500, 1);

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
(2, 6);

INSERT INTO `Aftercare` VALUES
(1, 2, "2012-12-03", NULL);


INSERT INTO `Serves` VALUES
(1, 1);

INSERT INTO `Treatment_Presc` VALUES
(1, 1);

INSERT INTO `Includes` VALUES
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