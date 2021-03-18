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