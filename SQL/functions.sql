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