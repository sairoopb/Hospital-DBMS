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

-- Create Diagnosis Report Function
DELIMITER #
CREATE OR REPLACE PROCEDURE create_diagnosis(
                                 IN pat_ID int,
                                 IN doctor_ID int,
                                 IN test_no int,
                                 IN test_result varchar(100),
                                 OUT new_diag_id int
                                )
proclabel: BEGIN
    
    DECLARE new_bill_id INTEGER;
    DECLARE test_price DECIMAL(10,2);

    SET autocommit = 0;
    START TRANSACTION;

    SELECT Diagnosis.diagnosis_id + 1 INTO new_diag_id
    FROM Diagnosis
    ORDER BY diagnosis_id DESC LIMIT 1;

    SELECT Bill.bill_number + 1 INTO new_bill_id
    FROM Bill
    ORDER BY bill_number DESC LIMIT 1;

    SELECT cost INTO test_price
    FROM Test 
    WHERE test_id = test_no;
    
    INSERT INTO Diagnosis VALUES
    (new_diag_id, test_result); 

    IF EXISTS(SELECT * FROM Patient WHERE patient_id = pat_ID) THEN
    INSERT INTO Undergoes VALUES
    (pat_ID, new_diag_id);
    ELSE
    ROLLBACK;
    SET autocommit = 1;
    LEAVE proclabel;
    END IF;

    IF EXISTS(SELECT * FROM Test WHERE test_id = test_no) THEN
    INSERT INTO Involves VALUES
    (new_diag_id,test_no,test_result);
    ELSE
    ROLLBACK;
    SET autocommit = 1;
    LEAVE proclabel;
    END IF;

    IF EXISTS(SELECT * FROM Doctor WHERE doctor_id = doctor_ID) THEN
    INSERT INTO Recommends VALUES
    (doctor_ID, new_diag_id);
    ELSE
    ROLLBACK;
    SET autocommit = 1;
    LEAVE proclabel;
    END IF;
    
    INSERT INTO Bill VALUES 
    (new_bill_id,1,test_price*(1.05),test_price,test_price*0.05,0);

    INSERT INTO Bill_Diag VALUES
    (new_bill_id,new_diag_id);


    COMMIT;
    SET autocommit = 1;

END #
DELIMITER ;

-- Create Treatment
DELIMITER //

CREATE OR REPLACE PROCEDURE create_treatment(IN pat_id INT, IN doc_id INT, IN proc_id INT, IN st_date DATE, IN room INT, IN diag_id INT, OUT new_treat_id INT)
proc_label: BEGIN

DECLARE new_bill_id INT;
DECLARE bill_total DECIMAL(10, 2);
DECLARE bill_subtotal DECIMAL(10, 2);
DECLARE bill_taxes DECIMAL(10, 2);

SET autocommit = 0;
START TRANSACTION;
SELECT treatment_id + 1 INTO new_treat_id FROM Treatment ORDER BY treatment_id DESC LIMIT 1;

SELECT bill_number + 1 INTO new_bill_id FROM Bill ORDER BY bill_number DESC LIMIT 1;


INSERT INTO Treatment (treatment_id, start_date)
VALUES (new_treat_id, st_date);

IF EXISTS(SELECT * from Patient WHERE patient_id=pat_id) THEN
INSERT INTO Treated
VALUES (pat_id, new_treat_id);
ELSE
ROLLBACK;
SET autocommit = 1;
LEAVE proc_label;
END IF;

IF EXISTS(SELECT * from Doctor WHERE doctor_id=doc_id) THEN
INSERT INTO Performs
VALUES (doc_id, new_treat_id);
ELSE
ROLLBACK;
SET autocommit = 1;
LEAVE proc_label;
END IF;

IF EXISTS(SELECT * from Room WHERE room_no=room) THEN
INSERT INTO Done_In
VALUES (new_treat_id, room);
ELSE
ROLLBACK;
SET autocommit = 1;
LEAVE proc_label;
END IF;

IF EXISTS(SELECT * from `Procedure` WHERE procedure_id=proc_id) THEN
INSERT INTO `Consists`
VALUES (proc_id, new_treat_id);
SELECT cost INTO bill_subtotal FROM `Procedure` WHERE procedure_id=proc_id;
SET bill_total = bill_subtotal * 1.05;
SET bill_taxes = bill_total - bill_subtotal;
ELSE
ROLLBACK;
SET autocommit = 1;
LEAVE proc_label;
END IF;

IF EXISTS(SELECT * from Diagnosis WHERE diagnosis_id=diag_id) THEN
INSERT INTO `Implies`
VALUES (diag_id, new_treat_id);
ELSE
ROLLBACK;
SET autocommit = 1;
LEAVE proc_label;
END IF;

INSERT INTO Bill
VALUES (new_bill_id, 2, bill_total, bill_subtotal, bill_taxes, 0);

INSERT INTO Treatment_Bill
VALUES (new_bill_id, new_treat_id);

COMMIT;
SET autocommit = 0;

END
//

DELIMITER ;