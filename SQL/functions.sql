use hospital

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
CREATE OR REPLACE PROCEDURE patient_exists(IN pat_id int, IN contact_number varchar(15), OUT exist varchar(10), OUT id int)
BEGIN
  SET id = -1;
  IF pat_id IS NOT NULL AND contact_number IS NOT NULL THEN
    SELECT patient_id INTO id FROM `Patient` WHERE contact_no = contact_number;
  ELSE
    IF contact_number IS NULL THEN
      SELECT patient_id INTO id FROM `Patient` WHERE patient_id = pat_id;
    ELSE
      SELECT patient_id INTO id FROM `Patient` WHERE contact_no = contact_number;
    END IF;
  END IF;
  SELECT id;
  SELECT IF(id <> -1, 1,0) INTO exist;
END#
DELIMITER ;
-- Adding a new registration
DELIMITER #
CREATE OR REPLACE PROCEDURE new_registration(IN  f_name varchar(30), 
                                            IN l_name varchar(30), IN contact_number varchar(15),
                                            IN addr varchar(100),OUT new_id int)
BEGIN
DECLARE t int;
SET new_id = (SELECT COUNT(*) FROM Patient) + 1;
CALL patient_exists(null,contact_number,t);
IF t > 0 THEN
    SELECT "Already Registered";
ELSE
    INSERT INTO `Patient` VALUES (new_id, f_name, l_name, contact_number, addr); 
   
END IF;
END#
DELIMITER ;

-- Patient Log entry check
DELIMITER #
CREATE OR REPLACE PROCEDURE checkin_out(IN pat_id int, IN val DATETIME, IN chkin int, OUT result int)
BEGIN
    SET result = 0;
    SELECT result;
    CALL patient_exists(pat_id,NULL,result,@temp);
    SELECT result;
    IF result = 1 THEN
      SELECT "check";
      IF chkin = 1 THEN
          INSERT INTO `Patient_Log` VALUES (pat_id, val, NULL);
      ELSE
          UPDATE `Patient_Log` SET checkout = val WHERE patient_id = pat_id AND checkout IS NULL ;
      END IF;
    END IF;
END#
DELIMITER ;

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
