DELIMITER //
CREATE OR REPLACE TRIGGER diagnosis_presc_bill_delete BEFORE DELETE ON Diagnosis
FOR EACH ROW
BEGIN
DELETE FROM Bill WHERE bill_number = (SELECT B.bill_number FROM Bill_Diag B WHERE B.diagnosis_id = OLD.diagnosis_id);
DELETE FROM Prescription WHERE prescription_id = (SELECT P.prescription_id FROM Diag_Presc P WHERE P.diagnosis_id = OLD.diagnosis_id);
END;
//
DELIMITER ;

DELIMITER //
CREATE OR REPLACE TRIGGER treatment_presc_bill_delete BEFORE DELETE ON Treatment
FOR EACH ROW
BEGIN
DELETE FROM Bill WHERE bill_number = (SELECT B.bill_number FROM Treatment_Bill B WHERE B.treatment_id = OLD.treatment_id);
DELETE FROM Prescription WHERE prescription_id = (SELECT P.prescription_id FROM Treatment_Presc P WHERE P.treatment_id = OLD.treatment_id);
END;
//
DELIMITER ;
