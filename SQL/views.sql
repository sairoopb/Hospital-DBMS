USE hospital

--1.

CREATE OR REPLACE VIEW Appointment_Schedule AS
SELECT  Doctor.doctor_id, first_name, last_name, role, specialization, date, start_time, room_no
FROM Appointment RIGHT OUTER JOIN
Doctor ON Doctor.doctor_id=Appointment.doctor_id;
 
--2.

CREATE OR REPLACE VIEW Diagnosis_Raw AS
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
CREATE OR REPLACE VIEW Diagnosis_Report AS
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
CREATE OR REPLACE VIEW Treatment_Raw AS
select T.treatment_id, T.start_date, T.end_date, patient_id, doctor_id, Done_In.room_no AS treatmentRoom, Aftercare.room_no AS aftercareRoom, Aftercare.start_date AS aftercare_start, Aftercare.end_date AS aftercare_end,
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
CREATE OR REPLACE VIEW Treatment_Report AS
SELECT T.treatment_id, T.patient_id, T.doctor_id, T.treatmentRoom, T.start_date, T.end_date, T.relatedDiagnosis, 
T.prescription_id, T.procedure_id, CONCAT(Patient.first_name," ",Patient.last_name) AS `Patient`, 
CONCAT(Doctor.first_name," ",Doctor.last_name) AS `Doctor`, T.aftercareRoom, T.aftercare_start, T.aftercare_end,
`Procedure`.name AS `Procedures`, Treatment.details, Medicine.name AS `Medicine Name`, Includes.unit
FROM Treatment_Raw T LEFT JOIN 
Patient ON T.patient_id = Patient.patient_id LEFT JOIN 
Doctor ON T.doctor_id = Doctor.doctor_id LEFT JOIN
`Procedure` ON T.procedure_id = `Procedure`.procedure_id LEFT JOIN
Includes ON T.prescription_id = Includes.prescription_id LEFT JOIN
Medicine ON Includes.medicine_id = Medicine.medicine_id LEFT JOIN
Treatment ON T.treatment_id = Treatment.treatment_id;

-- 6.
CREATE OR REPLACE VIEW Bill_Report AS
SELECT Bill.*, Test.name as `Tests`, Test.cost as `Test_Cost`,`Procedure`.name as `Procedures`, `Procedure`.cost as `Procedure_Cost`,
Medicine.name as `drug`, Includes.unit as `Medicine_Qt`, Medicine.price as `Medicine_Unit_Cost`, 
Patient.patient_id, CONCAT(Patient.first_name, " ", Patient.last_name) as `Patient_Name` 
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
CREATE OR REPLACE VIEW Prescription_Report AS
SELECT Includes.prescription_id, Includes.unit, Medicine.name 
FROM Includes LEFT JOIN 
Medicine ON Includes.medicine_id = Medicine.medicine_id;

CREATE OR REPLACE VIEW appointment_menu AS
SELECT D.doctor_id, CONCAT(D.first_name, " ", D.last_name), D.specialization, A.date, A.start_time FROM 
(Doctor AS D) JOIN (Appointment AS A) ON D.doctor_id = A.doctor_id ORDER BY D.first_name ASC, D.last_name ASC