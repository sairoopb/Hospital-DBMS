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

--all appointments

DELIMITER #
CREATE OR REPLACE PROCEDURE appointment_menu(IN first_name varchar(30), 
                                            IN last_name varchar(30), 
                                            IN specialization varchar(30))
BEGIN
    SELECT D.doctor_id, CONCAT(D.first_name, " ", D.last_name), D.specialization, A.date, A.start_time FROM 
    (Doctor AS D) JOIN (Appointment AS A) ON D.doctor_id = A.doctor_id 
    WHERE STRCMP(first_name, D.first_name) = 0 AND STRCMP(last_name, D.last_name) = 0
    AND STRCMP(specialization, D.specialization) = 0 ORDER BY D.first_name ASC, D.last_name ASC;
END#
DELIMITER ;


--create diagnosis

-- Test create_diagnosis: CALL create_diagnosis(1, 1, "1|2|3", "Breh | Oke boi | yeet", "he supa dead chief", @out_value);

DELIMITER //
CREATE OR REPLACE PROCEDURE create_diagnosis(
IN pat_id INT,
IN doc_id INT,
IN test_nos TEXT,
IN test_results TEXT,
IN final_result VARCHAR(150),
OUT new_diag_id INT
)
proclabel: BEGIN

DECLARE new_bill_id INTEGER;
DECLARE bill_subtotal DECIMAL(10, 2) DEFAULT 0.00;
DECLARE temp_cost DECIMAL(10, 2) DEFAULT 0.00;

DECLARE t_no TEXT;
DECLARE t_res TEXT;
DECLARE test_no_len INTEGER DEFAULT 0;
DECLARE test_no_substrlen INTEGER DEFAULT 0;
DECLARE test_res_len INTEGER DEFAULT 0;
DECLARE test_res_substrlen INTEGER DEFAULT 0;

DECLARE CONTINUE HANDLER FOR SQLSTATE '42000'
BEGIN
ROLLBACK;
SET autocommit = 1;
SET new_diag_id = -1;
END;

IF test_nos IS NULL THEN
SET test_nos = '';
END IF;

IF test_results IS NULL THEN
SET test_results = '';
END IF;


SET autocommit = 0;
START TRANSACTION;

SELECT Diagnosis.diagnosis_id + 1 INTO new_diag_id
FROM Diagnosis
ORDER BY diagnosis_id DESC LIMIT 1;

IF new_diag_id IS NULL THEN
SET new_diag_id = 1;
END IF;

SELECT Bill.bill_number + 1 INTO new_bill_id
FROM Bill
ORDER BY bill_number DESC LIMIT 1;

IF new_bill_id IS NULL THEN
SET new_bill_id = 1;
END IF;

INSERT INTO Diagnosis
VALUES (new_diag_id, final_result); 

IF EXISTS(SELECT * FROM Patient WHERE patient_id = pat_id) THEN
INSERT INTO Undergoes VALUES
(pat_id, new_diag_id);
ELSE
CALL non_existent_procedure;
LEAVE proclabel;
END IF;

IF EXISTS(SELECT * FROM Doctor WHERE doctor_id = doc_id) THEN
INSERT INTO Recommends VALUES
(doc_id, new_diag_id);
ELSE
CALL non_existent_procedure;
LEAVE proclabel;
END IF;



loop_label:
LOOP
SET test_no_len = CHAR_LENGTH(test_nos);
SET test_res_len = CHAR_LENGTH(test_results);

SET t_no = SUBSTRING_INDEX(test_nos, '|', 1);
SET t_res = SUBSTRING_INDEX(test_results, '|', 1);

IF EXISTS(SELECT * FROM Test WHERE test_id = t_no) THEN
INSERT INTO Involves VALUES
(new_diag_id,t_no, t_res);

SELECT cost INTO temp_cost FROM Test WHERE test_id = t_no;
SET bill_subtotal = bill_subtotal + temp_cost;

ELSE
CALL non_existent_procedure;
LEAVE proclabel;
END IF;

SET test_no_substrlen = CHAR_LENGTH(t_no) + 2;
SET test_nos = MID(test_nos, test_no_substrlen, test_no_len);

SET test_res_substrlen = CHAR_LENGTH(t_res) + 2;
SET test_results = MID(test_results, test_res_substrlen, test_res_len);

IF test_nos = '' THEN
IF test_results = '' THEN
LEAVE loop_label;
ELSE CALL non_existent_procedure;
LEAVE proclabel;
END IF;
END IF;
END LOOP loop_label;


INSERT INTO Bill VALUES 
(new_bill_id, 0, bill_subtotal*(1.05), bill_subtotal , bill_subtotal*0.05,0);

INSERT INTO Bill_Diag VALUES
(new_bill_id, new_diag_id);

INSERT INTO Pays
VALUES (pat_id, new_bill_id);

COMMIT;
SET autocommit = 1;

END //
DELIMITER ;


--create treatment

-- Test create_treatment: CALL create_treatment(2, "2 | 3", 4, 2, "3 | 5 | 1", "2021-05-09", "2021-05-10", "he supa dead chief", 1, 5, @out_value);




DELIMITER //

CREATE OR REPLACE PROCEDURE create_treatment(
IN pat_id INT,
IN doc_ids TEXT,
IN room INT,
IN diag_id INT,
IN proc_ids TEXT,
IN st_date DATE,
IN en_date DATE,
IN treatment_details VARCHAR(255),
IN aftercare_room INT,
IN aftercare_nurse INT,
OUT new_treat_id INT)

proclabel: BEGIN

DECLARE new_bill_id INT;
DECLARE bill_subtotal DECIMAL(10, 2) DEFAULT 0.00;
DECLARE temp_cost DECIMAL(10, 2) DEFAULT 0.00;

DECLARE proc_no TEXT;
DECLARE doc_id TEXT;
DECLARE proc_no_len INTEGER DEFAULT 0;
DECLARE proc_no_substrlen INTEGER DEFAULT 0;
DECLARE doc_ids_len INTEGER DEFAULT 0;
DECLARE doc_ids_substrlen INTEGER DEFAULT 0;

DECLARE CONTINUE HANDLER FOR SQLSTATE '42000'
BEGIN
ROLLBACK;
SET autocommit = 1;
SET new_treat_id = -1;
END;

IF proc_ids IS NULL THEN
SET proc_ids = '';
END IF;

IF doc_ids IS NULL THEN
SET doc_ids = '';
END IF;

SET autocommit = 0;
START TRANSACTION;

SELECT treatment_id + 1 INTO new_treat_id FROM Treatment ORDER BY treatment_id DESC LIMIT 1;

IF new_treat_id IS NULL THEN
SET new_treat_id = 1;
END IF;

SELECT bill_number + 1 INTO new_bill_id FROM Bill ORDER BY bill_number DESC LIMIT 1;

IF new_bill_id IS NULL THEN
SET new_bill_id = 1;
END IF;

INSERT INTO Treatment
VALUES (new_treat_id, st_date, en_date, treatment_details);

IF EXISTS(SELECT * from Patient WHERE patient_id=pat_id) THEN
INSERT INTO Treated
VALUES (pat_id, new_treat_id);
ELSE
CALL non_existent_procedure;
LEAVE proclabel;
END IF;

IF EXISTS(SELECT * from Room WHERE room_no=room) THEN
INSERT INTO Done_In
VALUES (new_treat_id, room);
ELSE
CALL non_existent_procedure;
LEAVE proclabel;
END IF;

IF diag_id >= 0 THEN
IF EXISTS(SELECT * from Diagnosis WHERE diagnosis_id=diag_id) THEN
INSERT INTO `Implies`
VALUES (diag_id, new_treat_id);
ELSE
CALL non_existent_procedure;
LEAVE proclabel;
END IF;
END IF;


loop1_label:
LOOP
SET doc_ids_len = CHAR_LENGTH(doc_ids);

SET doc_id = SUBSTRING_INDEX(doc_ids, '|', 1);

IF EXISTS(SELECT * from Doctor WHERE doctor_id=doc_id) THEN
INSERT INTO Performs
VALUES (doc_id, new_treat_id);
ELSE
CALL non_existent_procedure;
LEAVE proclabel;
END IF;

SET doc_ids_substrlen = CHAR_LENGTH(doc_id) + 2;
SET doc_ids = MID(doc_ids, doc_ids_substrlen, doc_ids_len);

IF doc_ids = '' THEN
LEAVE loop1_label;
END IF;
END LOOP loop1_label;


loop2_label:
LOOP
SET proc_no_len = CHAR_LENGTH(proc_ids);

SET proc_no = SUBSTRING_INDEX(proc_ids, '|', 1);

IF EXISTS(SELECT * from `Procedure` WHERE procedure_id=proc_no) THEN
INSERT INTO `Consists`
VALUES (proc_no, new_treat_id);
SELECT cost INTO temp_cost FROM `Procedure` WHERE procedure_id=proc_no;
SET bill_subtotal = bill_subtotal + temp_cost;
ELSE
CALL non_existent_procedure;
LEAVE proclabel;
END IF;

SET proc_no_substrlen = CHAR_LENGTH(proc_no) + 2;
SET proc_ids = MID(proc_ids, proc_no_substrlen, proc_no_len);

IF proc_ids = '' THEN
LEAVE loop2_label;
END IF;
END LOOP loop2_label;

INSERT INTO Bill
VALUES (new_bill_id, 2,  bill_subtotal*(1.05), bill_subtotal , bill_subtotal*0.05,0);

INSERT INTO Treatment_Bill
VALUES (new_bill_id, new_treat_id);

INSERT INTO Pays
VALUES (pat_id, new_bill_id);

IF EXISTS(SELECT * from Room WHERE room_no=aftercare_room) THEN
INSERT INTO Aftercare (treatment_id, room_no, start_date)
VALUES (new_treat_id, aftercare_room, en_date);
ELSE
CALL non_existent_procedure;
LEAVE proclabel;
END IF;

INSERT INTO Serves
VALUES(new_treat_id, aftercare_nurse);

COMMIT;
SET autocommit = 0;

END
//

DELIMITER ;


--create prescription

-- Test create_prescription: CALL create_prescription(2, 1, "2|3|4", "1|2|1", @out_value);


DELIMITER //
CREATE OR REPLACE PROCEDURE create_prescription(
IN entity_id INT,
IN presc_type INT,
IN meds TEXT,
IN units TEXT,
OUT new_presc_id INT
)
proclabel: BEGIN


DECLARE med_id TEXT;
DECLARE meds_len INTEGER DEFAULT 0;
DECLARE meds_substrlen INTEGER DEFAULT 0;

DECLARE unit_val TEXT;
DECLARE units_len INTEGER DEFAULT 0;
DECLARE units_substrlen INTEGER DEFAULT 0;

DECLARE CONTINUE HANDLER FOR SQLSTATE '42000'
BEGIN
ROLLBACK;
SET autocommit = 1;
SET new_presc_id = -1;
END;

IF meds IS NULL THEN
SET meds = '';
END IF;

IF units IS NULL THEN
SET units = '';
END IF;

SET autocommit = 0;
START TRANSACTION;

SELECT Prescription.prescription_id + 1 INTO new_presc_id
FROM Prescription
ORDER BY prescription_id DESC LIMIT 1;

IF new_presc_id IS NULL THEN
SET new_presc_id = 1;
END IF;

INSERT INTO Prescription
VALUES (new_presc_id); 

IF presc_type = 0 THEN
IF EXISTS(SELECT * FROM Diagnosis WHERE diagnosis_id = entity_id) THEN
INSERT INTO Diag_Presc VALUES
(new_presc_id, entity_id);
ELSE
CALL non_existent_procedure;
LEAVE proclabel;
END IF;

ELSE
IF EXISTS(SELECT * FROM Treatment WHERE treatment_id = entity_id) THEN
INSERT INTO Treatment_Presc VALUES
(entity_id, new_presc_id);
ELSE
CALL non_existent_procedure;
LEAVE proclabel;
END IF;

END IF;


loop_label:
LOOP
SET meds_len = CHAR_LENGTH(meds);
SET units_len = CHAR_LENGTH(units);

SET med_id = SUBSTRING_INDEX(meds, '|', 1);
SET unit_val = SUBSTRING_INDEX(units, '|', 1);

IF EXISTS(SELECT * FROM Medicine WHERE medicine_id = med_id) THEN
INSERT INTO Includes VALUES
(med_id, new_presc_id, unit_val);
ELSE
CALL non_existent_procedure;
LEAVE proclabel;
END IF;

SET meds_substrlen = CHAR_LENGTH(med_id) + 2;
SET meds = MID(meds, meds_substrlen, meds_len);

SET units_substrlen = CHAR_LENGTH(unit_val) + 2;
SET units = MID(units, units_substrlen, units_len);

IF meds = '' THEN
IF units = '' THEN
LEAVE loop_label;
ELSE CALL non_existent_procedure;
LEAVE proclabel;
END IF;
END IF;
END LOOP loop_label;

COMMIT;
SET autocommit = 1;

END //
DELIMITER ;



--evaluate prescription

DELIMITER //
CREATE OR REPLACE PROCEDURE evaluate_prescription(
IN presc_id INT,
OUT new_bill_id INT
)
proclabel: BEGIN

DECLARE bill_subtotal DECIMAL(10, 2) DEFAULT 0.00;
DECLARE pat_id INTEGER;

DECLARE CONTINUE HANDLER FOR SQLSTATE '42000'
BEGIN
ROLLBACK;
SET autocommit = 1;
SET new_bill_id = -1;
END;

SET autocommit = 0;
START TRANSACTION;

IF EXISTS(SELECT * FROM Medical_Bill WHERE prescription_id = presc_id) THEN
CALL non_existent_procedure;
LEAVE proclabel;
END IF;

SELECT Bill.bill_number + 1 INTO new_bill_id
FROM Bill
ORDER BY bill_number DESC LIMIT 1;

IF new_bill_id IS NULL THEN
SET new_bill_id = 1;
END IF;


IF EXISTS(SELECT * FROM Prescription WHERE prescription_id = presc_id) THEN
SELECT SUM(unit*price) INTO bill_subtotal FROM Includes JOIN Medicine USING(medicine_id) WHERE prescription_id=presc_id;
ELSE
CALL non_existent_procedure;
LEAVE proclabel;
END IF;

INSERT INTO Bill VALUES 
(new_bill_id, 0, bill_subtotal*(1.05), bill_subtotal , bill_subtotal*0.05,0);

INSERT INTO Medical_Bill VALUES
(presc_id, new_bill_id);

IF EXISTS(SELECT * FROM Treatment_Raw WHERE prescription_id = presc_id) THEN
SELECT DISTINCT patient_id INTO pat_id FROM Treatment_Raw WHERE prescription_id = presc_id;

ELSE
IF EXISTS(SELECT * FROM Diagnosis_Raw WHERE prescription_id = presc_id) THEN
SELECT DISTINCT patient_id INTO pat_id FROM Diagnosis_Raw WHERE prescription_id = presc_id;

ELSE
CALL non_existent_procedure;
LEAVE proclabel;
END IF;
END IF;

INSERT INTO Pays
VALUES (pat_id, new_bill_id);

COMMIT;
SET autocommit = 1;

END //
DELIMITER ;


--mark bill paid

DELIMITER //
CREATE OR REPLACE PROCEDURE mark_bill_paid(
IN bill_id INT,
OUT success_state INT
)
BEGIN

IF EXISTS(SELECT * FROM Bill WHERE bill_number=bill_id) THEN
IF ((SELECT paid FROM Bill WHERE bill_number=bill_id) = 0) THEN
UPDATE Bill SET paid = 1 WHERE bill_number = bill_id;
SET success_state = 0;
ELSE
SET success_state = -1;
END IF;
END IF;

END //
DELIMITER ;
